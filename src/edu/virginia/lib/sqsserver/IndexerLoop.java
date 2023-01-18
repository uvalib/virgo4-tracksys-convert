package edu.virginia.lib.sqsserver;

import java.util.concurrent.BlockingQueue;

import org.apache.log4j.Logger;

import com.amazonaws.services.sqs.model.Message;

import edu.virginia.lib.imagepool.ModsIndexer;
import edu.virginia.lib.imagepool.TracksysPidListIndexer;

public class IndexerLoop
{
    private final static Logger logger = Logger.getLogger(IndexerLoop.class);

    protected SQSOutProxy sqsProxy;
    protected BlockingQueue<MessageAndDoc> errQ;
    protected BlockingQueue<String> delQ;
    protected boolean shuttingDown = false;
    protected boolean viaInterrupt = false;
    protected boolean isShutDown = false;
    protected Thread theReaderThread = null;
    protected int trackOverallProgress = -1;
    
    public IndexerLoop(SQSOutProxy output)
    {
        sqsProxy = output;
        
    }
    
    
    
    /**
     * indexToSolr - Reads in a MARC Record, produces SolrInputDocument for it,
     * sends that document to solr This is the single threaded version that does
     * each of those action sequentially
     *
     * @param reader  MARC record reader object
     * @return        array containing number of records read, number of records
     *                indexed, and number of records sent to solr
     * @throws Exception 
     */
    public void indexToSolr(final SQSMessageReader reader) throws Exception
    {
        theReaderThread = Thread.currentThread();
        while (!shuttingDown)
        {
            MessageAndDoc messageAndDoc = getRecord(reader);
            if (messageAndDoc == null) break;
            logger.debug("message read : " + messageAndDoc.getPid());

//            MessageAndDoc messageAndDoc = null;
            getIndexDoc(messageAndDoc);

            if (messageAndDoc.getDoc() != null)
            {
                outputSingleDocument(messageAndDoc);
            }
        }

        if (shuttingDown)
        {
//            endProcessing();
        }
//        return (cnts);
    }

    private MessageAndDoc getRecord(SQSMessageReader reader)
    {
        MessageAndDoc result = null;
        if (reader.hasNext())
        {
            Message received = reader.next();
            result = new MessageAndDoc(received);            
        }
        return result;
    }
  
    private void outputSingleDocument(MessageAndDoc messageAndDoc)
    {
        sqsProxy.addDoc(messageAndDoc);        
    }

    private void getIndexDoc(MessageAndDoc messageAndDoc) throws Exception
    {
        ModsIndexer indexer = getIndexerForMessage(messageAndDoc);
        String pid = messageAndDoc.getPid();
        byte[] bais = indexer.indexItem(pid);
        messageAndDoc.setDoc(bais);
    }


    private ModsIndexer getIndexerForMessage(MessageAndDoc messageAndDoc) throws Exception
    {
        String source = messageAndDoc.getSourceAttribute();
        ModsIndexer indexer = null;
        if (source.equals("tracksys"))
            indexer = new TracksysPidListIndexer(true);
        return indexer;
    }



    public void endProcessing()
    {
    }
    
}
