package edu.virginia.lib.sqsserver;

import java.util.Collection;
import java.util.Iterator;

public class SQSWrappedProxy extends SQSOutProxy
{
    private SQSOutProxy wrapped = null;
    private AwsSqsSingleton aws_sqs = null;

    public SQSWrappedProxy(SQSOutProxy wrapped)
    {
        this.wrapped = wrapped;
        aws_sqs = AwsSqsSingleton.getInstance(null);
    }

    public int addDoc(MessageAndDoc messageAndDoc)
    {
        String inputDoc = messageAndDoc.getDocAsString();
        String id = messageAndDoc.getPid();
        wrapped.addDoc(messageAndDoc);
        markMessageProcessed(messageAndDoc);
        return(1);
    }

    @Override
    public int addDocs(Collection<MessageAndDoc> docQ)
    {
        Iterator <MessageAndDoc> iter = docQ.iterator();
        int num = 0;
        while (iter.hasNext())
        {
            MessageAndDoc inputDoc = iter.next();
            num += addDoc(inputDoc);
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
}
