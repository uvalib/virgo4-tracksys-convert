package edu.virginia.lib.sqsserver;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.net.*;
import java.io.*;
import javax.json.*;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;

import edu.virginia.lib.imagepool.IndexingException;

import org.apache.log4j.Logger;

public class DlMixin 
{
    private static final JsonObject NULL_JSON_OBJECT = Json.createObjectBuilder().add("value", "null").build();
    private final static Logger logger = Logger.getLogger(DlMixin.class);

//    private String JSON_SERVICE_URL = "https://tracksys-api-ws.internal.lib.virginia.edu/api/enriched/other/";
//    private String JSON_SERVICE_URL2 = "https://tracksys-api-ws.internal.lib.virginia.edu/api/published/virgo?type=other";
    private String enrichPublishedURL = "";
    private String enrichDataURL = "";

    private final ConcurrentHashMap<String, String> publishedMap = new ConcurrentHashMap<String, String>();

    public final static String s3Bucket = "s3://";
    public final static String s3UrlPrefix = "https://s3.us-east-1.amazonaws.com/";
    public static long lastInitializedTimeStamp = 0L;
    public final static long ONE_HOUR_IN_MILLISECONDS = (1000L * 60 * 60 * 1);
    public final static long ONE_MINUTE_IN_MILLISECONDS = (1000L * 60 * 1);

    public DlMixin()
    {
        enrichPublishedURL = SQSQueueDriver.DlMixin_Enrich_Published_URL;
        enrichDataURL = SQSQueueDriver.DLMixin_Enrich_Data_URL;
        if (enrichPublishedURL != null && enrichPublishedURL.length() != 0 && 
                enrichDataURL != null && enrichDataURL.length() != 0)
        {
            logger.info("Using URL "+enrichPublishedURL+" to populate list of records to enrich");
            logger.info("Using URL "+enrichDataURL+" as base url to fetch data for enriching");
        }
        else 
        {
            logger.info("Tracksys enrich URLs not defined, will not perform any of the tracksys enrich steps");
        }
    }

    public boolean isEnabled()
    {
        if (enrichPublishedURL != null && enrichPublishedURL.length() != 0 && 
                enrichDataURL != null && enrichDataURL.length() != 0)
        {
            return true;
        }
        return false;
    }

    private String readStreamIntoString(InputStream stream) throws IOException
    {
        Reader in = new BufferedReader(new InputStreamReader(stream));
        
        StringBuilder sb = new StringBuilder();
        char[] chars = new char[4096];
        int length;
        
        while ((length = in.read(chars)) > 0)
        {
            sb.append(chars, 0, length);
        }
        return sb.toString();
    }

    void initializePublishedMap()
    {
        synchronized (publishedMap)
        {
            long now = java.lang.System.currentTimeMillis();
            if (publishedMap.size() == 0 || now - lastInitializedTimeStamp > ONE_MINUTE_IN_MILLISECONDS)
            {
                logger.info(publishedMap.size() == 0 ? "Initializing PublishedMap" : 
                       (lastInitializedTimeStamp == 0L ) ? "Re-Initializing PublishedMap due to message-attribute-ignore-cache found" : "Re-Initializing PublishedMap after 1 minute");
                lastInitializedTimeStamp = now; 
                try
                {
                    final URL url = new URL(enrichPublishedURL);
                    InputStream urlInputStream = url.openStream();
                    
                    try
                    {
                        String allIds = readStreamIntoString(urlInputStream).replaceFirst("^[^,]*,[^:]*:.", "");
                        int offset = 0;
                        int endoffset;
                        do
                        {
                            endoffset = allIds.indexOf(',', offset);
                            String id = allIds.substring(offset, endoffset == -1 ? allIds.length() : endoffset);
                            id = id.replaceFirst("\"([^\"]*)\".*", "$1");
                            publishedMap.putIfAbsent(id, "");
                            offset = endoffset + 1;
                        } while (endoffset != -1);
                    }
                    finally
                    {
                        urlInputStream.close();
                    }
                }
                catch (IOException ioe)
                {
                    throw new RuntimeException(ioe);
                }
            }
        }
        logger.info("PublishedMap initialized, size is " + publishedMap.size()+ " items");
    }

