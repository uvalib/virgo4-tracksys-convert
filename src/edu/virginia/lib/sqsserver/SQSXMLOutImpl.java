package edu.virginia.lib.sqsserver;

import java.util.Collection;
import java.util.Iterator;

import org.apache.log4j.Logger;

import com.amazonaws.services.sqs.model.MessageAttributeValue;
import com.amazonaws.services.sqs.model.SendMessageRequest;

public class SQSXMLOutImpl extends SQSOutProxy
{
    private String queueUrl = null;
    private String queueName; // = "virgo4-ingest-sirsi-marc-convert-staging";
    private AwsSqsSingleton aws_sqs = null;
    private boolean createQueueIfNotExists = false;
    private final static Logger logger = Logger.getLogger(SQSXMLOutImpl.class);

    public SQSXMLOutImpl(String queueName, String s3BucketName)
    {
        this.queueName = queueName;
        init(queueName, s3BucketName);
    }
    
    public SQSXMLOutImpl(String queueName, String s3BucketName, boolean createQueue)
    {
        this.queueName = queueName;
        this.createQueueIfNotExists = createQueue;
        init(queueName, s3BucketName);
    }
    
    private void init(String queueName, String s3BucketName)
    {
        this.queueName = queueName;
        
        aws_sqs = AwsSqsSingleton.getInstance(s3BucketName);
        queueUrl = aws_sqs.getQueueUrlForName(this.queueName, createQueueIfNotExists);
    }

    public int addDoc(MessageAndDoc messageAndDoc)
    {
        String inputDoc = messageAndDoc.getDocAsString();
        String id = messageAndDoc.getPid();
        String source = messageAndDoc.getSourceAttribute();
        SendMessageRequest message = new SendMessageRequest(queueUrl, inputDoc)
                .addMessageAttributesEntry("id", new MessageAttributeValue().withDataType("String").withStringValue(id))
                .addMessageAttributesEntry("source", new MessageAttributeValue().withDataType("String").withStringValue(source))
                .addMessageAttributesEntry("type", new MessageAttributeValue().withDataType("String").withStringValue("application/xml"));

        if (messageAndDoc.hasAttribute("ignore-cache"))
        {
        	String ignoreCacheStr = messageAndDoc.getAttribute("ignore-cache");
            message.addMessageAttributesEntry( "ignore-cache", new MessageAttributeValue().withDataType("String").withStringValue(ignoreCacheStr));
        }
        aws_sqs.getSQS().sendMessage(message);
        markMessageProcessed(messageAndDoc);
        return(1);
    }

