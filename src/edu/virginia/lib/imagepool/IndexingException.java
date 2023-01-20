package edu.virginia.lib.imagepool;

public class IndexingException extends RuntimeException
{
    /**
     * 
     */
    private static final long serialVersionUID = 7188833703331159675L;
    enum IndexingPhase { GET_MODS, MAKE_UVAMAP, MAKE_SOLR };
    String id;
    IndexingPhase phase;
    Exception cause;
    String message;
    
    public IndexingException(String id, IndexingPhase phase, Exception cause)
    {
        this.id = id;
        this.phase = phase;
        this.cause = cause;
        this.message = cause.getMessage();
        this.setStackTrace(cause.getStackTrace());
    }
    
    public String getMessage()
    {
        return new String("Error while indexing record "+ id + " in phase "+ getPhaseString() + 
                          " : " + cause.getClass().getSimpleName() + " message = " + message );
    }

    private String getPhaseString()
    {
        switch (phase) 
        {
            case GET_MODS :    return("get_mods");
            case MAKE_UVAMAP : return("mods_to_uvamap");
            case MAKE_SOLR :   return("uvamap_to_solr");
        }
        return("undefined");
    }
}
