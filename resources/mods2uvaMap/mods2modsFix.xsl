<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.loc.gov/mods/v3"
  xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="mods xs" version="2.0">

  <xsl:output method="xml" encoding="UTF-8" indent="yes" media-type="text/xml"
    omit-xml-declaration="no" standalone="no"/>
  <xsl:strip-space elements="*"/>

  <!-- ======================================================================= -->
  <!-- GLOBAL VARIABLES                                                        -->
  <!-- ======================================================================= -->

  <!-- program name -->
  <xsl:variable name="progname">
    <xsl:text>normalizeMODS.xsl</xsl:text>
  </xsl:variable>

  <!-- program version -->
  <xsl:variable name="version">
    <xsl:text>0.1 beta</xsl:text>
  </xsl:variable>

  <!-- new line -->
  <xsl:variable name="nl">
    <xsl:text>&#xa;</xsl:text>
  </xsl:variable>

  <!-- ======================================================================= -->
  <!-- UTILITIES / NAMED TEMPLATES                                             -->
  <!-- ======================================================================= -->

  <!-- ======================================================================= -->
  <!-- MAIN OUTPUT TEMPLATE                                                    -->
  <!-- ======================================================================= -->

  <xsl:template match="*:mods">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <typeOfResource>
        <xsl:apply-templates select="*:typeOfResource/@*"/>
        <xsl:text>still image</xsl:text>
      </typeOfResource>
      <xsl:apply-templates
        select="
          *:accessCondition | *:titleInfo | *:name | *:genre |
          *:physicalDescription | *:note[not(matches(@type, 'provenance'))] | *:subject |
          *:identifier[not(matches(@displayLabel, '(retrieval id|slide call number|negative number|iris id|prints number|ead id|fine arts id)', 'i') or matches(@type, 'accessionNumber', 'i'))]"/>
      <xsl:if
        test="*:identifier[matches(@displayLabel, '(retrieval id|slide call number|negative number|iris id|prints number|ead id|fine arts id)', 'i')]">
        <relatedItem type="original" displayLabel="Original">
          <xsl:apply-templates
            select="*:identifier[matches(@displayLabel, '(retrieval id|slide call number|negative number|irs id|prints number|fine arts id)', 'i')]"/>
          <xsl:if
            test="*:physicalDescription[*:form[matches(@type, 'material|technique', 'i') or matches(., 'nonprojected graphic', 'i')] or *:extent]">
            <physicalDescription>
              <xsl:apply-templates
                select="*:physicalDescription/*:form[matches(@type, 'material|technique', 'i') or matches(., 'nonprojected graphic', 'i')] | *:physicalDescription/*:extent"
              />
            </physicalDescription>
          </xsl:if>
          <xsl:apply-templates select="*:originInfo" mode="original"/>
          <xsl:apply-templates select="*:note[matches(@type, 'provenance')]"/>
        </relatedItem>
      </xsl:if>
      <xsl:apply-templates select="*:location[*:url]" mode="image"/>
      <xsl:apply-templates
        select="*:relatedItem | *:identifier[matches(@displayLabel, 'retrieval id', 'i')]"/>
      <xsl:if test="matches(*:typeOfResource, 'image')">
        <xsl:apply-templates select="*:originInfo" mode="image"/>
      </xsl:if>
      <xsl:apply-templates select="*:recordInfo"/>
    </xsl:copy>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- MATCH TEMPLATES FOR ELEMENTS                                            -->
  <!-- ======================================================================= -->

  <xsl:template match="*:mods/*:location" mode="image">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="*[not(local-name() eq 'physicalLocation')]"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*:mods/*:location" mode="original">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="*[not(local-name() eq 'url')]"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*:originInfo" mode="image">
    <xsl:if test="*[not(matches(local-name(), 'dateCreated'))]">
      <xsl:copy>
        <xsl:apply-templates select="@*"/>
        <xsl:if test="not(*:publisher)">
          <publisher>University of Virginia</publisher>
        </xsl:if>
        <xsl:apply-templates select="*[not(matches(local-name(), 'dateCreated'))]"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*:originInfo" mode="original">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="*:dateCreated"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*:digitalOrigin">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
        <xsl:when test="matches(ancestor::*:mods/*:typeOfResource, 'object')">
          <xsl:text>born digital</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*:recordInfo/*:recordOrigin">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="recordOriginContent">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text>&#32; Normalized </xsl:text>
        <xsl:value-of select="format-dateTime(current-dateTime(), '[Y]-[M02]-[D02]T[H]:[m]:[s]')"/>
        <xsl:text> using </xsl:text>
        <xsl:value-of select="concat($progname, ', ', $version, '.')"/>
      </xsl:variable>
      <xsl:value-of select="normalize-space($recordOriginContent)"/>
    </xsl:copy>

  </xsl:template>

  <xsl:template match="*:mods/*:physicalDescription">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates
        select="
          *:digitalOrigin | *:form[not(matches(@type, 'material|technique', 'i') or matches(., 'nonprojected graphic', 'i'))] | *:internetMediaType | *:note[not(matches(@type, 'provenance'))]"
      />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*:mods/*:relatedItem">
    <xsl:copy>
      <xsl:apply-templates select="@*[not(matches(local-name(), 'type'))]"/>
      <xsl:attribute name="type">
        <xsl:choose>
          <xsl:when
            test="matches(lower-case(.), 'carnegie survey|collection|johnston photographs|jackson davis|photograph file')">
            <!--
              carnegie survey of the architecture of the south
              eduardo montes-bradley photograph and film collection
              frances benjamin johnston photographs
              holsinger studio collection
              jackson davis collection of african american photographs
              papers and photographs of jackson davis
              medical artifacts collection
              printing services photograph file
              visual history collection
              -->
            <xsl:text>host</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@type"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
      <xsl:if
        test="ancestor::*:mods/*:identifier[matches(@displayLabel, 'ead id', 'i') or matches(@type, 'accession', 'i') or matches(., '^(RG|MSS)')]">
        <xsl:apply-templates
          select="ancestor::*:mods/*:identifier[matches(@displayLabel, 'ead id', 'i') or matches(@type, 'accession', 'i') or matches(., '^(RG|MSS)')]"
        />
      </xsl:if>
      <xsl:if test="ancestor::*:mods/*:location[*:physicalLocation]">
        <xsl:apply-templates select="ancestor::*:mods/*:location" mode="original"/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- DEFAULT TEMPLATE                                                        -->
  <!-- ======================================================================= -->

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
