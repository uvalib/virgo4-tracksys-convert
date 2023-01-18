<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

  <xsl:output method="xml" encoding="UTF-8" indent="yes" media-type="text/xml"
    omit-xml-declaration="no" standalone="no"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="//*:report">
    <collectionNames>
      <xsl:variable name="matches">
        <xsl:apply-templates select="*:incident">
          <xsl:sort select="*:match"/>
        </xsl:apply-templates>
      </xsl:variable>
      <xsl:for-each select="$matches//*:match">
        <xsl:variable name="thisValue">
          <xsl:value-of select="lower-case(normalize-space(.))"/>
        </xsl:variable>
        <xsl:if test="not(preceding-sibling::*:match = $thisValue)">
          <name>
            <xsl:value-of select="."/>
          </name>
        </xsl:if>
      </xsl:for-each>
    </collectionNames>

  </xsl:template>

  <xsl:template match="*:incident">
    <match>
      <xsl:value-of select="lower-case(normalize-space(*:match))"/>
    </match>
  </xsl:template>

</xsl:stylesheet>
