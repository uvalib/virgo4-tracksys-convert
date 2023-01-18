
package edu.virginia.lib.imagepool;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.xml.stream.XMLEventFactory;
import javax.xml.stream.XMLEventReader;
import javax.xml.stream.XMLEventWriter;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.events.XMLEvent;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;
import javax.xml.transform.sax.SAXTransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.io.FileUtils;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;

/**
 * @deprecated This class represented an overly cumbersome and difficult to compare
 *             proccess that is being replaced by more targeted reindexing classes.
 *             Once all the useful code has been cannibalized it will be removed.
 */
public class CollectionExporter {
    
    public static void main(String [] args) throws Exception {
        CollectionExporter exporter = new CollectionExporter(new File("index"), true);

        ArrayList<File> addFiles = new ArrayList<File>();
        /*
        addFiles.add(exporter.processJeffersonCountry());
        */
        //addFiles.add(exporter.processJStorForumCollection());
        
        //addFiles.add(exporter.processVickeryCollection());
        addFiles.add(exporter.processMODSCollectionFromVirgo3Solr("University of Virginia Visual History Collection"));
        /*addFiles.add(exporter.processMODSCollectionFromVirgo3Solr("Holsinger Studio Collection"));
        addFiles.add(exporter.processMODSCollectionFromVirgo3Solr("Jackson Davis Collection of African American Photographs"));
        addFiles.add(exporter.processMODSCollectionFromVirgo3Solr("University of Virginia Medical Artifacts Collection"));
        addFiles.add(exporter.processMODSCollectionFromVirgo3Solr("Frances Benjamin Johnston Photographs"));
        addFiles.add(exporter.processMODSCollectionFromVirgo3Solr("Cecil Lang Collection of Vanity Fair Illustrations"));
        addFiles.add(exporter.processMODSCollectionFromVirgo3Solr("Eduardo Montes-Bradley Photograph and Film Collection"));
     */   
        System.out.println("All records aggregated in to " + exporter.concatenateAddDocs(addFiles).getAbsolutePath());
    }
    
    private File concatenateAddDocs(ArrayList<File> addFiles) throws Exception {
        File outputFile = new File(indexDir, "all-image-collections" + new SimpleDateFormat("yyyy-MM-dd-HHmm").format(new Date()) + ".xml");
        
       XMLEventWriter xmlw = XMLOutputFactory.newInstance().createXMLEventWriter(new FileOutputStream(outputFile));
       XMLEventFactory f = XMLEventFactory.newInstance();
       xmlw.add(f.createStartDocument());
       xmlw.add(f.createStartElement("", "", "add"));
       xmlw.add(f.createCharacters("\n"));
       System.out.println("Creating single xml file...");
        for (File add : addFiles) {
            System.out.print("  Adding " + add.getPath() + "...");
            int count = 0;
            InputStream xmlIn = new FileInputStream(add);
            XMLEventReader xmlr = XMLInputFactory.newInstance().createXMLEventReader(xmlIn);
            boolean copying = false;
            while(xmlr.hasNext()) {
                XMLEvent event = xmlr.nextEvent();
                if (event.isStartElement() && event.asStartElement().getName().getLocalPart().equals("add")) {
                    copying = true;
                } else if (event.isEndElement() && event.asEndElement().getName().getLocalPart().equals("add")) {
                    xmlw.add(f.createCharacters("\n"));
                    copying = false;
                } else if (copying) {
                    if (event.isEndElement() && event.asEndElement().getName().getLocalPart().equals("doc")) {
                        count ++;
                    }
                    // copy the content..
                    xmlw.add(event);
                } 
            }
            xmlr.close();
            System.out.println(count + " documents");
        }
        xmlw.add(f.createEndElement("", "", "add"));
        xmlw.add(f.createEndDocument());
        xmlw.flush();
        xmlw.close();
        return outputFile;
    }

