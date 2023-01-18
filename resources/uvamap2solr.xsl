<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

    <!-- sometimes the original files don't have a collection in the metadata -->
    <xsl:param name="collectionParam" required="no" />
    
    <!-- 
       To allow the same transform to potentially work for JStorForum and tracksys content without
       complex detection, the presence of this parameter triggers inclusion of a curio link for an
       embedded viewer. 
     -->
    <xsl:param name="curio" required="no" />
    
    <!-- and sometimes the ID isn't provided in the metadata (perhaps just the filename or something) -->
    <xsl:param name="extraIdentifier" required="no"/>
    
    <xsl:variable name="missingIds">
        <missing>
        <id>uva-lib:2408763</id>    
        <id>uva-lib:2408764</id>
        <id>uva-lib:2408765</id>
        <id>uva-lib:2408766</id>
        <id>uva-lib:2408767</id>
        <id>uva-lib:2408768</id>
        <id>uva-lib:1038845</id>
        <id>uva-lib:1038846</id>
        <id>uva-lib:1038857</id>
        <id>uva-lib:1038861</id>
        <id>uva-lib:1038886</id>
        <id>uva-lib:1038991</id>
        <id>uva-lib:1038993</id>
        <id>uva-lib:1039023</id>
        <id>uva-lib:1039806</id>
        <id>uva-lib:1039812</id>
        <id>uva-lib:1039813</id>
        <id>uva-lib:1039866</id>
        <id>uva-lib:1039867</id>
        <id>uva-lib:1039889</id>
        <id>uva-lib:1039915</id>
        <id>uva-lib:1039951</id>
        <id>uva-lib:1039953</id>
        <id>uva-lib:1039967</id>
        <id>uva-lib:1039974</id>
        <id>uva-lib:1039996</id>
        <id>uva-lib:1040034</id>
        <id>uva-lib:1040090</id>
        <id>uva-lib:1040091</id>
        <id>uva-lib:1040150</id>
        <id>uva-lib:1040165</id>
        <id>uva-lib:1040166</id>
        <id>uva-lib:1040168</id>
        <id>uva-lib:1040169</id>
        <id>uva-lib:1040304</id>
        <id>uva-lib:1040306</id>
        <id>uva-lib:1040322</id>
        <id>uva-lib:1040331</id>
        <id>uva-lib:1040332</id>
        <id>uva-lib:1040364</id>
        <id>uva-lib:1040365</id>
        <id>uva-lib:1040391</id>
        <id>uva-lib:1040410</id>
        <id>uva-lib:1040426</id>
        <id>uva-lib:1040439</id>
        <id>uva-lib:1040441</id>
        <id>uva-lib:1040445</id>
        <id>uva-lib:1040470</id>
        <id>uva-lib:1040471</id>
        <id>uva-lib:1040475</id>
        <id>uva-lib:1040476</id>
        <id>uva-lib:1040486</id>
        <id>uva-lib:1040553</id>
        <id>uva-lib:1040605</id>
        <id>uva-lib:1040612</id>
        <id>uva-lib:1040643</id>
        <id>uva-lib:1040670</id>
        <id>uva-lib:1040689</id>
        <id>uva-lib:1040748</id>
        <id>uva-lib:1040761</id>
        <id>uva-lib:1040867</id>
        <id>uva-lib:1040870</id>
        <id>uva-lib:1040871</id>
        <id>uva-lib:1040887</id>
        <id>uva-lib:1040888</id>
        <id>uva-lib:1040922</id>
        <id>uva-lib:1040926</id>
        <id>uva-lib:1040927</id>
        <id>uva-lib:1040928</id>
        <id>uva-lib:1040942</id>
        <id>uva-lib:1041088</id>
        <id>uva-lib:1041133</id>
        <id>uva-lib:1041134</id>
        <id>uva-lib:1041143</id>
        <id>uva-lib:1041151</id>
        <id>uva-lib:1041161</id>
        <id>uva-lib:1041172</id>
        <id>uva-lib:1041174</id>
        <id>uva-lib:1041175</id>
        <id>uva-lib:1041185</id>
        <id>uva-lib:1041202</id>
        <id>uva-lib:1041211</id>
        <id>uva-lib:1041224</id>
        <id>uva-lib:1041229</id>
        <id>uva-lib:1041287</id>
        <id>uva-lib:1041297</id>
        <id>uva-lib:1041298</id>
        <id>uva-lib:1041301</id>
        <id>uva-lib:1041302</id>
        <id>uva-lib:1041303</id>
        <id>uva-lib:1041319</id>
        <id>uva-lib:1041321</id>
        <id>uva-lib:1041331</id>
        <id>uva-lib:1041337</id>
        <id>uva-lib:1041348</id>
        <id>uva-lib:1041372</id>
        <id>uva-lib:1041377</id>
        <id>uva-lib:1041382</id>
        <id>uva-lib:1041416</id>
        <id>uva-lib:1041473</id>
        <id>uva-lib:1041490</id>
        <id>uva-lib:1041491</id>
        <id>uva-lib:1041492</id>
        <id>uva-lib:1041535</id>
        <id>uva-lib:1041536</id>
        <id>uva-lib:1041562</id>
        <id>uva-lib:1041585</id>
        <id>uva-lib:1041592</id>
        <id>uva-lib:1041593</id>
        <id>uva-lib:1041594</id>
        <id>uva-lib:1041595</id>
        <id>uva-lib:1041606</id>
        <id>uva-lib:1041607</id>
        <id>uva-lib:1041615</id>
        <id>uva-lib:1041617</id>
        <id>uva-lib:1041618</id>
        <id>uva-lib:1041623</id>
        <id>uva-lib:1041654</id>
        <id>uva-lib:1041662</id>
        <id>uva-lib:1041666</id>
        <id>uva-lib:1041667</id>
        <id>uva-lib:1041674</id>
        <id>uva-lib:1041676</id>
        <id>uva-lib:1041689</id>
        <id>uva-lib:1041729</id>
        <id>uva-lib:1041766</id>
        <id>uva-lib:1041784</id>
        <id>uva-lib:1041785</id>
        <id>uva-lib:1041796</id>
        <id>uva-lib:1041797</id>
        <id>uva-lib:1041798</id>
        <id>uva-lib:1041799</id>
        <id>uva-lib:1041800</id>
        <id>uva-lib:1041801</id>
        <id>uva-lib:1041809</id>
        <id>uva-lib:1041810</id>
        <id>uva-lib:1041822</id>
        <id>uva-lib:1041850</id>
        <id>uva-lib:1042083</id>
        <id>uva-lib:1042146</id>
        <id>uva-lib:1042184</id>
        <id>uva-lib:1042242</id>
        <id>uva-lib:1042259</id>
        <id>uva-lib:1042346</id>
        <id>uva-lib:1042366</id>
        <id>uva-lib:1042486</id>
        <id>uva-lib:1042715</id>
        <id>uva-lib:1042716</id>
        <id>uva-lib:1042857</id>
        <id>uva-lib:1042884</id>
        <id>uva-lib:1042887</id>
        <id>uva-lib:1042975</id>
        <id>uva-lib:1043172</id>
        <id>uva-lib:1043352</id>
        <id>uva-lib:1043388</id>
        <id>uva-lib:1043443</id>
        <id>uva-lib:1043492</id>
        <id>uva-lib:1043507</id>
        <id>uva-lib:1043522</id>
        <id>uva-lib:1043597</id>
        <id>uva-lib:1043700</id>
        <id>uva-lib:1043701</id>
        <id>uva-lib:1043702</id>
        <id>uva-lib:1043703</id>
        <id>uva-lib:1043704</id>
        <id>uva-lib:1043714</id>
        <id>uva-lib:1043715</id>
        <id>uva-lib:1043716</id>
        <id>uva-lib:1044020</id>
        <id>uva-lib:1044218</id>
        <id>uva-lib:1044308</id>
        <id>uva-lib:1044645</id>
        <id>uva-lib:1044646</id>
        <id>uva-lib:1044647</id>
        <id>uva-lib:1044688</id>
        <id>uva-lib:1044701</id>
        <id>uva-lib:1044788</id>
        <id>uva-lib:1044789</id>
        <id>uva-lib:1044927</id>
        <id>uva-lib:1044940</id>
        <id>uva-lib:1044946</id>
        <id>uva-lib:1044953</id>
        <id>uva-lib:1044961</id>
        <id>uva-lib:1044982</id>
        <id>uva-lib:1044989</id>
        <id>uva-lib:1044994</id>
        <id>uva-lib:1045021</id>
        <id>uva-lib:1045025</id>
        <id>uva-lib:1047797</id>
        <id>uva-lib:1047843</id>
        <id>uva-lib:1047870</id>
        <id>uva-lib:1047893</id>
        <id>uva-lib:1047919</id>
        <id>uva-lib:1047928</id>
        <id>uva-lib:1047956</id>
        <id>uva-lib:1047957</id>
        <id>uva-lib:1048010</id>
        <id>uva-lib:1048053</id>
        <id>uva-lib:1048054</id>
        <id>uva-lib:1048055</id>
        <id>uva-lib:1048078</id>
        <id>uva-lib:1048125</id>
        <id>uva-lib:1048132</id>
        <id>uva-lib:1048138</id>
        <id>uva-lib:1048149</id>
        <id>uva-lib:1048154</id>
        <id>uva-lib:1048157</id>
        <id>uva-lib:1048162</id>
        <id>uva-lib:1048180</id>
        <id>uva-lib:1048181</id>
        <id>uva-lib:1048205</id>
        <id>uva-lib:1048278</id>
        <id>uva-lib:1048279</id>
        <id>uva-lib:1048320</id>
        <id>uva-lib:1048321</id>
        <id>uva-lib:1048333</id>
        <id>uva-lib:1048343</id>
        <id>uva-lib:1048344</id>
        <id>uva-lib:1048345</id>
        <id>uva-lib:1048390</id>
        <id>uva-lib:1048399</id>
        <id>uva-lib:1048412</id>
        <id>uva-lib:1048416</id>
        <id>uva-lib:1048431</id>
        <id>uva-lib:1048469</id>
        <id>uva-lib:1048486</id>
        <id>uva-lib:1048495</id>
        <id>uva-lib:1048539</id>
        <id>uva-lib:1048540</id>
        <id>uva-lib:1048671</id>
        <id>uva-lib:1048672</id>
        <id>uva-lib:1048684</id>
        <id>uva-lib:1048717</id>
        <id>uva-lib:1048749</id>
        <id>uva-lib:1048818</id>
        <id>uva-lib:1048866</id>
        <id>uva-lib:1048895</id>
        <id>uva-lib:1048926</id>
        <id>uva-lib:1048931</id>
        <id>uva-lib:1048938</id>
        <id>uva-lib:1048941</id>
        <id>uva-lib:1048977</id>
        <id>uva-lib:1048978</id>
        <id>uva-lib:1048983</id>
        <id>uva-lib:1048999</id>
        <id>uva-lib:1049002</id>
        <id>uva-lib:1049014</id>
        <id>uva-lib:1049018</id>
        <id>uva-lib:1049021</id>
        <id>uva-lib:1049258</id>
        <id>uva-lib:1049353</id>
        <id>uva-lib:1049354</id>
        <id>uva-lib:1049561</id>
        <id>uva-lib:1049562</id>
        <id>uva-lib:1049582</id>
        <id>uva-lib:1049747</id>
        <id>uva-lib:1049773</id>
        <id>uva-lib:1049826</id>
        <id>uva-lib:1050054</id>
        <id>uva-lib:1050072</id>
        <id>uva-lib:1050073</id>
        <id>uva-lib:1050094</id>
        <id>uva-lib:1050213</id>
        <id>uva-lib:1050214</id>
        <id>uva-lib:1050274</id>
        <id>uva-lib:1050319</id>
        <id>uva-lib:1050432</id>
        <id>uva-lib:1050450</id>
        <id>uva-lib:1050458</id>
        <id>uva-lib:1050490</id>
        <id>uva-lib:1050501</id>
        <id>uva-lib:1050507</id>
        <id>uva-lib:1050524</id>
        <id>uva-lib:1050529</id>
        <id>uva-lib:1050559</id>
        <id>uva-lib:1050565</id>
        <id>uva-lib:1050574</id>
        <id>uva-lib:1050590</id>
        <id>uva-lib:1050619</id>
        <id>uva-lib:1050818</id>
        <id>uva-lib:1050826</id>
        <id>uva-lib:1050980</id>
        <id>uva-lib:1051032</id>
        <id>uva-lib:1051033</id>
        <id>uva-lib:1051034</id>
        <id>uva-lib:1051043</id>
        <id>uva-lib:1051049</id>
        <id>uva-lib:1051065</id>
        <id>uva-lib:1051066</id>
        <id>uva-lib:1051067</id>
        <id>uva-lib:1051101</id>
        <id>uva-lib:1051102</id>
        <id>uva-lib:1051126</id>
        <id>uva-lib:1051127</id>
        <id>uva-lib:1051129</id>
        <id>uva-lib:1051135</id>
        <id>uva-lib:1051145</id>
        <id>uva-lib:1051218</id>
        <id>uva-lib:1051233</id>
        <id>uva-lib:1051250</id>
        <id>uva-lib:1051662</id>
        <id>uva-lib:1051663</id>
        <id>uva-lib:1051670</id>
        <id>uva-lib:1051827</id>
        <id>uva-lib:1051851</id>
        <id>uva-lib:1051910</id>
        <id>uva-lib:1051919</id>
        <id>uva-lib:1052016</id>
        <id>uva-lib:1052017</id>
        <id>uva-lib:1052018</id>
        <id>uva-lib:1052022</id>
        <id>uva-lib:1052023</id>
        </missing>
    </xsl:variable>

    <xsl:variable name="howardCollectionName">James Murray Howard University of Virginia Historic Buildings and Grounds Collection, University of Virginia Library</xsl:variable>

    <xsl:param name="skipAdd"/>

    <xsl:template match="/">
       <xsl:if test="not($skipAdd = 'true')">
         <add>
           <xsl:apply-templates select="*" />
         </add>
       </xsl:if>
       <xsl:if test="$skipAdd = 'true'">
           <xsl:apply-templates select="*" />
       </xsl:if>
           
    </xsl:template>

    <xsl:template match="doc">
        <doc>
            <xsl:if test="$extraIdentifier"><field name="identifier_e_stored"><xsl:value-of select="$extraIdentifier"/></field></xsl:if>
            <xsl:variable name="id">
                <xsl:choose>
                    <!--  this is a mess of possible places to find the PID.  It's likely that some are no longer relevant.
                        To confirm that every ID is present 
                      -->
                    <xsl:when test="field[@name='sourceRecordIdentifier' and @source='JStor Forum' and @type='SSID']">i_<xsl:value-of select="field[@name='sourceRecordIdentifier' and @source='JStor Forum' and @type='SSID']" /></xsl:when>
                    <xsl:when test="field[@name='identifier' and @type='University of Virginia Library']"><xsl:value-of select="field[@name='identifier' and @type='University of Virginia Library']" /></xsl:when>
                    <xsl:when test="field[@name='localIdentifier' and @displayLabel='University of Virginia Library']"><xsl:value-of select="field[@name='localIdentifier' and @displayLabel='University of Virginia Library']" /></xsl:when>
                    <xsl:when test="field[@name='identifier' and @type='UVA Library Fedora Repository PID']"><xsl:value-of select="field[@name='identifier' and @type='UVA Library Fedora Repository PID']"></xsl:value-of></xsl:when>
                    <xsl:when test="field[@name='identifier' and @type='Metadata PID']"><xsl:value-of select="field[@name='identifier' and @type='Metadata PID']" /></xsl:when>
                    <xsl:when test="field[@name='identifier' and @type='pid']"><xsl:value-of select="field[@name='identifier' and @type='pid']" /></xsl:when>
                    <xsl:when test="field[@name = 'identifier' and @type = 'metadata pid']"><xsl:value-of select="field[@name = 'identifier' and @type = 'metadata pid']"/></xsl:when>
                    <xsl:otherwise>
                       <xsl:message terminate="yes">No Identifier found in (<xsl:value-of select="base-uri()" />)!</xsl:message> 
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="not($id) or $id = ''">
            <xsl:message terminate="yes">No Identifier found in uvaMAP (<xsl:value-of select="base-uri()" />)!</xsl:message>
            </xsl:if>
            <xsl:variable name="useGrouping" select="matches(field[@name = 'keyDate']/text(), '^\d{4}-\d{2}-\d{2}$') or not(field[@name = 'host_sortTitle']/text() = 'Holsinger Studio Collection')"/>
            <xsl:variable name="group">
                <xsl:if test="$useGrouping"><xsl:value-of select="field[@name = 'work_title']"/></xsl:if>
                <xsl:if test="not($useGrouping)"><xsl:value-of select="concat('ungrouped-individual-', $id)"/></xsl:if>
            </xsl:variable>
            <xsl:variable name="iiif">
                <xsl:choose>
                    <xsl:when test="$collectionParam = 'Architecture of Jefferson Country'">
                        <xsl:value-of select="concat('https://iiif.lib.virginia.edu/iiif/', $id)"/>
                    </xsl:when>
                    <xsl:when test="field[@name = 'uri' and @access = 'preview']">
                      <xsl:for-each select="field[@name = 'uri' and @access = 'preview']">
                        <xsl:if test="contains(text(), '/full/')">
                          <xsl:value-of select="substring-before(text(), '/full/')" />
                        </xsl:if>
                      </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="field[@name = 'uri' and @access = 'raw object']">
                      <xsl:for-each select="field[@name = 'uri' and @access = 'raw object']">
                        <xsl:if test="ends-with(text(), '/info.json')">
                          <xsl:value-of select="replace(text(), '/info.json', '')" />
                        </xsl:if>
                      </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="field[@name = 'identifier' and (@type = 'master file pid')]">
                        <xsl:value-of select="concat('https://iiif.lib.virginia.edu/iiif/', field[@name = 'identifier' and (@type = 'master file pid')])" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="field[@name = 'uri' and (@displayLabel = 'uvaIIIFimage' or @displayLabel='ArtStorIIIFimage')]" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="library">
                <xsl:call-template name="getLibrary"/>
            </xsl:variable>
            <xsl:variable name="missing">
                <xsl:value-of select="boolean($missingIds//id[text() = $id])"/>
            </xsl:variable>
            <xsl:if test="$missing = true()">
                 <xsl:comment><xsl:value-of select="$id"/> is known to have a placeholder image because the original is missing.</xsl:comment>
            </xsl:if>
            <xsl:if test="not($id) or not($group) or not($iiif) or $missing = true()">
                <field name="shadowed_location_f_stored">HIDDEN</field>
            </xsl:if>
            <field name="id">
                <xsl:value-of select="$id"/>
            </field>
            <xsl:if test="$curio">
                <field name="url_oembed_stored">https://curio.lib.virginia.edu/oembed?url=https://curio.lib.virginia.edu/view/<xsl:value-of select="$id" /></field>                                    
            </xsl:if>
            <field name="work_title2_key_ssort_stored">
                <xsl:value-of select="$group"/>
            </field>
            <field name="url_iiif_image_a">
                <xsl:value-of select="$iiif"/>
            </field>
            <field name="thumbnail_url_stored">
                <xsl:choose>
                  <xsl:when test="/add/doc/field[@name = 'uri'][@displayLabel='uvaIIIFthumbnail']">
                  <xsl:value-of select="/add/doc/field[@name = 'uri'][@displayLabel='uvaIIIFthumbnail']" />
                  </xsl:when>
                  <xsl:otherwise>
                    <!--  supports jefferson-country which won't recieve updates to the latest uvaMAP specification -->
                    <xsl:value-of select="concat($iiif, '/full/!200,200/0/default.jpg')"/>
                  </xsl:otherwise>
                </xsl:choose>
            </field>
            <!--  LEGACY NAMES 
            <field name="url_iiif_image_stored">
                <xsl:value-of select="$iiif"/><xsl:text>/info.json</xsl:text>
            </field>
            <field name="url_iiif_manifest_stored">missing</field>
              end of LEGACY NAMES -->
            <field name="pool_f_stored">images</field>
            <field name="uva_availability_f_stored">Online</field>
            <field name="anon_availability_f_stored">Online</field>
            <field name="circulating_f">true</field>
            <field name="library_f_stored">
                <xsl:value-of select="$library"/>
            </field>
            <xsl:apply-templates select="field"/>
            
            <!--  Because of inconsistency in where the collection name comes from and the fact that it shouldn't
                  change or it'll break links in Virgo, this can't be well handled by individual templates. -->
            <xsl:choose>
              <xsl:when test="$collectionParam">
                 <xsl:call-template name="applyCollectionExtras"><xsl:with-param name="collection" select="$collectionParam" /></xsl:call-template>
              </xsl:when>
              <xsl:when test="field[@name = 'host_sortTitle']">
                <xsl:call-template name="applyCollectionExtras"><xsl:with-param name="collection" select="field[@name = 'host_sortTitle']/text()" /></xsl:call-template>
              </xsl:when>
              <xsl:when test="field[@name = 'host_title']">
                <xsl:for-each select="field[@name = 'host_title']">
                  <xsl:call-template name="applyCollectionExtras"><xsl:with-param name="collection" select="text()" /></xsl:call-template>              
                </xsl:for-each>
                </xsl:when>
              <xsl:otherwise>
                 <xsl:message terminate="yes">No collection name found in (<xsl:value-of select="base-uri()" />), for <xsl:value-of select="$id" />!</xsl:message>
              </xsl:otherwise>
            </xsl:choose>
        </doc>
    </xsl:template>

   <xsl:template name="applyCollectionExtras">
     <xsl:param name="collection" required="yes"/>
     <xsl:choose>
            <xsl:when test="$collection = 'The Holsinger Studio Collection'">
                <field name="images_tsearch">Holsinger Studio Collection</field>
                <field name="images_tsearch">glass plate slides</field>
                <field name="images_tsearch">black and white</field>
                <field name="images_tsearch">images</field>
                <field name="images_tsearch">photographs</field>
                <field name="images_tsearch">pictures</field>
                <field name="digital_collection_tsearchf_stored">
                  <xsl:text>Holsinger Studio Collection</xsl:text>
                </field>
            </xsl:when>
         <xsl:when test="$collection = 'The University of Virginia Visual History Collection'">
           <field name="digital_collection_tsearchf_stored">
              <xsl:text>University of Virginia Visual History Collection</xsl:text>
           </field>
         </xsl:when>
            <xsl:when test="$collection = 'Architecture of Jefferson Country'">
                <field name="digital_collection_tsearchf_stored">
                    <xsl:text>Architecture of Jefferson Country</xsl:text>
                </field>
                <field name="digital_collection_tsearchf_stored">
                    <xsl:text>Art and Architecture</xsl:text>
                </field>
                <field name="author_credits_tsearch_stored">K. Edward Lay, Also published in The Architecture of Jefferson country: Charlottesville and Albemarle County, Virginia. 2000.</field>
            </xsl:when>
         <xsl:when test="$collection = $howardCollectionName">
             <field name="digital_collection_tsearchf_stored">
                <xsl:value-of select="$howardCollectionName" />
             </field> 
             <field name="author_facet_tsearchf_stored">Howard, James Murray</field>
         </xsl:when>
         <xsl:when test="$collection = 'The Jackson Davis Collection of African American Photographs'">
             <field name="digital_collection_tsearchf_stored">
                <xsl:text>Jackson Davis Collection of African American Photographs</xsl:text>
             </field>
         </xsl:when>
         <xsl:when test="$collection = 'James Murray Howard University of Virginia Historic Buildings and Grounds Collection'">
             <field name="digital_collection_tsearchf_stored">
                <xsl:text>James Murray Howard University of Virginia Historic Buildings and Grounds Collection</xsl:text>
             </field>
         </xsl:when>
         <xsl:when test="$collection = 'Richard Guy Wilson Archive'">
             <field name="digital_collection_tsearchf_stored">
                <xsl:text>Richard Guy Wilson Archive</xsl:text>
             </field>
         </xsl:when>
         <xsl:when test="$collection = 'Robert Vickery: Marks Upon the Land'">
             <field name="digital_collection_tsearchf_stored">
                <xsl:text>Robert Vickery: Marks Upon the Land</xsl:text>
             </field>
         </xsl:when>
         <xsl:when test="$collection = 'Elizabeth Meyer Barcelona Landscapes Collection'">
             <field name="digital_collection_tsearchf_stored">
                <xsl:text>Elizabeth Meyer Barcelona Landscapes Collection</xsl:text>
             </field>
         </xsl:when>
            <xsl:otherwise>
              <xsl:comment>Skipping unapproved collection title: <xsl:value-of select="$collection" /></xsl:comment>
              <field name="text_tsearchf_stored"><xsl:value-of select="$collection" /></field>
            </xsl:otherwise>
     </xsl:choose>
   </xsl:template>
    
    <xsl:template match="field[@name = 'identifier']">
        <field name="identifier_e_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
   
    <xsl:template match="field[@name = 'useRestrict']">
      <xsl:for-each select="@valueURI">
        <field name="rs_uri_a"><xsl:value-of select="." /></field>
      </xsl:for-each>
    </xsl:template>
    <xsl:template match="field[@name = 'orig_useRestrict'][text() = 'Copyright not evaluated']">
        <field name="rs_uri_a">http://rightsstatements.org/vocab/CNE/1.0/</field>
    </xsl:template>
    
    <xsl:template match="field[@name = 'orig_useRestrict']">
        <field name="access_note_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>

    <xsl:template match="field[@name = 'orig_accessRestrict']">
        <field name="access_note_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    
    <xsl:template match="field[@name = 'orig_content_type']">
        <field name="format_f">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    
    <xsl:template match="field[@name = 'orig_physDetails']">
        <field name="orig_physical_details_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>

    <xsl:template match="field[@name = 'orig_dateCreated']">
        <xsl:if test="not(text() = 'Xndated')">
            <field name="orig_date_created_tsearch_stored"><xsl:value-of select="text()" /></field>
        </xsl:if>
    </xsl:template>

    <xsl:template match="field[@name = 'keyDate']">
        <xsl:call-template name="fixDate">
            <xsl:with-param name="field">published_daterange</xsl:with-param>
            <xsl:with-param name="datestring">
                <xsl:value-of select="text()"/>
            </xsl:with-param>
            <xsl:with-param name="mode">range</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="fixDate">
            <xsl:with-param name="field">published_date</xsl:with-param>
            <xsl:with-param name="datestring">
                <xsl:value-of select="text()"/>
            </xsl:with-param>
            <xsl:with-param name="monthDefault">-01</xsl:with-param>
            <xsl:with-param name="mode">date</xsl:with-param>
            <xsl:with-param name="dayDefault">-01</xsl:with-param>
            <xsl:with-param name="timeDefault">T00:00:00Z</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="field[@name = 'displayTitle']">
        <field name="title_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    
    <xsl:template match="field[@name = 'alternativeTitle']">
        <field name="title_uniform_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    
    <xsl:template match="field[@name = 'carrierType']">
        <field name="orig_carrier_typetsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    
    <xsl:template match="field[@name = 'contentType']">
        <field name="content_type_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>

    <xsl:template match="field[@name = 'mediaType']">
        <field name="media_type_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    
    <xsl:template match="field[@name = 'digitalOrigin']">
        <field name="digital_origin_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    
    <xsl:template match="field[@name = 'internetMediaType']">
        <field name="internet_media_type_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    
    <xsl:template match="field[@name = 'metadataSource']">
        <field name="metadata_source_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    
    
    <xsl:template match="field[@name = 'host_creator']">
        <field name="author_tsearchf">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>    

    <xsl:template match="field[@name = 'creator']">
        <field name="author_facet_tsearchf_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    
    <xsl:template match="field[@name = 'orig_creator']">
        <field name="orig_creator_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    
    <xsl:template match="field[@name = 'creator' and @displayLabel = 'artist']">
        <field name="author_facet_tsearchf_stored">
            <xsl:value-of select="text()"/>
        </field>
        <field name="artist_facet_tsearchf_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    <xsl:template match="field[@name = 'creator' and @displayLabel = 'photographer']">
        <field name="author_facet_tsearchf_stored">
            <xsl:value-of select="text()"/>
        </field>
        <field name="photographer_facet_tsearchf_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>

    <xsl:template match="field[@name = 'contributor']">
        <field name="contributor_tsearchf_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>

    <xsl:template match="field[@name = 'genre']">
        <field name="topic_form_genre_tsearchf_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>

    <xsl:template match="field[@name = 'orig_note']">
        <field name="note_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    
    <xsl:template match="field[@name = 'note']">
        <field name="note_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>

    <xsl:template match="field[@name = 'note' and @displayLabel = 'Category']">
        <field name="vanity_fair_category_tsearchf_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>

    <xsl:template match="field[@name = 'note' and @displayLabel = 'Group']">
        <field name="vanity_fair_group_tsearchf_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>

    <xsl:template match="field[@name = 'note' and @displayLabel = 'Signature']">
        <field name="vanity_fair_signature_tsearchf_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    
    <xsl:template match="field[@name = 'uri' and @displayLabel='ArtStorImageInContext']">
        <field name="url_str_stored"><xsl:value-of select="text()" /></field>
        <field name="data_source_str_stored">artstor</field>
        <field name="url_label_str_stored">View Online</field>
    </xsl:template>


    <xsl:template match="field[@name = 'uri' and @access='object in context' and @usage='primary']">
        <field name="url_str_stored"><xsl:value-of select="text()" /></field>
        <xsl:if test="../field[@name='metadataSource']/text() = 'JStor Forum'">
            <field name="data_source_str_stored">artstor</field>
        </xsl:if>
        <field name="url_label_str_stored">View Online</field>
    </xsl:template>


