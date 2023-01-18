
package edu.virginia.lib.imagepool;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.xml.namespace.QName;
import javax.xml.stream.XMLEventReader;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamWriter;
import javax.xml.stream.events.Attribute;
import javax.xml.stream.events.XMLEvent;

import org.apache.http.HttpEntity;
import org.apache.http.client.CookieStore;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.protocol.HttpClientContext;
import org.apache.http.cookie.Cookie;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.BasicCookieStore;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HttpContext;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class JStorForumIIIFURLFinder {
    
    private static final String SERVICE_URL = "https://library.artstor.org/api/";
    private static final String IIIF_BASE_URL = "https://stor.artstor.org/iiif";
    public static void main(String [] args) throws Exception {
        
        final String filename = args.length == 0 ? "jmhoward-ssids.txt" : args[0];
        final String outputFilename = args.length != 2 ? "jmhoward-extra-metadata.xml" : args[1];

        JStorForumIIIFURLFinder finder = new JStorForumIIIFURLFinder();

        BufferedReader r = new BufferedReader(new InputStreamReader(new FileInputStream(filename))); 
        
        XMLStreamWriter xmlOut = XMLOutputFactory.newInstance().createXMLStreamWriter(new FileOutputStream(new File(outputFilename)));
        
        xmlOut.writeStartDocument();
        xmlOut.writeCharacters("\n");
     
        xmlOut.writeStartElement("images");
        xmlOut.writeCharacters("\n");

        
        try {
            String ssid = null;
            while((ssid = r.readLine()) != null) {
               Map<String, String> metadata = finder.getURLs(ssid);
               //System.out.println(ssid);
                
               // Write the "name" element with some content and two attributes
               xmlOut.writeCharacters("  ");
               xmlOut.writeStartElement("image");
               xmlOut.writeCharacters("\n    ");
                   
               xmlOut.writeStartElement("ssid");
               xmlOut.writeCharacters(ssid);
               xmlOut.writeEndElement();
               xmlOut.writeCharacters("\n    ");

               if (metadata.containsKey("artstorId")) {
                   xmlOut.writeStartElement("artstorId");
                   xmlOut.writeCharacters(metadata.get("artstorId"));
                   xmlOut.writeEndElement();
                   xmlOut.writeCharacters("\n    ");
                   xmlOut.writeStartElement("objectInContext");
                   xmlOut.writeCharacters("https://library.artstor.org/#/asset/" + metadata.get("artstorId"));
                   xmlOut.writeEndElement();
                   xmlOut.writeCharacters("\n    ");
               }
               if (metadata.containsKey("iiifImageManifest")) {
                   xmlOut.writeStartElement("iiifImageManifest");
                   xmlOut.writeCharacters(metadata.get("iiifImageManifest"));
                   xmlOut.writeEndElement();
                   xmlOut.writeCharacters("\n    ");;
               }
               if (metadata.containsKey("doi")) {
                   xmlOut.writeStartElement("doi");
                   xmlOut.writeCharacters(metadata.get("doi"));
                   xmlOut.writeEndElement();
                   xmlOut.writeCharacters("\n    ");;
               }
               xmlOut.writeEndElement();
               xmlOut.writeCharacters("\n");
           }
       } finally {
            xmlOut.writeEndElement();
            xmlOut.writeEndDocument();
            xmlOut.close();
        }
        
    }
    
    private CloseableHttpClient client;
    
    public JStorForumIIIFURLFinder() throws Exception {
        client = HttpClients.createDefault();
        CookieStore cookieStore = new BasicCookieStore();
        HttpContext httpContext = new BasicHttpContext();
        httpContext.setAttribute(HttpClientContext.COOKIE_STORE, cookieStore);
        
        // start a session
        /* https://library.artstor.org/api/secure/userinfo?no-cache=1610659092639*/
        final URI uri = new URI(SERVICE_URL + "secure/userinfo");
        HttpGet get = new HttpGet(uri);
        System.out.println("GETting " + uri);
        CloseableHttpResponse response = client.execute(get);
        try {
            if (response.getStatusLine().getStatusCode() != 200) {
                System.err.println(response.getStatusLine().getReasonPhrase());
                throw new RuntimeException("Unable to create new JStorForum session!");
            }
        } finally {
            response.close();
        }
        System.out.println("Created session!");
    }
    
    /**
     * Hits https://library.artstor.org/api/search/v3.0/search
     * with a payload like
     * {"limit":2,"start":0,"query":"ssid:(2315610)","hier_facet_fields2":[{"field":"hierarchies","hierarchy":"artstor-geography","look_ahead":2,"look_behind":-10,"d_look_ahead":1}],"facet_fields":[{"name":"artclassification_str","mincount":1,"limit":20},{"name":"donatinginstitutionids","mincount":1,"limit":400},{"name":"collectiontypes","mincount":1,"limit":15}],"content_set_flags":["art"],"filter_queries":[],"sortorder":"asc"}
     * @param SSID
     * @throws Exception
     */
    private Map<String, String> getURLs(final String SSID) throws Exception {
        Map<String, String> values = new HashMap<String, String>();
        JSONParser parser = new JSONParser();
        
        HttpPost post = new HttpPost(new URI(SERVICE_URL + "search/v3.0/search"));
        post.setHeader("content-type", "application/json;charset=UTF-8");
        //post.setEntity(new StringEntity("{\"limit\":48,\"start\":0,\"query\":\"ssid:(2315610)\",\"hier_facet_fields2\":[{\"field\":\"hierarchies\",\"hierarchy\":\"artstor-geography\",\"look_ahead\":2,\"look_behind\":-10,\"d_look_ahead\":1}],\"facet_fields\":[{\"name\":\"artclassification_str\",\"mincount\":1,\"limit\":20},{\"name\":\"donatinginstitutionids\",\"mincount\":1,\"limit\":400},{\"name\":\"collectiontypes\",\"mincount\":1,\"limit\":15}],\"content_set_flags\":[\"art\"],\"filter_queries\":[],\"sortorder\":\"asc\"}"));
        post.setEntity(new StringEntity("{\"limit\":48,\"start\":0,\"query\":\"ssid:(" + SSID + ")\",\"hier_facet_fields2\":[{\"field\":\"hierarchies\",\"hierarchy\":\"artstor-geography\",\"look_ahead\":2,\"look_behind\":-10,\"d_look_ahead\":1}],\"facet_fields\":[{\"name\":\"artclassification_str\",\"mincount\":1,\"limit\":20},{\"name\":\"donatinginstitutionids\",\"mincount\":1,\"limit\":400},{\"name\":\"collectiontypes\",\"mincount\":1,\"limit\":15}],\"content_set_flags\":[\"art\"],\"filter_queries\":[],\"sortorder\":\"asc\"}"));
        CloseableHttpResponse response = client.execute(post);
        try {
            if (response.getStatusLine().getStatusCode() == 200) {
                InputStreamReader r = new InputStreamReader(response.getEntity().getContent());
                try {
                    //results[0]/media
                    JSONObject jsonResponse = (JSONObject) parser.parse(r);
                    if (jsonResponse.containsKey("results")) {
                        JSONArray results = (JSONArray) jsonResponse.get("results");
                        if (results.size() == 0) {
                            System.err.println("Not found (" + SSID + ")");
                            return values;
                        }
                        JSONObject result = (JSONObject) results.get(0);
                        String artStorId = (String) result.get("artstorid");
                        values.put("artstorId", artStorId);
                        //System.out.println(artStorId); 
                        String doi = (String) result.get("doi");
                        values.put("doi", doi);
                        JSONObject media = (JSONObject) parser.parse((String) result.get("media"));
                        String iiifValue = (String) media.get("iiif");
                        if (iiifValue == null) {
                            System.err.println("Unable to find IIIF URL for " + SSID + "!\n" + results.toString());
                            return values;
                        }
                        
                        // the API returns some odd values sometimes
                        String iiifImageUrl = iiifValue.replace("/prod.cirrostratus.org", "https://stor.artstor.org/iiif") + "/info.json";
                        iiifImageUrl = iiifImageUrl.replace("/home/ana/assets/", "https://stor.artstor.org/iiif/");
                        
                        if (!iiifImageUrl.startsWith("http")) {
                            throw new RuntimeException("iiifImageUrl seems wrong: \"" + iiifImageUrl + "\", " + results.toString());
                        }
                        values.put("iiifImageManifest", iiifImageUrl);
                    }
                    return values;
                } finally {
                    r.close();
                }
            } else {
                response.getEntity().writeTo(System.err);
                System.err.println("Unexpected response: " + response.getStatusLine().getStatusCode() + " - " + response.getStatusLine().getReasonPhrase());
                return values;
            }
        } finally {
            response.close();
        }
    }
    
    private JSONObject getMetadata(final String SSID) throws Exception {
        JSONParser parser = new JSONParser();
        
        HttpGet get = new HttpGet(new URI(SERVICE_URL + "v1/metadata?object_ids=" + SSID + "&legacy=false"));
        CloseableHttpResponse response = client.execute(get);
        try {
            if (response.getStatusLine().getStatusCode() == 200) {
                InputStreamReader r = new InputStreamReader(response.getEntity().getContent());
                try {
                    return (JSONObject) parser.parse(r);
                } finally {
                    r.close();
                }
            } else {
                throw new Exception("Unexpected response: " + response.getStatusLine().getReasonPhrase());
            }
        } finally {
            response.close();
        }
    }
    
    private static String getImageServiceURL(final JSONObject o) {
        JSONArray metadata = (JSONArray) o.get("metadata");
        JSONObject record = (JSONObject) metadata.get(0);
        return IIIF_BASE_URL + record.get("image_url");
    }

}
