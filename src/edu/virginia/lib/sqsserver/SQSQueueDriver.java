package edu.virginia.lib.sqsserver;

import java.io.IOException;
import java.util.Arrays;
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
    public final static int VIRGO4_MARC_CONVERT_QUEUE_POLL_TIMEOUT = 20; // in seconds
//    private boolean reconfigurable = false;
//    private Properties indexSpecMap = null; 
//    private String indexSpecName = null;
    protected SQSMessageReader reader;
    protected String[] args;
    protected OptionSet options = null;
    protected boolean multiThreaded = false;
    protected IndexerLoop indexer = null; 
    private SQSOutProxy sqsProxy;
    private boolean debug = false;
    
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
//        String[] awsLibDirStrs = {"lib_aws"};
//        Boot.extendClasspathWithLocalJarDirs(homeDirStrs, awsLibDirStrs);
//
//        indexerFactory = ValueIndexerFactory.initialize(homeDirStrs);
        initializeFromOptions();

        String inputQueueName = getSqsParm(options, "sqs-in", VIRGO4_INGEST_IMAGE_TRACKSYS_CONVERT_IN_QUEUE);
        String sqsOutQueue = getSqsParm(options, "sqs-out", VIRGO4_INGEST_IMAGE_TRACKSYS_CONVERT_OUT_QUEUE);
        String s3BucketName = getSqsParm(options, "s3", VIRGO4_TRACKSYS_CONVERT_SQS_MESSAGE_BUCKET);
        logger.info("Opening input queue: "+ inputQueueName + ((s3BucketName != null) ? " (with S3 bucket: "+ s3BucketName + " )" : ""));
        this.configureReader(inputQueueName, s3BucketName);
    }

//    public Indexer getIndexerForJunitTest()
//    {
//        return indexer;
//    }
//
//    public MarcReader getReaderForJunitTest()
//    {
//        return reader;
//    }

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
//        readOpts = parser.acceptsAll(Arrays.asList( "r", "reader_opts"), "file containing MARC Reader options").withRequiredArg().defaultsTo("marcreader.properties");
//        configSpecs = parser.acceptsAll(Arrays.asList( "c", "config"), "index specification file to use").withRequiredArg();
//        homeDirs = parser.accepts("dir", "directory to look in for scripts, mixins, and translation maps").withRequiredArg().ofType( String.class );
//        addnlLibDirs = parser.accepts("lib_local", "directory to look in for additional jars and libraries").withRequiredArg().defaultsTo("lib_local");
//        solrjDir = parser.accepts("solrj", "directory to look in for jars required for SolrJ").withRequiredArg().ofType( File.class );
//        solrjClass = parser.accepts("solrjClassName", "Classname of class to use for talking to solr").withRequiredArg();
//        errorMarcErrOutFile = parser.accepts("marcerr", "File to write records with errors.(not yet implemented)").withRequiredArg().ofType( File.class );
//        errorIndexErrOutFile = parser.accepts("indexerr", "File to write the solr documents for records with errors.(not yet implemented)").withRequiredArg().ofType( File.class );
//        errorSolrErrOutFile = parser.accepts("solrerr", "File to write the solr documents for records with errors.(not yet implemented)").withRequiredArg().ofType( File.class );
//        deleteRecordByIdFile = parser.accepts("del", "File to read list of document ids that are to be deleted").withRequiredArg().ofType( File.class );
        parser.accepts("debug", "non-multithreaded debug mode");
//        parser.acceptsAll(Arrays.asList( "solrURL", "u"), "URL of Remote Solr to use").withRequiredArg();
//        parser.acceptsAll(Arrays.asList( "solrCommit", "c"), "Whether to commit, true or false").withRequiredArg();
      //  parser.acceptsAll(Arrays.asList("print", "stdout"), "write output to stdout in user readable format").availableUnless("solrURL");
     //   parser.acceptsAll(Arrays.asList("null"), "discard all output, and merely show errors and warnings").availableUnless("solrURL");
        parser.acceptsAll(Arrays.asList("?", "help"), "show this usage information").forHelp();
        //parser.mutuallyExclusive("stdout", "solrURL");
        processAddnlArgs(parser);