    private static String abbrevateName(String name) {
        switch (name) {
        case "University of Virginia Visual History Collection": return "visual-history";
        case "Holsinger Studio Collection": return "holsinger";
        case "University of Virginia Printing Services photograph file": return "printing-services";
        case "Jackson Davis Collection of African American Photographs" : return "jackson-davis";
        case "Architecture of Jefferson Country" : return "jefferson-country";
        case "University of Virginia Medical Artifacts Collection" : return "medical-artifacts";
        case "Cecil Lang Collection of Vanity Fair Illustrations" : return "vanity-fair";
        case "Eduardo Montes-Bradley Photograph and Film Collection" : return "montes-bradley";
        case "Francis Benjamin Johntson Photographs" : return "benjamin-johnston";
        }
        return name.toLowerCase().replace("university of virginia", "uva").replace("collection", "").trim().replace(" ", "-");
    }    

    final CloseableHttpClient client;
    
    private Transformer modsToUvaMap;
    private Transformer spreadsheetToVra;
    private Transformer vraToUvaMap;
    private Transformer uvaMapToSolr;
    private Transformer spreadsheetToUvaMap;
    private Transformer vickeryToUvaMap;
    
    private File indexDir;
    private boolean regenerate;
    
    public CollectionExporter(final File indexDir, boolean regenerate) throws TransformerConfigurationException {
        this.regenerate = regenerate;
        this.indexDir = indexDir;
        this.indexDir.mkdirs();
        client = HttpClients.createDefault();
        
        URIResolver r = new URIResolver() {
            @Override
            public Source resolve(String href, String base) throws TransformerException {
                System.out.println("Resolving " + href);
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
                    System.err.println("Unable to parse " + href + " (base=" + base + ")");
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
        vraToUvaMap = f.newTemplates(new StreamSource(getClass().getClassLoader().getResourceAsStream("vra2uvaMap/vra2uvaMAP.xsl"))).newTransformer();
        spreadsheetToVra = f.newTemplates(new StreamSource(getClass().getClassLoader().getResourceAsStream("jMurrayHoward/jmurrayhoward2vra.xsl"))).newTransformer();
        spreadsheetToUvaMap = f.newTemplates(new StreamSource(getClass().getClassLoader().getResourceAsStream("jMurrayHoward/jmurrayhoward2uvaMAP.xsl"))).newTransformer();
        vickeryToUvaMap = f.newTemplates(new StreamSource(getClass().getClassLoader().getResourceAsStream("vickery/vickery2uvaMAP.xsl"))).newTransformer();
    }
    
    private File processJeffersonCountry() throws Exception {
        final String collectionId = "Architecture of Jefferson Country";
        final String shortName = abbrevateName(collectionId);
        final File outputDir = new File(indexDir, shortName); 
        outputDir.mkdirs();
        
        final File uvaMapDir = new File("src/main/resources/JeffersonCountry/uvaMAP");
        
        final File solrDoc = new File(outputDir, shortName + "-solr-add-docs.xml");
        if (solrDoc.exists() && !regenerate) {
            return solrDoc;
        }
        final OutputStream solrOut = new FileOutputStream(solrDoc);
        solrOut.write("<add>\n".getBytes("UTF-8"));
        int skipped = 0;
        for (File uvaMapFile : uvaMapDir.listFiles()) {
            final String pid = uvaMapFile.getName().replaceAll(".vra_uvaMAP.xml", "").replaceAll("_", ":");
            System.out.println(pid);
            try {
                FileInputStream uvaMapIn = new FileInputStream(uvaMapFile);
                uvaMapToSolr.clearParameters();
                uvaMapToSolr.setParameter("skipAdd", "true");
                uvaMapToSolr.setParameter("extraIdentifier", pid);
                uvaMapToSolr.setParameter("collectionParam", "Architecture of Jefferson Country");
                uvaMapToSolr.transform(new StreamSource(uvaMapIn), new StreamResult(solrOut));
            } catch (Throwable t) {
                if (skipped++ > 2) {
                    t.printStackTrace();
                    System.out.println("SKIPPED " + pid + "!");
                    continue;
                }
            } finally {
                uvaMapToSolr.clearParameters();
            }
        }
        solrOut.write("\n</add>".getBytes("UTF-8"));
        solrOut.close();
        return solrDoc;
    }
    
    private File processJStorForumCollection() throws Exception {
        final File outputDir = new File(indexDir, "jmurrayhoward");
        outputDir.mkdir();
        final File uvaMapFile = new File(outputDir, "jmurrayhoward-uvamap.xml");
        final File solrFile = new File(outputDir, "jmurrayhoward-solr.xml");
        if (solrFile.exists() && !regenerate) {
            return solrFile;
        }
        
        //final StreamSource xlsSource = new StreamSource(getClass().getClassLoader().getResourceAsStream("jMurrayHoward/JMH_published_2021_01_08-sample2.xml"));
        //final StreamSource xlsSource = new StreamSource(getClass().getClassLoader().getResourceAsStream("jMurrayHoward/JMH_published_2021_01_08.xml"));
        final StreamSource xlsSource = new StreamSource(getClass().getClassLoader().getResourceAsStream("JMHoward.xml"));
        final StreamResult uvaMapOut = new StreamResult(new FileOutputStream(uvaMapFile));
        try {
            spreadsheetToUvaMap.transform(xlsSource, uvaMapOut);
        } finally {
            uvaMapOut.getOutputStream().close();
        }
        final StreamSource uvaMapSource = new StreamSource(new FileInputStream(uvaMapFile));
        final StreamResult solrOut = new StreamResult(new FileOutputStream(solrFile));
        try {
            uvaMapToSolr.clearParameters();
            uvaMapToSolr.setParameter("collectionParam", "James Murray Howard University of Virginia Historic Buildings and Grounds Collection, University of Virginia Library");
            uvaMapToSolr.transform(uvaMapSource, solrOut);
        } finally {
            solrOut.getOutputStream().close();
        }
        return solrFile;
        
    }
    private File processVickeryCollection() throws Exception {
        final File outputDir = new File(indexDir, "vickery");
        outputDir.mkdir();
        final File vraFile = new File(outputDir, "vickery_VRA.xml");
        final File uvaMapFile = new File(outputDir, "vickery_uvaMAP.xml");
        final File solrFile = new File(outputDir, "vickery_solr.xml");
        if (solrFile.exists() && !regenerate) {
            return solrFile;
        }
        
        //final StreamSource xlsSource = new StreamSource(getClass().getClassLoader().getResourceAsStream("jMurrayHoward/JMH_published_2021_01_08-sample2.xml"));
        final StreamSource xlsSource = new StreamSource(getClass().getClassLoader().getResourceAsStream("vickery/vickery_fromXLS.xml"));
        final StreamResult uvaMapOut = new StreamResult(new FileOutputStream(uvaMapFile));
        try {
            vickeryToUvaMap.transform(xlsSource, uvaMapOut);
        } finally {
            uvaMapOut.getOutputStream().close();
        }
        final StreamSource uvaMapSource = new StreamSource(new FileInputStream(uvaMapFile));
        final StreamResult solrOut = new StreamResult(new FileOutputStream(solrFile));
        try {
            uvaMapToSolr.setParameter("collectionParam", "Vickery Dickery Dock Collection, University of Virginia Library");
            uvaMapToSolr.transform(uvaMapSource, solrOut);
        } finally {
            solrOut.getOutputStream().close();
        }
        return solrFile;
        
    }
    
    private File processMODSCollectionFromVirgo3Solr(String collectionId) throws Exception {
        final String shortName = abbrevateName(collectionId);
        final File outputDir = new File(indexDir, shortName);
        outputDir.mkdirs();
        
        final File cacheDir = new File(outputDir, "cache");
        final File modsDir = new File(cacheDir, "mods");
        final File uvaMapDir = new File(cacheDir, "uvamap");
        modsDir.mkdirs();
        uvaMapDir.mkdirs();
        
        final File solrDoc = new File(indexDir, shortName + "-solr-add-docs.xml");
        if (solrDoc.exists() && !regenerate) {
            return solrDoc;
        }
        final OutputStream solrOut = new FileOutputStream(solrDoc);
        solrOut.write("<add>\n".getBytes("UTF-8"));
        int skipped = 0;
        for (String pid : getPidsForCollection(collectionId, cacheDir)) {
            //System.out.println(pid);
            try {
                File uvaMapFile = createUVAMapFile(getModsFile(pid, modsDir), uvaMapDir, pid);
                FileInputStream uvaMapIn = new FileInputStream(uvaMapFile);
                uvaMapToSolr.clearParameters();
                uvaMapToSolr.setParameter("skipAdd", "true");
                uvaMapToSolr.transform(new StreamSource(uvaMapIn), new StreamResult(solrOut));
            } catch (Throwable t) {
                if (skipped++ > 2) {
                    t.printStackTrace();
                    System.out.println("SKIPPED " + pid + "!");
                    continue;
                }
            }
            break;
        }
        solrOut.write("\n</add>".getBytes("UTF-8"));
        solrOut.close();
        return solrDoc;
    }
    
    private List<String> getPidsForCollection(final String collectionId, final File cacheDir) throws Exception {
        final File solrResponseFile = new File(cacheDir, "solr-response.xml");
        if (!solrResponseFile.exists()) {
            cacheDir.mkdirs();
            cacheSolrResponse(collectionId, solrResponseFile);
        }
        
        return getPidsFromSolrResultSet(new FileInputStream(solrResponseFile));
    }
    
    private File createUVAMapFile(final File modsFile, final File uvaMapCacheDir, final String pid) throws Exception {
        final InputStream is = new FileInputStream(modsFile);
        try {
            final File uvaMap = new File(uvaMapCacheDir, fixPidForFile(pid) + "uvaMAP.xml");
            if (uvaMap.exists() && !regenerate) {
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
    
    private String fixPidForFile(String pid) {
		if (File.pathSeparatorChar == ':') {
			return (pid.replaceAll(":",  "_"));
		}
		return pid;
	}

	private File getModsFile(final String pid, final File modsDir) throws Exception {
        File modsFile = new File(modsDir, fixPidForFile(pid) + "-mods.xml");
        final String url = "https://tracksys-api-ws.internal.lib.virginia.edu/api/metadata/" + pid + "?type=mods";
        if (!modsFile.exists()) {
            HttpGet get = new HttpGet(new URI(url));
            CloseableHttpResponse response = client.execute(get);
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
    
    private void cacheSolrResponse(final String collectionId, final File outputFile) throws Exception {
        //    HttpGet get = new HttpGet(new URI("http://solr.lib.virginia.edu:8082/solr/core/select?q=digital_collection_facet:%22" + URLEncoder.encode(collectionId, "UTF-8") + "%22&rows=24000&fl=id"));
        HttpGet get = new HttpGet(new URI("http://libsvr40.lib.virginia.edu:8983/solr/all/select?q=digital_collection_facet:%22" + URLEncoder.encode(collectionId, "UTF-8") + "%22&rows=24000&fl=id"));
        CloseableHttpResponse response = client.execute(get);
        try {
            if (response.getStatusLine().getStatusCode() == 200) {
                FileUtils.copyInputStreamToFile(response.getEntity().getContent(), outputFile);
            } else {
                throw new Exception("Unexpected response: " + response.getStatusLine().getStatusCode() + " " + response.getStatusLine().getReasonPhrase());
            }
        } finally {
            response.close();
        }
    }
    
    public static List<String> getPidsFromSolrResultSet(InputStream solrXml) throws Exception {
        final List<String> results = new ArrayList<String>();
        
        XMLInputFactory factory = XMLInputFactory.newInstance();
        XMLEventReader xmlr = factory.createXMLEventReader(solrXml);
        
        boolean inDoc = false;
        boolean foundFirst = false;
        
        try {
                
            while(xmlr.hasNext()) {
                XMLEvent event = xmlr.nextEvent();
                if (event.isStartElement() && event.asStartElement().getName().getLocalPart().equals("doc")) {
                    inDoc = true;
                    foundFirst = false;
                } else if (event.isEndElement() && event.asEndElement().getName().getLocalPart().equals("doc")) {
                    inDoc = false;
                } else if (inDoc && !foundFirst && event.isStartElement() && event.asStartElement().getName().getLocalPart().equals("str")) {
                   StringBuffer sb = new StringBuffer();
                   while (xmlr.hasNext() && !event.isEndElement()) {
                       event = xmlr.nextEvent();
                       if (event.isCharacters()) {
                           sb.append(event.asCharacters().getData());
                       }
                   }
                   results.add(sb.toString());
                   foundFirst = true;
                }
               
           }
        } finally {
            solrXml.close();
        }
        return results;
        
    }
    
}