    private Cache<String, JsonObject> cache = new Cache<String, JsonObject>(64);

    private synchronized JsonObject lookupId(final String id)
    {
        if (!isEnabled()) return(null);
        long now = java.lang.System.currentTimeMillis();
        if (publishedMap.size() == 0 || now - lastInitializedTimeStamp > ONE_HOUR_IN_MILLISECONDS)
        {
            initializePublishedMap();
            lastInitializedTimeStamp = now; 
        }
        if (!publishedMap.containsKey(id))
        {
            return (null);
        }
        JsonObject jsonObject = null;
        synchronized (cache) 
        {
            if (cache.containsKey(id))
            {
                jsonObject = decodeNull(cache.get(id));
            }
        }
        if (jsonObject != null) return(jsonObject);
        final String urlStr = enrichDataURL + id;
        InputStream urlInputStream = null;
        try
        {
            final URL url = new URL(urlStr);
            urlInputStream = url.openStream();
            jsonObject = Json.createReader(urlInputStream).readObject();
            synchronized (cache) { cache.put(id, jsonObject); }
            logger.info("Reading JSON info from tracksys about record "+id);
            JsonArray items = jsonObject.getJsonArray("items");
            int num = (items != null) ? items.size() : 0;
            logger.info("Record contains "+num+ " items");
        }
        catch (IOException ex)
            {
            synchronized (cache) { cache.put(id, encodeNull(null)); }
            logger.warn(urlStr + " not found, so " + id + " must not be in the tracksys system");
            logger.warn("IOException", ex);
            }
            finally
            {
            if (urlInputStream != null) 
            {
                try { 
                    urlInputStream.close();
                }
                catch (IOException ioe)
                {}
            }
        }
        return jsonObject;
    }

    private JsonObject decodeNull(JsonObject o)
    {
        if (o == NULL_JSON_OBJECT)
        {
            return null;
        }
        return o;
    }

    private JsonObject encodeNull(JsonObject o)
    {
        if (o == null)
        {
            return NULL_JSON_OBJECT;
        }
        return o;
    }

    public boolean isInDL(final String id)
    {
        return lookupId(id) != null;
    }

    public Set<String> getFormatFacetsToAdd(final String id)
    {
        Set<String> result = new HashSet<String>();
        if (isInDL(id))
        {
            result.add("Online");
        }
        return result;
    }

    public Set<String> getSourceFacetsToAdd(final String id)
    {
        Set<String> result = new HashSet<String>();
        if (isInDL(id))
        {
            result.add("UVA Library Digital Repository");
        }
        return result;
    }

    public Set<String> getFeatureFacetsToAdd(final String id)
    {
        Set<String> result = new HashSet<String>();
        final JsonObject dlSummary = lookupId(id);
        if (dlSummary != null)
        {
            result.add("availability");
            result.add("iiif");
            result.add("dl_metadata");
            result.add("rights_wrapper");
            if (dlSummary.getString("pdfServiceRoot") != null)
            {
                result.add("pdf_service");
            }
        }
        return result;
    }

    public List<String> getThumbnailUrlDisplay(final String id)
    {
        List<String> result = new ArrayList<String>();
        final JsonObject dlSummary = lookupId(id);
        if (dlSummary != null && dlSummary.getString("thumbnailUrl") != null)
        {
            result.add(dlSummary.getString("thumbnailUrl"));
        }
        return result;
    }

    public List<String> getPdfUrlDisplay(final String id)
    {
        List<String> result = new ArrayList<String>();
        final JsonObject dlSummary = lookupId(id);
        if (dlSummary != null && dlSummary.getString("pdfServiceRoot") != null)
        {
            result.add(dlSummary.getString("pdfServiceRoot"));
        }
        return result;
    }

    public List<String> getRightsStatementURI(final String id)
    {
        List<String> result = new ArrayList<String>();
        final JsonObject dlSummary = lookupId(id);
        if (dlSummary != null && dlSummary.getString("rsURI") != null)
        {
            result.add(dlSummary.getString("rsURI"));
        }
        return result;
    }

