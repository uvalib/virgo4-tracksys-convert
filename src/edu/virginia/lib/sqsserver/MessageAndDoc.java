package edu.virginia.lib.sqsserver;

import java.nio.charset.StandardCharsets;

import com.amazonaws.services.sqs.model.Message;
import com.amazonaws.services.sqs.model.MessageAttributeValue;

/**
 * @author rh9ec
 *
 */
public class MessageAndDoc
{
    final Message message;
    Object doc;

    /**
     * Constructor for a MessageAndDoc object for which the Doc hasn't yet been created.
     *
     * @param message - The message being processed.
     */
    public MessageAndDoc(Message message)
    {
        this.message = message;
        this.doc = null;
    }

    /**
     * Used in conjunction with the above constructor to set the Doc member once it has been created.
     *
     * @param doc - The created SolrInputDocument
     */
    public void setDoc(Object doc)
    {
        this.doc = doc;
    }

    public String getPid()
    {
        String id = message.getMessageAttributes().get("id").getStringValue();
        return(id);
    }

    public Object getDoc()
    {
        return doc;
    }

    public String getDocAsString()
    {
        if (doc == null)
        {
            return(null);
        }
        String result = new String((byte[])doc, StandardCharsets.UTF_8);
        return(result);
    }

    public String getSourceAttribute()
    {
        String source = message.getMessageAttributes().get("source").getStringValue();
        return(source);
    }

    public String getMessageReceiptHandle()
    {
        String receipthandle = message.getReceiptHandle();
        return(receipthandle);
    }

    public boolean hasAttribute(String attribute)
    {
        MessageAttributeValue val = message.getMessageAttributes().get(attribute);
        return val != null;
    }

    public String getAttribute(String attribute)
    {
        MessageAttributeValue val = message.getMessageAttributes().get(attribute);
        if (val != null) 
        {
            return val.getStringValue();
        }
        return null;
    }

}
