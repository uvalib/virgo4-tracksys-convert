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
    <xsl:text>mods2modsFixDates.xsl</xsl:text>
  </xsl:variable>

  <!-- program version -->
  <xsl:variable name="version">
    <xsl:text>0.2 beta</xsl:text>
  </xsl:variable>

  <!-- new line -->
  <xsl:variable name="nl">
    <xsl:text>&#xa;</xsl:text>
  </xsl:variable>

  <!-- ======================================================================= -->
  <!-- UTILITIES / NAMED TEMPLATES                                             -->
  <!-- ======================================================================= -->

  <!-- Account for @qualifier -->
  <xsl:template name="processQualifier">
    <xsl:choose>
      <xsl:when test="@qualifier eq 'inferred'">
        <xsl:text>?</xsl:text>
      </xsl:when>
      <xsl:when test="@qualifier eq 'approximate'">
        <xsl:text>~</xsl:text>
      </xsl:when>
      <xsl:when test="@qualifier eq 'questionable'">
        <xsl:text>%</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

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
      <xsl:apply-templates select="@*[not(matches(local-name(), 'schemaLocation'))]"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- Combine start/end dates in a single date element -->
  <xsl:template match="*:originInfo">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <!-- Process non-date elements -->
      <xsl:apply-templates
        select="*[not(matches(local-name(), '(copyrightDate|dateCaptured|dateCreated|dateIssued|dateModified|dateOther|dateValid)'))]"/>
      <!-- Process date elements without @point -->
      <xsl:for-each
        select="*[matches(local-name(), 'copyrightDate|dateCaptured|dateCreated|dateIssued|dateModified|dateOther|dateValid')][not(@point)]">
        <xsl:variable name="elementName" select="local-name()"/>
        <xsl:element name="{$elementName}">
          <xsl:apply-templates select="@*[not(matches(local-name(), '(keyDate|qualifier)'))]"/>
          <xsl:choose>
            <!-- Check to make sure there's at least one digit before adding back @keyDate -->
            <xsl:when test="matches(., '\d') and @keyDate">
              <xsl:attribute name="keyDate">yes</xsl:attribute>
            </xsl:when>
          </xsl:choose>
          <!-- Output this element's value -->
          <xsl:value-of select="replace(normalize-space(.), 'u', 'X')"/>
          <!-- Account for @qualifier -->
          <xsl:call-template name="processQualifier"/>
        </xsl:element>
      </xsl:for-each>
      <!-- Process date elements with @point -->
      <xsl:choose>
        <!-- Same number of start & end dates -->
        <xsl:when
          test="count(*[matches(@point, 'start')]) &gt; 0 and count(*[matches(@point, 'end')]) &gt; 0 and count(*[matches(@point, 'start')]) = count(*[matches(@point, 'end')])">
          <xsl:variable name="pointDates">
            <xsl:copy-of select="*[@point]"/>
          </xsl:variable>
          <xsl:for-each select="$pointDates/*[matches(@point, 'start')]">
            <xsl:variable name="elementName" select="local-name()"/>
            <xsl:element name="{$elementName}">
              <xsl:apply-templates
                select="@*[not(matches(local-name(), 'keyDate|point|qualifier'))]"/>
              <!--<xsl:apply-templates select="@encoding"/>-->
              <xsl:choose>
                <!-- Already has @keyDate -->
                <xsl:when test="matches(., '\d') and @keyDate">
                  <xsl:attribute name="keyDate">yes</xsl:attribute>
                </xsl:when>
                <!-- Following sibling with same element name has @keyDate -->
                <xsl:when
                  test="matches(., '\d') and following-sibling::*[matches(local-name(), $elementName) and matches(@point, 'end')][1]/@keyDate">
                  <xsl:attribute name="keyDate">yes</xsl:attribute>
                </xsl:when>
              </xsl:choose>
              <xsl:value-of select="replace(normalize-space(.), 'u', 'X')"/>
              <!-- Account for @qualifier on start date -->
              <xsl:call-template name="processQualifier"/>
              <!-- Separate the start and end points with a slash -->
              <xsl:text>/</xsl:text>
              <xsl:for-each
                select="following-sibling::*[matches(local-name(), $elementName) and matches(@point, 'end')][1]">
                <xsl:value-of select="replace(normalize-space(.), 'u', 'X')"/>
                <xsl:call-template name="processQualifier"/>
              </xsl:for-each>
            </xsl:element>
          </xsl:for-each>
        </xsl:when>
        <!-- When different numbers of start & end dates, insert a comment and issue a warning message, but leave the dates alone -->
        <xsl:when
          test="count(*[matches(@point, 'start')]) &gt; 0 and count(*[matches(@point, 'end')]) &gt; 0 and count(*[matches(@point, 'start')]) != count(*[matches(@point, 'end')])">
          <xsl:comment>&#32;Unbalanced start/end dates!&#32;</xsl:comment>
          <xsl:apply-templates
            select="*[matches(local-name(), 'copyrightDate|dateCaptured|dateCreated|dateIssued|dateModified|dateOther|dateValid')][@point]"
          />
        </xsl:when>
        <!-- Single dates with @point -->
        <xsl:otherwise>
          <xsl:for-each
            select="*[matches(local-name(), 'copyrightDate|dateCaptured|dateCreated|dateIssued|dateModified|dateOther|dateValid')][@point]">
            <xsl:variable name="elementName" select="local-name()"/>
            <xsl:element name="{$elementName}">
              <xsl:apply-templates select="@point"/>
              <xsl:apply-templates
                select="@*[not(matches(local-name(), '(keyDate|point|qualifier)'))]"/>
              <xsl:choose>
                <!-- Check to make sure there's at least one digit before adding back @keyDate -->
                <xsl:when test="matches(., '\d') and @keyDate">
                  <xsl:attribute name="keyDate">yes</xsl:attribute>
                </xsl:when>
              </xsl:choose>
              <!-- If this element is an end point, precede it with a slash. -->
              <xsl:if test="matches(@point, 'end')">
                <xsl:text>/</xsl:text>
              </xsl:if>
              <!-- Output this element's value -->
              <xsl:value-of select="replace(normalize-space(.), 'u', 'X')"/>
              <!-- Account for @qualifier -->
              <xsl:call-template name="processQualifier"/>
              <!-- If this element is a start point, follow it with a slash. -->
              <xsl:if test="matches(@point, 'start')">
                <xsl:text>/</xsl:text>
              </xsl:if>
            </xsl:element>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <!-- Attempt to correctly set @encoding on recordCreationDate -->
  <xsl:template match="*:recordCreationDate">
    <xsl:copy>
      <xsl:apply-templates select="@*[not(matches(local-name(), 'encoding'))]"/>
      <xsl:variable name="thisContent">
        <xsl:value-of select="normalize-space(.)"/>
      </xsl:variable>
      <xsl:choose>
        <!-- W3C format requires separators -->
        <xsl:when
          test="
            matches($thisContent, '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d+(-\d{2}:00|Z)$') or
            matches($thisContent, '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d+$') or
            matches($thisContent, '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}$') or
            matches($thisContent, '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}$') or
            matches($thisContent, '^\d{4}-\d{2}-\d{2}T\d{2}$') or
            matches($thisContent, '^\d{4}-\d{2}-\d{2}$') or
            matches($thisContent, '^\d{4}-\d{2}$') or
            matches($thisContent, '^\d{4}$')">
          <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
        </xsl:when>
        <!-- ISO format does not require separators -->
        <xsl:when
          test="
            matches($thisContent, '^\d+\.\d+$') or
            matches($thisContent, '^\d{4}-?\d{2}-?\d{2}T\d{2}:?\d{2}:?\d{2}\.\d+(-\d{2}:00|Z)$') or
            matches($thisContent, '^\d{4}-?\d{2}-?\d{2}T\d{2}:?\d{2}:?\d{2}\.\d+$') or
            matches($thisContent, '^\d{4}-?\d{2}-?\d{2}T\d{2}:?\d{2}:?\d{2}$') or
            matches($thisContent, '^\d{4}-?\d{2}-?\d{2}T\d{2}:?\d{2}$') or
            matches($thisContent, '^\d{4}-?\d{2}-?\d{2}T\d{2}$') or
            matches($thisContent, '^\d{4}-?\d{2}-?\d{2}$') or
            matches($thisContent, '^\d{4}-\d{2}$') or
            matches($thisContent, '^\d{4}$')">
          <xsl:attribute name="encoding">iso8601</xsl:attribute>
        </xsl:when>
        <!-- Some other date format -->
        <xsl:otherwise>
          <xsl:apply-templates select="@encoding"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- Record running of this stylesheet -->
  <xsl:template match="*:recordOrigin">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="normalize-space(.)"/>
      <xsl:value-of select="concat(' Dates modified by ', $progname, ', ', $version, ' ')"/>
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