    public List<String> getAlternateIds(final String id)
    {
        List<String> result = new ArrayList<String>();
        final JsonObject dlSummary = lookupId(id);
        if (dlSummary != null && dlSummary.getString("pid") != null)
        {
            result.add(dlSummary.getString("pid"));
        }
        return result;
    }

    public List<String> getAdditionalCollectionFacets(final String id)
    {
        List<String> result = new ArrayList<String>();
        final JsonObject dlSummary = lookupId(id);
        if (dlSummary != null && dlSummary.getJsonString("collection") != null)
        {
            result.add(dlSummary.getString("collection"));
        }
        return result;
    }

    public List<String> getIIIFManifestURL(final String id) throws Exception
    {
        List<String> result = new ArrayList<String>();
        final JsonObject dlSummary = lookupId(id);
        if (dlSummary != null && dlSummary.getJsonString("backendIIIFManifestUrl") != null)
        {
            result.add(dlSummary.getString("backendIIIFManifestUrl"));
        }
        return result;
    }

    public List<String> makeDigitalContentCache(final String id, String templateFile)
            throws Exception
    {
        List<String> result = new ArrayList<String>();
        final JsonObject dlSummary = lookupId(id);
        if (dlSummary != null)
        {
            String cacheURL = createDigitalContentCacheEntry(id, dlSummary, templateFile);
            if (cacheURL != null)
            {
                result.add(cacheURL);
            }
        }
        return (result);
    }

    private String createDigitalContentCacheEntry(String id, JsonObject dlSummary, String templateFile) throws Exception
    {
        String s3BucketName = SQSQueueDriver.DlMixin_S3_BucketName;
        String[] template = readTemplate(id, templateFile);
        String digitalContent = createMultiPidMetadataContent(id, dlSummary, template);
        if (digitalContent != null)
        {
            if (s3BucketName == null || s3BucketName.length() == 0)
            {
                logger.warn("No bucket name defined.  Not writing digital content cache entry.");
                logger.info(digitalContent);
            }
            else
            {
                String urlstring = storeCacheData(digitalContent, s3BucketName, id);
                return (urlstring);
           }
        }
        return (null);
    }

    private String storeCacheData(String digitalContent, String s3BucketName, String id)
    {
        logger.info("Uploading " + id + " to S3 bucket " + s3Bucket + s3BucketName + "...\n");
        String urlStrWrite = s3UrlPrefix + s3BucketName + "/" + id;
        final AmazonS3 s3 = AmazonS3ClientBuilder.standard().build();
        try
        {
            s3.putObject(s3BucketName, id, digitalContent);
        }
        catch (AmazonServiceException e)
        {
            System.err.println(e.getErrorMessage());
            return null;
        }
        return (urlStrWrite);
    }


//<	{
//<	    "id":"${CATKEY}",
//<	    "parts": [
//=      {
//=        "iiif_manifest_url": "${MANIFEST}",
//=        "oembed_url": "https://curio.lib.virginia.edu/oembed?url=https://curio.lib.virginia.edu/view/${PID}",
//=        "label": "${CALLNUM}",
//=        "ocr": {
//=          "urls": {
//=            "delete": "https://ocr-service-dev.lib.virginia.edu/ocr/${PID}/delete",
//=            "download": "https://ocr-service-dev.lib.virginia.edu/ocr/${PID}/text",
//=            "generate": "https://ocr-service-dev.lib.virginia.edu/ocr/${PID}",
//=            "status": "https://ocr-service-dev.lib.virginia.edu/ocr/${PID}/status"
//=          }
//=        },
//=        "pdf": {
//=          "urls": {
//=            "delete": "${PDF}/${PID}/delete",
//=            "download": "${PDF}/${PID}/download",
//=            "generate": "${PDF}/${PID}",
//=            "status": "${PDF}/${PID}/status"
//=          }
//=        },
//=        "pid": "${PID}",
//=        "thumbnail_url":"${THUMBNAIL}"
//=      }
//?      ,
//>	  ]
//>	}
//
    private String[] readTemplate(String id, String templateFile)
    {
        List<String> result = new ArrayList<String>();
        InputStream templateStream = getClass().getClassLoader().getResourceAsStream(templateFile);
        BufferedReader reader = new BufferedReader(new InputStreamReader(templateStream));
        String line;
        try
        {
            while ((line = reader.readLine()) != null)
            {
                result.add(line);
            }
        }
        catch (FileNotFoundException e)
        {
            throw new IndexingException(id, IndexingException.IndexingPhase.TRACKSYS_ENRICH, "Unable to open lookup file " + templateFile);
        }
        catch (IOException e)
        {
            throw new IndexingException(id, IndexingException.IndexingPhase.TRACKSYS_ENRICH, "Unable to read lookup file " + templateFile);
        }
        return (result.toArray(new String[result.size()]));
    }

