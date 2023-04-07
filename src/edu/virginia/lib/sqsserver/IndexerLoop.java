package edu.virginia.lib.sqsserver;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.BlockingQueue;

import org.apache.log4j.Logger;

import com.amazonaws.services.sqs.model.Message;

import edu.virginia.lib.imagepool.IndexingException;
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
    protected Map<String, ModsIndexer>indexerMap = null;
    
    public IndexerLoop(SQSOutProxy output)
    {
        sqsProxy = output;
        indexerMap = new LinkedHashMap<String, ModsIndexer>();
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
    public void indexToSolr(final MessageReader reader) throws Exception
    {
        theReaderThread = Thread.currentThread();
        while (!shuttingDown)
        {
            MessageAndDoc messageAndDoc = getRecord(reader);
            if (messageAndDoc == null) break;
            logger.debug("message read : " + messageAndDoc.getPid());

//            MessageAndDoc messageAndDoc = null;
            boolean markMessageDone = false;
            try {
                getIndexDoc(messageAndDoc);
            }
            catch (IndexingException ie) {
                if (ie.getPhase() != IndexingException.IndexingPhase.GET_MODS_UNK)
                {
                    markMessageDone = true;
                    logger.warn(ie.getMessage());
                    logger.warn("Marking message with id: "+messageAndDoc.getPid()+ " as processed even though no Solr doc will be sent");
                }
                else
                {
                    logger.warn(ie.getMessage());
                    logger.warn("Leaving message with id: "+messageAndDoc.getPid()+ " in queue, due to unknown, and unexpected error.");
                }
            }
            catch (Exception e) {
                logger.error(e.getMessage());
                logger.warn("Leaving message with id: "+messageAndDoc.getPid()+ " in queue, due to unknown, and unexpected error.");
            }

            if (messageAndDoc.getDoc() != null)
            {
                outputSingleDocument(messageAndDoc);
            }
            else if (markMessageDone)
            {
                markMessageRead(messageAndDoc);
            }
            else
            {
                //  do nothing, leave message in queue and hope for better luck next time.
            }
        }
    }

    private MessageAndDoc getRecord(MessageReader reader)
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
    
    private void markMessageRead(MessageAndDoc messageAndDoc)
    {
        sqsProxy.markMessageProcessed(messageAndDoc);        
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
        if (indexerMap.containsKey(source))
        {
            indexer = indexerMap.get(source);
        }
        else 
        {
            if (source.equals("tracksys"))
            {
                indexer = new TracksysPidListIndexer(true);
            }
            indexerMap.put(source, indexer);
        }
        return indexer;
    }

    public void endProcessing()
    {
    }
    
}
