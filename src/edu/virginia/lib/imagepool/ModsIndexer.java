package edu.virginia.lib.imagepool;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;
import javax.xml.transform.sax.SAXTransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.log4j.Logger;

import net.sf.saxon.expr.instruct.TerminationException;

/**
 * An abstract class that encapsulates all the shared methods used
 * to index image collections from Tracksys MODS collections.  The
 * indexing process starts with a list of PIDs. 
 */
public abstract class ModsIndexer extends AbstractIndexer {
    
    private static Logger logger = Logger.getLogger(ModsIndexer.class);

    private boolean debug;
    
    private Transformer modsToUvaMap;
    private Transformer uvaMapToSolr;
    public static String tracksysURLBase = "https://tracksys-api-ws.internal.lib.virginia.edu/api/metadata/"; 
    
    public ModsIndexer(boolean debug) throws TransformerConfigurationException {
        this.debug = debug;
        
        URIResolver r = new URIResolver() {
            @Override
            public Source resolve(String href, String base) throws TransformerException {
                logger.info("Resolving href " + href);
                try {
                    // fetch the URL
                    URL url = new URL(href);
                    return new StreamSource(url.openStream());
                } catch (MalformedURLException e) {
                    // check the classpath
                    final InputStream s = getClass().getClassLoader().getResourceAsStream(href);
                    if (s != null) {
                        return new StreamSource(s);
                    } 
                    logger.error("Unable to parse " + href + " (base=" + base + ")");
                    throw new RuntimeException();
                    //return null;
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }
        };
        
        SAXTransformerFactory f = (SAXTransformerFactory) TransformerFactory.newInstance("net.sf.saxon.TransformerFactoryImpl", null);
        f.setURIResolver(r);
        modsToUvaMap = f.newTemplates(new StreamSource(getClass().getClassLoader().getResourceAsStream("mods2uvaMAP.xsl"))).newTransformer();
        uvaMapToSolr = f.newTemplates(new StreamSource(getClass().getClassLoader().getResourceAsStream("uvamap2solr.xsl"))).newTransformer();

    }
    

    public void IndexItems(final Iterable<String> pids) throws Exception {
        String timestamp = new SimpleDateFormat("yyyy-MM-dd-hhmm").format(new Date());
        File processDir = (debug ? new File("tracksys-debug") : new File("tracksys-" + timestamp));
        processDir.mkdirs();
        File modsDir = new File(processDir, "mods");
        modsDir.mkdirs();
        File uvamapDir = new File(processDir, "uvamap");
        uvamapDir.mkdirs();
        File solrDir = new File(processDir, "solr");
        solrDir.mkdirs();
        File deleteDoc = new File(processDir, "delete-doc.xml");
        PrintWriter deletes = new PrintWriter(new OutputStreamWriter(new FileOutputStream(deleteDoc)));
        
        final File resultFile = new File(processDir, timestamp + "-tracksys-solr-add-docs.xml");
        final List<File> files = new ArrayList<File>();
        for (String pid : pids) {
            logger.info("indexing " + pid);
            final File modsFile = getModsFileFromTracksys(pid, modsDir);
            final File uvaMapFile = createUVAMapFile(modsFile, uvamapDir, pid);
            final File solrFile = createSolrDocFile(uvaMapFile, solrDir, pid);
            files.add(solrFile);
            deletes.println("<delete><query>id:\"" + pid + "\"</query></delete>");
        }
        deletes.close();
        this.concatenateAddDocs(files.toArray(new File[0]), resultFile);
    }
    
    public byte[] indexItem(String pid) throws Exception {
        String timestamp = new SimpleDateFormat("yyyy-MM-dd-hhmm").format(new Date());
        logger.info("indexing " + pid + "  at timestamp " + timestamp);
        InputStream modsStream = null;
        try {
            modsStream = getModsStreamFromTracksys(pid);
        }
        catch (Exception e)
        {
            throw new IndexingException(pid, IndexingException.IndexingPhase.GET_MODS, e); 
        }
        InputStream uvaMapStream;
        try { 
            uvaMapStream = createUVAMapStream(modsStream, pid);
        }
        catch (TerminationException te)
        {
            throw new IndexingException(pid, IndexingException.IndexingPhase.MAKE_UVAMAP, te);
        }
        
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        try { 
            createSolrDocStream(uvaMapStream, baos, pid);
        }
        catch (TerminationException te)
        {
            throw new IndexingException(pid, IndexingException.IndexingPhase.MAKE_SOLR, te);
        }
        return baos.toByteArray();
    }
    
    private File createSolrDocFile(final File uvamapFile, final File solrCacheDir, final String pid) throws Exception {
        FileInputStream fis = new FileInputStream(uvamapFile);
        final File solr = new File(solrCacheDir, fixPidForFile(pid) + "-solr.xml");
        FileOutputStream solrOut = new FileOutputStream(solr);
        try {
            createSolrDocStream(fis, solrOut, pid);
        } finally {
            fis.close();
            solrOut.close();
        }
        return solr;
    }
    
    private void createSolrDocStream(final InputStream uvamapStream, OutputStream solrOutStream, String pid) throws Exception {
        try {
            uvaMapToSolr.clearParameters();
            uvaMapToSolr.setParameter("curio", "true");
            uvaMapToSolr.transform(new StreamSource(uvamapStream), new StreamResult(solrOutStream));
        } finally {
        }
    }
    
    /**
     * Creates new uvamap XML file representing or returns the existing file if present
     * @param modsFile
     * @param uvaMapCacheDir
     * @param pid
     * @return
     * @throws Exception
     */
    private File createUVAMapFile(final File modsFile, final File uvaMapCacheDir, final String pid) throws Exception {
        final InputStream is = new FileInputStream(modsFile);
        try {
            final File uvaMap = new File(uvaMapCacheDir, fixPidForFile(pid) + "uvaMAP.xml");
            if (uvaMap.exists()) {
                return uvaMap;
            }
            final OutputStream out = new FileOutputStream(uvaMap);
            try {
                modsToUvaMap.setParameter("pid", pid);
                modsToUvaMap.transform(new StreamSource(is), new StreamResult(out));
                return uvaMap;
            } finally {
                out.close();
            }
        } finally {
            is.close();
        }
    }
    /**
     * Creates new uvamap XML stream representing or returns the existing file if present
     * @param modsStream
     * @param pid
     * @return
     * @throws Exception
     */
    private InputStream createUVAMapStream(final InputStream modsStream, final String pid) throws Exception {
        InputStream result;
        final ByteArrayOutputStream baos = new ByteArrayOutputStream();
        modsToUvaMap.setParameter("pid", pid);
        modsToUvaMap.transform(new StreamSource(modsStream), new StreamResult(baos));
        result = new ByteArrayInputStream(baos.toByteArray()); 
        return result;
    }
    
    /**
     * Creates new mods XML file representing the current MODS metadata in tracksys
     * for a given metadata pid, or returns the existing file if present.
     * @param pid a metadata record pid from tracksys
     * @param modsDir a directory in which the file will be cached (or is expected to be cached)
     * @return the MODS XML
     */
    private File getModsFileFromTracksys(final String pid, final File modsDir) throws Exception {
        File modsFile = new File(modsDir, fixPidForFile(pid) + "-mods.xml");
        final String url =  tracksysURLBase + pid + "?type=mods";
        if (!modsFile.exists()) {
            HttpGet get = new HttpGet(new URI(url));
            CloseableHttpResponse response = getHttpClient().execute(get);
            try {
                if (response.getStatusLine().getStatusCode() == 200) {
                    java.nio.file.Files.copy(
                        response.getEntity().getContent(), 
                        modsFile.toPath(), 
                        StandardCopyOption.REPLACE_EXISTING);
                } else {
                    throw new Exception("Unexpected response: " + response.getStatusLine().getStatusCode() + "  " + response.getStatusLine().getReasonPhrase() + " (" + url + ")");
                }
            } finally {
                response.close();
            }    
        }
        return modsFile;
    }
    
    /**
     * Creates new mods XML file representing the current MODS metadata in tracksys
     * for a given metadata pid, or returns the existing file if present.
     * @param pid a metadata record pid from tracksys
     * @param modsDir a directory in which the file will be cached (or is expected to be cached)
     * @return the MODS XML
     */
    private InputStream getModsStreamFromTracksys(final String pid) throws Exception {
        final String url = tracksysURLBase + pid + "?type=mods";
        InputStream result = null;
        HttpGet get = new HttpGet(new URI(url));
        CloseableHttpResponse response = getHttpClient().execute(get);
        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            if (response.getStatusLine().getStatusCode() == 200) {
                InputStream input = response.getEntity().getContent();
                // Code simulating the copy
                // You could alternatively use NIO
                // And please, unlike me, do something about the Exceptions :D
                byte[] buffer = new byte[1024];
                int len;
                while ((len = input.read(buffer)) > -1 ) {
                    baos.write(buffer, 0, len);
                }
                baos.flush();
             
                result = new ByteArrayInputStream(baos.toByteArray()); 
            } else {
                throw new Exception("Unexpected response: " + response.getStatusLine().getStatusCode() + "  " + response.getStatusLine().getReasonPhrase() + " (" + url + ")");
            }
        } finally {
            response.close();
        }    
        return result;
    }
    
    private String fixPidForFile(String pid) {
        return (pid.replaceAll(":",  "_"));
    }
    
}