//        files = parser.nonOptions().ofType( String.class );

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
//        if (options.has("dir"))
//        {
//            File defDir = new File(Boot.getDefaultHomeDir());
//            List<String> homeDirList = new ArrayList<>();
//            boolean hasDefDir = false;
//            for (String dir :  (options.valueOf(homeDirs).replaceAll("[,;]", "|").split("[|]")))
//            {
//                File dirAsFile = new File(dir);
//                if (dirAsFile.getAbsolutePath().equals(defDir.getAbsolutePath()))
//                {
//                    hasDefDir = true;
//                }
//                if (!homeDirList.contains(dirAsFile.getAbsolutePath())) {
//                    homeDirList.add(dirAsFile.getAbsolutePath());
//                    logger.debug("Adding directory: " + dirAsFile.getAbsolutePath());
//                }
//            }
//            if (!hasDefDir)
//            {
//                homeDirList.add(defDir.getAbsolutePath());
//            }
//            this.homeDirStrs = ((String[]) homeDirList.toArray(new String[0]));
//        }
//        else
//        {
////            homeDirStrs = new String[]{ Boot.getDefaultHomeDir() };
//        }
//        System.setProperty("solrmarc.home.dir", homeDirStrs[0]);
//
//        LoggerDelegator.reInit(this.homeDirStrs);
//        if (needsSolrJ())
//        {
//            if (!hasSolrJ())
//            {
//                File solrJPath = (options.has(this.solrjDir) ? (File) this.options.valueOf(this.solrjDir) : new File("lib-solrj"));
//                try
//                {
//                    if (solrJPath.isAbsolute())
//                    {
//                        Boot.extendClasspathWithSolJJarDir(null, solrJPath);
//                    }
//                    else
//                    {
//                        Boot.extendClasspathWithSolJJarDir(this.homeDirStrs, solrJPath);
//                    }
//                }
//                catch (IndexerSpecException ise)
//                {
//                    logger.fatal("Fatal error: Failure to load SolrJ", ise);
//                    logger.error("Exiting...");
//                    System.exit(10);
//                }
//            }
//        }
//        // Now add local lib directories
//        try {
//            if (addnlLibDirs.value(options) != null)
//            {
//                addnlLibDirStrs = addnlLibDirs.value(options).split("[,;|]");
//                Boot.extendClasspathWithLocalJarDirs(homeDirStrs, addnlLibDirStrs);
//            }
//        }
//        catch (IndexerSpecException ise)
//        {
//            logger.fatal("Fatal error: Failure to load SolrJ", ise);
//            logger.error("Exiting...");
//            System.exit(10);
//        }
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
//        shutdownSimulator = new ShutdownSimulator(inEclipse, indexer);
//        shutdownSimulator.start();
//        Thread shutdownHook = new MyShutdownThread(indexer, shutdownSimulator);
//        Runtime.getRuntime().addShutdownHook(shutdownHook);
//        startTime = System.currentTimeMillis();
//        long endTime = startTime;

        try {
            indexer.indexToSolr(reader);
        }
        catch (Exception e)
        {
            logger.fatal("ERROR: Error while invoking indexToSolr");
            logger.fatal(e);
        }

//        endTime = System.currentTimeMillis();
//        if (!indexer.viaInterrupt)
//        {
//            Runtime.getRuntime().removeShutdownHook(shutdownHook);
//        }
        indexer.endProcessing();

