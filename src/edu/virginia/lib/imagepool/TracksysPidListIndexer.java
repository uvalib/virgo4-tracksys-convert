package edu.virginia.lib.imagepool;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;

public class TracksysPidListIndexer extends ModsIndexer {

    public static void main(String args[]) throws Exception {
        File pidlistfile = new File(args[0]);
        BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(pidlistfile)));
        ArrayList<String> pids = new ArrayList<String>(); 
        String pid = null;
        while ((pid = reader.readLine()) != null) {
            if (pid.trim().length() > 0) {
                pids.add(pid);
            }
        }
        
        ModsIndexer indexer = new TracksysPidListIndexer(true);
        indexer.IndexItems(pids);
        reader.close();
    }

    public TracksysPidListIndexer(boolean b) throws Exception {
        super(b);
    }
    
}
