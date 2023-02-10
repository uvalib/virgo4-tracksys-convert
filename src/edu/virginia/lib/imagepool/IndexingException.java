package edu.virginia.lib.imagepool;

public class IndexingException extends RuntimeException
{
    /**
     * 
     */
    private static final long serialVersionUID = 7188833703331159675L;
    public enum IndexingPhase { GET_MODS_404, GET_MODS_UNK, MAKE_UVAMAP, MAKE_SOLR };
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
    
    public IndexingException(String id, IndexingPhase phase, String message)
    {
        this.id = id;
        this.phase = phase;
        this.cause = null;
        this.message = message;
        this.setStackTrace(Thread.currentThread().getStackTrace());
    }
    
    public String getMessage()
    {
        return new String("Error while indexing record "+ id + " in phase "+ getPhaseString() + 
                          " : " + (cause != null ? cause.getClass().getSimpleName() : "" )+ " message = " + message );
    }

    public String getPhaseString()
    {
        switch (phase) 
        {
            case GET_MODS_404 :     return("get_mods_404_error");
            case GET_MODS_UNK :     return("get_mods_unknown_error");
            case MAKE_UVAMAP :      return("mods_to_uvamap");
            case MAKE_SOLR :        return("uvamap_to_solr");
        }
        return("undefined");
    }
    
    public IndexingPhase getPhase()
    {
        return(phase);
    }
}
