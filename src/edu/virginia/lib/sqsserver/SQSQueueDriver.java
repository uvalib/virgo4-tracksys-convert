package edu.virginia.lib.sqsserver;

import java.io.IOException;
import java.io.PrintStream;
import java.io.UnsupportedEncodingException;
import java.util.Arrays;
import java.util.Properties;

import org.apache.log4j.Logger;

import com.amazonaws.SdkBaseException;
import com.amazonaws.SdkClientException;

import edu.virginia.lib.imagepool.ModsIndexer;
import joptsimple.OptionException;
import joptsimple.OptionParser;
import joptsimple.OptionSet;

/**
 * Uses the command-line arguments to create a MarcReader, a collection of AbstractValueIndexer
 * objects, and a SolrProxy object and then passes them to the Indexer class which loops through
 * the MARC records, builds SolrInputDocuments and then sends them to Solr
 *
 * @author rh9ec
 *
 */
public class SQSQueueDriver 
{
    private static Logger logger = null;

    public final static String VIRGO4_INGEST_IMAGE_TRACKSYS_CONVERT_IN_QUEUE =  "VIRGO4_INGEST_IMAGE_TRACKSYS_CONVERT_IN_QUEUE";
    public final static String VIRGO4_INGEST_IMAGE_TRACKSYS_CONVERT_OUT_QUEUE = "VIRGO4_INGEST_IMAGE_TRACKSYS_CONVERT_OUT_QUEUE";
//    public final static String VIRGO4_MARC_CONVERT_DELETE_QUEUE =               "VIRGO4_INGEST_IMAGE_TRACKSYS_CONVERT_DELETE_QUEUE";
    public final static String VIRGO4_TRACKSYS_CONVERT_SQS_MESSAGE_BUCKET =     "VIRGO4_INGEST_IMAGE_TRACKSYS_CONVERT_SQS_MESSAGE_BUCKET";
    public final static String TRACKSYS_URL_BASE =                              "TRACKSYS_URL_BASE";
    public final static String VIRGO4_TRACKSYS_ENRICH_OEMBED_ROOT = "VIRGO4_TRACKSYS_ENRICH_OEMBED_ROOT";
    public final static String VIRGO4_TRACKSYS_ENRICH_OCR_ROOT = "VIRGO4_TRACKSYS_ENRICH_OCR_ROOT";
    public final static String VIRGO4_TRACKSYS_ENRICH_S3_BUCKET = "VIRGO4_TRACKSYS_ENRICH_S3_BUCKET";
    public final static String VIRGO4_TRACKSYS_ENRICH_DATA_URL = "VIRGO4_TRACKSYS_ENRICH_DATA_URL";
    public final static String VIRGO4_TRACKSYS_ENRICH_PUBLISHED_URL = "VIRGO4_TRACKSYS_ENRICH_PUBLISHED_URL";
    public final static int VIRGO4_MARC_CONVERT_QUEUE_POLL_TIMEOUT = 20; // in seconds
    protected MessageReader reader;
    protected String[] args;
    protected OptionSet options = null;
    protected boolean multiThreaded = false;
    protected IndexerLoop indexer = null; 
    private SQSOutProxy sqsProxy;
    private boolean debug = false;
    public static String DlMixin_Oembed_Root = "";
    public static String DlMixin_OCR_Root = "";
    public static String DlMixin_S3_BucketName = "";
    public static String DlMixin_Enrich_Published_URL = "";
    public static String DLMixin_Enrich_Data_URL = "";
    
    private Object numIndexed;

    /**
     * The main entry point of the SolrMarc indexing process. Typically called by the Boot class.
     *
     * @param args - The command-line arguments passed to the program
     */
    public static void main(String[] args)
    {
        SQSQueueDriver driver = new SQSQueueDriver(args);
        driver.execute();
    }

    /**
     * Provided as an optional entry-point for the Tracksys image indexing process.  It merely stores the
     * command-line arguments so then can be used by the method execute.
     *
     * @param args - The command-line arguments passed to the program
     */
    public SQSQueueDriver(String[] args)
    {
        this.args = args;
        logger = Logger.getLogger(SQSQueueDriver.class);
    }

