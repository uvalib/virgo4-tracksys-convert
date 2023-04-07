package edu.virginia.lib.sqsserver;

import com.amazonaws.services.sqs.model.Message;

public interface MessageReader
{
    public boolean hasNext();

    public Message next();
    
}