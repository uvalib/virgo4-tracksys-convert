<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns="http://www.loc.gov/mods/v3" xmlns:mods="http://www.loc.gov/mods/v3"
  xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xlink">

  <xsl:output media-type="text/xml" method="xml" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- ======================================================================= -->
  <!-- GLOBAL VARIABLES                                                        -->
  <!-- ======================================================================= -->

  <!-- program name -->
  <xsl:variable name="progname">
    <xsl:text>updateNonMedicalArtifacts.xsl</xsl:text>
  </xsl:variable>

  <!-- program version -->
  <xsl:variable name="version">
    <xsl:text>0.1 beta</xsl:text>
  </xsl:variable>

  <!-- ======================================================================= -->
  <!-- MAIN OUTPUT TEMPLATE                                                    -->
  <!-- ======================================================================= -->

  <xsl:template match="*:mods">
    <mods xmlns="http://www.loc.gov/mods/v3">
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
        <xsl:when
          test="not(*:relatedItem[@type = 'host']/*:titleInfo/*:title[matches(., 'Medical Artifacts Collection')])">
          <xsl:apply-templates select="*[not(matches(local-name(), '(name|genre|abstract)'))]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </mods>
  </xsl:template>

  <xsl:template match="*:relatedItem[@type = 'original']">
    <relatedItem xmlns="http://www.loc.gov/mods/v3">
      <xsl:apply-templates select="@*"/>
      <xsl:if
        test="not(../*:relatedItem[@type = 'host']/*:titleInfo/*:title[matches(., 'Medical Artifacts Collection')])">
        <xsl:apply-templates select="../*[matches(local-name(), '(name|abstract)')]"/>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="*:physicalDescription">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <physicalDescription>
            <xsl:apply-templates select="ancestor::*:mods/*:genre"/>
          </physicalDescription>
        </xsl:otherwise>
      </xsl:choose>
    </relatedItem>
  </xsl:template>

  <xsl:template match="*:relatedItem[@type = 'original']/*:physicalDescription">
    <xsl:apply-templates select="*:form"/>
    <xsl:apply-templates select="ancestor::*:mods/*:genre"/>
    <xsl:apply-templates select="*[not(matches(local-name(), 'form'))]"/>
  </xsl:template>

  <xsl:template match="*:mods/*:genre">
    <form>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </form>
  </xsl:template>

  <xsl:template match="*:recordInfo">
    <recordInfo xmlns="http://www.loc.gov/mods/v3">
      <xsl:apply-templates select="@*"/>
      <!--<xsl:apply-templates select="*:recordOrigin"/>-->
      <xsl:choose>
        <xsl:when
          test="not(../*:relatedItem[@type = 'host']/*:titleInfo/*:title[matches(., 'Medical Artifacts Collection')])">
          <recordOrigin>
            <xsl:value-of select="*:recordOrigin"/>
            <xsl:text> Updated </xsl:text>
            <xsl:value-of
              select="format-dateTime(current-dateTime(), '[Y]-[M02]-[D02]T[H]:[m]:[s]')"/>
            <xsl:text> using </xsl:text>
            <xsl:value-of select="concat($progname, ', ', $version, '.')"/>
          </recordOrigin>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="*:recordOrigin"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*[not(matches(local-name(), 'recordOrigin'))]"/>
    </recordInfo>
  </xsl:template>

  <xsl:template match="@* | *" mode="#all">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
