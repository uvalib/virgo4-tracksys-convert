package edu.virginia.lib.imagepool;

public class WilsonIndexer {
    
    public static void main(String [] args) throws Exception {
        (new JStorForumIndexer("xml-from-jstor/RGWilson_pt1.xml", "wilson1", true) {}).generateIndexDocuments();
        (new JStorForumIndexer("xml-from-jstor/RGWilson_pt2.xml", "wilson2", true) {}).generateIndexDocuments();

    }

}