    public void initializeForJunitTest(String[] args)
    {
        processArgs(args, true);
        initializeFromOptions();

        String inputQueueName = getSqsParm(options, "sqs-in", VIRGO4_INGEST_IMAGE_TRACKSYS_CONVERT_IN_QUEUE);
        String sqsOutQueue = getSqsParm(options, "sqs-out", VIRGO4_INGEST_IMAGE_TRACKSYS_CONVERT_OUT_QUEUE);
        String s3BucketName = getSqsParm(options, "s3", VIRGO4_TRACKSYS_CONVERT_SQS_MESSAGE_BUCKET);
        logger.info("Opening input queue: "+ inputQueueName + ((s3BucketName != null) ? " (with S3 bucket: "+ s3BucketName + " )" : ""));
        this.configureReader(inputQueueName, s3BucketName);
    }

    /**
     * Extract command line arguments and store them in various protected variables.
     *
     * @param args - the command line arguments passed to the Boot class, except for the first one
     *                which specifies which main program is to be executed.
     *
     * @param failOnZeroArgs - true will cause the program to exit and print a help message
     *                detailing the valid command-line arguments.  false will simply do nothing
     *                and return.
     */
    protected void processArgs(String[] args, boolean failOnZeroArgs)
    {
        OptionParser parser = new OptionParser(  );
        parser.accepts("debug", "non-multithreaded debug mode");
        parser.acceptsAll(Arrays.asList("?", "help"), "show this usage information").forHelp();
        processAddnlArgs(parser);

        options = null;
        try {
            options = parser.parse(args );
        }
        catch (OptionException uoe)
        {
            try
            {
                System.err.println(uoe.getMessage());
                parser.printHelpOn(System.err);
            }
            catch (IOException e)
            {
            }
            System.exit(1);
        }
        if ((failOnZeroArgs && args.length == 0) || options.has("help"))
        {
            try
            {
                parser.printHelpOn(System.err);
            }
            catch (IOException e)
            {
            }
            System.exit(0);
        }
    }

    /**
     *  Creates a MarcReader, a collection of AbstractValueIndexer objects, and a SolrProxy object 
     *  based on the values in the command-line arguments.  It creates a Indexer object
     *  and calls processInput which passes the MarcReader to the Indexer object to index all of the 
     *  MARC records.
     */
    public void execute()
    {
        processArgs(args, true);
        String[] awsLibDirStrs = {"lib_aws"};
        initializeFromOptions();

        String inputQueueName = getSqsParm(options, "sqs-in", VIRGO4_INGEST_IMAGE_TRACKSYS_CONVERT_IN_QUEUE);
        String s3BucketName = getSqsParm(options, "s3", VIRGO4_TRACKSYS_CONVERT_SQS_MESSAGE_BUCKET);
        logger.info("Opening input queue: "+ inputQueueName + ((s3BucketName != null) ? " (with S3 bucket: "+ s3BucketName + " )" : ""));
        this.configureReader(inputQueueName, s3BucketName);

        this.processInput();
    }
    
    protected void processInput()
    {
        String inEclipseStr = System.getProperty("runInEclipse");
        boolean inEclipse = "true".equalsIgnoreCase(inEclipseStr);
        String systemClassPath = System.getProperty("java.class.path");
        logger.debug("System Class Path = " + systemClassPath);
        if (!systemClassPath.contains("solrmarc_core"))
        {
            inEclipse = true;
        }

        try {
            indexer.indexToSolr(reader);
        }
        catch (Exception e)
        {
            logger.fatal("ERROR: Error while invoking indexToSolr");
            logger.fatal(e);
        }

        indexer.endProcessing();

    }

    protected void processAddnlArgs(OptionParser parser)
    {
        parser.accepts("sqs-in", "sqs queue to read records from").withRequiredArg().ofType( String.class );
        parser.accepts("sqs-out", "sqs queue to write solr docs to").withRequiredArg().ofType( String.class );
        parser.accepts("sqs-delete", "sqs queue to write ids to delete to").withRequiredArg().ofType( String.class );
        parser.accepts("s3", "s3 bucket to use for oversize records").withRequiredArg().ofType( String.class );
        parser.accepts("tracksys-url", "URL to use to connect to tracksys program").withRequiredArg().ofType( String.class );
        parser.accepts("reconfig", "specifies that the indexer can be reconfigured at runtime, providing a mapping from data source name to index specification").withRequiredArg().ofType( String.class );
    }

