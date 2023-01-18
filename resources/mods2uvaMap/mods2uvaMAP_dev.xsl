<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="mods xs" version="2.0">

  <xsl:output method="xml" encoding="UTF-8" indent="yes" media-type="text/xml"
    omit-xml-declaration="no" standalone="no"/>
  <xsl:strip-space elements="*"/>

  <xsl:import href="marcCarrierMap.xsl"/>
  <xsl:import href="marcMediaMap.xsl"/>
  <xsl:import href="resourcetypeMap.xsl"/>
  <xsl:import href="marcCountryList.xsl"/>
  <xsl:import href="marcGeoAreasMap.xsl"/>
  <xsl:import href="marcLangList.xsl"/>
  <xsl:import href="marcRelatorCodesTerms.xsl"/>
  <xsl:import href="marcStandardIdentifierSourceList.xsl"/>
  <xsl:import href="marcCompFormMap.xsl"/>

  <!-- ======================================================================= -->
  <!-- PARAMETERS                                                              -->
  <!-- ======================================================================= -->

  <!-- Set to 'true' for items that have been locally digitized  -->
  <xsl:param name="DL_digitized" select="'false'"/>

  <!-- ======================================================================= -->
  <!-- GLOBAL VARIABLES                                                        -->
  <!-- ======================================================================= -->

  <!-- program name -->
  <xsl:variable name="progName">
    <xsl:text>mods2uvaMAP.xsl</xsl:text>
  </xsl:variable>

  <!-- program version -->
  <xsl:variable name="progVersion">
    <xsl:text>2.03</xsl:text>
  </xsl:variable>

  <!-- new line -->
  <xsl:variable name="nl">
    <xsl:text>&#xa;</xsl:text>
  </xsl:variable>

  <xsl:variable name="fileName">
    <xsl:value-of select="tokenize(document-uri(), '/')[last()]"/>
  </xsl:variable>

  <xsl:variable name="pidFromFileName">
    <xsl:value-of select="replace(replace($fileName, '-mods.xml$', ''), '_', ':')"/>
  </xsl:variable>

  <xsl:variable name="extraMetadataFile">
    <xsl:text>tracksys-mods-extra-metadata.xml</xsl:text>
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

  <!-- Determine current place in hierarchy: surrogate, orig, host -->
  <xsl:template name="whereAmI">
    <xsl:choose>
      <!-- Locally digitized -->
      <xsl:when
        test="$DL_digitized = 'true' and not(ancestor-or-self::*/*:physicalDescription/*:form[matches(., 'electronic|online|remote')])">
        <xsl:if test="not(ancestor::*:relatedItem)">
          <xsl:text>orig_</xsl:text>
        </xsl:if>
      </xsl:when>
      <!--  NOT Digitized -->
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="ancestor::*:relatedItem[matches(@type, 'host')]">
            <xsl:text>host_</xsl:text>
          </xsl:when>
          <xsl:when test="ancestor::*:relatedItem[matches(@type, 'original')]">
            <xsl:text>orig_</xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Copy @authority and @displayLabel of top-level elements -->
  <xsl:template name="copyAuthDisplayAttr">
    <xsl:if test="@authority ne ''">
      <xsl:attribute name="authority">
        <xsl:value-of select="normalize-space(@authority)"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@authorityURI ne ''">
      <xsl:attribute name="authorityURI">
        <xsl:value-of select="normalize-space(@authorityURI)"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@valueURI ne ''">
      <xsl:attribute name="valueURI">
        <xsl:value-of select="normalize-space(@valueURI)"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@displayLabel ne ''">
      <xsl:attribute name="displayLabel">
        <xsl:value-of select="@displayLabel"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- Copy @authority and @displayLabel of non-top-level elements -->
  <!-- Use ./@authority or ./@authorityURI or ./@valueURI or ./@displayLabel if available; otherwise,
    use ../@authority or ../@authorityURI or ../@valueURI or ../@displayLabel -->
  <xsl:template name="copyAuthDisplayAttr2">
    <xsl:choose>
      <xsl:when test="@authority ne ''">
        <xsl:attribute name="authority">
          <xsl:value-of select="normalize-space(@authority)"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="../@authority ne ''">
        <xsl:attribute name="authority">
          <xsl:value-of select="normalize-space(../@authority)"/>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="@authorityURI ne ''">
        <xsl:attribute name="authorityURI">
          <xsl:value-of select="normalize-space(@authorityURI)"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="../@authorityURI ne ''">
        <xsl:attribute name="authorityURI">
          <xsl:value-of select="normalize-space(../@authorityURI)"/>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="@valueURI ne ''">
        <xsl:attribute name="valueURI">
          <xsl:value-of select="normalize-space(@valueURI)"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="../@valueURI ne ''">
        <xsl:attribute name="valueURI">
          <xsl:value-of select="normalize-space(../@valueURI)"/>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="@displayLabel">
        <xsl:attribute name="displayLabel">
          <xsl:value-of select="@displayLabel"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="../@displayLabel">
        <xsl:attribute name="displayLabel">
          <xsl:value-of select="../@displayLabel"/>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Copy an element to output only if it doesn't have a preceding sibling with the same value -->
  <xsl:template name="dedupeFields">
    <xsl:variable name="thisValue">
      <xsl:value-of select="replace(lower-case(normalize-space(.)), '\p{P}+$', '')"/>
    </xsl:variable>
    <xsl:if
      test="not(preceding::*[replace(lower-case(normalize-space(.)), '\p{P}+$', '') eq $thisValue])">
      <xsl:copy-of select="."/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="makeDisplayTitle">
    <xsl:for-each select="*:nonSort">
      <xsl:value-of select="concat(normalize-space(.), ' ')"/>
    </xsl:for-each>
    <xsl:for-each select="*:title">
      <xsl:value-of
        select="replace(replace(normalize-space(.), '[.:,;/]+$', ''), '(\.\w)+$', '$1.')"/>
    </xsl:for-each>
    <xsl:for-each
      select="*:subTitle | *:partName | *:partNumber | ../*:note[@type = 'statement of responsibility']">
      <xsl:choose>
        <xsl:when test="matches(local-name(), 'subTitle')">
          <xsl:choose>
            <xsl:when test="not(matches(../*:title, '=$'))">
              <xsl:text>: </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text> </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="matches(local-name(), 'partName|partNumber')">
          <xsl:text>, </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text> / </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of
        select="replace(replace(normalize-space(.), '[.:,;/]+$', ''), '(\.\w)+$', '$1.')"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="makeSortTitle">
    <xsl:for-each select="*:title">
      <xsl:value-of select="replace(normalize-space(.), '[.:,;/]+$', '')"/>
    </xsl:for-each>
    <xsl:for-each select="*:subTitle | *:partName | *:partNumber">
      <xsl:choose>
        <xsl:when test="matches(local-name(), 'subTitle')">
          <xsl:choose>
            <xsl:when test="not(matches(../*:title, '=$'))">
              <xsl:text>: </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text> </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="replace(normalize-space(.), '[.:,;/]+$', '')"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="getSubfield">
    <xsl:param name="stringValue" required="yes"/>
    <xsl:param name="subfield" required="yes"/>
    <xsl:choose>
      <!-- extent has a, b, c subfields -->
      <xsl:when test="matches($stringValue, ':.*;')">
        <xsl:choose>
          <xsl:when test="$subfield eq 'a'">
            <xsl:value-of select="normalize-space(substring-before($stringValue, ':'))"/>
          </xsl:when>
          <xsl:when test="$subfield eq 'b'">
            <xsl:value-of
              select="normalize-space(substring-before(substring-after($stringValue, ':'), ';'))"/>
          </xsl:when>
          <xsl:when test="$subfield eq 'c'">
            <xsl:value-of select="normalize-space(substring-after($stringValue, ';'))"/>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <!-- extent has a and b subfields -->
      <xsl:when test="matches($stringValue, ':')">
        <xsl:choose>
          <xsl:when test="$subfield eq 'a'">
            <xsl:value-of select="normalize-space(substring-before($stringValue, ':'))"/>
          </xsl:when>
          <xsl:when test="$subfield eq 'b'">
            <xsl:value-of select="normalize-space(substring-after($stringValue, ':'))"/>
          </xsl:when>
          <xsl:when test="$subfield eq 'c'"/>
        </xsl:choose>
      </xsl:when>
      <!-- extent has a and c subfields -->
      <xsl:when test="matches($stringValue, ';')">
        <xsl:choose>
          <xsl:when test="$subfield eq 'a'">
            <xsl:value-of select="normalize-space(substring-before($stringValue, ';'))"/>
          </xsl:when>
          <xsl:when test="$subfield eq 'b'"/>
          <xsl:when test="$subfield eq 'c'">
            <xsl:value-of select="normalize-space(substring-after($stringValue, ';'))"/>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <!-- extent has no delimiters -->
      <xsl:otherwise>
        <xsl:if test="$subfield eq 'a'">
          <xsl:value-of select="normalize-space($stringValue)"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- MAIN OUTPUT TEMPLATE                                                    -->
  <!-- ======================================================================= -->

  <xsl:template match="/">
    <!-- @schemaLocation is removed, dates within originInfo, recordCreationDate,
      and recordOrigin are reformatted as EDTF, and accessCondition is normalized. -->
    <xsl:variable name="prepMODS">
      <xsl:apply-templates mode="prepMODS"/>
    </xsl:variable>
    <!--<xsl:copy-of select="$prepMODS"/>-->

    <!-- The actual transformation of MODS to uvaMAP takes place in uvaMAP mode. -->
    <xsl:comment>&#32;Generated by <xsl:value-of select="concat($progName, ', v. ', $progVersion, ' ', format-dateTime(current-dateTime(), '[Y]-[M01]-[D01]T[H01]:[m01]'), ' ')"/></xsl:comment>
    <uvaMAP>
      <xsl:apply-templates select="$prepMODS" mode="uvaMAP"/>
    </uvaMAP>

  </xsl:template>

  <!-- ======================================================================= -->
  <!-- MATCH TEMPLATES FOR ELEMENTS (prepMODS mode)                            -->
  <!-- ======================================================================= -->

  <!-- Remove @xsi:schemaLocation on modsCollection element -->
  <xsl:template match="*:modsCollection" mode="prepMODS">
    <xsl:copy>
      <xsl:apply-templates select="@*[not(matches(local-name(), 'schemaLocation'))]" mode="prepMODS"/>
      <xsl:apply-templates mode="prepMODS"/>
    </xsl:copy>
  </xsl:template>

  <!-- Remove @xsi:schemaLocation on MODS element -->
  <xsl:template match="*:mods" mode="prepMODS">
    <xsl:copy>
      <xsl:apply-templates select="@*[not(matches(local-name(), 'schemaLocation'))]" mode="prepMODS"/>
      <xsl:apply-templates mode="prepMODS"/>
    </xsl:copy>
  </xsl:template>

  <!-- Remove empty elements and attributes that don't have content -->
  <xsl:template match="@*[normalize-space(.) eq ''] | node()[normalize-space(.) eq '']"
    mode="prepMODS"/>

  <!-- Remove redundant attributes -->
  <xsl:template match="@*[matches(name(), 'xmlns:date|xmlns:fn')]" mode="prepMODS"/>

  <!-- Combine start/end dates in a single date element -->
  <xsl:template match="*:originInfo" mode="prepMODS">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="prepMODS"/>
      <!-- Process non-date elements -->
      <xsl:apply-templates
        select="*[not(matches(local-name(), '(copyrightDate|dateCaptured|dateCreated|dateIssued|dateModified|dateOther|dateValid)'))]"
        mode="prepMODS"/>
      <!-- Process date elements without @point -->
      <xsl:for-each
        select="*[matches(local-name(), 'copyrightDate|dateCaptured|dateCreated|dateIssued|dateModified|dateOther|dateValid')][not(@point)]">
        <xsl:variable name="elementName" select="local-name()"/>
        <xsl:element name="{$elementName}" xmlns="http://www.loc.gov/mods/v3">
          <xsl:apply-templates select="@*[not(matches(local-name(), '(keyDate|qualifier)'))]"
            mode="prepMODS"/>
          <!--<xsl:choose>
            <!-\- Check to make sure there's at least one digit before adding back @keyDate -\->
            <xsl:when test="matches(., '\d') and @keyDate">
              <xsl:attribute name="keyDate">yes</xsl:attribute>
            </xsl:when>
          </xsl:choose>-->
          <!-- Output this element's value -->
          <xsl:value-of select="replace(normalize-space(.), 'u[^(ndated)]', 'X')"/>
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
            <xsl:element name="{$elementName}" xmlns="http://www.loc.gov/mods/v3">
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
              <xsl:value-of select="replace(normalize-space(.), 'u[^(ndated)]', 'X')"/>
              <!-- Account for @qualifier on start date -->
              <xsl:call-template name="processQualifier"/>
              <!-- Separate the start and end points with a slash -->
              <xsl:text>/</xsl:text>
              <xsl:for-each
                select="following-sibling::*[matches(local-name(), $elementName) and matches(@point, 'end')][1]">
                <xsl:value-of select="replace(normalize-space(.), 'u[^(ndated)]', 'X')"/>
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
            mode="prepMODS"/>
        </xsl:when>
        <!-- Single dates with @point -->
        <xsl:otherwise>
          <xsl:for-each
            select="*[matches(local-name(), 'copyrightDate|dateCaptured|dateCreated|dateIssued|dateModified|dateOther|dateValid')][@point]">
            <xsl:variable name="elementName" select="local-name()"/>
            <xsl:element name="{$elementName}" xmlns="http://www.loc.gov/mods/v3">
              <xsl:apply-templates select="@point" mode="prepMODS"/>
              <xsl:apply-templates
                select="@*[not(matches(local-name(), '(keyDate|point|qualifier)'))]" mode="prepMODS"/>
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
              <xsl:value-of select="replace(normalize-space(.), 'u[^(ndated)]', 'X')"/>
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
  <xsl:template match="*:recordCreationDate" mode="prepMODS">
    <xsl:copy>
      <xsl:apply-templates select="@*[not(matches(local-name(), 'encoding'))]" mode="prepMODS"/>
      <xsl:variable name="thisContent">
        <xsl:value-of select="normalize-space(.)"/>
      </xsl:variable>
      <xsl:choose>
        <!-- W3C format requires separators -->
        <xsl:when test="
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
        <xsl:when test="
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
          <xsl:apply-templates select="@encoding" mode="prepMODS"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- Record running of this stylesheet -->
  <xsl:template match="*:recordOrigin" mode="prepMODS">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="normalize-space(.)"/>
      <xsl:value-of select="concat(' Dates modified by ', $progName, ', ', $progVersion, ' ')"/>
      <xsl:value-of select="format-dateTime(current-dateTime(), '[Y]-[M02]-[D02]T[H01]:[m]:[s]')"/>
      <xsl:text>.</xsl:text>
    </xsl:copy>
  </xsl:template>

  <!-- restrictions imposed on access to [or use of] a resource -->
  <xsl:template match="*:accessCondition" mode="prepMODS">
    <accessCondition xmlns="http://www.loc.gov/mods/v3">
      <xsl:copy-of select="@type"/>
      <xsl:if test="@displayLabel[not(matches(., 'local|staff', 'i'))]">
        <xsl:attribute name="displayLabel">
          <xsl:value-of select="normalize-space(@displayLabel)"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:variable name="href">
        <xsl:choose>
          <xsl:when
            test="matches(normalize-space(.), 'In Copyright - EU Orphan Work|InC-OW-EU/', 'i')"
            >http://rightsstatements.org/vocab/InC-OW-EU/1.0/</xsl:when>
          <xsl:when
            test="matches(normalize-space(.), 'In Copyright - Educational Use Permitted|InC-EDU/', 'i')"
            >http://rightsstatements.org/vocab/InC-EDU/1.0/</xsl:when>
          <xsl:when
            test="matches(normalize-space(.), 'In Copyright - Non-Commercial Use Permitted|InC-NC/', 'i')"
            >http://rightsstatements.org/vocab/InC-NC/1.0/</xsl:when>
          <xsl:when
            test="matches(normalize-space(.), 'In Copyright - Rights-holder(s) Unlocatable or Unidentifiable|InC-RUU/', 'i')"
            >http://rightsstatements.org/vocab/InC-RUU/1.0/</xsl:when>
          <xsl:when test="matches(normalize-space(.), 'In Copyright|InC/', 'i')"
            >http://rightsstatements.org/vocab/InC/1.0/</xsl:when>
          <xsl:when
            test="matches(normalize-space(.), 'No Copyright - Contractual Restrictions|NoC-CR/', 'i')"
            >http://rightsstatements.org/vocab/NoC-CR/1.0/</xsl:when>
          <xsl:when
            test="matches(normalize-space(.), 'No Copyright - Non-Commercial Use Only|NoC-NC/', 'i')"
            >http://rightsstatements.org/vocab/NoC-NC/1.0/</xsl:when>
          <xsl:when
            test="matches(normalize-space(.), 'No Copyright - Other Known Legal Restrictions|NoC-OKLR/', 'i')"
            >http://rightsstatements.org/vocab/NoC-OKLR/1.0/</xsl:when>
          <xsl:when test="matches(normalize-space(.), 'No Copyright - United States|NoC-US/', 'i')"
            >http://rightsstatements.org/vocab/NoC-US/1.0/</xsl:when>
          <xsl:when test="matches(normalize-space(.), 'Copyright Not Evaluated|CNE/', 'i')"
            >http://rightsstatements.org/vocab/CNE/1.0/</xsl:when>
          <xsl:when test="matches(normalize-space(.), 'Copyright Undetermined|UND/', 'i')"
            >http://rightsstatements.org/vocab/UND/1.0/</xsl:when>
          <xsl:when test="matches(normalize-space(.), 'No Known Copyright|NKC/', 'i')"
            >http://rightsstatements.org/vocab/NKC/1.0/</xsl:when>
          <xsl:when test="matches(normalize-space(.), 'CC BY-NC-ND', 'i')"
            >https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode0</xsl:when>
          <xsl:when test="matches(normalize-space(.), 'Attribution-NonCommercial-NoDerivs', 'i')"
            >https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode</xsl:when>
          <xsl:when test="matches(normalize-space(.), 'CC BY-NC-SA', 'i')"
            >https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode</xsl:when>
          <xsl:when test="matches(normalize-space(.), 'Attribution-NonCommercial-ShareAlike', 'i')"
            >https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode</xsl:when>
          <xsl:when test="matches(normalize-space(.), 'CC BY-NC', 'i')"
            >https://creativecommons.org/licenses/by-nc/4.0/legalcode</xsl:when>
          <xsl:when test="matches(normalize-space(.), 'Attribution-NonCommercial', 'i')"
            >https://creativecommons.org/licenses/by-nc/4.0/legalcode</xsl:when>
          <xsl:when test="matches(normalize-space(.), 'CC BY-ND', 'i')"
            >https://creativecommons.org/licenses/by-nd/4.0/legalcode</xsl:when>
          <xsl:when test="matches(normalize-space(.), 'Attribution', 'i')"
            >https://creativecommons.org/licenses/by-nd/4.0/legalcode</xsl:when>
          <xsl:when test="matches(normalize-space(.), '^http[^\s]+$')">
            <xsl:value-of select="normalize-space(.)"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="normalize-space($href) ne ''">
        <xsl:attribute name="xlink:href">
          <xsl:value-of select="$href"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="matches($href, 'http://rightsstatements.org/vocab/InC/1.0/')">In
          Copyright</xsl:when>
        <xsl:when test="matches($href, 'http://rightsstatements.org/vocab/InC-OW-EU/1.0/')">In
          Copyright - EU Orphan Work</xsl:when>
        <xsl:when test="matches($href, 'http://rightsstatements.org/vocab/InC-EDU/1.0/')">In
          Copyright - Educational Use Permitted</xsl:when>
        <xsl:when test="matches($href, 'http://rightsstatements.org/vocab/InC-NC/1.0/')">In
          Copyright - Non-Commercial Use Permitted</xsl:when>
        <xsl:when test="matches($href, 'http://rightsstatements.org/vocab/InC-RUU/1.0/')">In
          Copyright - Rights-holder(s) Unlocatable or Unidentifiable</xsl:when>
        <xsl:when test="matches($href, 'http://rightsstatements.org/vocab/NoC-CR/1.0/')">No
          Copyright - Contractual Restrictions</xsl:when>
        <xsl:when test="matches($href, 'http://rightsstatements.org/vocab/NoC-NC/1.0/')">No
          Copyright - Non-Commercial Use Only</xsl:when>
        <xsl:when test="matches($href, 'http://rightsstatements.org/vocab/NoC-OKLR/1.0/')">No
          Copyright - Other Known Legal Restrictions</xsl:when>
        <xsl:when test="matches($href, 'http://rightsstatements.org/vocab/NoC-US/1.0/')">No
          Copyright - United States</xsl:when>
        <xsl:when test="matches($href, 'http://rightsstatements.org/vocab/CNE/1.0/')">Copyright Not
          Evaluated</xsl:when>
        <xsl:when test="matches($href, 'http://rightsstatements.org/vocab/UND/1.0/')">Copyright
          Undetermined</xsl:when>
        <xsl:when test="matches($href, 'http://rightsstatements.org/vocab/NKC/1.0/')">No Known
          Copyright</xsl:when>
        <xsl:when test="matches($href, 'https://creativecommons.org/licenses/by-nd/4.0/legalcode')"
          >Attribution</xsl:when>
        <xsl:when test="matches($href, 'https://creativecommons.org/licenses/by-nd/4.0/legalcode')"
          >CC BY-ND</xsl:when>
        <xsl:when test="matches($href, 'https://creativecommons.org/licenses/by-nc/4.0/legalcode')"
          >Attribution-NonCommercial</xsl:when>
        <xsl:when test="matches($href, 'https://creativecommons.org/licenses/by-nc/4.0/legalcode')"
          >CC BY-NC</xsl:when>
        <xsl:when
          test="matches($href, 'https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode')"
          >Attribution-NonCommercial-ShareAlike</xsl:when>
        <xsl:when
          test="matches($href, 'https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode')">CC
          BY-NC-SA</xsl:when>
        <xsl:when
          test="matches($href, 'https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode')"
          >Attribution-NonCommercial-NoDerivs</xsl:when>
        <xsl:when
          test="matches($href, 'https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode')">CC
          BY-NC-ND</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:otherwise>
      </xsl:choose>
    </accessCondition>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- MATCH TEMPLATES FOR ELEMENTS (uvaMAP mode)                                    -->
  <!-- ======================================================================= -->

  <xsl:template match="*:mods" mode="uvaMAP">
    <doc>
      <!-- Hold first pass for later processing -->
      <xsl:variable name="pass1">
        <!-- Original Metadata Type -->
        <field name="originalMetadataType">MODS</field>

        <!-- Original source record number -->
        <xsl:choose>
          <xsl:when test="@ID">
            <field name="sourceRecordIdentifier">
              <xsl:value-of select="@ID"/>
            </field>
          </xsl:when>
          <xsl:when test="*:recordInfo/*:recordIdentifier">
            <field name="sourceRecordIdentifier">
              <xsl:copy-of select="*:recordInfo/*:recordIdentifier/@source"/>
              <xsl:value-of select="*:recordInfo/*:recordIdentifier"/>
            </field>
          </xsl:when>
        </xsl:choose>

        <!-- Work Title -->
        <xsl:for-each select="*:titleInfo[matches(@type, 'uniform')][1]">
          <xsl:choose>
            <xsl:when test="@nameTitleGroup">
              <field name="work_title">
                <xsl:variable name="thisNameTitleGroup">
                  <xsl:value-of select="@nameTitleGroup"/>
                </xsl:variable>
                <xsl:variable name="name">
                  <xsl:for-each select="//*:name[@nameTitleGroup eq $thisNameTitleGroup]">
                    <xsl:for-each select="*:namePart">
                      <xsl:value-of select="normalize-space(.)"/>
                      <xsl:if test="not(position() = last())">
                        <xsl:choose>
                          <xsl:when test="not(matches(normalize-space(.), '[.:,;/]+$'))">
                            <xsl:text>, </xsl:text>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:text> </xsl:text>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:for-each>
                </xsl:variable>
                <xsl:value-of select="concat(replace(normalize-space($name), '\.$', ''), '. ')"/>
                <xsl:value-of
                  select="normalize-space(string-join(*[not(matches(local-name(), 'nonSort'))], '. '))"
                />
              </field>
            </xsl:when>
            <xsl:otherwise>
              <field name="work_title">
                <xsl:value-of
                  select="normalize-space(string-join(*[not(matches(local-name(), 'nonSort'))], '. '))"
                />
              </field>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>

        <!-- Key Date -->
        <!-- Dates should already be in EDTF! -->
        <xsl:variable name="keyDate1">
          <xsl:choose>
            <xsl:when test="descendant::*[matches(@keyDate, 'yes')]">
              <xsl:value-of select="descendant::*[matches(@keyDate, 'yes')][1]"/>
            </xsl:when>
            <xsl:when test="descendant::*:relatedItem[@type eq 'host']/*:originInfo/*:dateIssued">
              <xsl:value-of
                select="descendant::*:relatedItem[@type eq 'host']/*:originInfo/*:dateIssued[1]"/>
            </xsl:when>
            <xsl:when test="descendant::*:relatedItem[@type eq 'host']/*:originInfo/*:dateCreated">
              <xsl:value-of
                select="descendant::*:relatedItem[@type eq 'host']/*:originInfo/*:dateCreated[1]"/>
            </xsl:when>
            <xsl:when test="descendant::*:relatedItem[@type eq 'host']/*:originInfo/*:copyrightDate">
              <xsl:value-of
                select="descendant::*:relatedItem[@type eq 'host']/*:originInfo/*:copyrightDate[1]"
              />
            </xsl:when>
            <xsl:when test="descendant::*:relatedItem[@type eq 'host']/*:originInfo/*:dateValid">
              <xsl:value-of
                select="descendant::*:relatedItem[@type eq 'host']/*:originInfo/*:dateValid[1]"/>
            </xsl:when>
            <xsl:when test="descendant::*:relatedItem[@type eq 'host']/*:originInfo/*:dateCaptured">
              <xsl:value-of
                select="descendant::*:relatedItem[@type eq 'host']/*:originInfo/*:dateCaptured[1]"/>
            </xsl:when>
            <xsl:when test="descendant::*:relatedItem[@type eq 'host']/*:originInfo/*:dateModified">
              <xsl:value-of
                select="descendant::*:relatedItem[@type eq 'host']/*:originInfo/*:dateModified[1]"/>
            </xsl:when>
            <xsl:when test="descendant::*:relatedItem[@type eq 'host']/*:originInfo/*:dateOther">
              <xsl:value-of
                select="descendant::*:relatedItem[@type eq 'host']/*:originInfo/*:dateOther[1]"/>
            </xsl:when>
            <xsl:when test="descendant::*[matches(local-name(), 'dateIssued')]">
              <xsl:value-of select="descendant::*[matches(local-name(), 'dateIssued')][1]"/>
            </xsl:when>
            <xsl:when test="descendant::*[matches(local-name(), 'dateCreated')]">
              <xsl:value-of select="descendant::*[matches(local-name(), 'dateCreated')][1]"/>
            </xsl:when>
            <xsl:when test="descendant::*[matches(local-name(), 'copyrightDate')]">
              <xsl:value-of select="descendant::*[matches(local-name(), 'copyrightDate')][1]"/>
            </xsl:when>
            <xsl:when test="descendant::*[matches(local-name(), 'dateValid')]">
              <xsl:value-of select="descendant::*[matches(local-name(), 'dateValid')][1]"/>
            </xsl:when>
            <xsl:when test="descendant::*[matches(local-name(), 'dateCaptured')]">
              <xsl:value-of select="descendant::*[matches(local-name(), 'dateCaptured')][1]"/>
            </xsl:when>
            <xsl:when test="descendant::*[matches(local-name(), 'dateModified')]">
              <xsl:value-of select="descendant::*[matches(local-name(), 'dateModified')][1]"/>
            </xsl:when>
            <xsl:when test="descendant::*[matches(local-name(), 'dateOther')]">
              <xsl:value-of select="descendant::*[matches(local-name(), 'dateOther')][1]"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="keyDate2">
          <xsl:choose>
            <!-- Date range with qualifiers -->
            <xsl:when test="matches($keyDate1, '/') and matches($keyDate1, '[\?~%]')">
              <xsl:value-of select="concat('[', replace($keyDate1, '/', ' TO '), ']')"/>
            </xsl:when>
            <!-- Date range with unspecified digits -->
            <xsl:when test="matches($keyDate1, '/') and matches($keyDate1, '\dX')">
              <xsl:variable name="startDate">
                <xsl:value-of select="replace(substring-before($keyDate1, '/'), 'X', '0')"/>
              </xsl:variable>
              <xsl:variable name="endDate">
                <xsl:choose>
                  <!-- And an unspecified end -->
                  <xsl:when test="matches($keyDate1, '(/$|/\.\.$|/XXXX$)')">
                    <xsl:value-of select="'*'"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of
                      select="replace(replace(substring-after($keyDate1, '/'), 'X', '9'), '^9999$', '*')"
                    />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:value-of select="concat('[', $startDate, ' TO ', $endDate, ']')"/>
            </xsl:when>
            <!-- Date range with unknown or unspecified end -->
            <xsl:when test="matches($keyDate1, '(^/|^\.\./|^XXXX/)')">
              <xsl:value-of
                select="concat('[* TO ', replace(substring-after($keyDate1, '/'), '^9999$', '*'), ']')"
              />
            </xsl:when>
            <!-- Date range with unknown or unspecified start -->
            <xsl:when test="matches($keyDate1, '(/$|/\.\.$|/XXXX$)')">
              <xsl:value-of select="concat('[', substring-before($keyDate1, '/'), ' TO *]')"/>
            </xsl:when>
            <!-- Enumerated data range -->
            <xsl:when test="matches($keyDate1, '^[\d]+/[\d]+')">
              <xsl:value-of
                select="concat('[', substring-before($keyDate1, '/'), ' TO ', replace(substring-after($keyDate1, '/'), '^9999$', '*'), ']')"
              />
            </xsl:when>
            <!-- Single date with unspecified digits from the right -->
            <xsl:when test="matches($keyDate1, '^-?\d+X{1,3}$')">
              <xsl:value-of
                select="concat('[', replace($keyDate1, 'X', '0'), ' TO ', replace($keyDate1, 'X', '9'), ']')"
              />
            </xsl:when>
            <!-- Single year with sub-year indication -->
            <xsl:when test="matches($keyDate1, '^-?\d+-(2[1-9]|3[0-9]|4[01])$')">
              <xsl:value-of select="substring-before($keyDate1, '-')"/>
            </xsl:when>
            <!-- Single ISO/EDTF date, incl. optional qualifier  -->
            <xsl:when test="matches($keyDate1, '^-?\d+(-\d{2}(-\d{2})?)?[\?~%]?$')">
              <xsl:value-of select="normalize-space($keyDate1)"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="keyDate3">
          <xsl:value-of select="replace($keyDate2, '[\?~%]', '')"/>
        </xsl:variable>
        <!-- Reject date/date range that isn't EDTF/ISO-like -->
        <xsl:choose>
          <xsl:when test="
              matches($keyDate3, '^\[?-?\d+(-\d{2}(-\d{2})?)?( TO -?\d+(-\d{2}(-\d{2})?)?\])?$') or
              matches($keyDate3, '^\[?-?\d+(-\d{2}(-\d{2})?)?( TO \*?\])?$') or matches($keyDate3, '^\*( TO -?\d+(-\d{2}(-\d{2})?)?\])?$')">
            <field name="keyDate">
              <xsl:value-of select="$keyDate3"/>
            </field>
          </xsl:when>
          <xsl:otherwise>
            <xsl:comment>&#32;<xsl:value-of select="$keyDate3"/>&#32;</xsl:comment>
            <xsl:comment>&#32;No EDTF-compliant keyDate found&#32;</xsl:comment>
          </xsl:otherwise>
        </xsl:choose>

        <!-- Resource Type -->
        <xsl:apply-templates select="*:typeOfResource" mode="uvaMAP"/>

        <!-- Physical Description  -->
        <xsl:apply-templates select="*:physicalDescription" mode="uvaMAP"/>

        <!-- Display Title -->
        <xsl:if
          test="*:titleInfo[matches(@usage, 'primary') or not(matches(@type, 'abbreviated|alternative|translated|uniform'))][not(normalize-space(.) eq '')]">
          <field name="displayTitle">
            <xsl:variable name="displayTitle">
              <xsl:for-each
                select="*:titleInfo[matches(@usage, 'primary') or not(matches(@type, 'abbreviated|alternative|translated|uniform'))][not(normalize-space(.) eq '')][1]">
                <xsl:call-template name="makeDisplayTitle"/>
              </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="normalize-space(replace($displayTitle, '([.:,;/])\.', '$1'))"/>
          </field>
        </xsl:if>

        <!-- Sort Title = w/o leading article -->
        <!-- Capitalize first word -->
        <xsl:if
          test="*:titleInfo[matches(@usage, 'primary') or not(matches(@type, 'abbreviated|alternative|translated|uniform'))][not(normalize-space(.) eq '')]">
          <field name="sortTitle">
            <xsl:variable name="sortTitle">
              <xsl:for-each
                select="*:titleInfo[matches(@usage, 'primary') or not(matches(@type, 'abbreviated|alternative|translated|uniform'))][not(normalize-space(.) eq '')][1]">
                <xsl:call-template name="makeSortTitle"/>
              </xsl:for-each>
            </xsl:variable>
            <xsl:value-of
              select="lower-case(normalize-space(replace($sortTitle, '([.:,;/])\.', '$1')))"/>
          </field>
        </xsl:if>

        <!-- Title = title proper -->
        <!-- Capitalize first word -->
        <xsl:if
          test="*:titleInfo[matches(@usage, 'primary') or not(matches(@type, 'abbreviated|alternative|translated|uniform'))]/*:title[not(normalize-space(.) eq '')]">
          <field name="title">
            <xsl:variable name="title">
              <xsl:value-of
                select="replace(normalize-space(*:titleInfo[matches(@usage, 'primary') or not(matches(@type, 'abbreviated|alternative|translated|uniform'))][*:title[not(normalize-space(.) eq '')]]/*:title[not(normalize-space(.) eq '')]), '[\.:,;/]+$', '')"
              />
            </xsl:variable>
            <xsl:value-of select="upper-case(substring($title, 1, 1))"/>
            <xsl:value-of select="substring($title, 2)"/>
          </field>
        </xsl:if>

        <!-- Subtitle -->
        <!-- Capitalize first word -->
        <xsl:for-each
          select="*:titleInfo[matches(@usage, 'primary') or not(matches(@type, 'abbreviated|alternative|translated|uniform'))][1]/*:subTitle">
          <field name="subtitle">
            <xsl:value-of
              select="concat(upper-case(substring(normalize-space(.), 1, 1)), substring(normalize-space(.), 2))"
            />
          </field>
        </xsl:for-each>

        <!-- Abbreviated Title -->
        <xsl:for-each select="*:titleInfo[matches(@type, 'abbreviated')]">
          <field name="abbreviatedTitle">
            <xsl:call-template name="makeSortTitle"/>
          </field>
        </xsl:for-each>

        <!-- Translated Title -->
        <xsl:for-each select="*:titleInfo[matches(@type, 'translated')]">
          <field name="translatedTitle">
            <xsl:call-template name="makeSortTitle"/>
          </field>
        </xsl:for-each>

        <!-- Alternative Title -->
        <xsl:for-each select="*:titleInfo[matches(@type, 'alternative')]">
          <field name="alternativeTitle">
            <xsl:call-template name="makeSortTitle"/>
          </field>
        </xsl:for-each>
        <xsl:for-each
          select="*:titleInfo[not(matches(@type, 'abbreviated|alternative|translated|uniform'))][position() &gt; 1]">
          <field name="alternativeTitle">
            <xsl:call-template name="makeSortTitle"/>
          </field>
        </xsl:for-each>

        <!-- Transliterated Title -->
        <xsl:for-each select="*:titleInfo[@transliteration]">
          <field name="transliteratedTitle">
            <xsl:call-template name="makeSortTitle"/>
          </field>
        </xsl:for-each>

        <!-- Names & Identifiers -->
        <xsl:apply-templates select="*:name | *:identifier" mode="uvaMAP"/>

        <!-- Add metadata PID if it's not already present -->
        <xsl:if
          test="not(*:identifier[matches(@displayLabel, 'metadata pid|record displayed in virgo', 'i')]) and matches($pidFromFileName, '^.+:\d+$')">
          <field name="identifier" type="Metadata PID">
            <xsl:value-of select="$pidFromFileName"/>
          </field>
        </xsl:if>

        <!-- OCLC Number -->
        <xsl:for-each select="*:recordInfo/*:recordIdentifier[matches(@source, 'oco?lc', 'i')]">
          <field name="oclcNumber">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:for-each>

        <!-- Genre -->
        <!-- De-dupe values of genre and typeOfResource elements that are not MODS 3.6 compliant -->
        <xsl:variable name="genres">
          <xsl:apply-templates
            select="*:genre[not(matches(normalize-space(.), '^(text|cartographic|notated music|sound recording|sound recording-musical|sound recording-nonmusical|still image|moving image|three dimensional object|software, multimedia|mixed material)$'))]"
            mode="uvaMAP"/>
          <xsl:for-each
            select="*:typeOfResource[not(matches(normalize-space(.), '^(text|cartographic|notated music|sound recording|sound recording-musical|sound recording-nonmusical|still image|moving image|three dimensional object|software, multimedia|mixed material)$'))]">
            <field name="genre">
              <xsl:call-template name="copyAuthDisplayAttr"/>
              <xsl:value-of select="normalize-space(.)"/>
            </field>
          </xsl:for-each>
          <!-- Add genre term based on note type -->
          <xsl:for-each select="*:note[@type = 'thesis']">
            <field name="genre">Academic theses</field>
          </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="$genres/*:field">
          <xsl:variable name="thisValue">
            <xsl:value-of select="normalize-space(.)"/>
          </xsl:variable>
          <xsl:if test="not(preceding-sibling::*:field[. = $thisValue])">
            <xsl:copy-of select="."/>
          </xsl:if>
        </xsl:for-each>

        <!-- OriginInfo -->
        <xsl:apply-templates select="*:originInfo" mode="uvaMAP"/>

        <!-- Table of contents -->
        <xsl:apply-templates select="*:tableOfContents" mode="uvaMAP"/>

        <!-- Contents based on constituents -->
        <xsl:if test="*:relatedItem[matches(@type, 'constituent')]">
          <xsl:for-each select="*:relatedItem[matches(@type, 'constituent') and *:titleInfo]">
            <field name="work_relatedWork">
              <xsl:attribute name="displayLabel">
                <xsl:choose>
                  <xsl:when test="@otherType">
                    <xsl:value-of select="@otherType"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>Also contains</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:for-each select="*:name/*[normalize-space(.) ne '']">
                <xsl:value-of select="replace(normalize-space(.), '[:,;/]+$', '')"/>
                <xsl:choose>
                  <xsl:when test="position() ne last()">
                    <xsl:text>, </xsl:text>
                  </xsl:when>
                  <xsl:otherwise>. </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
              <xsl:variable name="displayTitle">
                <xsl:for-each
                  select="*:titleInfo[matches(@usage, 'primary') or not(matches(@type, 'abbreviated|alternative|translated|uniform'))][1]">
                  <xsl:call-template name="makeDisplayTitle"/>
                </xsl:for-each>
              </xsl:variable>
              <xsl:value-of select="normalize-space(replace($displayTitle, '([.:,;/])\.', '$1'))"/>
            </field>
          </xsl:for-each>
        </xsl:if>

        <!-- Abstract/Summary, AccessCondition, etc. -->
        <xsl:apply-templates select="
            *:abstract | *:accessCondition | *:classification |
            *:language | *:relatedItem[matches(@type, 'otherFormat')] | *:subject/*:cartographics |
            *:targetAudience" mode="uvaMAP"/>
        <!-- Sort location on shelfLocator -->
        <xsl:apply-templates select="*:location" mode="uvaMAP">
          <xsl:sort select="descendant::*:shelfLocator"/>
        </xsl:apply-templates>

        <!-- Notes -->
        <xsl:apply-templates
          select="*:note[not(matches(@type, '59[1-9]')) and normalize-space(.) ne '']" mode="uvaMAP"/>

        <!-- Add rights statement and URIs from external file -->
        <xsl:variable name="pidMatchExact">
          <xsl:value-of select="concat('^', normalize-space($pidFromFileName), '$')"/>
        </xsl:variable>
        <xsl:variable name="accessConditionPresent">
          <xsl:choose>
            <xsl:when test="*:accessCondition">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:if test="doc-available($extraMetadataFile)">
          <xsl:for-each
            select="doc($extraMetadataFile)//*:pid[matches(normalize-space(.), $pidMatchExact)]">
            <!-- If accessCondition isn't already available, use the rights URL from $extradMetadataFile -->
            <xsl:if test="$accessConditionPresent = 'false' and normalize-space(../*:rsUrl) ne ''">
              <field name="useRestrict">
                <xsl:attribute name="valueURI">
                  <xsl:value-of select="../*:rsUrl"/>
                </xsl:attribute>
                <!-- Map rsUrl to a human-readable value -->
                <xsl:choose>
                  <xsl:when test="matches(../*:rsUrl, 'http://rightsstatements.org/vocab/InC/1.0/')"
                    >In Copyright</xsl:when>
                  <xsl:when
                    test="matches(../*:rsUrl, 'http://rightsstatements.org/vocab/InC-OW-EU/1.0/')"
                    >In Copyright - EU Orphan Work</xsl:when>
                  <xsl:when
                    test="matches(../*:rsUrl, 'http://rightsstatements.org/vocab/InC-EDU/1.0/')">In
                    Copyright - Educational Use Permitted</xsl:when>
                  <xsl:when
                    test="matches(../*:rsUrl, 'http://rightsstatements.org/vocab/InC-NC/1.0/')">In
                    Copyright - Non-Commercial Use Permitted</xsl:when>
                  <xsl:when
                    test="matches(../*:rsUrl, 'http://rightsstatements.org/vocab/InC-RUU/1.0/')">In
                    Copyright - Rights-holder(s) Unlocatable or Unidentifiable</xsl:when>
                  <xsl:when
                    test="matches(../*:rsUrl, 'http://rightsstatements.org/vocab/NoC-CR/1.0/')">No
                    Copyright - Contractual Restrictions</xsl:when>
                  <xsl:when
                    test="matches(../*:rsUrl, 'http://rightsstatements.org/vocab/NoC-NC/1.0/')">No
                    Copyright - Non-Commercial Use Only</xsl:when>
                  <xsl:when
                    test="matches(../*:rsUrl, 'http://rightsstatements.org/vocab/NoC-OKLR/1.0/')">No
                    Copyright - Other Known Legal Restrictions</xsl:when>
                  <xsl:when
                    test="matches(../*:rsUrl, 'http://rightsstatements.org/vocab/NoC-US/1.0/')">No
                    Copyright - United States</xsl:when>
                  <xsl:when test="matches(../*:rsUrl, 'http://rightsstatements.org/vocab/CNE/1.0/')"
                    >Copyright Not Evaluated</xsl:when>
                  <xsl:when test="matches(../*:rsUrl, 'http://rightsstatements.org/vocab/UND/1.0/')"
                    >Copyright Undetermined</xsl:when>
                  <xsl:when test="matches(../*:rsUrl, 'http://rightsstatements.org/vocab/NKC/1.0/')"
                    >No Known Copyright</xsl:when>
                  <xsl:when
                    test="matches(../*:rsUrl, 'https://creativecommons.org/licenses/by-nd/4.0/legalcode')"
                    >Attribution</xsl:when>
                  <xsl:when
                    test="matches(../*:rsUrl, 'https://creativecommons.org/licenses/by-nd/4.0/legalcode')"
                    >CC BY-ND</xsl:when>
                  <xsl:when
                    test="matches(../*:rsUrl, 'https://creativecommons.org/licenses/by-nc/4.0/legalcode')"
                    >Attribution-NonCommercial</xsl:when>
                  <xsl:when
                    test="matches(../*:rsUrl, 'https://creativecommons.org/licenses/by-nc/4.0/legalcode')"
                    >CC BY-NC</xsl:when>
                  <xsl:when
                    test="matches(../*:rsUrl, 'https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode')"
                    >Attribution-NonCommercial-ShareAlike</xsl:when>
                  <xsl:when
                    test="matches(../*:rsUrl, 'https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode')"
                    >CC BY-NC-SA</xsl:when>
                  <xsl:when
                    test="matches(../*:rsUrl, 'https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode')"
                    >Attribution-NonCommercial-NoDerivs</xsl:when>
                  <xsl:when
                    test="matches(../*:rsUrl, 'https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode')"
                    >CC BY-NC-ND</xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="../*:rsUrl"/>
                  </xsl:otherwise>
                </xsl:choose>
              </field>
            </xsl:if>
            <xsl:if test="normalize-space(../*:imageUrl) ne ''">
              <field name="uri" displayLabel="uvaIIIFimage">
                <xsl:value-of select="../*:imageUrl"/>
              </field>
            </xsl:if>
            <xsl:if test="normalize-space(../*:thumbnailUrl) ne ''">
              <field name="uri" access="preview" displayLabel="uvaIIIFthumbnail">
                <xsl:value-of select="../*:thumbnailUrl"/>
              </field>
            </xsl:if>
            <xsl:if test="normalize-space(../*:manifestUrl) ne ''">
              <field name="uri" displayLabel="uvaIIIFmanifest">
                <xsl:value-of select="../*:manifestUrl"/>
              </field>
              <field name="uri" access="object in context" displayLabel="online">
                <xsl:value-of
                  select="concat('https://search.lib.virginia.edu/catalog/', replace(../*:manifestUrl, '^.*/', ''))"
                />
              </field>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>

        <!-- Subject -->
        <xsl:for-each select="descendant::*:subject">
          <xsl:variable name="thisValue">
            <xsl:value-of select="normalize-space(.)"/>
          </xsl:variable>
          <!-- Exclude subjects that only contain a geographic code or hierarchical geographic expression or cartographic info; they're dealt with elsewhere. -->
          <!-- De-dupe subject values -->
          <xsl:if
            test="count(*[not(matches(local-name(), 'cartographics|geographicCode|hierarchicalGeographic'))]) &gt; 0 and not(preceding::*:subject[. eq $thisValue])">
            <field name="subject">
              <xsl:call-template name="copyAuthDisplayAttr"/>
              <xsl:if test="not(@valueURI) and count(*) = 1">
                <xsl:copy-of select="*/@valueURI"/>
              </xsl:if>
              <xsl:variable name="subjectParts">
                <xsl:for-each select="*">
                  <subjectPart>
                    <xsl:choose>
                      <xsl:when test="*">
                        <!-- Exclude geographicCode -->
                        <xsl:for-each
                          select="*[not(matches(local-name(), 'cartographics|geographicCode|hierarchicalGeographic'))]">
                          <xsl:value-of select="normalize-space(.)"/>
                          <xsl:choose>
                            <xsl:when
                              test="not(matches(normalize-space(.), '[\.,;:/-]$')) and not(position() = last())">
                              <xsl:text>, </xsl:text>
                            </xsl:when>
                            <xsl:when test="not(position() = last())">
                              <xsl:text> </xsl:text>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>
                        <!--<xsl:value-of
                          select="string-join(*[not(matches(local-name(), 'cartographics|geographicCode|hierarchicalGeographic'))], ', ')"
                        />-->
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="normalize-space(.)"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </subjectPart>
                </xsl:for-each>
              </xsl:variable>
              <xsl:value-of select="string-join($subjectParts/*, '--')"/>
            </field>
          </xsl:if>
          <!-- hierarchicalGeographic as subject heading -->
          <xsl:for-each select="*:hierarchicalGeographic">
            <field name="subject">
              <xsl:choose>
                <xsl:when test="normalize-space(@valueURI) != ''">
                  <xsl:copy-of select="@valueURI"/>
                </xsl:when>
                <xsl:when test="normalize-space(*[position() = last()]/@valueURI) != ''">
                  <xsl:copy-of select="*[position() = last()]/@valueURI"/>
                </xsl:when>
              </xsl:choose>
              <xsl:call-template name="copyAuthDisplayAttr2"/>
              <xsl:value-of select="string-join(*, '--')"/>
            </field>
          </xsl:for-each>
        </xsl:for-each>
        <!-- Subject Parts/Facets -->
        <!-- Genre as subject -->
        <xsl:variable name="subjectGenres">
          <xsl:for-each select="descendant::*:subject/*:genre">
            <xsl:sort/>
            <field name="subjectGenre">
              <xsl:call-template name="copyAuthDisplayAttr2"/>
              <xsl:value-of select="normalize-space(.)"/>
            </field>
          </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="$subjectGenres/*:field">
          <xsl:call-template name="dedupeFields"/>
        </xsl:for-each>
        <!--  Geographics/Geographic code as dedicated geographic subject heading -->
        <xsl:variable name="subjectGeographics">
          <xsl:for-each select="descendant::*[matches(local-name(), 'geographic|geographicCode')]">
            <xsl:sort/>
            <xsl:variable name="thisValue">
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:variable>
            <!-- Prepare geographic code for translation -->
            <xsl:variable name="thisValueUnpadded">
              <xsl:value-of select="replace($thisValue, '-+$', '')"/>
            </xsl:variable>
            <!-- Translate geographic code into human-readable string -->
            <xsl:for-each select="$geographicAreas//*:geoArea[@code = $thisValueUnpadded]">
              <field name="subjectGeographic">
                <xsl:call-template name="copyAuthDisplayAttr2"/>
                <xsl:value-of select="normalize-space(.)"/>
              </field>
            </xsl:for-each>
            <field name="subjectGeographic">
              <xsl:call-template name="copyAuthDisplayAttr2"/>
              <xsl:value-of select="$thisValue"/>
            </field>
          </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="$subjectGeographics/*:field">
          <xsl:call-template name="dedupeFields"/>
        </xsl:for-each>
        <!-- Occupation as subject -->
        <xsl:variable name="subjectOccupations">
          <xsl:for-each select="descendant::*:subject/*:occupation">
            <xsl:sort/>
            <field name="subjectOccupation">
              <xsl:call-template name="copyAuthDisplayAttr2"/>
              <xsl:value-of select="normalize-space(.)"/>
            </field>
          </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="$subjectOccupations/*:field">
          <xsl:call-template name="dedupeFields"/>
        </xsl:for-each>
        <!-- Temporal division as subject -->
        <xsl:variable name="subjectTemporals">
          <xsl:for-each select="descendant::*:subject/*:temporal">
            <xsl:sort/>
            <field name="subjectTemporal">
              <xsl:call-template name="copyAuthDisplayAttr2"/>
              <xsl:value-of select="normalize-space(.)"/>
            </field>
          </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="$subjectTemporals/*:field">
          <xsl:call-template name="dedupeFields"/>
        </xsl:for-each>
        <!-- Topic as subject -->
        <xsl:variable name="subjectTopics">
          <xsl:for-each select="descendant::*:subject/*:topic">
            <xsl:sort/>
            <field name="subjectTopic">
              <xsl:call-template name="copyAuthDisplayAttr2"/>
              <xsl:value-of select="normalize-space(.)"/>
            </field>
          </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="$subjectTopics/*:field">
          <xsl:call-template name="dedupeFields"/>
        </xsl:for-each>
        <!-- Hierarchical geographic subject -->
        <xsl:variable name="subjectHierarchicals">
          <xsl:for-each select="descendant::*:subject/*:hierarchicalGeographic">
            <xsl:sort/>
            <field name="subjectGeographic">
              <xsl:choose>
                <xsl:when test="normalize-space(@valueURI) != ''">
                  <xsl:copy-of select="@valueURI"/>
                </xsl:when>
                <xsl:when test="normalize-space(*[position() = last()]/@valueURI) != ''">
                  <xsl:copy-of select="*[position() = last()]/@valueURI"/>
                </xsl:when>
              </xsl:choose>
              <xsl:call-template name="copyAuthDisplayAttr2"/>
              <xsl:value-of select="normalize-space(string-join(*[normalize-space(.) ne ''], '--'))"
              />
            </field>
          </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="$subjectHierarchicals/*:field">
          <xsl:call-template name="dedupeFields"/>
        </xsl:for-each>
        <!-- Name as subject -->
        <xsl:variable name="subjectNames">
          <xsl:for-each select="descendant::*:subject/*:name">
            <field name="subjectName">
              <xsl:call-template name="copyAuthDisplayAttr2"/>
              <xsl:copy-of select="@type"/>
              <xsl:variable name="namePartSeparator">
                <xsl:choose>
                  <xsl:when test="descendant::*[position() != last()][matches(., '[\.:,;/-]+$')]">
                    <xsl:text> </xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>, </xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:value-of
                select="replace(normalize-space(string-join(*[normalize-space(.) ne ''], $namePartSeparator)), ', \(', ' (')"
              />
            </field>
          </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="$subjectNames/*:field">
          <xsl:call-template name="dedupeFields"/>
        </xsl:for-each>
        <!-- Title as subject -->
        <xsl:variable name="subjectTitles">
          <xsl:for-each select="descendant::*:subject/*:titleInfo">
            <xsl:sort/>
            <field name="subjectTitle">
              <xsl:call-template name="copyAuthDisplayAttr2"/>
              <xsl:value-of select="normalize-space(string-join(*[normalize-space(.) ne ''], ' '))"
              />
            </field>
          </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="$subjectTitles/*:field">
          <xsl:call-template name="dedupeFields"/>
        </xsl:for-each>

        <!-- Relationships -->
        <xsl:apply-templates select="*:relatedItem[matches(@type, 'host|original|series')]"
          mode="uvaMAP"/>
        <xsl:apply-templates select="*:relatedItem[matches(@type, 'isReferencedBy')]" mode="uvaMAP"/>
        <xsl:apply-templates select="*:relatedItem[matches(@type, 'preceding|succeeding')]"
          mode="uvaMAP"/>
        <xsl:apply-templates select="*:relatedItem[matches(@type, 'otherVersion')]" mode="uvaMAP"/>
        <xsl:apply-templates select="*:relatedItem[not(@type)]" mode="uvaMAP"/>
      </xsl:variable>

      <!-- Output record so far -->
      <xsl:copy-of select="$pass1"/>

      <!-- Add work title -->
      <xsl:if test="not($pass1/*:field[@name = 'work_title'])">
        <field name="work_title" supplied="yes">
          <!-- Use title without leading article -->
          <xsl:value-of select="upper-case(substring($pass1/*:field[@name eq 'sortTitle'], 1, 1))"/>
          <xsl:value-of select="substring($pass1/*:field[@name eq 'sortTitle'], 2)"/>
          <!-- Add content type -->
          <xsl:text>¶</xsl:text>
          <xsl:value-of select="$pass1/*:field[@name eq 'contentType']"/>
          <!-- If serial, add issuanceMethod -->
          <xsl:if test="$pass1/*:field[@name eq 'issuanceMethod'][. eq 'serial']">
            <xsl:text>, serial</xsl:text>
          </xsl:if>
          <!-- Add work date -->
          <xsl:choose>
            <xsl:when test="$pass1/*:field[@name eq 'keyDate']">
              <xsl:text>¶</xsl:text>
              <xsl:value-of
                select="replace(replace(replace($pass1/*:field[@name eq 'keyDate'], '[\[\]]', ''), ' TO \*', '/'), ' TO ', '/')"
              />
            </xsl:when>
          </xsl:choose>
          <!-- Add creator or collection name -->
          <xsl:choose>
            <xsl:when test="$pass1/*:field[@name eq 'creator']">
              <xsl:text>¶</xsl:text>
              <xsl:value-of select="$pass1/*:field[@name eq 'creator'][1]"/>
            </xsl:when>
            <xsl:when test="$pass1/*:field[@name eq 'orig_creator']">
              <xsl:text>¶</xsl:text>
              <xsl:value-of select="$pass1/*:field[@name eq 'orig_creator'][1]"/>
            </xsl:when>
            <xsl:when test="$pass1/*:field[@name eq 'work_creator']">
              <xsl:text>¶</xsl:text>
              <xsl:value-of select="$pass1/*:field[@name eq 'work_creator'][1]"/>
            </xsl:when>
            <xsl:when test="$pass1/*:field[@name eq 'host_title']">
              <xsl:text>¶</xsl:text>
              <xsl:value-of select="$pass1/*:field[@name eq 'host_title'][1]"/>
            </xsl:when>
          </xsl:choose>
        </field>
      </xsl:if>
    </doc>
  </xsl:template>

  <!-- cartographic data indicating spatial coverage -->
  <xsl:template match="*:cartographics" mode="uvaMAP">
    <xsl:for-each select="*:coordinates | *:projection | *:scale">
      <field name="{local-name()}">
        <xsl:value-of select="normalize-space(.)"/>
      </field>
    </xsl:for-each>
  </xsl:template>

  <!-- language of the content of a resource -->
  <xsl:template match="*:language" mode="uvaMAP">
    <xsl:variable name="fieldNameLang">
      <!--<xsl:call-template name="whereAmI"/>-->
      <xsl:choose>
        <xsl:when test="matches(@objectPart, 'translation')">
          <xsl:text>originalLanguage</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>language</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="objectPart">
      <xsl:value-of select="normalize-space(@objectPart)"/>
    </xsl:variable>
    <xsl:for-each select="distinct-values(*:languageTerm)">
      <field name="{$fieldNameLang}">
        <xsl:if test="$objectPart ne '' and $objectPart ne 'translation'">
          <xsl:attribute name="objectPart">
            <xsl:value-of select="$objectPart"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:variable name="langTerm">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:variable>
        <!-- Get first match of @code in $marcLangList -->
        <xsl:value-of select="$marcLangList//*:lang[@code eq $langTerm][1]"/>
      </field>
    </xsl:for-each>
    <xsl:variable name="fieldNameScript">
      <xsl:call-template name="whereAmI"/>
      <xsl:text>alphabetScript</xsl:text>
    </xsl:variable>
    <xsl:for-each select="distinct-values(*:scriptTerm)">
      <field name="{$fieldNameScript}">
        <xsl:value-of select="normalize-space(.)"/>
      </field>
    </xsl:for-each>
  </xsl:template>

  <!--  description of the contents of a resource -->
  <xsl:template match="*:tableOfContents" mode="uvaMAP">
    <xsl:variable name="fieldName">
      <!--<xsl:call-template name="whereAmI"/>-->
      <xsl:text>contents</xsl:text>
    </xsl:variable>
    <field name="{$fieldName}">
      <xsl:apply-templates select="@displayLabel" mode="uvaMAP"/>
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <!-- description of the intellectual level of the audience for which the resource is intended -->
  <xsl:template match="*:targetAudience" mode="uvaMAP">
    <xsl:variable name="fieldName">
      <xsl:call-template name="whereAmI"/>
      <xsl:text>targetAudience</xsl:text>
    </xsl:variable>
    <field name="{$fieldName}">
      <xsl:apply-templates select="@displayLabel" mode="uvaMAP"/>
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <!-- name of a person, organization, or event (conference, meeting, etc.) -->
  <xsl:template match="*:name" mode="uvaMAP">
    <xsl:if test="*:namePart[not(normalize-space(.) eq '')]">
      <xsl:variable name="fieldName">
        <xsl:call-template name="whereAmI"/>
        <xsl:choose>
          <xsl:when test="count(../*:name) = 1">creator</xsl:when>
          <xsl:when test="*:role[*:roleTerm[matches(., '^(creator|cre)$')]]">creator</xsl:when>
          <xsl:when test="@usage eq 'primary'">creator</xsl:when>
          <xsl:otherwise>contributor</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <field name="{$fieldName}">
        <xsl:copy-of select="@authority | @authorityURI | @valueURI | @type"/>
        <xsl:variable name="roles">
          <xsl:for-each select="*:role/*:roleTerm">
            <xsl:variable name="thisValue">
              <xsl:value-of select="replace(lower-case(normalize-space(.)), '[\.:,;/]+$', '')"/>
            </xsl:variable>
            <xsl:choose>
              <!-- Map coded role value to term -->
              <xsl:when test="$marcRelators//*:relator[@code = $thisValue]">
                <role>
                  <xsl:value-of select="$marcRelators//*:relator[@code = $thisValue]/@term"/>
                </role>
              </xsl:when>
              <xsl:otherwise>
                <role>
                  <xsl:value-of select="lower-case(normalize-space(.))"/>
                </role>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:variable>
        <xsl:if test="normalize-space($roles) ne ''">
          <xsl:attribute name="role">
            <xsl:for-each select="distinct-values($roles/*:role)">
              <xsl:if test="position() &gt; 1">
                <xsl:text>, </xsl:text>
              </xsl:if>
              <xsl:value-of select="."/>
            </xsl:for-each>
          </xsl:attribute>
        </xsl:if>
        <xsl:variable name="nameValue">
          <xsl:value-of
            select="normalize-space(string-join(*:namePart[not(matches(@type, 'date'))], ' '))"/>
        </xsl:variable>
        <xsl:value-of select="replace(normalize-space($nameValue), '[:,;/]+$', '')"/>
        <xsl:for-each select="*:namePart[matches(@type, 'date')]">
          <xsl:value-of select="concat(', ', normalize-space(.))"/>
        </xsl:for-each>
      </field>
    </xsl:if>
  </xsl:template>

  <!-- summary of the content of the resource -->
  <xsl:template match="*:abstract" mode="uvaMAP">
    <xsl:variable name="fieldName">
      <xsl:call-template name="whereAmI"/>
      <xsl:text>abstractSummary</xsl:text>
    </xsl:variable>
    <field name="{$fieldName}">
      <xsl:apply-templates select="@displayLabel" mode="uvaMAP"/>
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <!-- designation applied to a resource that indicates the subject by applying a formal system of
  coding and organizing resources according to subject areas -->
  <xsl:template match="*:classification" mode="uvaMAP">
    <xsl:variable name="fieldName">
      <!--<xsl:call-template name="whereAmI"/>-->
      <xsl:text>classification</xsl:text>
    </xsl:variable>
    <field name="{$fieldName}">
      <xsl:call-template name="copyAuthDisplayAttr"/>
      <xsl:copy-of select="@edition"/>
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <!-- term(s) that designates a category characterizing a particular style, form, or content -->
  <xsl:template match="*:genre" mode="uvaMAP">
    <xsl:variable name="fieldName">
      <xsl:call-template name="whereAmI"/>
      <xsl:choose>
        <xsl:when test="matches(., 'government publication', 'i')">
          <xsl:text>governmentPublication</xsl:text>
        </xsl:when>
        <xsl:when test="matches(., 'festschrift', 'i')">
          <xsl:text>isFestschrift</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="contains($fieldName, 'isFestschrift')">
        <field name="isFestschrift">
          <xsl:text>yes</xsl:text>
        </field>
      </xsl:when>
      <xsl:when test="contains($fieldName, 'governmentPublication')">
        <field name="governmentPublication">
          <xsl:choose>
            <xsl:when test="matches(., 'autonomous', 'i')">
              <xsl:text>autonomous</xsl:text>
            </xsl:when>
            <xsl:when test="matches(., 'federal', 'i')">
              <xsl:text>federal</xsl:text>
            </xsl:when>
            <xsl:when test="matches(., 'intergovernmental')">
              <xsl:text>international intergovernmental</xsl:text>
            </xsl:when>
            <xsl:when test="matches(., 'multilocal')">
              <xsl:text>multilocal</xsl:text>
            </xsl:when>
            <xsl:when test="matches(., 'local')">
              <xsl:text>local</xsl:text>
            </xsl:when>
            <xsl:when test="matches(., 'multistate')">
              <xsl:text/>
            </xsl:when>
            <xsl:when test="matches(., 'state')">
              <xsl:text>state</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>government publication</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </field>
      </xsl:when>
      <!-- Expanding marcmuscomp codes with strings appears to duplicate subject headings,
        so not implemented now. -->
      <xsl:when test="matches(@authority, 'marcmuscomp')">
        <xsl:analyze-string select="normalize-space(.)" regex="-+">
          <xsl:non-matching-substring>
            <!-- Use 'formOfComposition' instead of $fieldName? -->
            <field name="{$fieldName}">
              <xsl:attribute name="authority">
                <xsl:text>marcmuscomp</xsl:text>
              </xsl:attribute>
              <xsl:variable name="thisValue">
                <xsl:value-of select="."/>
              </xsl:variable>
              <xsl:value-of select="$compFormMap/*:compForm[. eq $thisValue]/@term"/>
            </field>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <!-- Ignore lctgm values -->
      <xsl:when test="matches(@authority, 'lctgm')"/>
      <!-- Anything else -->
      <xsl:otherwise>
        <field name="genre">
          <xsl:call-template name="copyAuthDisplayAttr"/>
          <xsl:value-of select="normalize-space(.)"/>
        </field>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- unique standard number or code that distinctively identifies a resource -->
  <xsl:template match="*:identifier" mode="uvaMAP">
    <xsl:variable name="fieldName">
      <xsl:call-template name="whereAmI"/>
      <xsl:choose>
        <xsl:when test="matches(@type, 'oco?lc', 'i')">oclcNumber</xsl:when>
        <xsl:when test="matches(@type, 'lccn', 'i')">libraryCongressControlNumber</xsl:when>
        <xsl:when test="matches(@type, 'isbn', 'i')">internationalStandardBookNumber</xsl:when>
        <xsl:when test="matches(@type, 'issn', 'i')">internationalStandardSerialNumber</xsl:when>
        <xsl:when test="matches(@type, 'isrc', 'i')">internationalStandardRecordingCode</xsl:when>
        <xsl:when test="matches(@type, 'upc', 'i')">universalProductCode</xsl:when>
        <xsl:when test="matches(@type, 'ismn', 'i')">internationalStandardMusicNumber</xsl:when>
        <xsl:when test="matches(@type, 'ian', 'i')">internationalArticleNumber</xsl:when>
        <xsl:when test="matches(@type, 'sici', 'i')">serialItemContributionIdentifier</xsl:when>
        <xsl:when test="matches(@type, 'strn', 'i')">standardTechnicalReportNumber</xsl:when>
        <xsl:when
          test="matches(@type, '(issue.number|matrix.number|music.plate|music.publisher|stock.number|videorecording.identifier)')"
          >publisherDistributorNumber</xsl:when>
        <xsl:when test="matches(@type, 'GPO item number', 'i')">gpoItemNumber</xsl:when>
        <xsl:when test="matches(@type, 'CODEN', 'i')">CODEN</xsl:when>
        <xsl:when
          test="not(matches(@type, '(lccn|isbn|issn|isrc|upc|ismn|ian|sici|stm|stock.number|music.plate|music.publisher)'))">
          <xsl:text>identifier</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <field name="{$fieldName}">
      <xsl:copy-of select="@typeURI"/>
      <!-- Include identifiers with @invalid="yes" -->
      <xsl:copy-of select="@invalid"/>
      <xsl:choose>
        <!-- use @displayLabel when available or @type if it's not -->
        <xsl:when
          test="@displayLabel[not(matches(., 'legacy|local|staff', 'i')) and not(normalize-space(.) eq '')] and matches($fieldName, '(local|otherStandard)?identifier', 'i')">
          <xsl:attribute name="type">
            <xsl:value-of select="normalize-space(@displayLabel)"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when
          test="@type[not(matches(., 'legacy|local|staff|oco?lc|lccn|isbn|issn|isrc|upc|ismn|ian|sici|strn|CODEN|GPO', 'i'))]">
          <xsl:attribute name="type">
            <xsl:value-of
              select="replace(replace(normalize-space(@type), 'oco?lc', 'oclc', 'i'), '\.', ' ')"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <!-- Map note/@type to uvaMap element name -->
  <xsl:template match="*:note[not(matches(@type, 'uvax-'))]" mode="uvaMAP">
    <xsl:variable name="whereAmI">
      <xsl:call-template name="whereAmI"/>
    </xsl:variable>
    <xsl:variable name="fieldName">
      <xsl:choose>
        <xsl:when test="matches(@type, 'acquisition')">
          <xsl:text>acqInfo</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'action')">
          <xsl:text>appraisalProcessInfo</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'additional physical form')">
          <xsl:text>addPhysicalForm</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'bibliographical/historical')">
          <xsl:text>biogHist</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'citation/reference')">
          <xsl:text>referencedBy</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'creation/production credits')">
          <xsl:text>credits</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'funding')">
          <xsl:text>sponsor</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'ownership')">
          <xsl:text>custodHist</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'performers')">
          <xsl:text>performers</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'preferred citation')">
          <xsl:text>preferredCitation</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'publications')">
          <xsl:text>publications</xsl:text>
        </xsl:when>
        <xsl:when
          test="matches(@type, '(original locations|original version|source characteristics|source dimensions|source identifier|source note|source type)')">
          <xsl:text>originalsNote</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>note</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- Exclude notes where @type matches 'private' -->
    <xsl:if test="not(matches(@type, 'private'))">
      <field name="{$whereAmI}{$fieldName}">
        <xsl:if test="
            @type[not(matches(.,
            'local|staff|acquisition|action|additional physical form|bibliographical/historical|citation/reference|creation/production credits|funding|general|ownership|performers|preferred citation|publications|original (locations|version)|source (characteristics|dimensions|identifier|note|type)', 'i'))]">
          <xsl:attribute name="type">
            <xsl:value-of select="@type"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="@displayLabel and not(matches(@displayLabel, '^(local|staff)$', 'i'))">
          <xsl:copy-of select="@displayLabel"/>
        </xsl:if>
        <xsl:value-of select="normalize-space(.)"/>
      </field>
    </xsl:if>
    <xsl:if
      test="matches(., 'bibliograph', 'i') and not(../*:physicalDescription/*:note[matches(@type, 'containsBibrefs')])">
      <field name="containsBibrefs">
        <xsl:text>yes</xsl:text>
      </field>
    </xsl:if>
    <xsl:if
      test="matches(., '(contains|includes).*index', 'i') and not(../*:physicalDescription/*:note[matches(@type, 'containsIndex')])">
      <field name="containsIndex">
        <xsl:text>yes</xsl:text>
      </field>
    </xsl:if>
  </xsl:template>

  <!-- Information about the origin of the resource -->
  <xsl:template match="*:originInfo" mode="uvaMAP">
    <xsl:for-each select="*:publisher">
      <xsl:variable name="fieldName">
        <xsl:call-template name="whereAmI"/>
        <xsl:text>pubProdDist</xsl:text>
      </xsl:variable>
      <field name="{$fieldName}">
        <xsl:value-of
          select="replace(normalize-space(replace(., '^[.:,;/\[\]\s]+|[:,;/\[\]\s]+$', '')), 's\.n\.?', 'No name, unknown, or undetermined', 'i')"
        />
      </field>
    </xsl:for-each>

    <!-- Place -->
    <xsl:variable name="places">
      <xsl:for-each select="*:place">
        <xsl:variable name="fieldName">
          <xsl:call-template name="whereAmI"/>
          <xsl:text>pubProdDistPlace</xsl:text>
        </xsl:variable>
        <xsl:for-each
          select="*:placeTerm[matches(@type, 'code') and matches(@authority, 'marccountry')]">
          <xsl:variable name="placeCode">
            <!-- Account for incorrect case and/or length of placeTerm code -->
            <xsl:value-of select="substring(concat(lower-case(.), '   '), 1, 3)"/>
          </xsl:variable>
          <!-- Provide country name for state/territory codes -->
          <xsl:choose>
            <xsl:when test="matches($placeCode, '..a')">
              <field name="{$fieldName}">
                <xsl:text>Australia</xsl:text>
              </field>
            </xsl:when>
            <xsl:when test="matches($placeCode, '..c')">
              <field name="{$fieldName}">
                <xsl:text>Canada</xsl:text>
              </field>
            </xsl:when>
            <xsl:when test="matches($placeCode, '..k')">
              <field name="{$fieldName}">
                <xsl:text>United Kingdom</xsl:text>
              </field>
            </xsl:when>
            <xsl:when test="matches($placeCode, '..u')">
              <field name="{$fieldName}">
                <xsl:text>United States</xsl:text>
              </field>
            </xsl:when>
          </xsl:choose>
          <field name="{$fieldName}">
            <xsl:value-of select="$marcCountryCodes//*:country[@code eq $placeCode]"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="*:placeTerm[not(matches(@type, 'code'))]">
          <xsl:variable name="thisValue">
            <xsl:value-of select="normalize-space(.)"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="matches($thisValue, 's\.[1l]\.?', 'i')">
              <field name="{$fieldName}">
                <xsl:text>No place, unknown, or undetermined</xsl:text>
              </field>
            </xsl:when>
            <xsl:when test="$marcCountryCodes//*:country[@code eq $thisValue]">
              <field name="{$fieldName}">
                <xsl:value-of select="$marcCountryCodes//*:country[@code eq $thisValue]"/>
              </field>
            </xsl:when>
            <xsl:otherwise>
              <field name="{$fieldName}">
                <xsl:value-of
                  select="normalize-space(replace(., '^[.:,;/\[\]\s]+|[:,;/\[\]\s]+$', ''))"/>
              </field>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>
    <xsl:for-each select="$places/*:field">
      <xsl:variable name="thisValue">
        <xsl:value-of select="normalize-space(.)"/>
      </xsl:variable>
      <xsl:if test="not(preceding-sibling::*:field[. = $thisValue])">
        <xsl:copy-of select="."/>
      </xsl:if>
    </xsl:for-each>

    <!-- Date -->
    <!-- De-dupe values in same element -->
    <xsl:for-each
      select="*:copyrightDate | *:dateCaptured | *:dateCreated | *:dateIssued | *:dateValid | *:dateOther">
      <xsl:variable name="thisElement">
        <xsl:value-of select="local-name()"/>
      </xsl:variable>
      <xsl:variable name="thisValue">
        <xsl:value-of select="replace(normalize-space(.), '\D', '')"/>
      </xsl:variable>
      <xsl:if
        test="not(normalize-space(.) eq '') and not(preceding::*[matches(local-name(), $thisElement)][replace(normalize-space(.), '\D', '') = $thisValue])">
        <xsl:variable name="fieldName">
          <xsl:call-template name="whereAmI"/>
          <xsl:value-of select="local-name()"/>
        </xsl:variable>
        <field name="{$fieldName}">
          <xsl:if test="not(matches(., 'undated'))">
            <xsl:copy-of select="@encoding"/>
          </xsl:if>
          <xsl:value-of select="normalize-space(.)"/>
        </field>
      </xsl:if>
    </xsl:for-each>

    <!-- Edition/Version -->
    <xsl:for-each select="*:edition">
      <xsl:variable name="fieldName">
        <xsl:call-template name="whereAmI"/>
        <xsl:text>editionVersion</xsl:text>
      </xsl:variable>
      <field name="{$fieldName}">
        <xsl:value-of select="normalize-space(.)"/>
      </field>
    </xsl:for-each>

    <!-- Date modified -->
    <xsl:for-each select="*:dateModified">
      <xsl:variable name="fieldName">
        <xsl:call-template name="whereAmI"/>
        <xsl:text>editionVersionDate</xsl:text>
      </xsl:variable>
      <field name="{$fieldName}">
        <xsl:value-of select="normalize-space(.)"/>
      </field>
    </xsl:for-each>

    <!-- Issuance method -->
    <xsl:for-each select="*:issuance">
      <xsl:variable name="fieldName">
        <xsl:call-template name="whereAmI"/>
        <xsl:text>issuanceMethod</xsl:text>
      </xsl:variable>
      <field name="{$fieldName}">
        <xsl:value-of select="normalize-space(.)"/>
      </field>
    </xsl:for-each>

    <!-- Frequency -->
    <xsl:for-each select="*:frequency">
      <xsl:variable name="fieldName">
        <xsl:call-template name="whereAmI"/>
        <xsl:text>frequency</xsl:text>
      </xsl:variable>
      <field name="{$fieldName}">
        <xsl:value-of select="normalize-space(.)"/>
      </field>
    </xsl:for-each>
  </xsl:template>

  <!-- Physical description information of the resource -->
  <xsl:template match="*:physicalDescription" mode="uvaMAP">
    <!-- Media Type -->
    <xsl:variable name="mediaTypes">
      <xsl:for-each select="*:form[matches(@type, 'media')]">
        <mediaType>
          <xsl:value-of select="normalize-space(.)"/>
        </mediaType>
      </xsl:for-each>
      <!-- Collect media types based on certain types of <form> -->
      <xsl:for-each
        select="*:form[matches(@authority, 'gmd|marccategory|marcform|marcsmd|rdamedia')]">
        <xsl:variable name="thisValue">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:variable>
        <xsl:for-each select="$marcMediaMap//*:media[. = $thisValue]">
          <mediaType>
            <xsl:value-of select="@rdaType"/>
          </mediaType>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mediaTypeFieldName">
      <xsl:call-template name="whereAmI"/>
      <xsl:text>mediaType</xsl:text>
    </xsl:variable>
    <xsl:if
      test="$DL_digitized = 'true' and not(ancestor-or-self::*/*:physicalDescription/*:form[matches(., 'electronic|online|remote')])">
      <field name="mediaType">
        <xsl:text>computer</xsl:text>
      </field>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$mediaTypes/*:mediaType">
        <xsl:for-each
          select="distinct-values($mediaTypes/*:mediaType[not(matches(., 'unmediated'))])">
          <field>
            <xsl:attribute name="name">
              <xsl:value-of select="$mediaTypeFieldName"/>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:for-each>
        <xsl:if
          test="$mediaTypes/*:mediaType[matches(., 'unmediated')] and count(distinct-values($mediaTypes/*:mediaType[not(matches(., 'unmediated'))])) = 0">
          <field>
            <xsl:attribute name="name">
              <xsl:value-of select="$mediaTypeFieldName"/>
            </xsl:attribute>
            <xsl:text>unmediated</xsl:text>
          </field>
        </xsl:if>
      </xsl:when>
      <xsl:when test="*:internetMediaType or *:digitalOrigin">
        <field>
          <xsl:attribute name="name">
            <xsl:value-of select="$mediaTypeFieldName"/>
          </xsl:attribute>
          <xsl:text>computer</xsl:text>
        </field>
      </xsl:when>
    </xsl:choose>

    <!-- Carrier type -->
    <xsl:variable name="carrierTypeFieldName">
      <xsl:call-template name="whereAmI"/>
      <xsl:text>carrierType</xsl:text>
    </xsl:variable>
    <!-- Collect carrier types based on certain values of form -->
    <xsl:variable name="mappedCarrierTypes">
      <xsl:for-each select="*:form[not(matches(@authority, 'rdacarrier'))]">
        <xsl:variable name="thisValue">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:variable>
        <xsl:for-each select="$marcCarrierMap//*:carrier[. = $thisValue]">
          <xsl:value-of select="@rdaType"/>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="carrierValue">
      <xsl:choose>
        <!-- Use RDA value -->
        <xsl:when test="*:form[matches(@authority, 'rdacarrier')]">
          <xsl:for-each select="*:form[matches(@authority, 'rdacarrier')]">
            <xsl:if test="position() &gt; 1">
              <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:value-of select="normalize-space(.)"/>
          </xsl:for-each>
        </xsl:when>
        <!-- Map marcsmd to RDA -->
        <xsl:when test="*:form[matches(@authority, 'marcsmd')]">
          <xsl:for-each select="*:form[matches(@authority, 'marcsmd')]">
            <xsl:variable name="thisValue">
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:variable>
            <xsl:for-each select="$marcCarrierMap//*:carrier[. = $thisValue]">
              <xsl:if test="position() &gt; 1">
                <xsl:text>, </xsl:text>
              </xsl:if>
              <xsl:value-of select="@rdaType"/>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:when>
        <!-- Map marccategory to RDA -->
        <xsl:when test="*:form[matches(@authority, 'marccategory')]">
          <xsl:for-each select="*:form[matches(@authority, 'marccategory')]">
            <xsl:variable name="thisValue">
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:variable>
            <xsl:for-each select="$marcCarrierMap//*:carrier[. = $thisValue]">
              <xsl:if test="position() &gt; 1">
                <xsl:text>, </xsl:text>
              </xsl:if>
              <xsl:value-of select="@rdaType"/>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:when>
        <!-- Map GMD to RDA -->
        <xsl:when test="*:form[matches(@authority, 'gmd')]">
          <xsl:choose>
            <xsl:when test="$mappedCarrierTypes/*:carrierType">
              <xsl:for-each select="$mappedCarrierTypes/*:carrierType">
                <xsl:if test="position() &gt; 1">
                  <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:value-of select="normalize-space(.)"/>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
        <!-- Map marcform to RDA -->
        <xsl:when test="*:form[matches(@authority, 'marcform')]">
          <xsl:choose>
            <xsl:when test="$mappedCarrierTypes/*:carrierType">
              <xsl:for-each select="$mappedCarrierTypes/*:carrierType">
                <xsl:if test="position() &gt; 1">
                  <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:value-of select="normalize-space(.)"/>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
        <!-- Map internetMediaType or digitalOrigin to RDA -->
        <xsl:when test="*:internetMediaType or *:digitalOrigin">
          <xsl:text>online resource</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:if
      test="$DL_digitized = 'true' and not(ancestor-or-self::*/*:physicalDescription/*:form[matches(., 'electronic|online|remote')])">
      <field name="carrierType">
        <xsl:text>online resource</xsl:text>
      </field>
    </xsl:if>
    <field>
      <xsl:attribute name="name">
        <xsl:value-of select="$carrierTypeFieldName"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="normalize-space($carrierValue) ne ''">
          <xsl:value-of select="normalize-space($carrierValue)"/>
        </xsl:when>
        <xsl:when test="matches(ancestor::*:mods/*:typeOfResource, 'text')">
          <xsl:text>volume</xsl:text>
        </xsl:when>
        <xsl:when test="matches(ancestor::*:mods/*:typeOfResource, 'object')">
          <xsl:text>object</xsl:text>
        </xsl:when>
        <xsl:when test="*:extent[matches(., 'compact disc')] or ../*:note[matches(., 'CD')]">
          <xsl:text>computer disc</xsl:text>
        </xsl:when>
        <xsl:when test="*:extent[matches(., 'videodisc')] or ../*:note[matches(., 'DVD')]">
          <xsl:text>videodisc</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>unspecified</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </field>

    <!-- Physical extent -->
    <!-- Multiple extent elements result in multiple physExtent elements in the output -->
    <xsl:variable name="fieldName">
      <xsl:call-template name="whereAmI"/>
      <xsl:text>physExtent</xsl:text>
    </xsl:variable>
    <xsl:for-each select="*:extent">
      <xsl:variable name="unit">
        <xsl:value-of select="replace(normalize-space(@unit), '\W+$', '')"/>
      </xsl:variable>
      <xsl:analyze-string select="normalize-space(.)" regex="\+">
        <xsl:non-matching-substring>
          <xsl:variable name="subfieldA">
            <xsl:call-template name="getSubfield">
              <xsl:with-param name="stringValue">
                <xsl:value-of select="."/>
              </xsl:with-param>
              <xsl:with-param name="subfield">a</xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="not(normalize-space($subfieldA) eq '')">
            <!-- Substrings beyond the first are mapped to accMatter elements -->
            <field>
              <xsl:attribute name="name">
                <xsl:choose>
                  <xsl:when test="position() = 1">
                    <xsl:value-of select="$fieldName"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>accMatter</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:value-of select="$subfieldA"/>
              <!-- Unless it's already present in $subfieldA, append value of $unit -->
              <xsl:if test="position() = 1 and not(matches($subfieldA, $unit, 'i'))">
                <xsl:value-of select="concat(' ', $unit)"/>
              </xsl:if>
              <!-- Add a closing parenthesis if needed -->
              <xsl:if test="matches($subfieldA, '\([^\)]+$')">
                <xsl:text>)</xsl:text>
              </xsl:if>
            </field>
          </xsl:if>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:for-each>

    <!-- Other "facet-able" physical details -->
    <!-- Results in individual elements -->
    <xsl:for-each
      select="*:note[matches(@type, '^uvax-') and matches(@type, 'alphabetScript|brailleClass|brailleMusicFormat|colorContent|containsBibrefs|containsIndex|filmPresentationFormat|formOfComposition|illustrations|instrumentsVoicesCode|musicKey|musicParts|performanceMedium|physDimensions|playbackChannels|playbackSpecial|playingSpeed|playingTime|projection|relief|scoreFormat|soundContent|transpositionArrangement|videoFormat')]">
      <xsl:variable name="fieldName">
        <xsl:choose>
          <!-- Digitized -->
          <xsl:when
            test="$DL_digitized = 'true' and not(ancestor-or-self::*/*:physicalDescription/*:form[matches(., 'electronic|online|remote')])">
            <xsl:if test="matches(@type, 'physDimensions')">
              <xsl:text>orig_</xsl:text>
            </xsl:if>
          </xsl:when>
          <!--  NOT Digitized -->
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="ancestor::*:relatedItem[matches(@type, 'host')]">
                <xsl:text>host_</xsl:text>
              </xsl:when>
              <xsl:when test="ancestor::*:relatedItem[matches(@type, 'original')]">
                <xsl:text>orig_</xsl:text>
              </xsl:when>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="substring-after(@type, 'uvax-')"/>
      </xsl:variable>
      <field name="{$fieldName}">
        <xsl:copy-of select="@displayLabel"/>
        <xsl:value-of select="."/>
      </field>
    </xsl:for-each>

    <!-- Other non-facet-able technical details -->
    <!-- Collected into a single physDetails element -->
    <xsl:if test="
        *:form[matches(@type, 'material|technique')] or *:note[matches(@type, '^uvax-') and
        not(matches(@type, 'alphabetScript|brailleClass|brailleMusicFormat|colorContent|containsBibrefs|containsIndex|filmPresentationFormat|formOfComposition|illustrations|instrumentsVoicesCode|musicKey|musicParts|performanceMedium|physDimensions|playbackChannels|playbackSpecial|playingSpeed|playingTime|projection|relief|scoreFormat|soundContent|transpositionArrangement|videoFormat'))]">
      <xsl:variable name="fieldName">
        <xsl:call-template name="whereAmI"/>
        <xsl:text>physDetails</xsl:text>
      </xsl:variable>
      <field name="{$fieldName}">
        <xsl:variable name="sortedDetails">
          <xsl:for-each select="
              *:form[matches(@type, 'material|technique')] |
              *:note[matches(@type, '^uvax-') and not(matches(@type, 'alphabetScript|brailleClass|brailleMusicFormat|colorContent|containsIndex|filmPresentationFormat|formOfComposition|illustrations|instrumentsVoicesCode|musicKey|musicParts|performanceMedium|physDimensions|playbackChannels|playbackSpecial|playingSpeed|playingTime|projection|relief|scoreFormat|soundContent|transpositionArrangement|videoFormat'))]">
            <xsl:sort select="@displayLabel"/>
            <xsl:copy-of select="."/>
          </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="$sortedDetails/*">
          <xsl:if test="position() &gt; 1">
            <xsl:text>; </xsl:text>
          </xsl:if>
          <xsl:variable name="precedingLabel">
            <xsl:value-of select="preceding-sibling::*[1]/@displayLabel"/>
          </xsl:variable>
          <xsl:if test="@displayLabel != $precedingLabel">
            <xsl:value-of
              select="concat(normalize-space(replace(@displayLabel, '[.,;:]+$', '')), ': ')"/>
          </xsl:if>
          <xsl:value-of select="."/>
        </xsl:for-each>
      </field>
    </xsl:if>

    <!-- Other physical description info -->
    <xsl:apply-templates
      select="*:digitalOrigin | *:internetMediaType | *:note[not(matches(@type, '59[1-9]|uvax-')) and normalize-space(.) ne ''] | *:reformattingQuality"
      mode="uvaMAP"/>
  </xsl:template>

  <!-- source of a digital file important to its creation, use and management -->
  <xsl:template match="*:digitalOrigin" mode="uvaMAP">
    <xsl:variable name="fieldName">
      <xsl:call-template name="whereAmI"/>
      <xsl:text>digitalOrigin</xsl:text>
    </xsl:variable>
    <field name="{$fieldName}">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <!-- assessment of the physical quality of an electronic resource in relation to its intended use -->
  <xsl:template match="*:reformattingQuality" mode="uvaMAP">
    <xsl:variable name="fieldName">
      <xsl:call-template name="whereAmI"/>
      <xsl:text>reformattingQuality</xsl:text>
    </xsl:variable>
    <field name="{$fieldName}">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <!-- electronic format type, or the data representation of the resource -->
  <xsl:template match="*:internetMediaType" mode="uvaMAP">
    <xsl:variable name="fieldName">
      <xsl:call-template name="whereAmI"/>
      <xsl:text>internetMediaType</xsl:text>
    </xsl:variable>
    <field name="{$fieldName}">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <!-- Other resources related to the one being described -->
  <!-- Host or Original -->
  <xsl:template match="*:relatedItem[matches(@type, 'host|original')]" mode="uvaMAP">
    <xsl:variable name="fieldName">
      <xsl:value-of select="concat(substring(@type, 1, 4), '_')"/>
      <xsl:text>contentType</xsl:text>
    </xsl:variable>
    <xsl:choose>
      <!-- Use typeOfResource when it's available -->
      <xsl:when test="*:typeOfResource">
        <xsl:apply-templates select="*:typeOfResource" mode="uvaMAP"/>
      </xsl:when>
      <!-- Perform a lookup in resourcetypeMap -->
      <xsl:otherwise>
        <xsl:variable name="resourceTypes">
          <!-- Map form and genre elements to resourceType -->
          <xsl:for-each select="*:physicalDescription/*:form | *:mods/*:genre">
            <xsl:variable name="thisValue">
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:variable>
            <xsl:for-each select="$resourceMap//*:content[. = $thisValue]">
              <resourceType>
                <xsl:value-of select="@resourceType"/>
              </resourceType>
            </xsl:for-each>
          </xsl:for-each>
          <!-- Map internetMediaType values to resourceType -->
          <xsl:for-each
            select="*:physicalDescription/*:internetMediaType[matches(normalize-space(.), '^(application|audio|image|text|video|font|multipart)')]">
            <resourceType>
              <xsl:choose>
                <xsl:when test="matches(normalize-space(.), '^(application|font|multipart)')">
                  <xsl:text>software, multimedia</xsl:text>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), '^audio')">
                  <xsl:text>sound recording</xsl:text>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), '^image')">
                  <xsl:text>still image</xsl:text>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), '^text')">
                  <xsl:text>text</xsl:text>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), '^video')">
                  <xsl:text>moving image</xsl:text>
                </xsl:when>
              </xsl:choose>
            </resourceType>
          </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
          <!-- Output values other than 'unspecified', if they're available -->
          <xsl:when test="$resourceTypes/*:resourceType[. != 'unspecified']">
            <xsl:for-each
              select="distinct-values($resourceTypes/*:resourceType[. != 'unspecified'])">
              <field name="{$fieldName}">
                <xsl:value-of select="normalize-space(.)"/>
              </field>
            </xsl:for-each>
          </xsl:when>
          <!-- Output 'unspecified' as a last resort. The items bearing this contentType should have typeOfResource corrected in the source MODS. -->
          <!--<xsl:otherwise>
            <field name="{$fieldName}">
              <xsl:text>unspecified</xsl:text>
            </field>
          </xsl:otherwise>-->
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
    <!-- Physical Description of related item -->
    <xsl:apply-templates select="*:physicalDescription" mode="uvaMAP"/>
    <xsl:apply-templates
      select="*:abstract | *:accessCondition | *:genre | *:identifier | *:location | *:name | *:note[not(matches(@type, '59[1-9]')) and normalize-space(.) ne ''] | *:originInfo | *:relatedItem[matches(@type, 'series')] | *:titleInfo"
      mode="uvaMAP"/>
    <xsl:apply-templates select="*:part" mode="uvaMAP"/>
  </xsl:template>

  <!-- Series -->
  <xsl:template match="*:relatedItem[matches(@type, 'series')]" mode="uvaMAP">
    <xsl:variable name="fieldName">
      <xsl:call-template name="whereAmI"/>
      <xsl:text>seriesStatement</xsl:text>
    </xsl:variable>
    <field name="{$fieldName}">
      <xsl:value-of
        select="normalize-space(string-join(*:titleInfo/*[not(matches(local-name(), 'nonSort'))], ', '))"/>
      <xsl:for-each select="*:originInfo[not(normalize-space(.) = '')]">
        <xsl:text>. </xsl:text>
        <xsl:for-each select="*:place[not(normalize-space(.) = '')]/*:placeTerm">
          <xsl:if test="position() &gt; 1">
            <xsl:text>, </xsl:text>
          </xsl:if>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:for-each>
        <xsl:text>: </xsl:text>
        <xsl:for-each select="*:dateCreated">
          <xsl:value-of select="."/>
        </xsl:for-each>
      </xsl:for-each>
      <xsl:if test="*:part[not(normalize-space(.) = '')]">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:for-each select="*:part">
        <xsl:variable name="detailText">
          <xsl:for-each select="*:detail">
            <xsl:if test="position() != 1">
              <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:if test="not(normalize-space(@type) eq '')">
              <xsl:value-of select="concat(normalize-space(@type), ' ')"/>
            </xsl:if>
            <xsl:value-of select="normalize-space(string-join(*[normalize-space(.) ne ''], ' '))"/>
          </xsl:for-each>
          <xsl:if test="*:extent">
            <xsl:text>, &#32;</xsl:text>
            <xsl:for-each select="*:extent">
              <xsl:choose>
                <xsl:when test="*:start or *:end">
                  <xsl:choose>
                    <xsl:when test="matches(@unit, 'page') and *:start and *:end">pp. </xsl:when>
                    <xsl:when test="matches(@unit, 'page') and *:start">p. </xsl:when>
                  </xsl:choose>
                  <xsl:value-of select="*:start"/>
                  <xsl:if test="*:end">
                    <xsl:value-of select="concat('-', *:end)"/>
                  </xsl:if>
                </xsl:when>
                <xsl:when test="*:list">
                  <xsl:value-of select="normalize-space(*:list)"/>
                </xsl:when>
              </xsl:choose>
            </xsl:for-each>
          </xsl:if>
          <xsl:if test="*:date">
            <xsl:text>, &#32;</xsl:text>
            <xsl:value-of select="normalize-space(string-join(*:date, ' '))"/>
          </xsl:if>
        </xsl:variable>
        <xsl:value-of select="normalize-space($detailText)"/>
      </xsl:for-each>
    </field>
  </xsl:template>

  <!-- Constituent -->
  <xsl:template match="*:relatedItem[matches(@type, 'constituent')]" mode="uvaMAP">
    <field name="work_relatedWork">
      <xsl:for-each select="*:name/*[normalize-space(.) ne '']">
        <xsl:value-of select="replace(normalize-space(.), '[:,;/]+$', '')"/>
        <xsl:choose>
          <xsl:when test="position() ne last()">
            <xsl:text>, </xsl:text>
          </xsl:when>
          <xsl:otherwise>. </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:variable name="displayTitle">
        <xsl:for-each
          select="*:titleInfo[matches(@usage, 'primary') or not(matches(@type, 'abbreviated|alternative|translated|uniform'))][1]">
          <xsl:call-template name="makeDisplayTitle"/>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space(replace($displayTitle, '([.:,;/])\.', '$1'))"/>
    </field>
  </xsl:template>

  <!-- Referenced by -->
  <xsl:template match="*:relatedItem[matches(@type, 'isReferencedBy')]" mode="uvaMAP">
    <field name="referencedBy">
      <xsl:value-of select="string-join(descendant::text()[normalize-space(.) ne ''], ' ')"/>
    </field>
  </xsl:template>

  <!-- Other physical form -->
  <xsl:template match="*:relatedItem[matches(@type, 'otherFormat')]" mode="uvaMAP">
    <field name="addPhysicalForm">
      <xsl:choose>
        <xsl:when test="@displayLabel">
          <xsl:attribute name="displayLabel">
            <xsl:value-of select="replace(@displayLabel, '[.:,;/]+$', '')"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="@otherType">
          <xsl:attribute name="displayLabel">
            <xsl:value-of select="replace(@otherType, '[.:,;/]+$', '')"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:value-of select="string-join(*[normalize-space(.) ne ''], ' ')"/>
    </field>
  </xsl:template>

  <!-- Preceding/suceeding entry -->
  <xsl:template match="*:relatedItem[matches(@type, 'preceding|succeeding')]" mode="uvaMAP">
    <field name="{@type}Entry">
      <xsl:value-of select="string-join(*[normalize-space(.) ne ''], ' ')"/>
    </field>
  </xsl:template>

  <!-- Other version -->
  <xsl:template match="*:relatedItem[matches(@type, 'otherVersion')]" mode="uvaMAP">
    <field name="otherVersion">
      <xsl:value-of select="string-join(*[normalize-space(.) ne ''], ' ')"/>
    </field>
  </xsl:template>

  <!-- Related item w/o type value -->
  <xsl:template match="*:relatedItem[not(@type)]" mode="uvaMAP">
    <field name="work_relatedWork">
      <xsl:if test="@otherType">
        <xsl:attribute name="displayLabel">
          <xsl:value-of select="normalize-space(@otherType)"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:for-each select="*:titleInfo">
        <xsl:value-of select="string-join(*[normalize-space(.) ne ''], ' ')"/>
      </xsl:for-each>
      <xsl:if test="*:name/*[normalize-space(.) ne '']">
        <xsl:text>. </xsl:text>
      </xsl:if>
      <xsl:for-each select="*:name/*[normalize-space(.) ne '']">
        <xsl:value-of select="replace(normalize-space(.), '[:,;/]+$', '')"/>
        <xsl:choose>
          <xsl:when test="position() ne last()">
            <xsl:text>, </xsl:text>
          </xsl:when>
          <xsl:otherwise>.</xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:for-each select="*:location/*:url">
        <xsl:if test="normalize-space(@note) != ''">
          <xsl:value-of
            select="concat(upper-case(substring(normalize-space(@note), 1, 1)), lower-case(substring(normalize-space(@note), 2)), ' ')"
          />
        </xsl:if>
        <xsl:value-of select="normalize-space(.)"/>
      </xsl:for-each>
    </field>
  </xsl:template>

  <!-- Physical part of a resource -->
  <xsl:template match="*:part" mode="uvaMAP">
    <xsl:variable name="fieldName">
      <xsl:call-template name="whereAmI"/>
      <xsl:text>seriesDetails</xsl:text>
    </xsl:variable>
    <field name="{$fieldName}">
      <xsl:variable name="detailText">
        <xsl:for-each select="*:detail">
          <xsl:if test="position() != 1">
            <xsl:text>, </xsl:text>
          </xsl:if>
          <xsl:value-of select="normalize-space(string-join(*[normalize-space(.) ne ''], ' '))"/>
        </xsl:for-each>
        <xsl:if test="*:extent">
          <xsl:text>, &#32;</xsl:text>
          <xsl:for-each select="*:extent">
            <xsl:choose>
              <xsl:when test="*:start or *:end">
                <xsl:choose>
                  <xsl:when test="matches(@unit, 'page') and *:start and *:end">pp. </xsl:when>
                  <xsl:when test="matches(@unit, 'page') and *:start">p. </xsl:when>
                </xsl:choose>
                <xsl:value-of select="*:start"/>
                <xsl:if test="*:end">
                  <xsl:value-of select="concat('-', *:end)"/>
                </xsl:if>
              </xsl:when>
              <xsl:when test="*:list">
                <xsl:value-of select="normalize-space(*:list)"/>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>
        </xsl:if>
        <xsl:if test="*:date">
          <xsl:text>, &#32;</xsl:text>
          <xsl:value-of select="normalize-space(string-join(*:date, ' '))"/>
        </xsl:if>
      </xsl:variable>
      <xsl:value-of select="normalize-space($detailText)"/>
    </field>
  </xsl:template>

  <!--  word, phrase, character, or group of characters that names a resource or the work contained in it -->
  <xsl:template match="*:titleInfo" mode="uvaMAP">
    <xsl:variable name="whereAmI">
      <xsl:call-template name="whereAmI"/>
    </xsl:variable>
    <field>
      <xsl:attribute name="name">
        <xsl:value-of select="concat($whereAmI, 'title')"/>
      </xsl:attribute>
      <xsl:call-template name="makeDisplayTitle"/>
    </field>
  </xsl:template>

  <!-- restrictions imposed on access to [or use of] a resource -->
  <xsl:template match="*:accessCondition" mode="uvaMAP">
    <xsl:variable name="fieldName">
      <xsl:call-template name="whereAmI"/>
      <xsl:choose>
        <xsl:when test="matches(@type, 'use')">
          <xsl:text>useRestrict</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>accessRestrict</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <field name="{$fieldName}">
      <xsl:if test="@displayLabel[not(matches(., 'local|staff', 'i'))]">
        <xsl:attribute name="displayLabel">
          <xsl:value-of select="normalize-space(@displayLabel)"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="normalize-space(@xlink:href) != ''">
        <xsl:attribute name="valueURI">
          <xsl:value-of select="@xlink:href"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <!--  institution or repository holding the resource, or a remote location in the form
    of a URL where it is available -->
  <xsl:template match="*:location" mode="uvaMAP">
    <xsl:apply-templates
      select="*:physicalLocation[not(../*:holdingSimple/*:copyInformation/*:subLocation[matches(., 'INTERNET|WITHDRAWN', 'i')])] | *:shelfLocator | *:holdingSimple[not(*:copyInformation/*:subLocation[matches(., 'INTERNET|WITHDRAWN', 'i')])]/*:copyInformation/*:shelfLocator"
      mode="uvaMAP"/>
    <xsl:apply-templates select="*:url" mode="uvaMAP"/>
  </xsl:template>

  <!--  institution or repository that holds the resource or where it is available -->
  <xsl:template match="*:physicalLocation" mode="uvaMAP">
    <xsl:variable name="fieldName">
      <xsl:call-template name="whereAmI"/>
      <xsl:text>physLocation</xsl:text>
    </xsl:variable>
    <field name="{$fieldName}">
      <!-- Create relGroup and locGroup attributes that group data for related resources -->
      <!--<xsl:if test="matches($fieldName, '^host')">
        <xsl:attribute name="relGroup">
          <xsl:value-of select="generate-id(ancestor::*:relatedItem[@type = 'host'][1])"/>
        </xsl:attribute>
        <xsl:attribute name="locGroup">
          <xsl:value-of select="generate-id(ancestor::*:location[1])"/>
        </xsl:attribute>
      </xsl:if>-->
      <xsl:value-of select="normalize-space(.)"/>
      <xsl:for-each
        select="../*:holdingSimple/*:copyInformation/*:subLocation[not(matches(., 'INTERNET|WITHDRAWN', 'i'))]">
        <xsl:value-of select="concat(', ', normalize-space(.))"/>
      </xsl:for-each>
    </field>
  </xsl:template>

  <!-- Shelfmark or other shelving designation that indicates the location identifier for a copy -->
  <xsl:template match="*:shelfLocator" mode="uvaMAP">
    <xsl:variable name="fieldName">
      <xsl:call-template name="whereAmI"/>
      <xsl:text>callNumber</xsl:text>
    </xsl:variable>
    <field name="{$fieldName}">
      <xsl:if test="following-sibling::*:note[@type eq 'call_number_sort']">
        <xsl:attribute name="type">
          <xsl:value-of select="lower-case(following-sibling::*:note[@type eq 'call_number_sort'])"
          />
        </xsl:attribute>
      </xsl:if>
      <!-- Create relGroup and locGroup attributes that group data for related resources -->
      <!--<xsl:if test="matches($fieldName, '^host')">
        <xsl:attribute name="relGroup">
          <xsl:value-of select="generate-id(ancestor::*:relatedItem[@type = 'host'][1])"/>
        </xsl:attribute>
        <xsl:attribute name="locGroup">
          <xsl:value-of select="generate-id(ancestor::*:location[1])"/>
        </xsl:attribute>
      </xsl:if>-->
      <xsl:value-of select="normalize-space(.)"/>
    </field>
    <xsl:for-each select="../*:itemIdentifier | ../*:holdingSimple//*:itemIdentifier">
      <xsl:variable name="fieldName">
        <xsl:call-template name="whereAmI"/>
        <xsl:text>itemID</xsl:text>
      </xsl:variable>
      <field name="{$fieldName}">
        <xsl:copy-of select="@type"/>
        <!-- Create relGroup and locGroup attributes that group data for related resources -->
        <!--<xsl:if test="matches($fieldName, '^host')">
          <xsl:attribute name="relGroup">
            <xsl:value-of select="generate-id(ancestor::*:relatedItem[@type = 'host'][1])"/>
          </xsl:attribute>
          <xsl:attribute name="locGroup">
            <xsl:value-of select="generate-id(ancestor::*:location[1])"/>
          </xsl:attribute>
        </xsl:if>-->
        <xsl:value-of select="normalize-space(.)"/>
      </field>
    </xsl:for-each>
  </xsl:template>

  <!-- Uniform Resource Location of the resource -->
  <xsl:template match="*:url" mode="uvaMAP">
    <xsl:variable name="fieldName">
      <xsl:call-template name="whereAmI"/>
      <xsl:text>uri</xsl:text>
    </xsl:variable>
    <field name="{$fieldName}">
      <xsl:copy-of select="@access | @usage | @displayLabel"/>
      <!-- <xsl:if test="matches($fieldName, '^host')">
        <xsl:attribute name="relGroup">
          <xsl:value-of select="generate-id(ancestor::*:relatedItem[@type = 'host'][1])"/>
        </xsl:attribute>
        <xsl:attribute name="locGroup">
          <xsl:value-of select="generate-id(ancestor::*:location[1])"/>
        </xsl:attribute>
      </xsl:if>-->
      <xsl:choose>
        <xsl:when test="not(@access) and count(../*:url) = 1 and count(../../*:url) = 1">
          <xsl:attribute name="usage">primary</xsl:attribute>
        </xsl:when>
        <xsl:when test="not(preceding::*:url)">
          <xsl:attribute name="usage">primary</xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <!-- term that specifies the characteristics and general type of content of the resource -->
  <xsl:template match="*:typeOfResource" mode="uvaMAP">
    <xsl:if test="@collection = 'yes'">
      <xsl:variable name="fieldName">
        <xsl:call-template name="whereAmI"/>
        <xsl:text>isCollection</xsl:text>
      </xsl:variable>
      <field name="{$fieldName}">
        <!-- Create relGroup and locGroup attributes that group data for related resources -->
        <!--<xsl:if test="matches($fieldName, '^host')">
          <xsl:attribute name="relGroup">
            <xsl:value-of select="generate-id(ancestor::*:relatedItem[@type = 'host'][1])"/>
          </xsl:attribute>
        </xsl:if>-->
        <xsl:text>yes</xsl:text>
      </field>
    </xsl:if>
    <xsl:if test="@manuscript = 'yes'">
      <field name="isHandwritten">
        <xsl:if test="ancestor::*:relatedItem[@type = 'host']">
          <xsl:attribute name="relGroup">
            <xsl:value-of select="generate-id(ancestor::*:relatedItem[@type = 'host'][1])"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:text>yes</xsl:text>
      </field>
    </xsl:if>
    <xsl:if
      test="$DL_digitized = 'true' and not(ancestor-or-self::*/*:physicalDescription/*:form[matches(., 'electronic|online|remote')])">
      <field name="contentType">
        <xsl:if test="ancestor::*:relatedItem[@type = 'host']">
          <xsl:attribute name="relGroup">
            <xsl:value-of select="generate-id(ancestor::*:relatedItem[@type = 'host'][1])"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:value-of select="normalize-space(.)"/>
      </field>
    </xsl:if>
    <xsl:choose>
      <!-- Already a MARC value -->
      <xsl:when
        test="matches(normalize-space(.), '^(text|cartographic|notated music|sound recording|sound recording-musical|sound recording-nonmusical|still image|moving image|three dimensional object|software, multimedia|mixed material)$')">
        <xsl:variable name="fieldName">
          <xsl:call-template name="whereAmI"/>
          <xsl:text>contentType</xsl:text>
        </xsl:variable>
        <field name="{$fieldName}">
          <!-- Create relGroup and locGroup attributes that group data for related resources -->
          <!--<xsl:if test="matches($fieldName, '^host')">
            <xsl:attribute name="relGroup">
              <xsl:value-of select="generate-id(ancestor::*:relatedItem[@type = 'host'][1])"/>
            </xsl:attribute>
          </xsl:if>-->
          <xsl:value-of select="normalize-space(.)"/>
        </field>
      </xsl:when>
      <!-- Not a MARC value, perform a lookup -->
      <xsl:otherwise>
        <xsl:variable name="resourceTypes">
          <!-- Map form and genre elements -->
          <xsl:for-each
            select=". | ancestor::*:mods/*:physicalDescription/*:form | ancestor::*:mods/*:genre">
            <xsl:variable name="thisValue">
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:variable>
            <xsl:for-each select="$resourceMap//*:content[. = $thisValue]">
              <resourceType>
                <xsl:value-of select="@resourceType"/>
              </resourceType>
            </xsl:for-each>
          </xsl:for-each>
          <!-- Map internetMediaType values too -->
          <xsl:for-each
            select="ancestor::*:mods/*:physicalDescription/*:internetMediaType[matches(normalize-space(.), '^(application|audio|image|text|video|font|multipart)')]">
            <resourceType>
              <xsl:choose>
                <xsl:when test="matches(normalize-space(.), '^(application|font|multipart)')">
                  <xsl:text>software, multimedia</xsl:text>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), '^audio')">
                  <xsl:text>sound recording</xsl:text>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), '^image')">
                  <xsl:text>still image</xsl:text>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), '^text')">
                  <xsl:text>text</xsl:text>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), '^video')">
                  <xsl:text>moving image</xsl:text>
                </xsl:when>
              </xsl:choose>
            </resourceType>
          </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
          <!-- Output values other than 'unspecified', if they're available -->
          <xsl:when test="$resourceTypes/*:resourceType[. != 'unspecified']">
            <xsl:for-each
              select="distinct-values($resourceTypes/*:resourceType[. != 'unspecified'])">
              <field name="contentType">
                <xsl:value-of select="normalize-space(.)"/>
              </field>
            </xsl:for-each>
          </xsl:when>
          <!-- Output 'unspecified' as a last resort. The items bearing this contentType should have typeOfResource corrected in the source MODS. -->
          <xsl:otherwise>
            <field name="contentType">
              <xsl:text>unspecified</xsl:text>
            </field>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- DEFAULT TEMPLATE                                                        -->
  <!-- ======================================================================= -->

  <xsl:template match="@* | node()" mode="#all">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
