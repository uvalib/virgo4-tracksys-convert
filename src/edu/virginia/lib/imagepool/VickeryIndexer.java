package edu.virginia.lib.imagepool;

public class VickeryIndexer extends JStorForumIndexer {
    
    public VickeryIndexer() {
        super("xml-from-jstor/Vickery.xml", "vickery", true);
    }
    
    public static void main(String [] args) throws Exception {
        new VickeryIndexer().generateIndexDocuments();
    }

}
