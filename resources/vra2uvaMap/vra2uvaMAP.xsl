<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns=""
  xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="mods xlink">

  <xsl:output media-type="text/xml" method="xml" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- ======================================================================= -->
  <!-- PARAMETERS                                                              -->
  <!-- ======================================================================= -->



  <!-- ======================================================================= -->
  <!-- GLOBAL VARIABLES                                                        -->
  <!-- ======================================================================= -->

  <!-- program name -->
  <xsl:variable name="progname">
    <xsl:text>vra2uvaMAP.xsl</xsl:text>
  </xsl:variable>

  <!-- program version -->
  <xsl:variable name="version">
    <xsl:text>0.3 beta</xsl:text>
  </xsl:variable>

  <!-- new line -->
  <xsl:variable name="nl">
    <xsl:text>&#xa;</xsl:text>
  </xsl:variable>

  <!-- ======================================================================= -->
  <!-- UTILITIES / NAMED TEMPLATES                                             -->
  <!-- ======================================================================= -->

  <xsl:template name="whereAmI">
    <xsl:choose>
      <xsl:when test="ancestor::*:work[*:image]">
        <xsl:text>orig_</xsl:text>
      </xsl:when>
      <xsl:when test="ancestor::*:work">
        <xsl:text>work_</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- MAIN OUTPUT TEMPLATE                                                    -->
  <!-- ======================================================================= -->

  <xsl:template match="/">
    <xsl:comment>&#32;Generated by <xsl:value-of select="concat($progname, ', v. ', $version, ' ', format-dateTime(current-dateTime(), '[Y]-[M01]-[D01]T[H01]:[m01]'), ' ')"/></xsl:comment>
    <add>
      <!--<xsl:apply-templates select="descendant::*:image"/>-->
      <!-- For J. Murray Howard  -->
      <xsl:apply-templates
        select="descendant::*:image[*:locationSet/*:location[matches(@source, 'ArtStor')]]"/>
    </add>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- MATCH TEMPLATES FOR ELEMENTS                                            -->
  <!-- ======================================================================= -->

  <!-- Digital surrogate -->
  <xsl:template match="*:image">
    <doc>

      <xsl:variable name="pass1">
        <field name="localIdentifier" displayLabel="metadata pid"><xsl:value-of select="@id"/></field>
        <field name="originalMetadataType">VRA</field>
        <xsl:apply-templates select="*:worktypeSet"/>
        <field name="mediaType">computer</field>
        <field name="carrierType">online resource</field>
        <field name="digitalOrigin">reformatted digital</field>
        <xsl:variable name="mediaTypes">
          <xsl:for-each select="*:locationSet/*:location[matches(@href, 'jpe?g|tiff?')]">
            <mediaType>
              <xsl:text>image/</xsl:text>
              <xsl:choose>
                <xsl:when test="matches(@href, 'tiff?')">tiff</xsl:when>
                <xsl:otherwise>jpeg</xsl:otherwise>
              </xsl:choose>
            </mediaType>
          </xsl:for-each>
        </xsl:variable>
        <xsl:if test="$mediaTypes/*:mediaType[not(normalize-space(.) eq '')]">
          <xsl:for-each select="distinct-values($mediaTypes/*:mediaType)">
            <field name="internetMediaType">
              <xsl:value-of select="."/>
            </field>
          </xsl:for-each>
        </xsl:if>
        <field name="pubProdDist">The Rector and Visitors of the University of Virginia</field>
        <field name="pubProdDistPlace">Charlottesville, Va.</field>
        <xsl:for-each select="*:rightsSet/*:rights">
          <field name="useRestrict">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:for-each>
        <xsl:apply-templates select="*:locationSet"/>
        <xsl:apply-templates select="parent::*:work"/>
      </xsl:variable>

      <xsl:apply-templates select="$pass1" mode="workTitle"/>
      <!--<xsl:copy-of select="$pass1"/>-->
    </doc>
  </xsl:template>

  <xsl:template match="*:field[@name eq 'work_title']" mode="workTitle">
    <field name="displayTitle">
      <xsl:value-of select="." /><xsl:text> (</xsl:text>
      <xsl:value-of select="normalize-space(../*:field[@name eq 'title'])"/>
      <xsl:text>)</xsl:text>
    </field>
    
    <field name="work_title">
      <xsl:value-of select="."/>
      <!--<xsl:text>¶</xsl:text>
      <xsl:value-of select="../*:field[@name eq 'sortTitle']"/>-->
      <xsl:text>¶</xsl:text>
      <xsl:value-of select="../*:field[@name eq 'contentType']"/>
      <xsl:choose>
        <xsl:when test="normalize-space(../field[@name eq 'keyDate']) ne ''">
          <xsl:text>¶</xsl:text>
          <xsl:value-of
            select="replace(replace(replace(../*:field[@name eq 'keyDate'], '[\[\]]', ''), ' TO ', '/'), '\*', '')"
          />
        </xsl:when>
        <xsl:when test="../*:field[@name eq 'work_date']">
          <xsl:text>¶</xsl:text>
          <xsl:value-of select="../*:field[@name eq 'work_date']"/>
        </xsl:when>
        <xsl:when test="../*:field[@name eq 'orig_dateCreated']">
          <xsl:text>¶</xsl:text>
          <xsl:value-of select="../*:field[@name eq 'orig_dateCreated']"/>
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="../*:field[@name eq 'orig_creator']">
          <xsl:text>¶</xsl:text>
          <xsl:value-of select="../*:field[@name eq 'orig_creator'][1]"/>
        </xsl:when>
        <xsl:when test="../*:field[@name eq 'creator']">
          <xsl:text>¶</xsl:text>
          <xsl:value-of select="../*:field[@name eq 'creator'][1]"/>
        </xsl:when>
        <xsl:when test="../*:field[@name eq 'work_creator']">
          <xsl:text>¶</xsl:text>
          <xsl:value-of select="../*:field[@name eq 'work_creator'][1]"/>
        </xsl:when>
        <xsl:when test="../*:field[@name eq 'host_displayTitle']">
          <xsl:text>¶</xsl:text>
          <xsl:value-of select="../*:field[@name eq 'host_displayTitle'][1]"/>
        </xsl:when>
      </xsl:choose>
    </field>
  </xsl:template>

  <!-- Work w/ descendant image(s) represents the original, physical work, i.e., photograph -->
  <xsl:template match="*:work[*:image]">
    <xsl:choose>
      <xsl:when test="*:relationSet/*:relation[matches(@type, 'depicts')]">
        <field name="sortTitle">
          <xsl:value-of select="replace(*:titleSet/*:title[1], '^(a|an|the) ', '', 'i')"/>
        </field>
        <field name="title">
          <xsl:value-of select="normalize-space(*:titleSet/*:title[1])"/>
        </field>
        <xsl:for-each select="*:titleSet/*:title[position() &gt; 1]">
          <field name="alternativeTitle">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="*:descriptionSet/*:description">
          <field name="abstractSummary">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="*:agentSet/*:agent">
          <field name="orig_creator">
            <xsl:value-of select="normalize-space(*:name)"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="*:dateSet">
          <field name="orig_dateCreated">
            <xsl:value-of select="normalize-space(*:display)"/>
          </field>
          <xsl:for-each select="*:notes">
            <field name="note">
              <xsl:value-of select="normalize-space(.)"/>
            </field>
          </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="*:locationSet/*:location">
          <xsl:if test="matches(@type, 'repository')">
            <xsl:if test="*:refid">
              <field name="orig_localIdentifier">
                <xsl:value-of select="normalize-space(*:refid)"/>
              </field>
            </xsl:if>
            <field name="host_displayTitle">
              <xsl:value-of select="normalize-space(*:name)"/>
            </field>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="*:rightsSet/*:rights">
          <field name="orig_useRestrict">
            <xsl:value-of select="normalize-space(*:text)"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="*:subjectSet/*:subject">
          <field name="subject">
            <xsl:value-of select="string-join(*:term, '--')"/>
          </field>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <field name="work_title">
          <xsl:value-of select="normalize-space(*:titleSet/*:title[1])"/>
        </field>
        <xsl:for-each select="*:titleSet/*:title[position() &gt; 1]">
          <field name="work_alternativeTitle">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="*:descriptionSet/*:description">
          <field name="work_abstractSummary">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="*:agentSet/*:agent">
          <field name="work_creator">
            <xsl:value-of select="normalize-space(*:name)"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="*:dateSet">
          <field name="work_dateCreated">
            <xsl:value-of select="normalize-space(*:display)"/>
          </field>
          <xsl:for-each select="*:notes">
            <field name="work_note">
              <xsl:value-of select="normalize-space(.)"/>
            </field>
          </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="*:locationSet/*:location">
          <xsl:if test="matches(@type, 'repository')">
            <xsl:if test="*:refid">
              <field name="work_localIdentifier">
                <xsl:value-of select="normalize-space(*:refid)"/>
              </field>
            </xsl:if>
            <field name="work_location">
              <xsl:value-of select="normalize-space(*:name)"/>
            </field>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="*:culturalContextSet/*:culturalContext">
          <field name="culturalContext">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="*:stylePeriodSet/*:stylePeriod">
          <field name="stylePeriod">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:for-each>
        <field name="keyDate">
          <xsl:variable name="earliestDate">
            <xsl:value-of select="normalize-space(*:dateSet/*:date/*:earliestDate)"/>
          </xsl:variable>
          <xsl:variable name="latestDate">
            <xsl:value-of select="normalize-space(*:dateSet/*:date/*:latestDate)"/>
          </xsl:variable>
          <xsl:variable name="keyDateValue">
            <xsl:value-of select="$earliestDate"/>
            <xsl:if test="not($latestDate eq $earliestDate)">
              <xsl:value-of select="concat('/', $latestDate)"/>
            </xsl:if>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="matches($keyDateValue, '/')">
              <xsl:value-of
                select="concat('[', substring-before($keyDateValue, '/'), ' TO ', substring-after($keyDateValue, '/'), ']')"
              />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$keyDateValue"/>
            </xsl:otherwise>
          </xsl:choose>
        </field>
        <xsl:for-each select="*:worktypeSet/*:worktype">
          <field name="work_type">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="*:agentSet/*:agent">
          <field name="work_creator">
            <xsl:value-of select="normalize-space(*:name)"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="*:dateSet">
          <field name="work_date">
            <xsl:choose>
              <xsl:when test="*:display">
                <xsl:value-of select="normalize-space(*:display)"/>
              </xsl:when>
              <xsl:when test="*:latestDate eq *:earliestDate">
                <xsl:value-of select="normalize-space(*:earliestDate)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat(*:earliestDate, '-', *:latestDate)"/>
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <xsl:for-each select="*:notes">
            <field name="work_note">
              <xsl:value-of select="normalize-space(.)"/>
            </field>
          </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="*:descriptionSet/*:description">
          <field name="work_description">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="*:materialSet/*:material">
          <field name="work_physDetails">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="*:rightsSet/*:rights">
          <field name="work_useRestrict">
            <xsl:value-of select="normalize-space(*:text)"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="*:subjectSet/*:subject">
          <field name="subject">
            <xsl:value-of select="string-join(*:term, '--')"/>
          </field>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>

    <!-- Work info taken from work elements associated with the photograph via the 'depicts' relation,
      i.e., built works -->
    <xsl:for-each select="*:relationSet/*:relation[matches(@type, 'depicts') and @relids]">
      <xsl:variable name="relatedWorkID">
        <xsl:value-of select="@relids"/>
      </xsl:variable>
      <xsl:for-each select="ancestor::*:vra/*:work[@id eq $relatedWorkID]">
        <xsl:for-each select="*:subjectSet/*:subject">
          <field name="subject">
            <xsl:value-of select="string-join(*:term, '--')"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="*:culturalContextSet/*:culturalContext">
          <field name="culturalContext">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="*:stylePeriodSet/*:stylePeriod">
          <field name="stylePeriod">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:for-each>
        <field name="keyDate">
          <xsl:variable name="earliestDate">
            <xsl:value-of select="normalize-space(*:dateSet/*:date/*:earliestDate)"/>
          </xsl:variable>
          <xsl:variable name="latestDate">
            <xsl:value-of select="normalize-space(*:dateSet/*:date/*:latestDate)"/>
          </xsl:variable>
          <xsl:variable name="keyDateValue">
            <xsl:value-of select="$earliestDate"/>
            <xsl:if test="not($latestDate eq $earliestDate)">
              <xsl:value-of select="concat('/', $latestDate)"/>
            </xsl:if>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="matches($keyDateValue, '/')">
              <xsl:value-of
                select="concat('[', substring-before($keyDateValue, '/'), ' TO ', substring-after($keyDateValue, '/'), ']')"
              />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$keyDateValue"/>
            </xsl:otherwise>
          </xsl:choose>
        </field>
        <xsl:for-each select="*:worktypeSet/*:worktype">
          <field name="work_type">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:for-each>
        <field name="work_title">
          <xsl:choose>
            <xsl:when test="*:titleSet/*:title[@pref]">
              <xsl:value-of select="normalize-space(*:titleSet/*:title[@pref])"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="normalize-space(*:titleSet/*:title[1])"/>
            </xsl:otherwise>
          </xsl:choose>
        </field>
        <xsl:for-each select="*:titleSet/*:title[position() &gt; 1]">
          <field name="work_alternativeTitle">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="*:agentSet/*:agent">
          <field name="work_creator">
            <xsl:value-of select="normalize-space(*:name)"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="*:dateSet">
          <field name="work_date">
            <xsl:choose>
              <xsl:when test="*:display">
                <xsl:value-of select="normalize-space(*:display)"/>
              </xsl:when>
              <xsl:when test="*:latestDate eq *:earliestDate">
                <xsl:value-of select="normalize-space(*:earliestDate)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat(*:earliestDate, '-', *:latestDate)"/>
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <xsl:for-each select="*:notes">
            <field name="work_note">
              <xsl:value-of select="normalize-space(.)"/>
            </field>
          </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="*:descriptionSet/*:description">
          <field name="work_description">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="*:locationSet/*:location">
          <field name="work_location">
            <xsl:value-of select="normalize-space(string-join(*, ' '))"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="*:materialSet/*:material">
          <field name="work_physDetails">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>

    <!-- Work relationships -->
    <!-- De-dupe relations expressed in the data about the photograph and those expressed 
      in the data about the depicted work -->
    <xsl:variable name="relations">
      <xsl:for-each select="*:relationSet/*:relation[matches(@type, 'relatedTo') and @relids]">
        <field name="work_relatedWork">
          <xsl:value-of select="."/>
        </field>
      </xsl:for-each>
      <xsl:for-each select="*:relationSet/*:relation[matches(@type, 'depicts') and @relids]">
        <xsl:variable name="relatedWorkID">
          <xsl:value-of select="@relids"/>
        </xsl:variable>
        <xsl:for-each select="ancestor::*:vra/*:work[@id eq $relatedWorkID]">
          <xsl:for-each
            select="*:relationSet/*:relation[@relids and not(matches(@relids, $relatedWorkID))]">
            <field name="work_relatedWork">
              <xsl:value-of select="normalize-space(.)"/>
            </field>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>
    <xsl:for-each select="$relations/*:field">
      <xsl:variable name="thisValue">
        <xsl:value-of select="."/>
      </xsl:variable>
      <xsl:if test="not(preceding-sibling::*:field[. eq $thisValue])">
        <xsl:copy-of select="."/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="*:work[not(*:image)]">
    <field name="keyDate">
      <xsl:variable name="earliestDate">
        <xsl:value-of select="normalize-space(*:dateSet/*:date/*:earliestDate)"/>
      </xsl:variable>
      <xsl:variable name="latestDate">
        <xsl:value-of select="normalize-space(*:dateSet/*:date/*:latestDate)"/>
      </xsl:variable>
      <xsl:variable name="keyDateValue">
        <xsl:value-of select="$earliestDate"/>
        <xsl:if test="not($latestDate eq $earliestDate)">
          <xsl:value-of select="concat('/', $latestDate)"/>
        </xsl:if>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="matches($keyDateValue, '/')">
          <xsl:value-of
            select="concat('[', substring-before($keyDateValue, '/'), ' TO ', substring-after($keyDateValue, '/'), ']')"
          />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$keyDateValue"/>
        </xsl:otherwise>
      </xsl:choose>
    </field>
    <field name="work_title">
      <xsl:choose>
        <xsl:when test="*:titleSet/*:title[@pref]">
          <xsl:value-of select="normalize-space(*:titleSet/*:title[@pref])"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space(*:titleSet/*:title[1])"/>
        </xsl:otherwise>
      </xsl:choose>
    </field>
    <xsl:for-each select="*:titleSet/*:title[position() &gt; 1]">
      <field name="work_alternativeTitle">
        <xsl:value-of select="normalize-space(.)"/>
      </field>
    </xsl:for-each>
    <xsl:for-each select="*:worktypeSet/*:worktype">
      <field name="work_type">
        <xsl:value-of select="normalize-space(.)"/>
      </field>
    </xsl:for-each>
    <xsl:for-each select="*:agentSet/*:agent">
      <field name="work_creator">
        <xsl:value-of select="normalize-space(*:name)"/>
      </field>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="*:agentSet">
    <xsl:for-each select="*:agent">
      <xsl:variable name="elementName">
        <xsl:call-template name="whereAmI"/>
        <xsl:text>creator</xsl:text>
      </xsl:variable>
      <field name="{$elementName}">
        <xsl:value-of select="normalize-space(*:name)"/>
      </field>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="*:dateSet">
    <field name="orig_dateCreated">
      <xsl:value-of select="normalize-space(*:display)"/>
    </field>
    <xsl:for-each select="*:notes">
      <field name="note">
        <xsl:value-of select="normalize-space(.)"/>
      </field>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="*:location[ancestor::*:image]">
    <xsl:variable name="fieldName">
      <xsl:choose>
        <xsl:when test="matches(@href, '^[^:]+://')">
          <xsl:text>uri</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>localIdentifier</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <field name="{$fieldName}">
      <xsl:if test="normalize-space(@source) ne ''">
        <xsl:attribute name="displayLabel">
          <xsl:value-of select="@source"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:value-of select="@href"/>
    </field>
  </xsl:template>

  <xsl:template match="*:worktype[ancestor::*:image]">
    <field name="contentType">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- IDENTITY/COPY/DEFAULT TEMPLATES                                         -->
  <!-- ======================================================================= -->

  <xsl:template match="@* | node()" mode="workTitle">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>


</xsl:stylesheet>