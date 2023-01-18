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
    <xsl:text>mods2modsAddMetadataPID.xsl</xsl:text>
  </xsl:variable>

  <!-- program version -->
  <xsl:variable name="version">
    <xsl:text>0.1 beta</xsl:text>
  </xsl:variable>

  <!-- new line -->
  <xsl:variable name="nl">
    <xsl:text>&#xa;</xsl:text>
  </xsl:variable>

  <xsl:variable name="pidFromFileName">
    <xsl:value-of
      select="replace(tokenize(replace(document-uri(), '-mods.xml$', ''), '/')[last()], '_', ':')"/>
  </xsl:variable>

  <xsl:variable name="imageURLsFile">
    <xsl:text>tracksys-mods-extra-metadata.xml</xsl:text>
  </xsl:variable>

  <!-- ======================================================================= -->
  <!-- UTILITIES / NAMED TEMPLATES                                             -->
  <!-- ======================================================================= -->


  <!-- ======================================================================= -->
  <!-- MAIN OUTPUT TEMPLATE                                                    -->
  <!-- ======================================================================= -->

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- MATCH TEMPLATES FOR ELEMENTS                                            -->
  <!-- ======================================================================= -->

  <!-- Remove @xsi:schemaLocation -->
  <xsl:template match="*:modsCollection">
    <xsl:copy>
      <xsl:apply-templates select="@*[not(matches(local-name(), 'schemaLocation'))]"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- Remove @xsi:schemaLocation -->
  <xsl:template match="*:mods">
    <xsl:copy>
      <!-- Remove @xsi:schemaLocation -->
      <xsl:apply-templates select="@*[not(matches(local-name(), 'schemaLocation'))]"/>
      <xsl:choose>
        <xsl:when test="*:identifier">
          <!-- Process top-level elements preceding any identifiers -->
          <xsl:apply-templates
            select="*[not(matches(local-name(), 'identifier'))][following-sibling::*:identifier]"/>
          <!-- Process identifiers -->
          <xsl:apply-templates select="*:identifier"/>
          <!-- Add URLs from external file -->
          <xsl:if test="not(*:location[*:url[matches(@access, 'preview')]])">
            <xsl:variable name="pidMatchExact">
              <xsl:value-of select="concat('^', normalize-space($pidFromFileName), '$')"/>
            </xsl:variable>
            <xsl:if test="doc-available('tracksys-mods-extra-metadata.xml')">
              <!-- Add URLs -->
              <xsl:for-each
                select="doc('tracksys-mods-extra-metadata.xml')//*:pid[matches(normalize-space(.), $pidMatchExact)]">
                <location>
                  <url usage="primary" access="object in context"
                    displayLabel="Record displayed in VIRGO">
                    <xsl:text>https://search.lib.virginia.edu/catalog/</xsl:text>
                    <xsl:value-of select="$pidFromFileName"/>
                  </url>
                  <xsl:if test="normalize-space(../*:thumbnailUrl) ne ''">
                    <url access="preview" displayLabel="uvaIIIFpreview">
                      <xsl:value-of select="../*:thumbnailUrl"/>
                    </url>
                  </xsl:if>
                  <xsl:if test="normalize-space(../*:imageUrl) ne ''">
                    <url access="raw object" displayLabel="uvaIIIFimage">
                      <xsl:value-of select="../*:imageUrl"/>
                    </url>
                  </xsl:if>
                  <xsl:if test="normalize-space(../*:manifestUrl) ne ''">
                    <url access="raw object" displayLabel="uvaIIIFmanifest">
                      <xsl:value-of select="../*:manifestUrl"/>
                    </url>
                  </xsl:if>
                </location>
              </xsl:for-each>
            </xsl:if>
          </xsl:if>
          <!-- Add rights statement -->
          <xsl:if test="not(*:accessCondition[matches(@type, 'use.*reproduction')])">
            <xsl:variable name="pidMatchExact">
              <xsl:value-of select="concat('^', normalize-space($pidFromFileName), '$')"/>
            </xsl:variable>
            <xsl:for-each
              select="doc('tracksys-mods-extra-metadata.xml')//*:pid[matches(normalize-space(.), $pidMatchExact)]">
              <xsl:if test="normalize-space(../*:rsUrl) ne ''">
                <accessCondition type="use and reproduction">
                  <xsl:value-of select="../*:rsUrl"/>
                </accessCondition>
              </xsl:if>
            </xsl:for-each>
          </xsl:if>
          <!-- Process top-level elements following any identifiers -->
          <xsl:apply-templates
            select="*[not(matches(local-name(), 'identifier'))][preceding-sibling::*:identifier]"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- process children of *:mods -->
          <xsl:apply-templates/>
          <!-- Add URLs at the end of the record -->
          <xsl:if test="not(*:location[*:url])">
            <xsl:variable name="pidMatchExact">
              <xsl:value-of select="concat('^', normalize-space($pidFromFileName), '$')"/>
            </xsl:variable>
            <xsl:if test="doc-available('tracksys-mods-extra-metadata.xml')">
              <!-- Add URLs -->
              <xsl:for-each
                select="doc('tracksys-mods-extra-metadata.xml')//*:pid[matches(normalize-space(.), $pidMatchExact)]">
                <location>
                  <url access="object in context" usage="primary">
                    <xsl:text>https://search.lib.virginia.edu/catalog/</xsl:text>
                    <xsl:value-of select="$pidFromFileName"/>
                  </url>
                  <xsl:if test="normalize-space(../*:thumbnailUrl) ne ''">
                    <url access="preview" displayLabel="preview">
                      <xsl:value-of select="../*:thumbnailUrl"/>
                    </url>
                  </xsl:if>
                  <xsl:if test="normalize-space(../*:imageUrl) ne ''">
                    <url access="raw object" displayLabel="uvaIIIFimage">
                      <xsl:value-of select="../*:imageUrl"/>
                    </url>
                  </xsl:if>
                  <xsl:if test="normalize-space(../*:manifestUrl) ne ''">
                    <url access="raw object" displayLabel="uvaIIIFmanifest">
                      <xsl:value-of select="../*:manifestUrl"/>
                    </url>
                  </xsl:if>
                </location>
              </xsl:for-each>
            </xsl:if>
          </xsl:if>
          <!-- Add rights statement -->
          <xsl:if test="not(*:accessCondition[matches(@type, 'use.*reproduction')])">
            <xsl:variable name="pidMatchExact">
              <xsl:value-of select="concat('^', normalize-space($pidFromFileName), '$')"/>
            </xsl:variable>
            <xsl:for-each
              select="doc('tracksys-mods-extra-metadata.xml')//*:pid[matches(normalize-space(.), $pidMatchExact)]">
              <xsl:if test="normalize-space(../*:rsUrl) ne ''">
                <accessCondition type="use and reproduction">
                  <xsl:value-of select="../*:rsUrl"/>
                </accessCondition>
              </xsl:if>
            </xsl:for-each>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*:mods/*:location">
    <!-- Remove existing URL into Virgo -->
    <xsl:if
      test="not(count(*) = 1 and *:url[matches(@displayLabel, 'VIRGO') or matches(@access, 'object in context')])">
      <xsl:copy>
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <!-- Record running of this stylesheet -->
  <xsl:template match="*:recordOrigin">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="normalize-space(.)"/>
      <xsl:value-of
        select="concat(' URLs added from an external file by ', $progname, ', ', $version, ' ')"/>
      <xsl:value-of select="format-dateTime(current-dateTime(), '[Y]-[M02]-[D02]T[H01]:[m]:[s]')"/>
      <xsl:text>.</xsl:text>
    </xsl:copy>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- DEFAULT TEMPLATE                                                        -->
  <!-- ======================================================================= -->

  <xsl:template match="@* | node()" mode="#all">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
