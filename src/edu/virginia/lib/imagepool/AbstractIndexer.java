package edu.virginia.lib.imagepool;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;

import javax.xml.stream.XMLEventFactory;
import javax.xml.stream.XMLEventReader;
import javax.xml.stream.XMLEventWriter;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.events.XMLEvent;

import org.apache.http.client.HttpClient;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;

public abstract class AbstractIndexer {
    
    /**
     * Concatenates the documents from the supplied add document XML files into
     * a single XML document.
     */
    void concatenateAddDocs(File[] allFiles, File outputFile) throws Exception {
       XMLEventWriter xmlw = XMLOutputFactory.newInstance().createXMLEventWriter(new FileOutputStream(outputFile));
       XMLEventFactory f = XMLEventFactory.newInstance();
       xmlw.add(f.createStartDocument());
       xmlw.add(f.createStartElement("", "", "add"));
       xmlw.add(f.createCharacters("\n"));
        for (File add : allFiles) {
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
        }
        xmlw.add(f.createEndElement("", "", "add"));
        xmlw.add(f.createEndDocument());
        xmlw.flush();
        xmlw.close();
    }
    
    private CloseableHttpClient client = null;

    public CloseableHttpClient getHttpClient() {
        if (client == null) {
            client = HttpClients.createDefault();
        }
        return client;
    }

}