//        boolean perMethodReport = Boolean.parseBoolean(PropertyUtils.getProperty(readerProps, "solrmarc.method.report", "false"));
//        reportResultsAndTime(numIndexed, startTime, endTime, indexer, (indexer.shuttingDown) ? false : perMethodReport);
//        if (!indexer.viaInterrupt && indexer.errQ.size() > 0)
//        {
//            handleRecordErrors();
//        }
//
//        if (!indexer.viaInterrupt && shutdownSimulator != null)
//        {
//            shutdownSimulator.interrupt();
//        }
//        indexer.setIsShutDown();
//        if (indexer.shuttingDown && indexer.viaInterrupt)
//        {
//            try
//            {
//                Thread.sleep(5000L);
//            }
//            catch (InterruptedException ie)
//            {
//                endTime = startTime;
//            }
//        }
    }

    protected void processAddnlArgs(OptionParser parser)
    {
        parser.accepts("sqs-in", "sqs queue to read records from").withRequiredArg().ofType( String.class );
        parser.accepts("sqs-out", "sqs queue to write solr docs to").withRequiredArg().ofType( String.class );
        parser.accepts("sqs-delete", "sqs queue to write ids to delete to").withRequiredArg().ofType( String.class );
        parser.accepts("s3", "s3 bucket to use for oversize records").withRequiredArg().ofType( String.class );
        parser.accepts("tracksys-url", "URL to use to connect to tracksys program").withRequiredArg().ofType( String.class );
        parser.accepts("reconfig", "specifies that the indexer can be reconfigured at runtime, providing a mapping from data source name to index specification").withRequiredArg().ofType( String.class );
//        if (System.getProperty("solrmarc.indexer.test.fire.method","undefined").equals("undefined"))
//        {
//            System.setProperty("solrmarc.indexer.test.fire.method", "true");
//        }
    }

    private void initializeFromOptions()
    {
//        String[] inputSource = new String[1];
//        String propertyFileAsURLStr = PropertyUtils.getPropertyFileAbsoluteURL(homeDirStrs, options.valueOf(readOpts), true, inputSource);
//        logger.info("marcreader option is "+options.valueOf(readOpts));
//        logger.info("propertyFileAsURLStr is "+propertyFileAsURLStr);
//        try
//        {
//            configureReaderProps(propertyFileAsURLStr);
//        }
//        catch (IOException e1)
//        {
//            logger.fatal("Fatal error: Exception opening reader properties input stream: " + inputSource[0]);
//            logger.error("Exiting...");
//            System.exit(1);
//        }
//
//        String sqsOutQueue = getSqsParm(options, "sqs-out", VIRGO4_INGEST_IMAGE_TRACKSYS_CONVERT_OUT_QUEUE);
//        reconfigurable = options.has("reconfig");
//        if (reconfigurable) 
//        {
//            String reconfigFile = options.valueOf("reconfig").toString();
//            indexSpecMap = PropertyUtils.loadProperties(ValueIndexerFactory.instance().getHomeDirs(), reconfigFile, false, null, null);
//        }
        debug = options.has("debug") ? true : false;

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
//        String specs = options.valueOf(configSpecs);
//        if (indexSpecMap != null && indexSpecMap.containsKey("default") && specs == null)
//        {
//            specs = indexSpecMap.getProperty("default");
//        }
//        else if (indexSpecMap != null && !indexSpecMap.containsKey("default"))
//        {
//            indexSpecMap.put("default", specs);
//        }
//
//        this.indexSpecName = "default";
        try
        {
//            logger.info("Reading and compiling index specifications: " + specs);
            /*if (multiThreaded) indexer = new ThreadedIndexer(indexers, solrProxy, bufferSize, chunkSize);
            else     */          indexer = new IndexerLoop(sqsProxy);
        }
        catch (Exception e1)
        {
//            logger.error("Error opening or reading index configurations: " + specs, e1);
            logger.error("Exiting...");
            System.exit(2);
        }
//        if (!exceptions.isEmpty())
//        {
//            logger.error("Error processing index configurations: " + specs);
//            logTextForExceptions(exceptions);
//            logger.error("Exiting...");
//            System.exit(5);
//        }
    }

//    public void reconfigureIndexer(String specSelector)
//    {
//        if (specSelector.equals(indexSpecName)) 
//        {
//            return;
//        }
//        String indexSpecString; 
//        logger.info("Received records from different source, re-initializing specs for "+ specSelector);
//        if (indexSpecMap.containsKey(specSelector))
//        {
//            indexSpecString = indexSpecMap.getProperty(specSelector);
//        }
//        else
//        {
//            indexSpecString = indexSpecMap.getProperty("default");
//        }
//        logger.info("Using specifications: "+ indexSpecString);
//
//        try {
//            String[] indexSpecs = indexSpecString.split("[ ]*[;,][ ]*");
//            File[] specFiles = new File[indexSpecs.length];
//            int i = 0;
//            for (String indexSpec : indexSpecs)
//            {
//                File specFile = new File(indexSpec);
//                if (!specFile.isAbsolute())
//                {
//                    specFile = PropertyUtils.findFirstExistingFile(homeDirStrs, indexSpec);
//                }
//                logger.info("Opening index spec file: " + specFile);
//                specFiles[i++] = specFile;
//            }
//            indexers = indexerFactory.createValueIndexers(specFiles);
//            indexer.indexers.clear();
//            indexer.indexers.addAll(indexers);
//
//            indexSpecName = specSelector;
//        }
//        catch (IllegalAccessException e)
//        {
//            // TODO Auto-generated catch block
//            e.printStackTrace();
//        }
//        catch (InstantiationException e)
//        {
//            // TODO Auto-generated catch block
//            e.printStackTrace();
//        }
//        catch (IOException e)
//        {
//            // TODO Auto-generated catch block
//            e.printStackTrace();
//        }
//    }

    private String getSqsParm(OptionSet options, String clOptName, String propertyOrEnvName)
    {
        return (options.has(clOptName) ? options.valueOf(clOptName).toString() : 
            System.getProperty(propertyOrEnvName)!= null ?  System.getProperty(propertyOrEnvName) :
                System.getenv(propertyOrEnvName));
    }