    private String createMultiPidMetadataContent(String catKey, JsonObject dlSummary, String[] template)
    {
        // build the dataset for the template generation
        String oembed_Root = SQSQueueDriver.DlMixin_Oembed_Root;
        String ocrRoot = SQSQueueDriver.DlMixin_OCR_Root;

        StringBuilder sb = new StringBuilder();
        Map<String, String> valueMap = new LinkedHashMap<String, String>();
        String pdfServiceRoot = dlSummary.getString("pdfServiceRoot");
        valueMap.put("CATKEY", catKey);
        valueMap.put("OEMBED", oembed_Root);
        valueMap.put("OCR", ocrRoot);
        valueMap.put("PDF", pdfServiceRoot);
        handleTemplate(sb, template, "<", valueMap);
        valueMap.put("PID", (((JsonObject) dlSummary).getString("pid")));
        valueMap.put("MANIFEST", (((JsonObject) dlSummary).getString("backendIIIFManifestUrl")));
        valueMap.put("THUMBNAIL", (((JsonObject) dlSummary).getString("thumbnailUrl")));
        handleTemplate(sb, template, "=", valueMap);
        handleTemplate(sb, template, ">", valueMap);
        return sb.toString();
    }

    private void handleTemplate(StringBuilder sb, String[] template, String prefixStr, Map<String, String> valueMap)
    {
        for (String templateLine : template)
        {
            char start = templateLine.charAt(0);
            String templateRest = templateLine.substring(1);
            if (prefixStr.charAt(0) == start)
            {
                handleTemplateLine(sb, templateRest, valueMap);
            }
        }
    }

    private void handleTemplateLine(StringBuilder sb, String templateRest, Map<String, String> valueMap)
    {
        int offset = 0;
        // if template line starts with '?'   the variable immediately after that must be defined or the line will be skipped
        if (templateRest.charAt(0) == '?') 
        {
            int ifend = templateRest.indexOf(' ');
            String onlyif = templateRest.substring(1, ifend).replaceFirst("^[$][{]", "").replaceFirst("[}]$", "");
            if (!valueMap.containsKey(onlyif) || valueMap.get(onlyif) == null || valueMap.get(onlyif).length() == 0)
                return;
            templateRest = templateRest.substring(ifend);
        }
        int rep = templateRest.indexOf("${", offset);
        while (rep > 0)
        {
            sb.append(templateRest.substring(offset, rep));
            int endOffset = templateRest.indexOf("}", offset);
            String toReplace = templateRest.substring(rep + 2, endOffset);
            if (valueMap.containsKey(toReplace))
            {
                sb.append(valueMap.get(toReplace));
            }
            offset = endOffset + 1;
            rep = templateRest.indexOf("${", offset);
        }
        sb.append(templateRest.substring(offset)).append("\n");
    }

    private static class Cache<K, V> extends LinkedHashMap<K, V>
    {
        private int size;
        
        public Cache(int size)
        {
            super(16, 0.75f, true);
            this.size = size;
        }
        
        protected boolean removeEldestEntry(Map.Entry<K, V> eldest)
        {
            return this.size() >= size;
        }
    }
}
