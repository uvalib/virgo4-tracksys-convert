<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns=""
  xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="mods xlink">

  <xsl:output media-type="text/xml" method="xml" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- ======================================================================= -->
  <!-- PARAMETERS                                                              -->
  <!-- ======================================================================= -->

  <xsl:param name="groupBy" select="'uniform title'"/>

  <!-- ======================================================================= -->
  <!-- GLOBAL VARIABLES                                                        -->
  <!-- ======================================================================= -->

  <!-- program name -->
  <xsl:variable name="progname">
    <xsl:text>mods2solr-DEV.xsl</xsl:text>
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

  <xsl:template name="dataType">
    <xsl:choose>
      <xsl:when test="@displayLabel">
        <xsl:value-of select="concat(' (', @displayLabel, ')')"/>
      </xsl:when>
      <xsl:when test="@type">
        <xsl:value-of select="concat(' (', @type, ')')"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="dataLabel">
    <xsl:choose>
      <xsl:when
        test="not(matches(@displayLabel, 'staff')) and not(starts-with(normalize-space(.), @displayLabel))">
        <xsl:value-of select="concat(normalize-space(@displayLabel), ': ')"/>
      </xsl:when>
      <xsl:when test="not(matches(@type, 'staff')) and not(starts-with(normalize-space(.), @type))">
        <xsl:value-of select="concat(normalize-space(@type), ': ')"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="dateQualifiers">
    <xsl:choose>
      <xsl:when test="matches(., 'approximate')">
        <xsl:text>~</xsl:text>
      </xsl:when>
      <xsl:when test="matches(., 'questionable')">
        <xsl:text>?</xsl:text>
      </xsl:when>
      <xsl:when test="matches(., 'inferred')">
        <xsl:text>%</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="combineDates">
    <xsl:param name="field" required="yes"/>
    <xsl:variable name="fieldOut">
      <xsl:choose>
        <xsl:when test="matches($field, 'dateModified')">
          <xsl:text>editionVersionDate</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$field"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <!-- Combine start and end dates into a single field -->
      <xsl:when
        test="count(*[matches(local-name(), $field)]) = 2 and *[matches(local-name(), $field)][@point eq 'start'] and *[matches(local-name(), $field)][@point eq 'end']">
        <field name="{$fieldOut}">
          <xsl:value-of select="normalize-space(*[matches(local-name(), $field)][1])"/>
          <xsl:for-each select="*[matches(local-name(), $field)][1]/@qualifier">
            <xsl:call-template name="dateQualifiers"/>
          </xsl:for-each>
          <!-- Output end date only if it's different from start date -->
          <xsl:if
            test="normalize-space(*[matches(local-name(), $field)][2]) ne normalize-space(*[matches(local-name(), $field)][1])">
            <xsl:text>/</xsl:text>
            <xsl:value-of select="normalize-space(*[matches(local-name(), $field)][2])"/>
            <xsl:for-each select="*[matches(local-name(), $field)][2]/@qualifier">
              <xsl:call-template name="dateQualifiers"/>
            </xsl:for-each>
          </xsl:if>
        </field>
      </xsl:when>
      <!-- Emit multiple dates -->
      <xsl:otherwise>
        <xsl:for-each select="*[matches(local-name(), $field)]">
          <xsl:sort/>
          <field name="{$fieldOut}">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- ======================================================================= -->
  <!-- MAIN OUTPUT TEMPLATE                                                    -->
  <!-- ======================================================================= -->

  <xsl:template match="/">
    <add>
      <xsl:choose>
        <!-- Group "works" by uniform title -->
        <xsl:when test="matches($groupBy, 'uniform')">
          <xsl:for-each-group select="descendant::*:mods"
            group-by="normalize-space(concat(replace(*:titleInfo[matches(@type, 'uniform')][1]/*:title[1], '[\s:]+$', ''), ' : ', *:titleInfo[matches(@type, 'uniform')][1]/*:subTitle[1]))">
            <xsl:sort
              select="lower-case(normalize-space(concat(replace(*:titleInfo[matches(@type, 'uniform')][1]/*:title[1], '[\s:]+$', ''), ' : ', *:titleInfo[matches(@type, 'uniform')][1]/*:subTitle[1])))"/>
            <doc>
              <field name="originalMetadataType">MODS</field>
              <field name="work_title">
                <xsl:value-of
                  select="replace(normalize-space(*:titleInfo[matches(@type, 'uniform')][1]/*:title[1]), '[\s:]+$', '')"/>
                <xsl:if test="*:titleInfo[matches(@type, 'uniform')][1]/*:subTitle">
                  <xsl:value-of
                    select="concat(' : ', normalize-space(*:titleInfo[matches(@type, 'uniform')][1]/*:subTitle[1]))"
                  />
                </xsl:if>
                <xsl:if test="*:titleInfo[matches(@type, 'uniform')][1]/*:nonSort">
                  <xsl:value-of
                    select="concat(', ', normalize-space(*:titleInfo[matches(@type, 'uniform')][1]/*:nonSort[1]))"
                  />
                </xsl:if>
              </field>
              <xsl:variable name="components">
                <field name="components">
                  <xsl:for-each select="current-group()">
                    <doc>
                      <xsl:apply-templates mode="resource"/>
                    </doc>
                  </xsl:for-each>
                </field>
              </xsl:variable>
              <xsl:variable name="keyDates">
                <xsl:for-each select="$components/*:field[@name eq 'components']/*:doc">
                  <xsl:variable name="keyDate">
                    <xsl:choose>
                      <xsl:when test="descendant::*:field[@name eq 'dateCreated']">
                        <xsl:value-of select="descendant::*:field[@name eq 'dateCreated'][1]"/>
                      </xsl:when>
                      <xsl:when test="descendant::*:field[@name eq 'dateIssued']">
                        <xsl:value-of select="descendant::*:field[@name eq 'dateIssued'][1]"/>
                      </xsl:when>
                      <xsl:when test="descendant::*:field[@name eq 'copyrightDate']">
                        <xsl:value-of select="descendant::*:field[@name eq 'copyrightDate'][1]"/>
                      </xsl:when>
                      <xsl:when test="descendant::*:field[@name eq 'dateModified']">
                        <xsl:value-of select="descendant::*:field[@name eq 'dateModified'][1]"/>
                      </xsl:when>
                      <xsl:when test="descendant::*:field[@name eq 'dateValid']">
                        <xsl:value-of select="descendant::*:field[@name eq 'dateValid'][1]"/>
                      </xsl:when>
                      <xsl:when test="descendant::*:field[@name eq 'work_dateCreated']">
                        <xsl:value-of select="descendant::*:field[@name eq 'work_dateCreated'][1]"/>
                      </xsl:when>
                      <xsl:when test="descendant::*:field[@name eq 'dateOther']">
                        <xsl:value-of select="descendant::*:field[@name eq 'dateOther'][1]"/>
                      </xsl:when>
                      <xsl:when
                        test="descendant::*:field[@name eq 'seriesDetails'][matches(., '\d{4}(\s*-\s*\d{4})?')]">
                        <xsl:analyze-string
                          select="descendant::*:field[@name eq 'seriesDetails'][matches(., '\d{4}(\s*-\s*\d{4})?')][1]"
                          regex="\d{{4}}(\s*-\s*\d{{4}})?">
                          <xsl:matching-substring>
                            <xsl:value-of select="replace(., '-', ' TO ')"/>
                          </xsl:matching-substring>
                        </xsl:analyze-string>
                      </xsl:when>
                      <xsl:when
                        test="descendant::*:field[@name eq 'title'][matches(., '\d{4}(\s*-\s*\d{4})?')]">
                        <xsl:analyze-string
                          select="descendant::*:field[@name eq 'title'][matches(., '\d{4}(\s*-\s*\d{4})?')][1]"
                          regex="\d{{4}}(\s*-\s*\d{{4}})?">
                          <xsl:matching-substring>
                            <xsl:value-of select="replace(., '-', ' TO ')"/>
                          </xsl:matching-substring>
                        </xsl:analyze-string>
                      </xsl:when>
                    </xsl:choose>
                  </xsl:variable>
                  <xsl:if test="normalize-space($keyDate) ne ''">
                    <keyDate>
                      <xsl:choose>
                        <xsl:when test="matches($keyDate, '/')">
                          <xsl:variable name="date1">
                            <xsl:value-of
                              select="replace(replace(replace(substring-before(replace(replace($keyDate, '^[cp]', '', 'i'), '[~\?%]', ''), '/'), 'XXX', '000', 'i'), 'XX', '00', 'i'), 'X', '0', 'i')"
                            />
                          </xsl:variable>
                          <xsl:variable name="date2">
                            <xsl:value-of
                              select="replace(replace(replace(replace(substring-after(replace(replace($keyDate, '^[cp]', '', 'i'), '[~\?%]', ''), '/'), 'XXX', '999', 'i'), 'XX', '99', 'i'), 'X', '9', 'i'), '^9999$', '*')"
                            />
                          </xsl:variable>
                          <xsl:value-of select="concat('[', $date1, ' TO ', $date2, ']')"/>
                        </xsl:when>
                        <xsl:when test="matches($keyDate, '\d+X+', 'i')">
                          <xsl:value-of
                            select="
                              concat(replace($keyDate, 'X', '0', 'i'), ' TO ',
                              replace($keyDate, 'X', '9', 'i'))"
                          />
                        </xsl:when>
                        <xsl:when test="matches($keyDate, 'X', 'i')">
                          <xsl:value-of
                            select="replace(replace(replace(replace(replace($keyDate, '^[cp]', '', 'i'), '[~\?%]', ''), 'XXX', '000', 'i'), 'XX', '00', 'i'), 'X', '0', 'i')"
                          />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of
                            select="replace(replace($keyDate, '^[cp]', '', 'i'), '[~\?%]', '')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </keyDate>
                  </xsl:if>
                </xsl:for-each>
              </xsl:variable>
              <xsl:for-each select="distinct-values($keyDates/*:keyDate)">
                <!-- Ignore 'undated' values -->
                <xsl:if test="not(matches(., 'undated'))">
                  <field name="keyDate">
                    <xsl:value-of select="."/>
                  </field>
                </xsl:if>
              </xsl:for-each>
              <xsl:copy-of select="$components"/>
            </doc>
          </xsl:for-each-group>
        </xsl:when>
        <!-- No grouping or sorting performed -->
        <xsl:otherwise>
          <xsl:for-each select="descendant::*:mods">
            <!--<xsl:sort
              select="lower-case(normalize-space(concat(replace(*:titleInfo[1]/*:title[1], '[\s:]+$', ''), ' : ', *:titleInfo[1]/*:subTitle[1])))"/>-->
            <doc>
              <field name="originalMetadataType">MODS</field>
              <xsl:variable name="components">
                <field name="components">
                  <doc>
                    <xsl:apply-templates mode="resource"/>
                  </doc>
                </field>
              </xsl:variable>
              <xsl:copy-of select="$components"/>
              <xsl:variable name="keyDates">
                <xsl:for-each select="$components/*:field[@name eq 'components']/*:doc">
                  <xsl:variable name="keyDate">
                    <xsl:choose>
                      <xsl:when test="descendant::*:field[@name eq 'dateCreated']">
                        <xsl:value-of select="descendant::*:field[@name eq 'dateCreated'][1]"/>
                      </xsl:when>
                      <xsl:when test="descendant::*:field[@name eq 'dateIssued']">
                        <xsl:value-of select="descendant::*:field[@name eq 'dateIssued'][1]"/>
                      </xsl:when>
                      <xsl:when test="descendant::*:field[@name eq 'copyrightDate']">
                        <xsl:value-of select="descendant::*:field[@name eq 'copyrightDate'][1]"/>
                      </xsl:when>
                      <xsl:when test="descendant::*:field[@name eq 'dateModified']">
                        <xsl:value-of select="descendant::*:field[@name eq 'dateModified'][1]"/>
                      </xsl:when>
                      <xsl:when test="descendant::*:field[@name eq 'dateValid']">
                        <xsl:value-of select="descendant::*:field[@name eq 'dateValid'][1]"/>
                      </xsl:when>
                      <xsl:when test="descendant::*:field[@name eq 'work_dateCreated']">
                        <xsl:value-of select="descendant::*:field[@name eq 'work_dateCreated'][1]"/>
                      </xsl:when>
                      <xsl:when test="descendant::*:field[@name eq 'dateOther']">
                        <xsl:value-of select="descendant::*:field[@name eq 'dateOther'][1]"/>
                      </xsl:when>
                      <xsl:when
                        test="descendant::*:field[@name eq 'seriesDetails'][matches(., '\d{4}(\s*-\s*\d{4})?')]">
                        <xsl:analyze-string
                          select="descendant::*:field[@name eq 'seriesDetails'][matches(., '\d{4}(\s*-\s*\d{4})?')][1]"
                          regex="\d{{4}}(\s*-\s*\d{{4}})?">
                          <xsl:matching-substring>
                            <xsl:value-of select="replace(., '-', ' TO ')"/>
                          </xsl:matching-substring>
                        </xsl:analyze-string>
                      </xsl:when>
                      <xsl:when
                        test="descendant::*:field[@name eq 'title'][matches(., '\d{4}(\s*-\s*\d{4})?')]">
                        <xsl:analyze-string
                          select="descendant::*:field[@name eq 'title'][matches(., '\d{4}(\s*-\s*\d{4})?')][1]"
                          regex="\d{{4}}(\s*-\s*\d{{4}})?">
                          <xsl:matching-substring>
                            <xsl:value-of select="replace(., '-', ' TO ')"/>
                          </xsl:matching-substring>
                        </xsl:analyze-string>
                      </xsl:when>
                    </xsl:choose>
                  </xsl:variable>
                  <xsl:if test="normalize-space($keyDate) ne ''">
                    <keyDate>
                      <xsl:choose>
                        <xsl:when test="matches($keyDate, '/')">
                          <xsl:variable name="date1">
                            <xsl:value-of
                              select="replace(replace(replace(substring-before(replace(replace($keyDate, '^[cp]', '', 'i'), '[~\?%]', ''), '/'), 'XXX', '000', 'i'), 'XX', '00', 'i'), 'X', '0', 'i')"
                            />
                          </xsl:variable>
                          <xsl:variable name="date2">
                            <xsl:value-of
                              select="replace(replace(replace(replace(substring-after(replace(replace($keyDate, '^[cp]', '', 'i'), '[~\?%]', ''), '/'), 'XXX', '999', 'i'), 'XX', '99', 'i'), 'X', '9', 'i'), '^9999$', '*')"
                            />
                          </xsl:variable>
                          <xsl:value-of select="concat('[', $date1, ' TO ', $date2, ']')"/>
                        </xsl:when>
                        <xsl:when test="matches($keyDate, '\d+X+', 'i')">
                          <xsl:value-of
                            select="
                              concat(replace($keyDate, 'X', '0', 'i'), ' TO ',
                              replace($keyDate, 'X', '9', 'i'))"
                          />
                        </xsl:when>
                        <xsl:when test="matches($keyDate, 'X', 'i')">
                          <xsl:value-of
                            select="replace(replace(replace(replace(replace($keyDate, '^[cp]', '', 'i'), '[~\?%]', ''), 'XXX', '000', 'i'), 'XX', '00', 'i'), 'X', '0', 'i')"
                          />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of
                            select="replace(replace($keyDate, '^[cp]', '', 'i'), '[~\?%]', '')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </keyDate>
                  </xsl:if>
                </xsl:for-each>
              </xsl:variable>
              <xsl:for-each select="distinct-values($keyDates/*:keyDate)">
                <!-- Ignore 'undated' values -->
                <xsl:if test="not(matches(., 'undated'))">
                  <field name="keyDate">
                    <xsl:value-of select="."/>
                  </field>
                </xsl:if>
              </xsl:for-each>
              <xsl:copy-of select="$components"/>
            </doc>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </add>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- MATCH TEMPLATES FOR ELEMENTS                                            -->
  <!-- ======================================================================= -->

  <xsl:template match="*:titleInfo" mode="resource">
    <xsl:variable name="fieldName">
      <xsl:choose>
        <xsl:when test="matches(@type, 'abbreviated')">
          <xsl:text>abbreviatedTitle</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'alternative')">
          <xsl:text>alternativeTitle</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'translated')">
          <xsl:text>translatedTitle</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'uniform')">
          <xsl:text>work_title</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>title</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <field name="{$fieldName}">
      <xsl:value-of select="normalize-space(*:title)"/>
      <xsl:if test="*:nonSort">
        <xsl:value-of select="concat(', ', normalize-space(*:nonSort))"/>
      </xsl:if>
    </field>
    <xsl:for-each select="*:subTitle">
      <field name="subTitle">
        <xsl:value-of select="normalize-space(.)"/>
      </field>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="*:typeOfResource" mode="resource">
    <field name="contentType">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
    <xsl:if test="@collection">
      <field name="isCollection">yes</field>
    </xsl:if>
    <xsl:if test="@manuscript">
      <field name="isManuscript">yes</field>
    </xsl:if>
    <xsl:choose>
      <!-- internetMediaType and/or digitOrigin dictate mediaType and carrierType -->
      <xsl:when
        test="../*:physicalDescription/*[matches(local-name(), '(internetMediaType|digitalOrigin)')]">
        <field name="mediaType">computer</field>
        <field name="carrierType">online resource</field>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <!-- Map physicalDescription/form to mediaType -->
          <xsl:when
            test="
              ../*:physicalDescription/*:form[matches(normalize-space(.),
              'audio|computer|electronic resource|globe|kit|map|microform|microscopic|motion picture|nonprojected graphic|notated music|projected|projected graphic|remote sensing image|sound recording|stereographic|tactile material|text|unmediated|unspecified|video|videorecording')]">
            <field name="mediaType">
              <xsl:choose>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'electronic resource')]">
                  <xsl:text>computer</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'globe')]">
                  <xsl:text>unmediated</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'kit')]">
                  <xsl:text>unspecified</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'map')]">
                  <xsl:text>unmediated</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'motion picture')]">
                  <xsl:text>projected</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'nonprojected graphic')]">
                  <xsl:text>unmediated</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'notated music')]">
                  <xsl:text>unmediated</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'projected graphic')]">
                  <xsl:text>projected</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'remote sensing image')]">
                  <xsl:text>unmediated</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'sound recording')]">
                  <xsl:text>audio</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'stereographic')]">
                  <xsl:text>stereographic</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'tactile material')]">
                  <xsl:text>unmediated</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'text')]">
                  <xsl:text>unmediated</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'unmediated')]">
                  <xsl:text>unmediated</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'unspecified')]">
                  <xsl:text>unspecified</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'videorecording')]">
                  <xsl:text>video</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="normalize-space(.)"/>
                </xsl:otherwise>
              </xsl:choose>
            </field>
          </xsl:when>
          <!-- Use typeOfResource to determine mediaType -->
          <!--<xsl:when test="matches(., 'mixed material')">
            <field name="mediaType">unspecified</field>
          </xsl:when>-->
          <xsl:when test="matches(., 'text')">
            <field name="mediaType">unmediated</field>
          </xsl:when>
        </xsl:choose>

        <xsl:choose>
          <!-- Map physicalDescription/form to carrierType -->
          <xsl:when
            test="
              ../*:physicalDescription/*:form[matches(normalize-space(.),
              '(aperture card|art original|art reproduction|atlas|audio cartridge|audio cylinder|audio disc|audio roll|audiocassette|audiotape reel|braille|card|celestial globe|chart|collage|computer card|computer chip cartridge|computer disc|computer disc cartridge|computer tape cartridge|computer tape cassette|computer tape reel|cylinder|diagram|diorama|drawing|earth moon globe|electronic resource|film cartridge|film cassette|film reel|film roll|filmslip|filmstrip|filmstrip cartridge|flash card|flipchart|game|graphic|kit|large print|magnetic disk|magneto-optical disc|map|microfiche|microfiche cassette|microfilm cartridge|microfilm cassette|microfilm reel|microfilm roll|microfilm slip|microform|microopaque|microscope slide|model|moon|motion picture|object|online resource|optical disc|other audio carrier|other computer carrier|other filmstrip type|other microform carrier|other microscopic carrier|other projected carrier|other stereographic carrier|other unmediated carrier|other video carrier|overhead transparency|painting|photomechanical print|photonegative|photoprint|picture|planetary or lunar globe|print|profile|realia|regular print|remote|remote-sensing image|roll|section|sheet|slide|sound cartridge|sound cassette|sound disc|sound recording|sound track reel|sound-tape reel|sound-track film|stereograph card|stereograph disc|tactile, with no writing system|tape cartridge|tape cassette|tape reel|technical drawing|terrestrial globe|text in looseleaf binder|toy|transparency|unspecified|video cartridge|videocartridge|videocassette|videodisc|videorecording|videoreel|videotape reel|view|volume|wire recording)')]">
            <field name="carrierType">
              <xsl:choose>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'art original')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'art reproduction')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'atlas')]">
                  <xsl:text>volume</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'braille')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'celestial globe')]">
                  <xsl:text>object</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'chart')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'collage')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'cylinder')]">
                  <xsl:text>audio cylinder</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'diagram')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'diorama')]">
                  <xsl:text>object</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'drawing')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'earth moon globe')]">
                  <xsl:text>object</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'electronic resource')]">
                  <xsl:text>online resource</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'flash card')]">
                  <xsl:text>card</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'game')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'graphic')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'kit')]">
                  <xsl:text>unspecified</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'large print')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'magnetic disk')]">
                  <xsl:text>computer disc</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'magneto-optical disc')]">
                  <xsl:text>computer disc</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'map')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'microform')]">
                  <xsl:text>unspecified</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'model')]">
                  <xsl:text>object</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'moon')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'motion picture')]">
                  <xsl:text>other projected carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'optical disc')]">
                  <xsl:text>computer disc</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'other filmstrip type')]">
                  <xsl:text>filmstrip</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'painting')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when
                  test="../*:physicalDescription/*:form[matches(., 'photomechanical print')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'photonegative')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'photoprint')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'picture')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when
                  test="../*:physicalDescription/*:form[matches(., 'planetary or lunar globe')]">
                  <xsl:text>object</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'print')]">
                  <xsl:choose>
                    <xsl:when test="../*:typeOfResource[matches(., 'text')]">
                      <xsl:text>volume</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>other unmediated carrier</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'profile')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'realia')]">
                  <xsl:text>object</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'regular print')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'remote')]"
                  ><xsl:text>remot</xsl:text>e</xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'remote-sensing image')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'section')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'sound cartridge')]">
                  <xsl:text>audio cartridge</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'sound cassette')]">
                  <xsl:text>audiocassette</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'sound disc')]">
                  <xsl:text>audio disc</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'sound recording')]">
                  <xsl:text>other audio carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'sound-tape reel')]">
                  <xsl:text>sound track reel</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'sound-track film')]">
                  <xsl:text>sound track reel</xsl:text>
                </xsl:when>
                <xsl:when
                  test="../*:physicalDescription/*:form[matches(., 'tactile, with no writing system')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'tape cartridge')]">
                  <xsl:text>computer tape cartridge</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'tape cassette')]">
                  <xsl:text>computer tape cassette</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'tape reel')]">
                  <xsl:text>computer tape reel</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'technical drawing')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'terrestrial globe')]">
                  <xsl:text>object</xsl:text>
                </xsl:when>
                <xsl:when
                  test="../*:physicalDescription/*:form[matches(., 'text in looseleaf binder')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'toy')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'transparency')]">
                  <xsl:text>overhead transparency</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'videocartridge')]">
                  <xsl:text>video cartridge</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'videorecording')]">
                  <xsl:text>unspecified</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'videoreel')]">
                  <xsl:text>videotape reel</xsl:text>
                </xsl:when>
                <xsl:when test="../*:physicalDescription/*:form[matches(., 'view')]">
                  <xsl:text>other unmediated carrier</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="normalize-space(.)"/>
                </xsl:otherwise>
              </xsl:choose>
            </field>
          </xsl:when>
          <!-- Use typeOfResource to determine carrierType -->
          <!--<xsl:when test="matches(., 'mixed material')">
            <field name="carrierType">unspecified</field>
          </xsl:when>-->
          <xsl:when test="matches(., 'text')">
            <field name="carrierType">volume</field>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*:genre | *:subject/*:genre" mode="resource">
    <xsl:variable name="thisValue">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when
        test="parent::*:subject and not(preceding::*:subject/*:genre[matches(normalize-space(.), $thisValue)])">
        <field name="genre">
          <xsl:value-of select="normalize-space(.)"/>
          <!--<xsl:if test="@authority">
        <xsl:value-of select="concat(' (', normalize-space(@authority) ,')')"/>
      </xsl:if>-->
        </field>
      </xsl:when>
      <xsl:otherwise>
        <field name="genre">
          <xsl:value-of select="normalize-space(.)"/>
        </field>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*:identifier" mode="resource">
    <xsl:variable name="fieldName">
      <xsl:choose>
        <xsl:when test="matches(@type, 'lccn')">
          <xsl:text>libraryCongressControlNumber</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'isbn')">
          <xsl:text>internationalStandardBookNumber</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'issn')">
          <xsl:text>internationalStandardSerialNumber</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'isrc')">
          <xsl:text>internationalStandardRecordingCode</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'upc')">
          <xsl:text>universalProductCode</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'ismn')">
          <xsl:text>internationalStandardMusicNumber</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'ian')">
          <xsl:text>internationalArticleNumber</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'sici')">
          <xsl:text>serialItemContributionIdentifier</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, 'strn')">
          <xsl:text>standardTechnicalReportNumber</xsl:text>
        </xsl:when>
        <xsl:when test="matches(@type, '(stock-number|music-plate|music-publisher)')">
          <xsl:text>publisherDistributorNumber</xsl:text>
        </xsl:when>
        <xsl:when
          test="not(matches(@type, '(lccn|isbn|issn|isrc|upc|ismn|ian|sici|stm|stock-number|music-plate|music-publisher)'))">
          <xsl:text>localIdentifier</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <field name="{$fieldName}">
      <xsl:value-of select="normalize-space(.)"/>
      <xsl:call-template name="dataType"/>
    </field>
  </xsl:template>

  <xsl:template match="*:mods/*:abstract" mode="resource">
    <field name="abstractSummary">
      <xsl:call-template name="dataLabel"/>
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:physicalDescription" mode="resource">
    <xsl:apply-templates mode="resource"/>
  </xsl:template>

  <xsl:template match="*:originInfo" mode="resource">
    <xsl:apply-templates select="*:edition | *:frequency | *:issuance | *:place | *:publisher"
      mode="resource"/>
    <!-- Combine multiple dates of the same kind into a single display value -->
    <xsl:if test="*:copyrightDate">
      <xsl:call-template name="combineDates">
        <xsl:with-param name="field">copyrightDate</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="*:dateCaptured">
      <xsl:call-template name="combineDates">
        <xsl:with-param name="field">dateCaptured</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="*:dateCreated">
      <xsl:call-template name="combineDates">
        <xsl:with-param name="field">dateCreated</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="*:dateIssued">
      <xsl:call-template name="combineDates">
        <xsl:with-param name="field">dateIssued</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="*:dateModified">
      <xsl:call-template name="combineDates">
        <xsl:with-param name="field">dateModified</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="*:dateValid">
      <xsl:call-template name="combineDates">
        <xsl:with-param name="field">dateValid</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="*:dateOther[matches(@type, 'work_dateCreated')]">
      <field name="work_dateCreated">
        <xsl:value-of select="normalize-space(*:dateOther[matches(@type, 'work_dateCreated')])"/>
      </field>
    </xsl:if>
    <xsl:if test="*:dateOther[not(matches(@type, 'work_dateCreated'))]">
      <xsl:call-template name="combineDates">
        <xsl:with-param name="field">dateOther</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*:edition" mode="resource">
    <field name="editionVersion">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:frequency" mode="resource">
    <xsl:variable name="thisValue">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:variable>
    <xsl:if
      test="
        not(preceding-sibling::*:frequency[matches(normalize-space(.), $thisValue)])">
      <field name="frequency">
        <xsl:value-of select="normalize-space(.)"/>
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*:issuance" mode="resource">
    <field name="issuanceMethod">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:cartographics" mode="resource">
    <xsl:for-each select="*:coordinates | *:projection | *:scale">
      <xsl:variable name="fieldName">
        <xsl:value-of select="local-name()"/>
      </xsl:variable>
      <field name="{$fieldName}">
        <xsl:value-of select="normalize-space(.)"/>
      </field>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="*:language" mode="resource">
    <field name="language">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:tableOfContents" mode="resource">
    <field name="contents">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:classification" mode="resource">
    <field name="callNumber">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:hierarchicalGeographic" mode="resource">
    <field name="subjectGeographic">
      <xsl:for-each select="*">
        <xsl:if test="position() != 1">
          <xsl:text>--</xsl:text>
        </xsl:if>
        <xsl:value-of select="normalize-space(.)"/>
      </xsl:for-each>
    </field>
  </xsl:template>

  <xsl:template match="*:subject/*:temporal" mode="resource">
    <xsl:variable name="thisValue">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:variable>
    <xsl:if test="not(preceding::*:subject/*:temporal[matches(normalize-space(.), $thisValue)])">
      <field name="coverageDateTime">
        <xsl:value-of select="normalize-space(.)"/>
        <!--<xsl:if test="@authority">
        <xsl:value-of select="concat(' (', normalize-space(@authority) ,')')"/>
      </xsl:if>-->
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*:subject/*[matches(local-name(), 'geographic')]" mode="resource">
    <xsl:variable name="thisValue">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:variable>
    <xsl:if
      test="not(preceding::*:subject/*[matches(local-name(), 'geographic')][matches(normalize-space(.), $thisValue)])">
      <field name="coverageGeographic">
        <xsl:value-of select="normalize-space(.)"/>
        <!--<xsl:if test="@authority">
        <xsl:value-of select="concat(' (', normalize-space(@authority) ,')')"/>
      </xsl:if>-->
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*:subject" mode="resource">
    <xsl:apply-templates select="*:cartographics" mode="resource"/>
    <xsl:apply-templates select="*:genre" mode="resource"/>
    <xsl:apply-templates select="*:geographic | *:geographicCode" mode="resource"/>
    <xsl:apply-templates select="*:hierarchicalGeographic" mode="resource"/>
    <xsl:apply-templates select="*:temporal" mode="resource"/>
    <xsl:if test="*[not(matches(local-name(), '(cartographics|hierarchicalGeographic)'))]">
      <xsl:variable name="fieldName">
        <xsl:choose>
          <xsl:when
            test="matches(local-name(*[not(matches(local-name(), '(cartographics|hierarchicalGeographic)'))][1]), 'genre|occupation|topic')">
            <xsl:text>subjectTopic</xsl:text>
          </xsl:when>
          <xsl:when
            test="matches(local-name(*[not(matches(local-name(), '(cartographics|hierarchicalGeographic)'))][1]), 'geographic|geographicCode')">
            <xsl:text>subjectGeographic</xsl:text>
          </xsl:when>
          <xsl:when
            test="matches(local-name(*[not(matches(local-name(), '(cartographics|hierarchicalGeographic)'))][1]), 'name')">
            <xsl:text>subjectName</xsl:text>
          </xsl:when>
          <xsl:when
            test="matches(local-name(*[not(matches(local-name(), '(cartographics|hierarchicalGeographic)'))][1]), 'temporal')">
            <xsl:text>subjectChronologic</xsl:text>
          </xsl:when>
          <xsl:when
            test="matches(local-name(*[not(matches(local-name(), '(cartographics|hierarchicalGeographic)'))][1]), 'titleInfo')">
            <xsl:text>subjectTitle</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>subjectTopic</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <field name="{$fieldName}">
        <xsl:for-each select="*[not(matches(local-name(), 'cartographics|hierarchicalGeographic'))]">
          <xsl:if test="position() != 1">
            <xsl:text>--</xsl:text>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="matches(local-name(), 'name')">
              <xsl:apply-templates select="." mode="resource"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <!--<xsl:if test="@authority">
          <xsl:value-of select="concat(' (', normalize-space(@authority) ,')')"/>
        </xsl:if>-->
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*:digitalOrigin" mode="resource">
    <field name="digitalOrigin">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:internetMediaType" mode="resource">
    <field name="internetMediaType">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:extent" mode="resource">
    <xsl:variable name="parsedPhysDesc">
      <xsl:analyze-string select="normalize-space(.)" regex="[+]">
        <xsl:non-matching-substring>
          <field>
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:variable>
    <xsl:if test="exists($parsedPhysDesc/field[1])">
      <xsl:variable name="physDescABC">
        <xsl:analyze-string select="normalize-space($parsedPhysDesc/field[1])" regex="[:;]">
          <xsl:non-matching-substring>
            <field>
              <xsl:value-of select="normalize-space(.)"/>
            </field>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:variable>
      <field name="physExtent">
        <xsl:value-of select="normalize-space($physDescABC/field[1])"/>
      </field>
      <xsl:if
        test="exists($physDescABC/field[2]) and matches($physDescABC/field[2], '(charts|coats of arms|facsimiles|forms|genealogical tables|illuminations|ill(us(trations|\.)?|\.)?|maps|music|phonodisc|photographs|plans|plates|portraits|samples)')">
        <field name="illustrations">
          <xsl:variable name="fieldValue">
            <xsl:analyze-string select="$physDescABC/field[2]"
              regex="(charts|coats of arms|facsimiles|forms|genealogical tables|illuminations|ill(us(trations|\.)?|\.)?|maps|music|phonodisc|photographs|plans|plates|portraits|samples)">
              <xsl:matching-substring>
                <xsl:value-of
                  select="concat(replace(., 'ill(us(trations|\.)?|\.)?', 'illustrations'), ', ')"/>
              </xsl:matching-substring>
            </xsl:analyze-string>
          </xsl:variable>
          <xsl:value-of select="replace($fieldValue, ', $', '')"/>
        </field>
      </xsl:if>
      <xsl:if
        test="exists($physDescABC/field[2]) and matches($physDescABC/field[2], '(col(\.|or)|b&amp;w|black and white)')">
        <field name="color">
          <xsl:variable name="fieldValue">
            <xsl:analyze-string select="$physDescABC/field[2]"
              regex="(col(\.|or)|b&amp;w|black and white)">
              <xsl:matching-substring>
                <xsl:value-of
                  select="concat(replace(replace(., 'col\.', 'color'), 'b&amp;w', 'black and white'), ', ')"
                />
              </xsl:matching-substring>
            </xsl:analyze-string>
          </xsl:variable>
          <xsl:value-of select="replace($fieldValue, ', $', '')"/>
        </field>
      </xsl:if>
      <xsl:if test="exists($physDescABC/field[2])">
        <xsl:variable name="fieldValue">
          <xsl:analyze-string select="$physDescABC/field[2]"
            regex="(col(\.|or)|b&amp;w|black and white|charts|coats of arms|facsimiles|forms|genealogical tables|illuminations|ill(us(trations|\.)?|\.)?|maps|music|phonodisc|photographs|plans|plates|portraits|samples)">
            <xsl:non-matching-substring>
              <xsl:value-of select="concat(., ', ')"/>
            </xsl:non-matching-substring>
          </xsl:analyze-string>
        </xsl:variable>
        <xsl:if test="normalize-space(replace($fieldValue, '(, )+$', '')) ne ''">
          <field name="physDetails">
            <xsl:value-of select="replace($fieldValue, '(, )+$', '')"/>
          </field>
        </xsl:if>
      </xsl:if>
      <xsl:if test="exists($physDescABC/field[3])">
        <field name="physDimensions">
          <xsl:value-of select="normalize-space($physDescABC/field[3])"/>
        </field>
      </xsl:if>
    </xsl:if>
    <xsl:if test="exists($parsedPhysDesc/field[2])">
      <field name="accMatter">
        <xsl:value-of select="normalize-space($parsedPhysDesc/field[2])"/>
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*:reformattingQuality" mode="resource">
    <field name="reformattingQuality">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:form" mode="resource">
    <xsl:variable name="thisValue">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:variable>
    <!-- Emit field only if there's not another matching form value and the value hasn't already been used to populate mediaType or carrierType -->
    <xsl:if
      test="not(matches(normalize-space(.), '^(audio|audio cartridge|audio disc|audiocassette|card|computer|computer disc|computer tape cartridge|computer tape cassette|computer tape reel|filmstrip|object|online resource|other audio carrier|other projected carrier|other unmediated carrier|overhead transparency|projected|remote|sound track reel|stereographic|unmediated|unspecified|unspecified|video|video cartridge|videotape reel|volume)$'))">
      <field name="physDetails">
        <xsl:value-of select="normalize-space(.)"/>
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*:note" mode="resource">
    <xsl:variable name="fieldName">
      <xsl:choose>
        <xsl:when test="matches(@type, 'biographical/historical')">biogHist</xsl:when>
        <xsl:when test="matches(@type, 'ownership')">custodHist</xsl:when>
        <xsl:when test="matches(@type, 'acquisition')">acqInfo</xsl:when>
        <xsl:when test="matches(@type, 'funding')">sponsor</xsl:when>
        <xsl:when test="matches(@type, 'preferred citation')">preferredCitation</xsl:when>
        <xsl:when test="matches(@type, 'action')">appraisalProcessInfo</xsl:when>
        <xsl:when test="matches(@type, 'accrual (method|policy)')">accruals</xsl:when>
        <xsl:when test="matches(@type, 'creation/production credits')">credits</xsl:when>
        <xsl:when test="matches(@type, 'performers')">performers</xsl:when>
        <xsl:when test="matches(@type, 'additional physical form')">addPhysicalForm</xsl:when>
        <xsl:when test="matches(@type, 'original location|original version|source characteristics')"
          >originalsNote</xsl:when>
        <xsl:when test="matches(@type, 'citation/reference')">referencedBy</xsl:when>
        <xsl:when test="matches(@type, 'publications')">publications</xsl:when>
        <xsl:when test="matches(@type, 'restriction')">accessRestrict</xsl:when>
        <xsl:when test="matches(@type, 'physical details')">physDetails</xsl:when>
        <xsl:when
          test="matches(@type, 'bibliography') or matches(., 'bibliographic(al)? references')"
          >bibliography</xsl:when>
        <xsl:otherwise>
          <xsl:text>note</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <field name="{$fieldName}">
      <xsl:call-template name="dataLabel"/>
      <xsl:value-of select="normalize-space(.)"/>
    </field>
    <xsl:if test="matches(., 'includes.*index', 'i')">
      <field name="containsIndex">yes</field>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*:publisher" mode="resource">
    <field name="pubProdDist">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:place" mode="resource">
    <field name="pubProdDistPlace">
      <xsl:for-each select="*">
        <xsl:if test="position() != 1">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:value-of select="normalize-space(.)"/>
      </xsl:for-each>
    </field>
  </xsl:template>

  <xsl:template match="*:location" mode="resource">
    <xsl:apply-templates
      select="*:physicalLocation | *:shelfLocator | *:url | *:holdingSimple/*:copyInformation/*:subLocation"
      mode="resource"/>
  </xsl:template>

  <xsl:template match="*:physicalLocation" mode="resource">
    <field name="physLocation">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:subLocation" mode="resource">
    <field name="physSublocation">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:shelfLocator" mode="resource">
    <field name="callNumber">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:url" mode="resource">
    <field name="uri">
      <xsl:value-of select="replace(normalize-space(.), '\s+', '')"/>
      <xsl:call-template name="dataType"/>
    </field>
  </xsl:template>

  <xsl:template match="*:part" mode="resource">
    <field name="seriesDetails">
      <xsl:variable name="detailsValue">
        <xsl:for-each select="*:detail">
          <xsl:if test="position() != 1">
            <xsl:text>, </xsl:text>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="*:caption">
              <xsl:value-of select="concat(*:caption, ' ')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="dataLabel"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="normalize-space(*:number | *:title)"/>
        </xsl:for-each>
        <xsl:for-each select="*:text">
          <xsl:value-of select="concat(', ', normalize-space(.))"/>
        </xsl:for-each>
        <xsl:if test="*:extent[*:list or *:start]">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:for-each select="*:extent">
          <xsl:choose>
            <xsl:when test="*:list">
              <xsl:value-of select="normalize-space(*:list)"/>
            </xsl:when>
            <xsl:when test="*:start">
              <xsl:if test="@unit">
                <xsl:value-of select="concat(normalize-space(@unit), ' ')"/>
              </xsl:if>
              <xsl:value-of select="normalize-space(*:start)"/>
              <xsl:choose>
                <xsl:when test="*:end">
                  <xsl:value-of select="concat('-', *:end)"/>
                </xsl:when>
                <xsl:when test="*:start[matches(., '^\d+$')] and *:total[matches(., '^\d+$')]">
                  <xsl:value-of select="concat('-', number(*:start) + number(*:total))"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of
                    select="concat('- (', normalize-space(*:total), ' ', normalize-space(@unit), ')')"
                  />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="*:total">
              <xsl:value-of
                select="concat(' (', normalize-space(*:total), ' ', normalize-space(@unit), ')')"/>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="*:date">
          <xsl:value-of select="concat(', ', normalize-space(.))"/>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space(replace($detailsValue, '^,\s+', ''))"/>
    </field>
  </xsl:template>

  <xsl:template match="*:relatedItem[@type eq 'series']" mode="resource">
    <xsl:for-each select="*:titleInfo">
      <field name="seriesTitle">
        <xsl:value-of select="normalize-space(*:title)"/>
        <xsl:if test="*:nonSort">
          <xsl:value-of select="concat(', ', normalize-space(*:nonSort))"/>
        </xsl:if>
      </field>
    </xsl:for-each>
    <xsl:apply-templates select="*:part" mode="resource"/>
  </xsl:template>

  <xsl:template match="*:relatedItem[@type eq 'original']" mode="resource">
    <field name="original">
      <doc>
        <xsl:apply-templates mode="resource"/>
      </doc>
    </field>
  </xsl:template>

  <xsl:template match="*:relatedItem[@type eq 'host']" mode="resource">
    <field name="host">
      <doc>
        <xsl:apply-templates mode="resource"/>
      </doc>
    </field>
  </xsl:template>

  <xsl:template match="*:accessCondition" mode="resource">
    <xsl:choose>
      <xsl:when test="matches(@type, 'access')">
        <field name="accessRestrict">
          <xsl:value-of select="normalize-space(.)"/>
        </field>
      </xsl:when>
      <xsl:otherwise>
        <field name="useRestrict">
          <xsl:value-of select="normalize-space(.)"/>
        </field>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*:name[parent::*:subject]" mode="resource">
    <xsl:choose>
      <!-- Inverted name order based on @type -->
      <xsl:when test="*:namePart and (count(*:namePart[@type]) = count(*:namePart))">
        <xsl:value-of select="*:namePart[matches(@type, 'family')]"/>
        <xsl:if test="*:namePart[matches(@type, 'given')]">
          <xsl:text>, </xsl:text>
          <xsl:value-of select="*:namePart[matches(@type, 'given')]"/>
        </xsl:if>
        <xsl:if test="*:namePart[matches(@type, 'date')]">
          <xsl:text>, </xsl:text>
          <xsl:value-of select="*:namePart[matches(@type, 'date')]"/>
        </xsl:if>
      </xsl:when>
      <!-- Use <displayForm>, which should contain name in direct order -->
      <xsl:when test="*:displayForm">
        <xsl:value-of select="*:displayForm"/>
      </xsl:when>
      <!-- Use document order -->
      <xsl:otherwise>
        <xsl:for-each
          select="*[not(matches(local-name(), 'affiliation|description|displayForm|role'))]">
          <xsl:if test="position() != 1">
            <xsl:text>&#32;</xsl:text>
          </xsl:if>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="*:affiliation | *:role">
      <xsl:text> (</xsl:text>
      <xsl:for-each select="*:affiliation | *:role/*:roleTerm">
        <xsl:if test="position() != 1">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:value-of select="normalize-space(.)"/>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*:work_dateCreated" mode="resource">
    <field name="work_dateCreated">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:targetAudience" mode="resource">
    <field name="targetAudience">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:name" mode="resource">
    <xsl:variable name="fieldName">
      <xsl:choose>
        <xsl:when test="descendant::*:roleTerm[matches(., 'creator')]">
          <xsl:text>creator</xsl:text>
        </xsl:when>
        <xsl:when test="count(preceding-sibling::*:name) + count(following-sibling::*:name) = 0">
          <xsl:text>creator</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>contributor</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <field name="{$fieldName}">
      <xsl:choose>
        <!-- Inverted name order based on @type -->
        <xsl:when test="*:namePart and (count(*:namePart[@type]) = count(*:namePart))">
          <xsl:value-of select="*:namePart[matches(@type, 'family')]"/>
          <xsl:if test="*:namePart[matches(@type, 'given')]">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="*:namePart[matches(@type, 'given')]"/>
          </xsl:if>
          <xsl:if test="*:namePart[matches(@type, 'date')]">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="*:namePart[matches(@type, 'date')]"/>
          </xsl:if>
        </xsl:when>
        <!-- Use <displayForm>, which should contain name in direct order -->
        <xsl:when test="*:displayForm">
          <xsl:value-of select="*:displayForm"/>
        </xsl:when>
        <!-- Use document order -->
        <xsl:otherwise>
          <xsl:for-each
            select="*[not(matches(local-name(), 'affiliation|description|displayForm|role'))]">
            <xsl:if test="position() != 1">
              <xsl:text>&#32;</xsl:text>
            </xsl:if>
            <xsl:value-of select="normalize-space(.)"/>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="*:affiliation | *:role">
        <xsl:text> (</xsl:text>
        <xsl:for-each select="*:affiliation | *:role/*:roleTerm">
          <xsl:if test="position() != 1">
            <xsl:text>, </xsl:text>
          </xsl:if>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:for-each>
        <xsl:text>)</xsl:text>
      </xsl:if>
      <!--<xsl:if test="@authority">
        <xsl:value-of select="concat(' (', normalize-space(@authority) ,')')"/>
      </xsl:if>-->
    </field>
    <xsl:if test="*:description">
      <field name="creatorContributorCharacter">
        <xsl:for-each select="*:description">
          <xsl:if test="position() != 1">
            <xsl:text>; </xsl:text>
          </xsl:if>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:for-each>
      </field>
    </xsl:if>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- IDENTITY/COPY/DEFAULT TEMPLATES                                         -->
  <!-- ======================================================================= -->

  <!-- Drop elements which aren't matched elsewhere -->
  <xsl:template match="node()" mode="resource"/>


</xsl:stylesheet>