    @Override
    public int addDocs(Collection<MessageAndDoc> messageAndDocList)
    {
        Iterator <MessageAndDoc> iter = messageAndDocList.iterator();
        PushbackIterator<MessageAndDoc> pbIter = PushbackIterator.pushbackIterator(iter);
        int num = 0;
//        int messageBatchSize;
//        SendMessageBatchRequestEntry messageReq;
//        String messageSizes[];
//        int i;
//        boolean oversizeOnly = Boolean.parseBoolean(System.getProperty("solrmarc-sqs-oversize-only", "false"));
        while (pbIter.hasNext())
        {
            MessageAndDoc messageAndDoc = pbIter.next();
            this.addDoc(messageAndDoc);
            num++;
        }
//            List<SendMessageBatchRequestEntry> messageBatchReq = new ArrayList<SendMessageBatchRequestEntry>(10);
//            Map<String,String> toDeleteMap = new LinkedHashMap<String, String>(10);
//            messageBatchSize = 0;
//            messageSizes = new String[10];
//            for (i = 0; i < 10 && pbIter.hasNext(); i++)
//            {
//            	MessageAndDoc inputRecDoc = pbIter.next();
//            	SolrInputDocument inputDoc = inputRecDoc.getDoc();
//                String xml = ClientUtils.toXML(inputDoc);
//                String id = inputDoc.getFieldValue("raw_id") != null ? inputDoc.getFieldValue("raw_id").toString() : 
//                            inputDoc.getFieldValue("id") != null ? inputDoc.getFieldValue("id").toString() : "<no id>";
//                RecordPlus recPlus = (RecordPlus)inputRecDoc.getRec();
//                if (recPlus.hasExtraData("message-attribute-message-id"))
//                {
//                	id = recPlus.getExtraData("message-attribute-message-id");
//                }
//                String messageReceiptHandle = recPlus.getExtraData("message-receipt-handle");
//
//                // The attributes here must be the same (is size at least) as those added below note id is include twice since it is used as an attribute and as the batch id
//                int curMessageSize = getTotalMessageSize(xml, id, "id", id, "source", "solrmarc", "type", "application/xml", "ignore-cache", "false");
//                if (i > 0 && messageBatchSize + curMessageSize >= AwsSqsSingleton.SQS_SIZE_LIMIT)
//                {
//                    logger.info("Message batch would be too large, only sending " + (i + 1) + " messages in batch");
//                    pbIter.pushback(inputRecDoc);
//                    break;
//                }
//                if (toDeleteMap.containsKey(id))
//                {
//                    logger.info("Message batch already contains message with id " + id );
//                    pbIter.pushback(inputRecDoc);
//                    break;
//                }
//                messageSizes[i] = id + " : " + curMessageSize;
//                messageReq = new SendMessageBatchRequestEntry(queueUrl, xml).withId(id)
//                        .addMessageAttributesEntry("id", new MessageAttributeValue().withDataType("String").withStringValue(id))
//                        .addMessageAttributesEntry("source", new MessageAttributeValue().withDataType("String").withStringValue("solrmarc"))
//                        .addMessageAttributesEntry("type", new MessageAttributeValue().withDataType("String").withStringValue("application/xml"));
//                if (recPlus.hasExtraData("message-attribute-ignore-cache"))
//                {
//                	String ignoreCacheStr = recPlus.getExtraData("message-attribute-ignore-cache");
//                	messageReq.addMessageAttributesEntry( "ignore-cache", new MessageAttributeValue().withDataType("String").withStringValue(ignoreCacheStr));
//                }
//
//                messageBatchReq.add(messageReq);
//                num++;
//                messageBatchSize += curMessageSize;
//                toDeleteMap.put(id, messageReceiptHandle);
//            }
//            if (oversizeOnly && ( i > 1 || messageBatchSize < AwsSqsSingleton.SQS_SIZE_LIMIT))  continue;
//            SendMessageBatchRequest sendBatchRequest = new SendMessageBatchRequest().withQueueUrl(queueUrl)
//                    .withEntries(messageBatchReq);
//            try {
//                SendMessageBatchResult result = aws_sqs.getSQS().sendMessageBatch(sendBatchRequest);
//                for (BatchResultErrorEntry failed : result.getFailed())
//                {
//                    toDeleteMap.remove(failed.getId());
//                }
//                aws_sqs.removeBatch(toDeleteMap);   
//            }
//            catch (com.amazonaws.services.sqs.model.BatchRequestTooLongException tooBig)
//            {
//                logger.warn("Amazon sez I cannot handle that batch, it is too big. Perhaps I could handle a smaller one though.");
//                for (int j = 0; j < i; j++)
//                {
//                    logger.warn("message : "+ messageSizes[j]);
//                }
//                logger.warn("My computed batch size was "+ messageBatchSize, tooBig);
//            }
//        }
        if (num < messageAndDocList.size()) 
        {
            logger.debug("Not all queued documents sent");
        }
        return(num);
    }

    @Override
    public boolean markMessageProcessed(MessageAndDoc messageAndDoc)
    {
        String messageReceiptHandle = null;
        String id = messageAndDoc.getPid();
        if (messageAndDoc.getMessageReceiptHandle() != null)
        {
            messageReceiptHandle = messageAndDoc.getMessageReceiptHandle();
            aws_sqs.remove(id, messageReceiptHandle);
            return(true);
        }
        return(false);
    }

    private int getTotalMessageSize(String message, String batchId, String ... attributes)
    {
        int len = message.length();
       // len += batchId.length();
        for (String attribute : attributes)
        {
            len += attribute.length() + 3;
        }
        len += 500;  // fudge factor.    MMMmm  fudge.
        return(len);
    }

}
