package edu.virginia.lib.sqsserver;

import java.io.PrintStream;
import java.util.Collection;


public class StdOutProxy extends SQSOutProxy
{
    PrintStream output;

    public StdOutProxy(PrintStream out)
    {
        this.output = out;
    }

    @Override
    public int addDoc(MessageAndDoc msgdoc)
    {
        synchronized (output)
        {
            String inputDoc = msgdoc.getDocAsString();
            output.print(inputDoc+"\n");
            return(1);
        }
    }

    @Override
    public int addDocs(Collection<MessageAndDoc> msgdocs)
    {
        int num = 0;
        for (MessageAndDoc msgdoc : msgdocs)
        {
            num += this.addDoc(msgdoc);
        }
        return(num);
    }

    @Override
    public boolean markMessageProcessed(MessageAndDoc message)
    {
        // TODO Auto-generated method stub
        return false;
    }

}
