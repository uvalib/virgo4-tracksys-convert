package edu.virginia.lib.imagepool;

public class MeyerIndexer extends JStorForumIndexer {
    
    public MeyerIndexer() {
        super("xml-from-jstor/Meyer.xml", "meyer", true);
    }
    
    public static void main(String [] args) throws Exception {
        new MeyerIndexer().generateIndexDocuments();
    }

}
