package edu.virginia.lib.imagepool;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;

public class ClearCollection {

    /**
     *  http://virgo4-solr-staging-master-private.internal.lib.virginia.edu:8080/solr/images_core/select?fl=id&q=digital_collection_a%3A%22James%20Murray%20Howard%20University%20of%20Virginia%20Historic%20Buildings%20and%20Grounds%20Collection%2C%20University%20of%20Virginia%20Library%22&rows=10000&wt=xml
     * @param args
     * @throws Exception
     */
    public static void main(String[] args) throws Exception {
        PrintWriter out = new PrintWriter(new OutputStreamWriter(new FileOutputStream("howard-mismatch.ids")));
        FileInputStream in = new FileInputStream("howard-mismatch.xml");
        for (String pid : CollectionExporter.getPidsFromSolrResultSet(in)) {
            out.println(pid);
            System.out.println(pid);
        }
        out.close();
    }
    
}
