package edu.virginia.lib.sqsserver;

import java.util.List;

import org.apache.log4j.Logger;

import com.amazonaws.services.sqs.model.Message;
import com.amazonaws.services.sqs.model.ReceiveMessageRequest;

public class SQSMessageReader
{

    private String queueUrl = null;
    private String queueName; // = "virgo4-ingest-sirsi-inbound-staging";
   // private String s3BucketName; // = "virgo4-ingest-staging-messages";
    ReceiveMessageRequest receiveMessageRequest;
    private boolean createQueueIfNotExists = false;
    private boolean alreadyWaiting = false;
    private List<Message> curMessages;
    private int curMessageIndex;
    private AwsSqsSingleton aws_sqs = null;
    private int messagesSinceLastSleep = 0;

    private final static Logger logger = Logger.getLogger(SQSMessageReader.class);

    public SQSMessageReader(String queueName)
    {
        init(queueName, null);
    }

    public SQSMessageReader(String queueName, String s3BucketName)
    {
        init(queueName, s3BucketName);
    }

    public SQSMessageReader(String queueName, String s3BucketName, boolean createQueueIfNotExists)
    {
        this.createQueueIfNotExists = createQueueIfNotExists;
        init(queueName, s3BucketName);
    }

    public SQSMessageReader(String queueName, String s3BucketName, boolean createQueueIfNotExists, SQSQueueDriver driver)
    {
        this.createQueueIfNotExists = createQueueIfNotExists;
        init(queueName, s3BucketName);
    }

    private void init(String queueName, String s3BucketName)
    {
        this.queueName = queueName;

        aws_sqs = AwsSqsSingleton.getInstance(s3BucketName);
        queueUrl = aws_sqs.getQueueUrlForName(this.queueName, createQueueIfNotExists);
        receiveMessageRequest = new ReceiveMessageRequest(queueUrl).withMaxNumberOfMessages(10).withMessageAttributeNames("All").withWaitTimeSeconds(20);
    }

    public boolean hasNext()
    {
        if (this.curMessages == null && this.curMessageIndex == 0 || this.curMessageIndex >= this.curMessages.size())
        {
            // make blocking call
            fetchMessages();
        }
        return(curMessages == null ? false : this.curMessageIndex < this.curMessages.size());
    }

    private void fetchMessages()
    {
        curMessageIndex = -1;
        while (curMessageIndex == -1 && ! Thread.currentThread().isInterrupted())
        {
            try {
                curMessages = aws_sqs.getSQS().receiveMessage(receiveMessageRequest).getMessages();
                if (curMessages.size() > 0)
                {
                    curMessageIndex = 0;
                    messagesSinceLastSleep += curMessages.size();
                    if (alreadyWaiting) 
                    {
                        logger.info("Read queue " + this.queueName + " active again. Getting to work.");
                        alreadyWaiting = false;
                    }
                }
                else if (Boolean.parseBoolean(System.getProperty("solrmarc.sqsdriver.terminate.on.empty", "false")))
                {
                    logger.info("Read queue " + this.queueName + " is empty and solrmarc.sqsdriver.terminate.on.empty it true.  Calling it a day.");
                    curMessages = null;
                    curMessageIndex = 0;
                }
                else // timed out without finding any records.   If there is a partial chunk waiting to be sent, flush it out.
                {
                    if (!alreadyWaiting)
                    {
                        logger.info("Read queue " + this.queueName + " is empty. Waiting for more records");
                        logger.info(messagesSinceLastSleep + " messages received since waking up.");
                        alreadyWaiting = true;
                        messagesSinceLastSleep = 0;
                    }
                }
            }
            // this is sent when the sqs object is shutdown.  It causes the reader thread to terminate cleanly.
            // although at present it should actually be triggered.
            catch(com.amazonaws.AbortedException abort)
            {
                curMessages = null;
                curMessageIndex = 0;
            }
            catch(com.amazonaws.services.s3.model.AmazonS3Exception s3e)
            {
                logger.error("Read queue " + this.queueName + " Failed to get the S3 object associated with large SQS message. ");
            }
            catch(com.amazonaws.AmazonServiceException s3e)
            {
                logger.error("Read queue " + this.queueName + " Failed to get the S3 object associated with large SQS message. ");
            }
            catch(com.amazonaws.SdkClientException cas)
            {
                logger.error("Read queue " + this.queueName + " Failed trying to read SQS message. ");
                curMessages = null;
                curMessageIndex = 0;
            }
        }
        if (Thread.currentThread().isInterrupted())
        {
            curMessages = null;
            curMessageIndex = 0;
        }
    }

    public Message next()
    {
        if (hasNext())
        {
            Message message = curMessages.get(curMessageIndex++);
            return(message);
        }
        else 
        {
            return null;
        }
    }


//    public static void main(String[] args)
//    {
//        //    -sqs-in "virgo4-ingest-sirsi-marc-ingest-staging"
//        //    -s3 "virgo4-ingest-staging-messages" 
//        String queueName= "virgo4-ingest-sirsi-marc-ingest-staging";
//        String s3BucketName = "virgo4-ingest-staging-messages";
//        MarcReaderConfig config = new MarcReaderConfig().setCombineConsecutiveRecordsFields("852|853|863|866|867|868|999").setToUtf8(true).setPermissiveReader(true);
//
//        SQSMessageReader reader = new SQSMessageReader(config, queueName, s3BucketName);
//        long start = System.currentTimeMillis();
//        for (int i = 0; i < 1000; )
//        {
//            reader.fetchMessages();
//            i += reader.curMessages.size();
//        }
//        long end = System.currentTimeMillis();
//        System.out.println("Total time (fetch only)= "+ ((1.0 * (end - start)) / 1000.0) + " seconds");
//
//        start = System.currentTimeMillis();
//        for (int i = 0; i < 1000; i++)
//        {
//            @SuppressWarnings("unused")
//            Record record = reader.next();
//        //    if (record != null)
//       //     {
//       //         System.out.println(i);
//        //    }
//        }
//        end = System.currentTimeMillis();
//        System.out.println("Total time (fetch and convert to MARC)= "+ ((1.0 * (end - start)) / 1000.0) + " seconds");
//    }

}
