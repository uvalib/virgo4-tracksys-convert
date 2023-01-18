package edu.virginia.lib.sqsserver;

import java.util.Collection;

public abstract class SQSOutProxy
{
 
    /**
     * given a MessageAndDoc add it to the index
     * 
     * @param document  message and document containing document to add to Solr index
     * @return       
     */

    public abstract int addDoc(MessageAndDoc document);

    public abstract int addDocs(Collection<MessageAndDoc> docQ);

}