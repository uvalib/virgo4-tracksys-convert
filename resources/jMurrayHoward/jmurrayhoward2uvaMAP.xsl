<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="#all" version="2.0">

  <xsl:output method="xml" indent="yes"/>

  <xsl:param name="externalSSIDfile">
    <xsl:text>JMurrayHoward_supplemental-metadata.xml</xsl:text>
  </xsl:param>

  <!-- program name -->
  <xsl:variable name="progName">
    <xsl:text>jmurrayhoward2uvaMAP.xsl</xsl:text>
  </xsl:variable>

  <!-- program version -->
  <xsl:variable name="progVersion">
    <xsl:text>0.1 beta</xsl:text>
  </xsl:variable>

  <!-- new line -->
  <xsl:variable name="nl">
    <xsl:text>&#xa;</xsl:text>
  </xsl:variable>

  <xsl:variable name="ssidLookup">
    <xsl:copy-of select="document($externalSSIDfile)"/>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:comment>
      <xsl:text>&#32;Generated using </xsl:text>
      <xsl:value-of select="$progName"/>
      <xsl:text> (v. </xsl:text>
      <xsl:value-of select="$progVersion"/>
      <xsl:text>) on </xsl:text>
      <xsl:value-of select="format-date(current-date(), '[Y]-[M01]-[D01]')"/>
      <xsl:text> at </xsl:text><xsl:value-of select="format-time(current-time(), '[h]:[m] [P]')"/>
      <xsl:text>&#32;</xsl:text>
    </xsl:comment>
    <uvaMAP>
      <!-- Exclude records without Work_Type -->
      <xsl:apply-templates select="descendant::*:image[*:Work_Type and *:SSID]"/>
    </uvaMAP>
  </xsl:template>

  <xsl:template match="*:image">

    <xsl:variable name="thisSSID">
      <xsl:value-of select="normalize-space(*:SSID)"/>
    </xsl:variable>

    <xsl:choose>
      <!-- Process records that have a corresponding imageUrl in the supplemental-metadata.xml file -->
      <xsl:when test="$ssidLookup//*:image/*:ssid[. eq $thisSSID]">
        <xsl:variable name="keyDate">
          <xsl:choose>
            <xsl:when test="*:Earliest_Date or *:Latest_Date">
              <xsl:choose>
                <xsl:when test="normalize-space(*:Earliest_Date) eq normalize-space(*:Latest_Date)">
                  <xsl:value-of select="normalize-space(*:Earliest_Date)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>[</xsl:text>
                  <xsl:choose>
                    <xsl:when test="normalize-space(*:Earliest_Date) eq ''">
                      <xsl:text>*</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="normalize-space(*:Earliest_Date)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:text> TO </xsl:text>
                  <xsl:choose>
                    <xsl:when test="normalize-space(*:Latest_Date) eq ''">
                      <xsl:text>*</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="normalize-space(*:Latest_Date)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:text>]</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="matches(normalize-space(*:Image_Date), '^\d+(-\d{2}(-\d{2})*)*$')">
              <xsl:value-of select="*:Image_Date"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <doc>
          <field name="metadataSource">JStor Forum</field>
          <field name="originalMetadataType">Excel</field>
          <field name="sourceRecordIdentifier" source="JStor Forum" type="SSID">
            <xsl:value-of select="*:SSID"/>
          </field>
          <xsl:choose>
            <xsl:when test="normalize-space($keyDate) ne ''">
              <field name="keyDate">
                <xsl:value-of select="$keyDate"/>
              </field>
            </xsl:when>
            <xsl:otherwise>
              <xsl:comment>&#32;No keyDate found&#32;</xsl:comment>
            </xsl:otherwise>
          </xsl:choose>
          <field name="contentType">still image</field>
          <field name="mediaType">computer</field>
          <field name="carrierType">online resource</field>
          <field name="digitalOrigin">reformatted digital</field>
          <field name="identifier" type="fileNname">
            <xsl:value-of select="*:Filename"/>
          </field>
          <field name="identifier" type="ArtStorID">
            <xsl:value-of select="$ssidLookup//*:image/*:ssid[. eq $thisSSID]/../*:artstorId"/>
          </field>
          <field name="internetMediaType">
            <xsl:value-of
              select="concat('image/', tokenize(normalize-space(*:Filename), '\.')[last()])"/>
          </field>
          <field name="pubProdDist">Rector and Visitors of the University of Virginia</field>
          <field name="pubProdDistPlace">Charlottesville, Va.</field>

          <!-- URLs -->
          <field name="uri" access="object in context" usage="primary">
            <xsl:value-of select="$ssidLookup//*:image/*:ssid[. eq $thisSSID]/../*:objectInContext"
            />
          </field>
          <field name="uri" access="object in context">
            <xsl:value-of
              select="concat('https://doi.org/', $ssidLookup//*:image/*:ssid[. eq $thisSSID]/../*:doi)"
            />
          </field>
          <field name="uri" access="raw object">
            <xsl:value-of
              select="$ssidLookup//*:image/*:ssid[. eq $thisSSID]/../*:iiifImageManifest"/>
          </field>
          <xsl:apply-templates select="*:Media_URL"/>

          <xsl:choose>
            <xsl:when test="*:Work_Type eq 'photographs'">
              <!-- title -->
              <xsl:analyze-string select="*:Title" regex="\|">
                <xsl:non-matching-substring>
                  <xsl:variable name="fieldName">
                    <xsl:choose>
                      <xsl:when test="position() = 1">
                        <xsl:text>title</xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:text>alternativeTitle</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <field name="{$fieldName}">
                    <xsl:value-of
                      select="concat(upper-case(substring(normalize-space(.), 1, 1)), substring(normalize-space(.), 2))"
                    />
                  </field>
                </xsl:non-matching-substring>
              </xsl:analyze-string>
              <!-- displayTitle -->
              <field name="displayTitle">
                <xsl:variable name="displayTitle">
                  <xsl:value-of select="normalize-space(*:Title)"/>
                  <!--<xsl:value-of select="normalize-space(tokenize(*:Title, '\|')[1])"/>-->
                </xsl:variable>
                <xsl:value-of
                  select="concat(upper-case(substring($displayTitle, 1, 1)), substring($displayTitle, 2))"
                />
              </field>
              <!-- sortTitle -->
              <field name="sortTitle">
                <xsl:variable name="sortTitle">
                  <xsl:value-of select="normalize-space(*:Title)"/>
                </xsl:variable>
                <xsl:value-of select="lower-case(replace($sortTitle, '^(a|an|the) ', '', 'i'))"/>
              </field>
              <!-- Abstract/Summary/Description -->
              <xsl:apply-templates select="*:Image_View_Description"/>
              <!-- Original creator(s) -->
              <xsl:apply-templates select="*:Photographer"/>
              <xsl:apply-templates select="*:Image_Date"/>
              <xsl:apply-templates select="*:ID_Number"/>
              <xsl:apply-templates
                select="*:Description[matches(../*:Work_Type, 'photographs', 'i')]"/>
              <field name="work_type">
                <xsl:value-of select="normalize-space(*:Work_Type)"/>
              </field>
              <!--<xsl:variable name="workCreator">
                <xsl:value-of select="*:Creator"/>
              </xsl:variable>-->
              <xsl:analyze-string select="*:Title" regex="\|">
                <xsl:non-matching-substring>
                  <xsl:variable name="fieldName">
                    <xsl:choose>
                      <xsl:when test="position() = 1">
                        <xsl:text>work_title</xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:text>work_alternativeTitle</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <field name="{$fieldName}">
                    <xsl:choose>
                      <xsl:when test="$fieldName eq 'work_title'">
                        <xsl:attribute name="supplied">
                          <xsl:text>yes</xsl:text>
                        </xsl:attribute>
                        <xsl:variable name="workTitleDate">
                          <xsl:value-of
                            select="normalize-space(replace(replace(replace($keyDate, ' TO ', '/'), '\*', ''), '[\[\]]', ''))"
                          />
                        </xsl:variable>
                        <xsl:value-of select="normalize-space(.)"/>
                        <!--<xsl:if test="normalize-space($workCreator) ne ''">
                          <xsl:value-of select="concat('¶', normalize-space($workCreator))"/>
                        </xsl:if>-->
                        <xsl:value-of select="concat('¶', 'still image')"/>
                        <xsl:if test="normalize-space($workTitleDate) ne ''">
                          <xsl:value-of select="concat('¶', $workTitleDate)"/>
                        </xsl:if>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="normalize-space(.)"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </field>
                </xsl:non-matching-substring>
              </xsl:analyze-string>
              <xsl:apply-templates select="*:Relationship_depicts | *:Relationship_relatedTo"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="rawTitle">
                <xsl:choose>
                  <xsl:when test="*:Image_View_Type">
                    <xsl:value-of select="normalize-space(*:Image_View_Type)"/>
                  </xsl:when>
                  <xsl:when test="*:Title">
                    <xsl:value-of select="normalize-space(*:Title)"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:variable>
              <xsl:if test="normalize-space($rawTitle) ne ''">
                <!-- title -->
                <xsl:analyze-string select="$rawTitle" regex="\|">
                  <!--<xsl:analyze-string select="*:Image_View_Description" regex="\|">-->
                  <xsl:non-matching-substring>
                    <xsl:variable name="fieldName">
                      <xsl:choose>
                        <xsl:when test="position() = 1">
                          <xsl:text>title</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text>alternativeTitle</xsl:text>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>
                    <field name="{$fieldName}">
                      <xsl:value-of
                        select="concat(upper-case(substring(normalize-space(.), 1, 1)), substring(normalize-space(.), 2))"
                      />
                    </field>
                  </xsl:non-matching-substring>
                </xsl:analyze-string>
                <!-- displayTitle -->
                <field name="displayTitle">
                  <xsl:variable name="displayTitle">
                    <xsl:value-of select="concat(normalize-space(tokenize(*:Title, '\|')[1]), ', ')"/>
                    <xsl:value-of select="normalize-space(*:Image_View_Type)"/>
                    <!--<xsl:value-of select="normalize-space(tokenize($rawTitle, '\|')[1])"/>-->
                  </xsl:variable>
                  <xsl:value-of
                    select="concat(upper-case(substring($displayTitle, 1, 1)), substring($displayTitle, 2))"
                  />
                </field>
                <!-- sortTitle -->
                <field name="sortTitle">
                  <xsl:variable name="sortTitle">
                    <xsl:value-of select="normalize-space($rawTitle)"/>
                  </xsl:variable>
                  <xsl:value-of select="lower-case(replace($sortTitle, '^(a|an|the) ', '', 'i'))"/>
                </field>
              </xsl:if>

              <!-- Abstract/summary/description -->
              <xsl:apply-templates select="*:Image_View_Description"/>

              <!-- Original creator(s) -->
              <xsl:apply-templates select="*:Photographer"/>
              <xsl:apply-templates select="*:Image_Date"/>
              <xsl:apply-templates select="*:ID_Number"/>

              <!-- Work info -->
              <field name="work_type">
                <xsl:value-of select="normalize-space(*:Work_Type)"/>
              </field>
              <xsl:analyze-string select="*:Title" regex="\|">
                <xsl:non-matching-substring>
                  <xsl:variable name="fieldName">
                    <xsl:choose>
                      <xsl:when test="position() = 1">
                        <xsl:text>work_title</xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:text>work_alternativeTitle</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <field name="{$fieldName}">
                    <xsl:choose>
                      <xsl:when test="$fieldName eq 'work_title'">
                        <xsl:attribute name="supplied">
                          <xsl:text>yes</xsl:text>
                        </xsl:attribute>
                        <xsl:variable name="workTitleDate">
                          <xsl:value-of
                            select="normalize-space(replace(replace(replace($keyDate, ' TO ', '/'), '\*', ''), '[\[\]]', ''))"
                          />
                        </xsl:variable>
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:value-of select="concat('¶', 'still image')"/>
                        <xsl:if test="normalize-space($workTitleDate) ne ''">
                          <xsl:value-of select="concat('¶', $workTitleDate)"/>
                        </xsl:if>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="normalize-space(.)"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </field>
                </xsl:non-matching-substring>
              </xsl:analyze-string>
              <xsl:apply-templates select="*:Relationship_depicts | *:Relationship_relatedTo"/>
              <xsl:apply-templates
                select="*:Creator[not(matches(../*:Work_Type, 'photographs', 'i'))]"/>
              <xsl:apply-templates select="*:Date"/>
              <xsl:apply-templates select="*:Current_Site | *:Spatial_coordinates"/>
              <xsl:apply-templates
                select="*:Description[not(matches(../*:Work_Type, 'photographs', 'i'))]"/>
              <xsl:apply-templates select="*:Measurements"/>
              <xsl:apply-templates select="*:Materials_Techniques"/>
            </xsl:otherwise>
          </xsl:choose>

          <!-- collection name -->
          <xsl:apply-templates select="*:Collection"/>

          <!-- accession number -->
          <!--<xsl:apply-templates select="*:Repository_Accession_Number"/>-->

          <!-- Acquisition info -->
          <xsl:apply-templates select="*:Collector"/>

          <!-- orig_useRestrict / rights -->
          <!-- Hard-code since some records don't have a <Rights> field -->
          <field name="useRestrict" valueURI="https://rightsstatements.org/vocab/InC/1.0/">In
            copyright</field>

          <!-- Subject terms -->
          <xsl:apply-templates select="*:Artstor_Classification | *:Image_Subject | *:Work_Subject"/>
          <xsl:apply-templates select="*:Culture | *:Style_Period"/>

        </doc>
      </xsl:when>
      <!-- Report records that don't have a corresponding imageUrl in the supplemental-metadata.xml file -->
      <xsl:otherwise>
        <xsl:message>URL for SSID <xsl:value-of select="$thisSSID"/> not found in <xsl:value-of
          select="$externalSSIDfile"/></xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*:Relationship_depicts | *:Relationship_relatedTo">
    <field name="work_relatedWork">
      <xsl:value-of select="normalize-space(tokenize(., '\|')[1])"/>
      <!--<xsl:value-of select="normalize-space(.)"/>-->
    </field>
  </xsl:template>

  <xsl:template match="*:ID_Number">
    <field name="orig_identifier">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:Collector">
    <field name="host_creator" role="collector">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:Image_View_Description">
    <field name="abstractSummary">
      <xsl:value-of
        select="concat(upper-case(substring(normalize-space(.), 1, 1)), substring(normalize-space(.), 2))"
      />
    </field>
  </xsl:template>

  <xsl:template match="*:Measurements">
    <field name="work_physDimensions">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:Materials_Techniques">
    <field name="work_physDetails">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:Country | *:Current_Site">
    <field name="work_workLocation">
      <xsl:if test="matches(normalize-space(.), '^site: ')">
        <xsl:attribute name="type">site</xsl:attribute>
      </xsl:if>
      <xsl:variable name="locationSteps">
        <xsl:analyze-string select="replace(normalize-space(.), '^site: ', '', 'i')" regex=",\s*">
          <xsl:non-matching-substring>
            <locationStep>
              <xsl:value-of select="normalize-space(.)"/>
            </locationStep>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:variable>
      <xsl:for-each select="distinct-values($locationSteps/*:locationStep)">
        <xsl:if test="position() &gt; 1">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:value-of select="."/>
      </xsl:for-each>
    </field>
  </xsl:template>

  <xsl:template match="*:Spatial_coordinates">
    <field name="work_workLocation" type="site">
      <xsl:value-of select="replace(normalize-space(.), '\s*[;,]\s*', ', ')"/>
    </field>
  </xsl:template>

  <xsl:template match="*:Collection">
    <field name="host_title">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:Media_URL">
    <field name="uri" access="raw object">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:Image_Date">
    <field name="orig_dateCreated">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:Photographer">
    <xsl:analyze-string select="." regex=";">
      <xsl:non-matching-substring>
        <field name="orig_creator" role="photographer">
          <xsl:value-of select="normalize-space(.)"/>
        </field>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template match="*:Creator[not(matches(../*:Work_Type, 'photographs', 'i'))]">
    <xsl:analyze-string select="." regex="\|">
      <xsl:non-matching-substring>
        <xsl:variable name="fieldName">
          <xsl:choose>
            <xsl:when test="position() = 1">
              <xsl:text>work_creator</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>work_contributor</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <field name="{$fieldName}">
          <xsl:variable name="role">
            <xsl:value-of select="tokenize(normalize-space(.), '\([^\)]+\)')[last()]"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="normalize-space($role) ne ''">
              <xsl:attribute name="role">
                <xsl:value-of select="normalize-space($role)"/>
              </xsl:attribute>
              <xsl:variable name="roleVariable">
                <xsl:value-of select="concat($role, '$')"/>
              </xsl:variable>
              <xsl:value-of select="replace(normalize-space(.), $roleVariable, '')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:otherwise>
          </xsl:choose>
        </field>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template match="*:Date">
    <xsl:analyze-string select="." regex=";">
      <xsl:non-matching-substring>
        <xsl:choose>
          <xsl:when test="matches(., '\(creation\)')">
            <field name="work_dateCreated">
              <xsl:value-of select="normalize-space(replace(., '\(creation\)', ''))"/>
            </field>
          </xsl:when>
          <xsl:when test="matches(., '\([^\)]+\)')">
            <field name="work_dateOther">
              <xsl:attribute name="type">
                <xsl:analyze-string select="." regex="\([^\)]+\)">
                  <xsl:matching-substring>
                    <xsl:value-of select="normalize-space(replace(., '[\(\)]', ''))"/>
                  </xsl:matching-substring>
                </xsl:analyze-string>
              </xsl:attribute>
              <xsl:value-of select="normalize-space(.)"/>
            </field>
          </xsl:when>
          <xsl:otherwise>
            <field name="work_dateCreated">
              <xsl:value-of select="normalize-space(.)"/>
            </field>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template match="*:Description">
    <field name="work_abstractSummary">
      <xsl:value-of select="normalize-space(replace(., '\|', ' '))"/>
    </field>
  </xsl:template>

  <xsl:template match="*:Culture">
    <field name="culturalContext">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:Style_Period">
    <xsl:analyze-string select="." regex=";">
      <xsl:non-matching-substring>
        <field name="stylePeriod">
          <xsl:value-of select="normalize-space(.)"/>
        </field>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <!--<xsl:template match="*:Repository_Accession_Number">
    <field name="host_identifier" type="Accession Number">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>-->

  <xsl:template match="*:Artstor_Classification">
    <field name="subject" authority="AAT">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:Image_Subject | *:Work_Subject">
    <xsl:analyze-string select="." regex=";">
      <xsl:non-matching-substring>
        <xsl:if test="normalize-space(.) ne ''">
          <field name="subject" authority="AAT">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:if>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template match="* | comment() | @*" mode="#all">
    <xsl:copy>
      <xsl:apply-templates select="node() | comment() | @*" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text()" mode="#all">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

</xsl:stylesheet>
