package edu.virginia.lib.imagepool;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import edu.virginia.lib.sqsserver.DlMixin;
import net.sf.saxon.expr.instruct.TerminationException;

public class TracksysPidListIndexer extends ModsIndexer {
    
    private DlMixin dlmixin = null;

    public static void main(String args[]) throws Exception {
        String tracksysURLBaseDefault = "https://tracksys-api-ws.internal.lib.virginia.edu/api/metadata/"; 
        File pidlistfile = new File(args[0]);
        BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(pidlistfile)));
        ArrayList<String> pids = new ArrayList<String>(); 
        String pid = null;
        while ((pid = reader.readLine()) != null) {
            if (pid.trim().length() > 0) {
                pids.add(pid);
            }
        }
        
        ModsIndexer indexer = new TracksysPidListIndexer(tracksysURLBaseDefault, true);
        indexer.IndexItems(pids);
        reader.close();
    }

    public TracksysPidListIndexer(String tracksysURLBase, boolean debug) throws Exception {
        super(tracksysURLBase, debug);
        dlmixin = new DlMixin();
    }
    
    @Override
    public byte[] indexItem(String pid) throws Exception {
        byte[] modsIndexerResult = super.indexItem(pid);
        if (!dlmixin.isInDL(pid))
        {
            return modsIndexerResult;
        }
        ByteArrayInputStream solrStream = new ByteArrayInputStream(modsIndexerResult);
        ByteArrayOutputStream finalResult = new ByteArrayOutputStream();
        try { 
            addTracksysEnrichItems(solrStream, finalResult, pid);
        }
        catch (Exception te)
        {
            throw new IndexingException(pid, IndexingException.IndexingPhase.MAKE_SOLR, te);
        }

        return finalResult.toByteArray();
    }
    
    private void addTracksysEnrichItems(ByteArrayInputStream solrStream, ByteArrayOutputStream finalResult, String pid) throws Exception
    {
        Set<String> format_f_stored = dlmixin.getFormatFacetsToAdd(pid);
        List<String> alternate_id_str_stored = dlmixin.getAlternateIds(pid);
        List<String> iiif_presentation_metadata_url_a = dlmixin.getIIIFManifestURL(pid);
        List<String> thumbnail_url_a = dlmixin.getThumbnailUrlDisplay(pid);
        List<String> rs_uri_a = dlmixin.getRightsStatementURI(pid);
        List<String> pdf_url_a = dlmixin.getPdfUrlDisplay(pid);
        List<String> anon_availability_f_stored = Collections.singletonList("Online");
        List<String> uva_availability_f_stored = Collections.singletonList("Online");
        List<String> digital_content_service_url_e_stored = dlmixin.makeDigitalContentCache(pid, "digital_content_template.txt");     
        List<String> before = new ArrayList<String>();
        Set<String> solrDocFields = new LinkedHashSet<String>();
        List<String> after = new ArrayList<String>();
        BufferedReader br = new BufferedReader(new InputStreamReader(solrStream, StandardCharsets.UTF_8 ));
        BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(finalResult, StandardCharsets.UTF_8 ));
        String line;
        while ((line = br.readLine()) != null)
        {
            if (line.matches("[ \t]*<field.*")) 
            {
                solrDocFields.add(line.trim());
            }
            else if (solrDocFields.size() == 0)
            {
                before.add(line);
            }
            else
            {
                after.add(line);
            }
        }
        addFields(solrDocFields, "anon_availability_f_stored", anon_availability_f_stored);
        addFields(solrDocFields, "uva_availability_f_stored", uva_availability_f_stored);
        addFields(solrDocFields, "iiif_presentation_metadata_url_a", iiif_presentation_metadata_url_a);
        addFields(solrDocFields, "thumbnail_url_a", thumbnail_url_a);
        addFields(solrDocFields, "rs_uri_a", rs_uri_a);
        addFields(solrDocFields, "pdf_url_a", pdf_url_a);
        addFields(solrDocFields, "alternate_id_str_stored", alternate_id_str_stored);
        addFields(solrDocFields, "format_f_stored", format_f_stored);
        addFields(solrDocFields, "digital_content_service_url_e_stored", digital_content_service_url_e_stored);

        for (String line1 : before)
        {
            bw.write(line1+"\n");
        }
        for (String line1 : solrDocFields)
        {
            bw.write("      "+line1+"\n");
        }
        for (String line1 : after)
        {
            bw.write(line1+"\n");
        }
        bw.flush();
        return;       
    }

    private void addFields(Set<String> solrDocFields, String fieldName, Collection<String> values)
    {
        for (String value : values)
        {
            String line = "<field name=\""+fieldName+"\">"+value+"</field>";
            solrDocFields.add(line);
        }
    }

}
