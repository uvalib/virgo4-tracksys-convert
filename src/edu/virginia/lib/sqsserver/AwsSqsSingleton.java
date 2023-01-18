package edu.virginia.lib.sqsserver;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.amazon.sqs.javamessaging.AmazonSQSExtendedClient;
import com.amazon.sqs.javamessaging.ExtendedClientConfiguration;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
import com.amazonaws.services.sqs.model.CreateQueueRequest;
import com.amazonaws.services.sqs.model.CreateQueueResult;
import com.amazonaws.services.sqs.model.DeleteMessageBatchRequest;
import com.amazonaws.services.sqs.model.DeleteMessageBatchRequestEntry;
import com.amazonaws.services.sqs.model.DeleteMessageBatchResult;
import com.amazonaws.services.sqs.model.DeleteMessageRequest;
import com.amazonaws.services.sqs.model.GetQueueUrlResult;
import com.amazonaws.services.sqs.model.QueueDoesNotExistException;

public class AwsSqsSingleton
{
    private static boolean alwaysThroughS3 = false;
    public static final int SQS_SIZE_LIMIT = 262144;
    private AmazonSQS sqs;
    private AmazonS3 s3;
    private boolean shutdown = false;
    String queueUrl = null;

    private final static Logger logger = Logger.getLogger(AwsSqsSingleton.class);

    private static AwsSqsSingleton instance = null;

    private AwsSqsSingleton() {} ; // private to ensure its a singleton

    public static AwsSqsSingleton getInstance(String s3BucketName)
    {
        if (instance != null) return (instance);
        AwsSqsSingleton local = new AwsSqsSingleton();
        AmazonSQS sqstmp = AmazonSQSClientBuilder.defaultClient();
        if (s3BucketName != null)
        {
            local.s3 = AmazonS3ClientBuilder.standard().build();
            ExtendedClientConfiguration extendedClientConfig = new ExtendedClientConfiguration();
            extendedClientConfig.withLargePayloadSupportEnabled(local.s3, s3BucketName)
                .withAlwaysThroughS3(alwaysThroughS3).withMessageSizeThreshold(SQS_SIZE_LIMIT);

            final AmazonSQSExtendedClient sqsx = new AmazonSQSExtendedClient(sqstmp, extendedClientConfig);
            local.sqs = sqsx;
        }
        else  // Use the normal, non-extended client
        {
            local.sqs = sqstmp;
        }

        instance = local;
        return(instance);
    }

    public AmazonSQS getSQS()
    {
        return(sqs);     
    }

    public String getQueueUrlForName(String queueName, boolean createQueueIfNotExists)
    {
        logger.debug("Listing all queues in your account.");
        try { 
            GetQueueUrlResult queueUrlResult = sqs.getQueueUrl(queueName);
            if (queueUrlResult != null)
            {
                queueUrl = queueUrlResult.getQueueUrl();
                return (queueUrl);
            }
            logger.debug("SQS queue named "+ queueName+ " not found");
            throw new RuntimeException("SQS queue named "+ queueName+ " not found");
        }
        catch (QueueDoesNotExistException NoQ)
        {
            if (createQueueIfNotExists)
            {
                logger.debug("Creating a new SQS queue called "+ queueName);
                final CreateQueueRequest createQueueRequest = new CreateQueueRequest(queueName);
                CreateQueueResult createResult = sqs.createQueue(createQueueRequest);
                if (createResult != null) 
                {
                    return (createResult.getQueueUrl());
                }
            }
            logger.debug("SQS queue named "+ queueName+ " not found");
            throw new RuntimeException("SQS queue named "+ queueName+ " not found");
        }
    }

    public void remove(String id, String messageHandle)
    {
        getSQS().deleteMessage(new DeleteMessageRequest(queueUrl, messageHandle));            
    }

    public void removeBatch(Map<String, String> toDeleteMap)
    {
        Iterator<String> iter = toDeleteMap.keySet().iterator();
        while (iter.hasNext())
        {
            List<DeleteMessageBatchRequestEntry> toDeleteRequest = new ArrayList<DeleteMessageBatchRequestEntry>(10);
            for (int i = 0; i < 10 && iter.hasNext(); i++)
            {
                String id = iter.next();
                String messageHandle = toDeleteMap.get(id);
                toDeleteRequest.add(new DeleteMessageBatchRequestEntry(id, messageHandle));
            }
            @SuppressWarnings("unused")
            DeleteMessageBatchResult res = getSQS().deleteMessageBatch(new DeleteMessageBatchRequest(queueUrl).withEntries(toDeleteRequest));
        }
    }

    public void shutdown()
    {
        if (!shutdown) 
        {
            sqs.shutdown();
            shutdown = true;
        }
    }

}
