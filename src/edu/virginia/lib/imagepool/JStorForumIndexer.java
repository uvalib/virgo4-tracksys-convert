package edu.virginia.lib.imagepool;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.xml.stream.XMLEventFactory;
import javax.xml.stream.XMLEventReader;
import javax.xml.stream.XMLEventWriter;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.events.XMLEvent;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;
import javax.xml.transform.sax.SAXTransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import net.sf.saxon.lib.StandardOutputResolver;
import net.sf.saxon.trans.XPathException;

/**
 * An abstract class that encapsulates all the shared methods used
 * to index image collections from JStorForum.  The indexing process
 * starts with an XML representaiton of the exported spreadsheet. 
 */
public abstract class JStorForumIndexer extends AbstractIndexer {

    /**
     * The path (relative to the classpath) of the source spreadsheet.
     */
    private String sourceSpreadsheetPath;
    
    private String collectionShortName;
    
    private boolean debug;
    
    /**
     * @param path the path to the spreadsheet XML file
     * @param name a short name for the collection -- used in naming output files
     * @param debug set this value to "true" to cause generateIndexDocuments to 
     *        output to a non-unique directory name which will allow subsequent runs
     *        to use the existing results from the expensive lookups and just reperform 
     *        the transformation steps.
     */
    public JStorForumIndexer(final String path, final String name, boolean debug) {
        this.sourceSpreadsheetPath = path;
        this.collectionShortName = name;
        this.debug = debug;
    }
    
    /**
     * Processes the spreadsheet and produces all the index documents for
     * the JStorForum collection.
     */
    public void generateIndexDocuments() throws Exception {
        
        String timestamp = new SimpleDateFormat("yyyy-MM-dd-hhmm").format(new Date());
        File processDir = (debug ? new File(collectionShortName + "-debug") : new File(collectionShortName + "-" + timestamp));
        processDir.mkdirs();
        
        // produce supplementary metadata information
        File ssids = new File(processDir, "ssids.txt");
        File extraMetadata = new File(processDir, "extra-metadata.xml");
        if (ssids.exists()) {
            System.out.println("Skipping SSID generation!");
        } else {
            writeOutArray(ssids, getSSIDValues());
        }
        if (extraMetadata.exists()) {
            System.out.println("Skipping JStorForum lookups!");
        } else {
            JStorForumIIIFURLFinder.main(new String[] { ssids.getPath(), extraMetadata.getPath() });
        }
        
        // TODO: augment spreadsheet
        
        // generate uvaMap and solr files
        createUvaMapFiles(extraMetadata);

        // create solr files
        final File uvaMapRoot = new File(processDir, "uvaMAP");
        final File solrOutputDir = new File(processDir, "solr");
        createSolrFiles(uvaMapRoot, solrOutputDir);
        
        final File bulkAddDoc = new File(processDir, collectionShortName + "-collection-add-docs-" + timestamp +".xml");
        concatenateAddDocs(solrOutputDir.listFiles(), bulkAddDoc);
    }
    
    /**
     * A helper method to get an InputStream to read the spreadsheet XML
     */
    public InputStream getSpreadsheetStream() {
        return this.getClass().getClassLoader().getResourceAsStream(sourceSpreadsheetPath);
    }
    

    /**
     * Gets a transformer for the given XSLT file that's configured to write out
     * documents to the given output directory.
     * @param xsltPath the path (relative to classpath) of the XSLT file
     * @param output the directory to which output files are written
     */
    Transformer getTransformer(String xsltPath, File output) throws Exception {
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
        net.sf.saxon.TransformerFactoryImpl f2 = (net.sf.saxon.TransformerFactoryImpl) f;
        f2.getConfiguration().setOutputURIResolver(new LocalOutputURIResolver(output));
        f.setURIResolver(r);
        return f.newTemplates(new StreamSource(JStorForumIndexer.class.getClassLoader().getResourceAsStream(xsltPath))).newTransformer();
    }
    
    /**
     * A StandardOutputResolver that has a default base path which 
     * is considered for any relative output paths specified
     * in a given transformation scenario.
     */
    static class LocalOutputURIResolver extends StandardOutputResolver {

