package edu.virginia.lib.imagepool;

import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.StringWriter;
import java.io.Writer;

import javax.xml.transform.SourceLocator;
import javax.xml.transform.TransformerException;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;

import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.serialize.MessageEmitter;
import net.sf.saxon.trans.XPathException;

public class ErrorLogger extends MessageEmitter implements javax.xml.transform.ErrorListener 
{
    static Logger logger = Logger.getLogger(ErrorLogger.class);
    Writer logwriter;

    public ErrorLogger()
    {
        OutputStream logout = new LoggingOutputStream(logger, Level.INFO);
        logwriter = new OutputStreamWriter(logout);
        try
        {
            setWriter(logwriter);
        }
        catch (XPathException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }        
    }
    
    @Override
    public void open() throws XPathException {
        setWriter(logwriter);
        super.open();
    }

    @Override
    public void error(TransformerException arg0) throws TransformerException
    {
        logger.info("XSLT error reported: " + arg0.getMessage());
    }

    @Override
    public void fatalError(TransformerException arg0) throws TransformerException
    {
        logger.info("XSLT fatal reported: " + arg0.getMessage());
    }

    @Override
    public void warning(TransformerException arg0) throws TransformerException
    {
        logger.info("XSLT warning reported: " + arg0.getMessage());
    }
    

}