<!--
    <xsl:template match="field[@name = 'uri' and @displayLabel = 'uvaIIIFthumbnail']">
        <field name="thumbnail_url_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
 -->
 <!-- 
    <xsl:template match="field[@name = 'uri' and @displayLabel = 'uvaIIIFmanifest']">
        <field name="url_iiif_manifest_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
-->
    <xsl:template match="field[@name = 'subject']">
        <field name="subject_tsearchf_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
<!--
    <xsl:template match="field[@name = 'subjectGenre']">
        <field name="subject_genre_tsearchf_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>

    <xsl:template match="field[@name = 'subjectTopic']">
        <field name="subject_tsearchf_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>

    <xsl:template match="field[@name = 'subjectGeographic']">
        <field name="region_tsearchf_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    
    <xsl:template match="field[@name = 'subjectName']">
        <field name="subject_tsearchf_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
-->

    <xsl:template match="field[@name = 'abstractSummary']">
        <field name="abstract_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>

    <xsl:template match="field[@name = 'orig_identifier' and @type = 'Retrieval ID']">
        <field name="retrieval_id_tsearchf_stored">
            <xsl:value-of select="text()"/>
        </field>
        <field name="identifier_e_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>

    <xsl:template match="field[@name = 'orig_physExtent']">
        <field name="extent_tsearch_stored">
            <xsl:value-of select="text()" />
        </field>
    </xsl:template>

    <xsl:template match="field[@name = 'host_localIdentifier']">
        <field name="identifier_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
        <field name="collection_call_number_a">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>

    <xsl:template match="field[@name = 'host_callNumber']">
        <field name="identifier_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
        <field name="collection_call_number_a">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>

    <xsl:template match="field[@name = 'host_identifier']">
        <field name="collection_call_number_a">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>

    <xsl:template match="field[@name = 'orig_identifier']">
        <field name="identifier_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
        <xsl:choose>
          <xsl:when test="@type = 'Negative Number'">
            <field name="negative_number_e_stored">
                <xsl:value-of select="text()"/>
            </field>
          </xsl:when>
          <xsl:when test="@type = 'Collection AccessionNumber'">
            <field name="collection_call_number_a">
              <xsl:value-of select="text()"/>
            </field>
          </xsl:when>
          <xsl:otherwise>
            <field name="orig_identifier_e_stored">
              <xsl:value-of select="text()"/>
            </field>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template
        match="field[@name = 'host_identifier' and @type = 'Collection Accession Number']">
        <field name="collection_call_number_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
        <field name="identifier_e_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>

    <xsl:template match="field[@name = 'host_physLocation']">
        <field name="host_location_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    
    <xsl:template match="field[@name = 'stylePeriod']">
        <field name="style_period_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    
    <xsl:template match="field[@name = 'culturalContext']">
        <field name="culture_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    <!-- Added for Jefferson Country -->
    <xsl:template match="field[@name = 'work_creator']">
        <field name="author_facet_tsearchf_stored">
            <xsl:value-of select="concat(text(), ' (work creator)')"/>
        </field>
        <field name="work_creator_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    <xsl:template match="field[@name = 'work_date']">
        <field name="work_date_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    <xsl:template match="field[@name = 'work_dateCreated']">
        <field name="work_date_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    <xsl:template match="field[@name = 'work_dateOther']">
      <field name="work_date_tsearch_stored">
         <xsl:value-of select="text()" />
      </field>
      <!--  The following is added to the index, but given that the dates already include a piece specifying their type, are not configured to be displayed -->
      <field>
         <xsl:attribute name="name"><xsl:value-of select="concat('work_date_', @type, '_tsearch_stored')" /></xsl:attribute>
         <xsl:value-of select="text()" />
      </field>
    </xsl:template>
    <xsl:template match="field[@name = 'work_abstractSummary']">
        <field name="work_abstract_summary_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    <xsl:template match="field[@name = 'work_location']">
        <field name="work_location_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    <xsl:template match="field[@name = 'work_relatedWork']">
        <field name="work_related_work_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    <xsl:template match="field[@name = 'work_workLocation']">
        <field name="work_location_tsearch_stored">
            <xsl:value-of select="text()" />
        </field>
    </xsl:template>
    <xsl:template match="field[@name = 'work_identifier']">
        <field name="work_identifier_e_stored">
            <xsl:value-of select="text()"/>
            <xsl:if test="@type"><xsl:value-of select="concat(' (', @type, ')')"/></xsl:if>
        </field>
    </xsl:template>
    <xsl:template match="field[@name = 'work_contentType']">
        <field name="work_content_type_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    <xsl:template match="field[@name = 'work_description']">
        <field name="work_description_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    <xsl:template match="field[@name = 'work_type']">
        <field name="work_type_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    <xsl:template match="field[@name = 'work_physDetails']">
        <field name="material_tsearch_stored">
            <xsl:value-of select="text()"/>
        </field>
    </xsl:template>
    
    <xsl:template match="field[@name='orig_carrierType']">
      <field name="orig_carrier_type"><xsl:value-of select="text()" /></field>
    </xsl:template>
    
    <xsl:template match="field[@name='orig_contentType']">
      <field name="orig_content_type"><xsl:value-of select="text()" /></field>
    </xsl:template>
    
    <xsl:template match="field[@name='orig_mediaType']">
      <field name="orig_media_type"><xsl:value-of select="text()" /></field>
    </xsl:template>
    
    <!-- Catch all -->
    <xsl:template match="field">
      <!--  some fields are known about but we either have very special handling 
            for them elsewhere, or we know we don't want to handle them in any 
            specific way, so we can include them in this list to prevent a comment
            in the solr doc -->
      <xsl:variable name="known">
        <knownFields>
          <name>originalMetadataType</name>
          <name>sourceRecordIdentifier</name>
          <name>pubProdDist</name>
          <name>pubProdDistPlace</name>
          <name>orig_pubProdDistPlace</name>
          <name>host_pubProdDistPlace</name>
          <name>uri</name>
          <name>title</name>
          <name>sortTitle</name>
          <name>work_title</name>
          <name>host_title</name>
          <name>subjectTopic</name>
          <name>subjectGeographic</name>
          <name>subjectName</name>
          <name>host_contentType</name>
          <name>host_isCollection</name>
          <name>host_dateCreated</name>
          <name>host_accessRestrict</name>
        </knownFields>
      </xsl:variable>
      <xsl:variable name="name" select="@name" />
        <field name="images_tsearch"><xsl:value-of select="text()"/></field>
        <xsl:if test="not(boolean($known//name[text() = $name]))">
          <xsl:comment>NO MAPPING FOR <xsl:value-of select="@name" />, <xsl:value-of select="@type"/></xsl:comment>
        </xsl:if>
    </xsl:template>

    <!-- handles fixing all of the dates. Can create a date or a daterange -->
    <xsl:template name="fixDate">
        <xsl:param name="field"/>
        <xsl:param name="datestring"/>
        <xsl:param name="monthDefault"/>
        <xsl:param name="dayDefault"/>
        <xsl:param name="timeDefault"/>
        <xsl:param name="mode"/>
        <xsl:variable name="fmtdate">
            <xsl:choose>
                <xsl:when
                    test="matches($datestring, '\[[0-9][0-9][0-9][0-9] TO [0-9][0-9][0-9][0-9]\]')">
                    <xsl:analyze-string select="$datestring"
                        regex="\[([0-9][0-9][0-9][0-9]) TO ([0-9][0-9][0-9][0-9])\]">
                        <xsl:matching-substring>
                            <xsl:variable name="year1" select="number(regex-group(1))"/>
                            <xsl:variable name="year2" select="number(regex-group(2))"/>
                            <xsl:choose>
                                <xsl:when test="$mode = 'range'">
                                    <xsl:if test="$year2 &gt; $year1"><xsl:value-of select="$datestring"/></xsl:if>
                                </xsl:when>
                                <xsl:when test="$mode = 'human'">
                                    <xsl:value-of select="concat($year1, '-', $year2)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="concat(number(regex-group(1)), $monthDefault, $dayDefault, $timeDefault)"
                                    />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:when
                    test="matches($datestring, '([0-9][0-9][0-9][0-9])[~?]?[/]([0-9][0-9][0-9][0-9])[~?]?(.*)')">
                    <xsl:analyze-string select="$datestring"
                        regex="([0-9][0-9][0-9][0-9])[~?]?[/]([0-9][0-9][0-9][0-9])[~?]?(.*)">
                        <xsl:matching-substring>
                            <xsl:variable name="year1" select="number(regex-group(1))"/>
                            <xsl:variable name="year2" select="number(regex-group(2))"/>
                            <xsl:choose>
                                <xsl:when test="$mode = 'range'">
                                    <xsl:value-of select="$datestring"/>
                                </xsl:when>
                                <xsl:when test="$mode = 'human'">
                                    <xsl:value-of select="concat($year1, '-', $year2)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="concat($year1, $monthDefault, $dayDefault, $timeDefault)"
                                    />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:when
                    test="matches($datestring, '([0-9][0-9][0-9][0-9])[-/]([0-9][0-9]?)[-/]([0-9][0-9]?)(.*)')">
                    <xsl:analyze-string select="$datestring"
                        regex="([0-9][0-9][0-9][0-9])[-/]([0-9][0-9]?)[-/]([0-9][0-9]?)(.*)">
                        <xsl:matching-substring>
                            <xsl:variable name="month" select="regex-group(2)"/>
                            <xsl:variable name="dayraw" select="regex-group(3)"/>
                            <xsl:variable name="day">
                                <xsl:choose>
                                    <xsl:when
                                        test="number($month) = 2 and matches($dayraw, '(29|30|31)')">
                                        <xsl:value-of select="number('28')"/>
                                    </xsl:when>
                                    <xsl:when
                                        test="$dayraw = '31' and matches($month, '(04|06|09|11)')">
                                        <xsl:value-of select="number('30')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="number($dayraw)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="year" select="number(regex-group(1))"/>
                            <xsl:value-of
                                select="concat($year, '-', format-number(number($month), '00'), '-', format-number($day, '00'), $timeDefault)"
                            />
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:when test="matches($datestring, '[^0-9]*([0-9][0-9][0-9][0-9])(.*)')">
                    <xsl:analyze-string select="$datestring"
                        regex="[^0-9]*([0-9][0-9][0-9][0-9])(.*)">
                        <xsl:matching-substring>
                            <xsl:variable name="year" select="number(regex-group(1))"/>
                            <xsl:value-of
                                select="concat($year, $monthDefault, $dayDefault, $timeDefault)"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:when test="matches($datestring, '[^0-9]*([0-9][0-9][0-9])X(.*)')">
                    <xsl:analyze-string select="$datestring" regex="[^0-9]*([0-9][0-9][0-9])X(.*)">
                        <xsl:matching-substring>
                            <xsl:variable name="yearstart" select="number(regex-group(1))"/>
                            <xsl:variable name="yearunits" select="number(regex-group(1))"/>
                            <xsl:choose>
                                <xsl:when test="$mode = 'range'">
                                    <xsl:value-of
                                        select="concat('[', $yearstart, '0', ' TO ', $yearstart, '9', ']')"
                                    />
                                </xsl:when>
                                <xsl:when test="$mode = 'human'">
                                    <xsl:value-of select="concat($yearstart, '-', $yearstart, '9')"
                                    />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="concat($yearstart, '5', $monthDefault, $dayDefault, $timeDefault)"
                                    />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:otherwise>
                    <!--   <xsl:value-of select="concat('%%%%%', $datestring, '%%%%%')"/> -->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$fmtdate != ''">
            <xsl:element name="field">
                <xsl:attribute name="name">
                    <xsl:value-of select="$field"/>
                </xsl:attribute>
                <xsl:value-of select="$fmtdate"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template name="getLibrary">
        <xsl:choose>
            <xsl:when
                test="//field[@name = 'host_physLocation' and text() = 'Special Collections, University of Virginia Library, Charlottesville, Va.']">
                <xsl:text>Special Collections</xsl:text>
            </xsl:when>
            <xsl:when
                test="//field[@name='host_physLocation' and text()='Historical Collections &amp; Services, Claude Moore Health Sciences Library, Charlottesville, Va.']">
                <xsl:text>Health Sciences</xsl:text>
            </xsl:when>
            <xsl:when
                test="//field[@name = 'host_physLocation' and text() = 'Fiske Kimball Fine Arts Library, University of Virginia Libraries, Charlottesville, Va.']">
                <xsl:text>Fine Arts</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- ======================================================================= -->
    <!-- DEFAULT TEMPLATE                                                        -->
    <!-- ======================================================================= -->

    <xsl:template match="@* | node()">
        <xsl:apply-templates select="@* | node()"/>
    </xsl:template>

    <xsl:template match="@* | node()" mode="group item skip">
        <xsl:apply-templates select="@* | node()"/>
    </xsl:template>

</xsl:stylesheet>