        private File defaultBase;

        public LocalOutputURIResolver(final File base) {
            this.defaultBase = base;
        }
        
        @Override
        public Result resolve(String href, String base) throws XPathException {
            if (base == null) {
                return super.resolve(href, this.defaultBase.toURI().toString());
            } else {
                return super.resolve(href, base); 
            }
        }
        
    }
    
    /**
     * Creates UVAMap files from the spreadsheet and the supplemental metadata
     */
    void createUvaMapFiles(final File extraMetadata) throws Exception {
        final File outputDir = extraMetadata.getParentFile();
        final File uvaMapFile = new File(outputDir, "uvamap.xml");
        final File uvamapOutputDir = new File(outputDir, "uvamap");
        
        final StreamSource xlsSource = new StreamSource(this.getSpreadsheetStream());
        final StreamResult uvaMapOut = new StreamResult(new FileOutputStream(uvaMapFile));
        try {
            Transformer t = getTransformer("jstor2uvaMAP.xsl", uvamapOutputDir);
            t.setParameter("externalSSIDfile", extraMetadata.toURI().toString());
            t.transform(xlsSource, uvaMapOut);
        } finally {
            uvaMapOut.getOutputStream().close();
        }
    }
    
    /**
     * Creates solr files from the UVAMap files found in the given directory
     * @param uvaMapRoot base directory in which to start looking for UVA Map files
     * @param solrOutputDir directory to write out individual Solr Add documents
     */
    void createSolrFiles(File uvaMapRoot, File solrOutputDir) throws Exception {
        if (!uvaMapRoot.exists() || !uvaMapRoot.isDirectory()) {
            throw new RuntimeException("UVAMap root directory seems to be incorrect! (" + uvaMapRoot.getAbsolutePath() + ")");
        }
        
        solrOutputDir.mkdirs();
        
        
        Transformer uvaMapToSolr = getTransformer("uvamap2solr.xsl", solrOutputDir);
        System.out.println("Created " + convertContainedUVAMAPFilesToSolr(uvaMapRoot, uvaMapToSolr, solrOutputDir) +  " solr documents.");
    }
    
    /**
     * A recursive method to do the work of identifying and transforming uvaMap files.
     * @throws IOException 
     */
    int convertContainedUVAMAPFilesToSolr(final File file, Transformer t, final File outputDir) throws TransformerException, IOException {
        if (file.isDirectory()) {
            int count = 0;
            for (File f : file.listFiles()) {
                count += convertContainedUVAMAPFilesToSolr(f, t, outputDir);
            }
            return count;
        } else {
            File solrFile = new File(outputDir, file.getName().split("\\.")[0] + "-solr.xml");
            final StreamSource uvaMapSource = new StreamSource(new FileInputStream(file));
            final StreamResult solrOut = new StreamResult(new FileOutputStream(solrFile));
            try {
                t.transform(uvaMapSource,  solrOut);
                return 1;
            } catch (Throwable ex) {
                solrOut.getOutputStream().close();
                solrFile.delete();
                ex.printStackTrace();
                System.err.println("UVAMAP file for " + file.getAbsolutePath() + " unable to be converted to solr! (SKIPPED)");
                return 0;
            }
        }
        
    }
    
    /**
     * A helper method to write out a list of values into an file.
     */
    void writeOutArray(File f, Iterable<String> values) throws IOException {
        PrintWriter out = new PrintWriter(new OutputStreamWriter(new FileOutputStream(f)));
        try {
            for (String value : values) {
                out.println(value);
            }
        } finally {
            out.close();
        }
        return;
    }
    
    /**
     * Parses the XL representaiton of the collection spreadsheet to 
     * get just the SSID values.
     */
    Iterable<String> getSSIDValues() throws XMLStreamException, IOException {
        final List<String> results = new ArrayList<String>();
        
        XMLInputFactory factory = XMLInputFactory.newInstance();
        XMLEventReader xmlr = factory.createXMLEventReader(getSpreadsheetStream());
        
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
                    results.add(sb.toString());
                }
           }
        } finally {
            xmlr.close();
        }
        return results;
    }
}
