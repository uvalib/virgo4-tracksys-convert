package edu.virginia.lib.imagepool;

import java.io.BufferedReader;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.net.URI;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamWriter;

import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class TracksysPidFinder {

    public static void main(String [] args) throws Exception {
        
        XMLStreamWriter xmlOut = XMLOutputFactory.newInstance().createXMLStreamWriter(new FileOutputStream("tracksys.xml"));
        
        Pattern p = Pattern.compile("\\Qhttps://iiif.lib.virginia.edu/iiif/\\E([^/]+)");
        
        xmlOut.writeStartDocument();
        xmlOut.writeCharacters("\n");
     
        xmlOut.writeStartElement("images");
        xmlOut.writeCharacters("\n");

        try {
            final TracksysPidFinder tracksys = new TracksysPidFinder();
            //for (String pid : Arrays.asList(new String[] {"tsb:103485"})) {
            for (String pid : tracksys.getAllMetadataPids()) {
                //final JSONObject o = tracksys.getItemMetadata(pid); 
                //final String manifestUrl = "https://iiifman.lib.virginia.edu/pid/" + pid;
                final String manifestUrl = "https://s3.us-east-1.amazonaws.com/iiif-manifest-cache-staging/pid-" + pid.replace(':', '-');
                
                JSONObject iiif = null;
                String rsUrl = null;
                String imageUrl = null;
                String masterFilePid = null;
                String thumbnailUrl = null;
                
                for (int i = 0; i < 1; i ++) {
                    try {
                        iiif = tracksys.getJSONObjectResponse(manifestUrl);
                        rsUrl = getRightsStatement(iiif);
                        imageUrl = getImageUrl(iiif);
                        Matcher m = p.matcher(imageUrl);
                        masterFilePid = m.matches() ? m.group(1) : null;
                        thumbnailUrl = getThumbnailUrl(iiif);
                        break;
                    } catch (Throwable t) {
                        System.out.println("Error: " + (t.getMessage() == null ? "" : t.getMessage()));
                        t.printStackTrace();
                        Thread.sleep(3000);
                        
                    }
                }
                
                System.out.println(pid + ": " + imageUrl);
                if (imageUrl == null) {
                    xmlOut.writeCharacters("  ");
                    if (iiif == null) {
                        xmlOut.writeComment(pid + " was unavailable");
                    } else {
                        xmlOut.writeComment(pid + " is not an image item");
                    }
                    xmlOut.writeCharacters("\n");
                } else {
                   xmlOut.writeCharacters("  ");
                   xmlOut.writeStartElement("image");
                   xmlOut.writeCharacters("\n");
                   
                   // pid
                   xmlOut.writeCharacters("    ");
                   xmlOut.writeStartElement("pid");
                   xmlOut.writeCharacters(pid);
                   xmlOut.writeEndElement();
                   xmlOut.writeCharacters("\n");
                   
                   // rights statement
                   if (imageUrl != null) {
                       xmlOut.writeCharacters("    ");
                       xmlOut.writeStartElement("rsUrl");
                       xmlOut.writeCharacters(rsUrl);
                       xmlOut.writeEndElement();
                       xmlOut.writeCharacters("\n");;
                   }
                   
                   // thumbnail
                   if (thumbnailUrl != null) {
                       xmlOut.writeCharacters("    ");
                       xmlOut.writeStartElement("thumbnailUrl");
                       xmlOut.writeCharacters(thumbnailUrl);
                       xmlOut.writeEndElement();
                       xmlOut.writeCharacters("\n");;
                   }
                   
                   // manifest URL
                   if (manifestUrl != null) {
                       xmlOut.writeCharacters("    ");
                       xmlOut.writeStartElement("manifestUrl");
                       xmlOut.writeCharacters(manifestUrl);
                       xmlOut.writeEndElement();
                       xmlOut.writeCharacters("\n");;
                   }
                   
                   //service URL
                   if (imageUrl != null) {
                       xmlOut.writeCharacters("    ");
                       xmlOut.writeStartElement("imageUrl");
                       xmlOut.writeCharacters(imageUrl);
                       xmlOut.writeEndElement();
                       xmlOut.writeCharacters("\n");;
                   }
                   //service URL
                   if (masterFilePid != null) {
                       xmlOut.writeCharacters("    ");
                       xmlOut.writeStartElement("masterFilePid");
                       xmlOut.writeCharacters(masterFilePid);
                       xmlOut.writeEndElement();
                       xmlOut.writeCharacters("\n");;
                   }
                   xmlOut.writeCharacters("  ");
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
    
    final CloseableHttpClient client;
    
    public TracksysPidFinder() {
        client = HttpClients.createDefault();
        
    }
    
    public List<String> getAllMetadataPids() throws Exception {
        final ArrayList<String> pids = new ArrayList<String>();     
        HttpGet get = new HttpGet(new URI("https://tracksys.lib.virginia.edu/api/solr/?timestamp=0"));
        CloseableHttpResponse response = client.execute(get);
        try {
            if (response.getStatusLine().getStatusCode() == 200) {
                BufferedReader r = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
                return Arrays.asList(r.readLine().split(","));
                /*
                try {
                    String line = r.readLine();
                    while (line != null) {
                        pids.add(line);
                        line = r.readLine();
                    }
                } finally {
                    r.close();
                }
                */
            } else {
                throw new Exception("Unexpected response: " + response.getStatusLine().getReasonPhrase());
            }
        } finally {
            response.close();
        }
            
        //return pids;
    }
    
    public JSONObject getItemMetadata(final String id) throws Exception {
        return getJSONObjectResponse("https://tracksys.lib.virginia.edu/api/metadata/" + id + "?type=brief");
    }
    
    public JSONObject getJSONObjectResponse(final String url) throws Exception {
        JSONParser parser = new JSONParser();
        
        HttpGet get = new HttpGet(new URI(url));
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
    
    public static String getRightsStatement(final JSONObject iiifManifest) {
        try {
            return iiifManifest.get("license").toString();
        } catch (NullPointerException ex) {
            throw ex;
        }
    }
    
    public static String getThumbnailUrl(final JSONObject iiifManifest) {
        final JSONObject canvas = getStartCanvas(iiifManifest);
        if (canvas == null) {
            return null;
        } else {
            return canvas.get("thumbnail").toString();
        }
    }
    
    public static String getImageUrl(final JSONObject iiifManifest) {
        final JSONObject canvas = getStartCanvas(iiifManifest);
        if (canvas == null) {
            return null;
        } else {
            return ((JSONObject) ((JSONObject) ((JSONObject) ((JSONArray) canvas.get("images")).get(0)).get("resource")).get("service")).get("@id").toString();
        }
    }

    private static JSONObject getStartCanvas(final JSONObject iiifManifest) {
        JSONObject firstSequence = (JSONObject) ((JSONArray) iiifManifest.get("sequences")).get(0);
        final String startCanvasID = firstSequence.get("startCanvas").toString();
        Iterable i = (Iterable) firstSequence.get("canvases");
        for (Object o : i) {
            JSONObject canvas = (JSONObject) o;
            if (startCanvasID == null || startCanvasID.equals(canvas.get("@id").toString())) {
                 return canvas;
            }  
        }
        return null;
    }
    
}