//    final static String [] solrmarcPropertyStrings = {
//            "solrmarc.indexer.chunksize",
//            "solrmarc.indexer.buffersize",
//            "solrmarc.indexer.threadcount",
//            "solrmarc.solrj.threadcount",
//            "solrmarc.track.solr.progress",
//            "solrmarc.terminate.on.marc.exception",
//            "solrmarc.output.redirect",
//            "solrmarc.indexer.test.fire.method",
//            "solrmarc.method.report",
//    };
//
//    private void configureReaderProps(String propertyFileURLStr) throws FileNotFoundException, IOException
//    {
//        List<String> propertyStringsToCopy = Arrays.asList(solrmarcPropertyStrings);
//        readerProps = new Properties();
//        if (propertyFileURLStr != null)
//        {
//            readerProps.load(PropertyUtils.getPropertyFileInputStream(propertyFileURLStr));
//            Enumeration<?> iter = readerProps.propertyNames();
//            while (iter.hasMoreElements())
//            {
//                String propertyName = iter.nextElement().toString();
//                if (propertyName.startsWith("solrmarc.") && propertyStringsToCopy.contains(propertyName) && System.getProperty(propertyName) == null)
//                {
//                    System.setProperty(propertyName, readerProps.getProperty(propertyName));
//                }
//                if (propertyName.startsWith("org.marc4j.marc") && System.getProperty(propertyName) == null)
//                {
//                    System.setProperty(propertyName, readerProps.getProperty(propertyName));
//                }
//            }
//            try {
//                readerConfig = new MarcReaderConfig(readerProps);
//            }
//            catch(NoClassDefFoundError ncdfe)
//            {
//                readerConfig = null;
//            }
//        }
//    }

    private void configureReader(String inputQueueName, String s3BucketName)
    {
        try
        {
//            if (this.reconfigurable) 
//            {
//                reader = new SQSMessageReader(readerConfig, inputQueueName, s3BucketName, false, this);
//            }
//            else 
//            {
                reader = new SQSMessageReader(inputQueueName, s3BucketName);
//            }
        }
//        catch (IOException e)
//        {
//            throw new IllegalArgumentException(e.getMessage(), e);
//        }
        catch (NoClassDefFoundError ncdfe)
        {
//            logger.warn("Using SolrMarc with a marc4j version < 2.8 uses deprecated code in SolrMarc");
//            reader = SolrMarcMarcReaderFactory.instance().makeReader(readerProps, ValueIndexerFactory.instance().getHomeDirs(), inputQueueName);
        }
    }

    protected void configureOutput(OptionSet options)
    {
//        String solrJClassName = solrjClass.value(options);
//        String solrURL = options.has("solrURL") ? options.valueOf("solrURL").toString() : options.has("null") ? "devnull" : "stdout";
        String sqsOutQueue = getSqsParm(options, "sqs-out", VIRGO4_INGEST_IMAGE_TRACKSYS_CONVERT_OUT_QUEUE);
        String s3Bucket = getSqsParm(options, "s3", VIRGO4_TRACKSYS_CONVERT_SQS_MESSAGE_BUCKET);
//        boolean oversizeOnly = Boolean.parseBoolean(System.getProperty("solrmarc-sqs-oversize-only", "false"));
//        boolean wrapped = false;

        if (sqsOutQueue != null)
        {
            logger.info("Opening output queue: "+ sqsOutQueue + ((s3Bucket != null) ? " (with S3 bucket: "+ s3Bucket + " )" : ""));
            sqsProxy = new SQSXMLOutImpl(sqsOutQueue, s3Bucket, false);
            return;
        }
//        else if (solrURL.startsWith("wrapped"))
//        {
//            solrURL = solrURL.replace("wrapped", "");
//            wrapped = true;
//        }
//        if (solrURL.equals("stdout"))
//        {
//            try
//            {
//                PrintStream out = new PrintStream(System.out, true, "UTF-8");
//                System.setOut(out);
//                solrProxy = new StdOutProxy(out);
//                if (wrapped) solrProxy = new SolrSQSWrappedProxy(solrProxy);
//            }
//            catch (UnsupportedEncodingException e)
//            {
//                // since the encoding is hard-coded, and is valid, this Exception cannot occur.
//            }
//        }
//        else if (solrURL.equals("xml"))
//        {
//            try
//            {
//                PrintStream out = new PrintStream(System.out, true, "UTF-8");
//                System.setOut(out);
//                solrProxy = new XMLOutProxy(out);
//                if (wrapped) solrProxy = new SolrSQSWrappedProxy(solrProxy);
//            }
//            catch (UnsupportedEncodingException e)
//            {
//                // since the encoding is hard-coded, and is valid, this Exception cannot occur.
//            }
//        }
//        else if (solrURL.equals("devnull"))
//        {
//            solrProxy = new DevNullProxy();
//            if (wrapped) solrProxy = new SolrSQSWrappedProxy(solrProxy);
//        }
//        else
//        {
//            try  {
//                solrProxy = SolrCoreLoader.loadRemoteSolrServer(solrURL, solrJClassName, true);
//            }
//            catch (SolrRuntimeException sre) 
//            {
//                logger.error("Error connecting to solr at URL " + solrURL + " : " + sre.getMessage());
//                throw(sre);
//            }
//       }
    }
}