    private void initializeFromOptions()
    {
        debug = options.has("debug") ? true : false;

        DlMixin_Oembed_Root =  getSqsParm(options, "tracksys-cache-oembed-root", VIRGO4_TRACKSYS_ENRICH_OEMBED_ROOT);
        DlMixin_OCR_Root =  getSqsParm(options, "tracksys-cache-ocr-root", VIRGO4_TRACKSYS_ENRICH_OCR_ROOT);
        DlMixin_S3_BucketName = getSqsParm(options, "tracksys-cache-s3", VIRGO4_TRACKSYS_ENRICH_S3_BUCKET);
        DlMixin_Enrich_Published_URL = getSqsParm(options, "tracksys-published-url", VIRGO4_TRACKSYS_ENRICH_PUBLISHED_URL);
        DLMixin_Enrich_Data_URL = getSqsParm(options, "tracksys-enrich-data-url", VIRGO4_TRACKSYS_ENRICH_DATA_URL);

        String tracksysURLBase = getSqsParm(options, "tracksys-url", TRACKSYS_URL_BASE);
        if (tracksysURLBase != null) 
        {
            logger.info("Using "+ tracksysURLBase + " as the base URL to connect to Tracksys");
            ModsIndexer.tracksysURLBase = tracksysURLBase;
        }
        else 
        {
            logger.info("Using default tracksys URL base");
        }
        boolean multithread =  false; // sqsOutQueue != null && !options.has("debug") && !reconfigurable ? true : false;
        try
        {
            this.configureOutput(options);
        }
        catch (SdkClientException sce)
        {
            logger.fatal(sce.getMessage());
            logger.fatal("Exiting...");
            System.exit(4);
            
        }
        catch (SdkBaseException sce)
        {
            logger.fatal(sce.getMessage());
            logger.fatal("Exiting...");
            System.exit(4);
            
        }
        catch (Exception sre)
        {
            logger.debug(sre.getMessage(), sre);
            logger.error("Exiting...");
            System.exit(6);
        }
        try {
            indexer = new IndexerLoop(sqsProxy);
        }
        catch (Exception e1)
        {
            logger.error("Exiting...");
            System.exit(2);
        }
    }

    private String getSqsParm(OptionSet options, String clOptName, String propertyOrEnvName)
    {
        return (options.has(clOptName) ? options.valueOf(clOptName).toString() : 
            System.getProperty(propertyOrEnvName)!= null ?  System.getProperty(propertyOrEnvName) :
                System.getenv(propertyOrEnvName));
    }

    private void configureReader(String inputQueueName, String s3BucketName)
    {
        reader = new SQSMessageReader(inputQueueName, s3BucketName);
    }

    protected void configureOutput(OptionSet options)
    {
        String sqsOutQueue = getSqsParm(options, "sqs-out", VIRGO4_INGEST_IMAGE_TRACKSYS_CONVERT_OUT_QUEUE);
        String s3Bucket = getSqsParm(options, "s3", VIRGO4_TRACKSYS_CONVERT_SQS_MESSAGE_BUCKET);

        if (sqsOutQueue.equals("stdout"))
        {
            try
            {
                PrintStream out = new PrintStream(System.out, true, "UTF-8");
                System.setOut(out);
                sqsProxy = new StdOutProxy(out);
                sqsProxy = new SQSWrappedProxy(sqsProxy);
            }
            catch (UnsupportedEncodingException e)
            {
                // since the encoding is hard-coded, and is valid, this Exception cannot occur.
            }
        }
        else if (sqsOutQueue != null)
        {
            logger.info("Opening output queue: "+ sqsOutQueue + ((s3Bucket != null) ? " (with S3 bucket: "+ s3Bucket + " )" : ""));
            sqsProxy = new SQSXMLOutImpl(sqsOutQueue, s3Bucket, false);
            return;
        }
    }
}
