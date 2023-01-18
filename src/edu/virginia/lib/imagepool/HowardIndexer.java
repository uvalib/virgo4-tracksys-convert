package edu.virginia.lib.imagepool;

public class HowardIndexer extends JStorForumIndexer {
    
    public HowardIndexer() {
        super("xml-from-jstor/JMHoward.xml", "howard", true);
    }
    
    public static void main(String [] args) throws Exception {
        new HowardIndexer().generateIndexDocuments();
    }

}
