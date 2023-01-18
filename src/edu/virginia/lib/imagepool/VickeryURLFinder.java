
package edu.virginia.lib.imagepool;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Iterator;

import javax.xml.namespace.QName;
import javax.xml.stream.XMLEventReader;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamWriter;
import javax.xml.stream.events.Attribute;
import javax.xml.stream.events.XMLEvent;

import org.apache.http.client.CookieStore;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.protocol.HttpClientContext;
import org.apache.http.cookie.Cookie;
import org.apache.http.impl.client.BasicCookieStore;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HttpContext;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class VickeryURLFinder {
    
    private static final String SERVICE_URL = "https://library.artstor.org/api/";
    private static final String IIIF_BASE_URL = "https://stor.artstor.org/iiif";
    public static void main(String [] args) throws Exception {
        
        final String filename = args.length == 0 ? "vickery_ssids.xml" : args[0];

        VickeryURLFinder finder = new VickeryURLFinder();
        
        XMLInputFactory factory = XMLInputFactory.newInstance();
        XMLEventReader xmlr = factory.createXMLEventReader(filename,
                new FileInputStream(filename));
        
        XMLStreamWriter xmlOut = XMLOutputFactory.newInstance().createXMLStreamWriter(new FileOutputStream("vickery.xml"));
        
        xmlOut.writeStartDocument();
        xmlOut.writeCharacters("\n");
     
        xmlOut.writeStartElement("images");
        xmlOut.writeCharacters("\n");

        boolean first = true;
        
        try {
                
            while(xmlr.hasNext()) {
                XMLEvent event = xmlr.nextEvent();
               if (event.isStartElement() && event.asStartElement().getName().getLocalPart().equals("SSID")) {
                   StringBuffer sb = new StringBuffer();
                   while (xmlr.hasNext() && !event.isEndElement()) {
                       event = xmlr.nextEvent();
                       if (event.isCharacters()) {
                           sb.append(event.asCharacters().getData());
                       }
                   }
                   final String ssid = sb.toString();
                   String url = null;
                   try {
                       JSONObject o = finder.getMetadata(ssid);
                       url = getImageServiceURL(o);
                   } catch (Throwable t) {
                       t.printStackTrace();
                   }
                   System.out.println(ssid + ": " + url);
                   
                   // Write the "name" element with some content and two attributes
                   xmlOut.writeCharacters("  ");
                   xmlOut.writeStartElement("image");
                   xmlOut.writeCharacters("\n    ");
                   
                   xmlOut.writeStartElement("ssid");
                   xmlOut.writeCharacters(ssid);
                   xmlOut.writeEndElement();
                   xmlOut.writeCharacters("\n    ");
                   
                   if (url != null) {
                       xmlOut.writeStartElement("imageUrl");
                       xmlOut.writeCharacters(url);
                       xmlOut.writeEndElement();
                       xmlOut.writeCharacters("\n  ");;
                   }
                   xmlOut.writeEndElement();
                   xmlOut.writeCharacters("\n");
               }
           }
        } finally {
            xmlOut.writeEndElement();
            xmlOut.writeEndDocument();
            xmlOut.close();
        }
        
    }
    
    private CloseableHttpClient client;
    
    public VickeryURLFinder() throws Exception {
        client = HttpClients.createDefault();
        CookieStore cookieStore = new BasicCookieStore();
        HttpContext httpContext = new BasicHttpContext();
        httpContext.setAttribute(HttpClientContext.COOKIE_STORE, cookieStore);
        
        // start a session
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
