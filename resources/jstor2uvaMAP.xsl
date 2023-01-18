<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="#all" version="2.0">

  <xsl:output method="xml" indent="yes"/>

  <xsl:param name="externalSSIDfile" select="''"/>

  <xsl:param name="defaultRightsText">Attribution-NonCommercial 2.0 Generic (CC BY-NC
    2.0)</xsl:param>

  <xsl:param name="defaultRightsURI">https://creativecommons.org/licenses/by-nc/2.0/</xsl:param>

  <xsl:param name="outDirName" select="'uvaMAP'"/>

  <xsl:param name="schemaLocation" select="''"/>
  <!-- file:/C:/Users/pdr4h/OneDrive%20-%20University%20of%20Virginia/Documents/uvaMAP/uvaMAP.rng -->

  <!-- program name -->
  <xsl:variable name="progName">
    <xsl:text>jstor2uvaMAP.xsl</xsl:text>
  </xsl:variable>

  <!-- program version -->
  <xsl:variable name="progVersion">
    <xsl:text>0.1 beta</xsl:text>
  </xsl:variable>

  <xsl:variable name="ssidLookup">
    <xsl:copy-of select="document($externalSSIDfile)"/>
  </xsl:variable>

  <xsl:variable name="licenseLookup">
    <license>
      <label>Creative Commons: Attribution</label>
      <uri>https://creativecommons.org/licenses/by/4.0/</uri>
    </license>
    <license>
      <label>Creative Commons: Attribution-NonCommercial</label>
      <uri>https://creativecommons.org/licenses/by-nc/4.0</uri>
    </license>
    <license>
      <label>Creative Commons: Attribution-NonCommercial-NoDerivs</label>
      <uri>https://creativecommons.org/licenses/by-nc-nd/4.0</uri>
    </license>
    <license>
      <label>Creative Commons: Attribution-NonCommercial-ShareAlike</label>
      <uri>https://creativecommons.org/licenses/by-nc-sa/4.0</uri>
    </license>
    <license>
      <label>Creative Commons: Attribution-ShareAlike</label>
      <uri>https://creativecommons.org/licenses/by-sa/4.0</uri>
    </license>
    <license>
      <label>Creative Commons: Free Reuse (CC0)</label>
      <uri>https://creativecommons.org/publicdomain/zero/1.0/</uri>
    </license>
    <license>
      <label>Creative Commons: Public Domain Mark</label>
      <uri>https://creativecommons.org/publicdomain/mark/1.0/</uri>
    </license>
    <license>
      <label>Copyright Not Evaluated</label>
      <uri>http://rightsstatements.org/vocab/CNE/1.0/</uri>
    </license>
    <license>
      <label>Copyright Undetermined</label>
      <uri>http://rightsstatements.org/vocab/UND/1.0/</uri>
    </license>
    <license>
      <label>In Copyright</label>
      <uri>http://rightsstatements.org/vocab/InC/1.0/</uri>
    </license>
    <license>
      <label>In Copyright – Educational Use Permitted</label>
      <uri>http://rightsstatements.org/vocab/InC-EDU/1.0/</uri>
    </license>
    <license>
      <label>In Copyright – EU Orphan Work</label>
      <uri>http://rightsstatements.org/vocab/InC-OW-EU/1.0/</uri>
    </license>
    <license>
      <label>In Copyright – Non-commercial Use Permitted</label>
      <uri>http://rightsstatements.org/vocab/InC-NC/1.0/</uri>
    </license>
    <license>
      <label>In Copyright – Rights-holder(s) Unlocatable Or Unidentifiable</label>
      <uri>http://rightsstatements.org/vocab/InC-RUU/1.0/</uri>
    </license>
    <license>
      <label>No Copyright – Contractual Restrictions</label>
      <uri>http://rightsstatements.org/vocab/NoC-CR/1.0/</uri>
    </license>
    <license>
      <label>No Copyright – Non-commercial Use Only</label>
      <uri>http://rightsstatements.org/vocab/NoC-NC/1.0/</uri>
    </license>
    <license>
      <label>No Copyright – Other Known Legal Restrictions</label>
      <uri>http://rightsstatements.org/vocab/NoC-OKLR/1.0/</uri>
    </license>
    <license>
      <label>No Copyright – United States</label>
      <uri>http://rightsstatements.org/vocab/NoC-US/1.0/</uri>
    </license>
    <license>
      <label>No Known Copyright</label>
      <uri>http://rightsstatements.org/vocab/NKC/1.0/</uri>
    </license>
  </xsl:variable>

  <xsl:template match="/">
    <!-- Exclude records without Work_Type or SSID -->
    <xsl:apply-templates select="descendant::*:image[*:Work_Type != '' and *:SSID != '']"/>
  </xsl:template>

  <xsl:template match="*:image">
    <xsl:variable name="thisSSID">
      <xsl:value-of select="normalize-space(*:SSID)"/>
    </xsl:variable>
    <xsl:choose>
      <!-- Records with non-numeric SSID values can't be written to disk -->
      <xsl:when test="not(matches($thisSSID, '^\d+$'))">
        <xsl:message>
          <xsl:value-of
            select="concat('Cannot map SSID &quot;', $thisSSID, '&quot; to a numeric value!')"/>
        </xsl:message>
      </xsl:when>
      <!-- Process records that have a corresponding imageUrl in the supplemental-metadata.xml file -->
      <!-- If $externalSSIDfile eq '', then records get processed anyway -->
      <xsl:when
        test="normalize-space($externalSSIDfile) = '' or $ssidLookup//*:image/*:ssid[. eq $thisSSID]">
        <xsl:variable name="earliestEra">
          <xsl:if test="*:Era = 'BCE' or matches(*:Era, '-')">-</xsl:if>
        </xsl:variable>
        <xsl:variable name="latestEra">
          <xsl:if test="*:Era = 'BCE'">-</xsl:if>
        </xsl:variable>
        <xsl:variable name="keyDate">
          <xsl:choose>
            <xsl:when
              test="*:Earliest_Date[not(normalize-space(.) eq '')] or *:Latest_Date[not(normalize-space(.) eq '')]">
              <xsl:choose>
                <xsl:when test="normalize-space(*:Earliest_Date) eq normalize-space(*:Latest_Date)">
                  <xsl:value-of select="concat($earliestEra, normalize-space(*:Earliest_Date))"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>[</xsl:text>
                  <xsl:choose>
                    <xsl:when test="normalize-space(*:Earliest_Date) eq ''">
                      <xsl:text>*</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="concat($earliestEra, normalize-space(*:Earliest_Date))"
                      />
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:text> TO </xsl:text>
                  <xsl:choose>
                    <xsl:when test="normalize-space(*:Latest_Date) eq ''">
                      <xsl:text>*</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="concat($latestEra, normalize-space(*:Latest_Date))"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:text>]</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="matches(normalize-space(*:Image_Date), '/')">
              <!-- EDTF date range -->
              <xsl:variable name="dateStart">
                <xsl:value-of
                  select="normalize-space(substring-before(normalize-space(*:Image_Date), '/'))"/>
              </xsl:variable>
              <xsl:variable name="dateEnd">
                <xsl:value-of
                  select="normalize-space(substring-after(normalize-space(*:Image_Date), '/'))"/>
              </xsl:variable>
              <!-- Either dateStart or dateEnd has a non-null value -->
              <xsl:if
                test="matches($dateStart, '^\d+(-\d{2}(-\d{2})?)?$') or matches($dateEnd, '^\d+(-\d{2}(-\d{2})?)?$')">
                <xsl:text>[</xsl:text>
                <xsl:choose>
                  <xsl:when test="normalize-space($dateStart) eq ''">
                    <xsl:text>*</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space($dateStart)"/>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:text> TO </xsl:text>
                <xsl:choose>
                  <xsl:when test="normalize-space($dateEnd) eq ''">
                    <xsl:text>*</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space($dateEnd)"/>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:text>]</xsl:text>
              </xsl:if>
            </xsl:when>
            <xsl:when test="matches(normalize-space(*:Image_Date), '^\d+(-\d{2}(-\d{2})?)?$')">
              <!-- single EDTF date -->
              <xsl:value-of select="normalize-space(*:Image_Date)"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <!-- Construct output directory path based on SSID -->
        <xsl:variable name="thisSSIDpadded">
          <xsl:variable name="s1">
            <xsl:value-of select="concat('000000000000', $thisSSID)"/>
          </xsl:variable>
          <xsl:value-of select="substring($s1, string-length($s1) - 11)"/>
        </xsl:variable>
        <xsl:variable name="dir1">
          <xsl:value-of select="substring($thisSSIDpadded, 1, 3)"/>
        </xsl:variable>
        <xsl:variable name="dir2">
          <xsl:value-of select="substring($thisSSIDpadded, 4, 3)"/>
        </xsl:variable>
        <xsl:variable name="dir3">
          <xsl:value-of select="substring($thisSSIDpadded, 7, 3)"/>
        </xsl:variable>
        <xsl:variable name="outFileName">
          <xsl:value-of
            select="concat($outDirName, '/', $dir1, '/', $dir2, '/', $dir3, '/', $thisSSID, '-uvaMAP.xml')"
          />
        </xsl:variable>
        <!-- Output file -->
        <xsl:result-document href="{$outFileName}">
          <xsl:if test="normalize-space($schemaLocation) != ''">
            <xsl:processing-instruction name="xml-model">href="<xsl:value-of
                select="$schemaLocation"/>" type="application/xml"
              schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
            <xsl:processing-instruction name="xml-model">href="<xsl:value-of
                select="$schemaLocation"/>" type="application/xml"
              schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
          </xsl:if>
          <uvaMAP>
            <doc>
              <!-- Admin info -->
              <field name="recordOrigin">
                <xsl:text>Machine generated using </xsl:text>
                <xsl:value-of select="$progName"/>
                <xsl:text> (v. </xsl:text>
                <xsl:value-of select="$progVersion"/>
                <xsl:text>)</xsl:text>
              </field>
              <field name="recordCreationDate">
                <xsl:value-of select="current-dateTime()"/>
              </field>
              <field name="metadataSource">JStor Forum</field>
              <field name="originalMetadataType">Excel</field>
              <field name="sourceRecordIdentifier" source="JStor Forum" type="SSID">
                <xsl:value-of select="$thisSSID"/>
              </field>

              <!-- key date -->
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

              <!-- Image info -->
              <field name="contentType">still image</field>
              <field name="mediaType">computer</field>
              <field name="carrierType">online resource</field>
              <field name="internetMediaType">
                <xsl:value-of
                  select="concat('image/', tokenize(normalize-space(*:Filename), '\.')[last()])"/>
              </field>
              <!--<field name="digitalOrigin">digitized other analog</field>-->
              <field name="pubProdDist">Rector and Visitors of the University of Virginia</field>
              <field name="pubProdDistPlace">Charlottesville, Va.</field>

              <!-- Identifiers -->
              <field name="identifier" type="fileName">
                <xsl:value-of select="*:Filename"/>
              </field>
              <xsl:if test="normalize-space($externalSSIDfile) ne ''">
                <field name="identifier" type="ArtStorID">
                  <xsl:value-of select="$ssidLookup//*:image/*:ssid[. eq $thisSSID]/../*:artstorId"
                  />
                </field>
              </xsl:if>

              <!-- URLs -->
              <xsl:if test="normalize-space($externalSSIDfile) ne ''">
                <field name="uri" access="preview">
                  <xsl:variable name="previewURLstub">
                    <xsl:value-of
                      select="replace(replace(replace($ssidLookup//*:image/*:ssid[. eq $thisSSID]/../*:iiifImageManifest, '/home/ana/assets/', ''), 'https://stor.artstor.org/iiif/', ''), '/info.json', '')"
                    />
                  </xsl:variable>
                  <xsl:value-of
                    select="concat('https://stor.artstor.org/iiif/', $previewURLstub, '/full/!250,250/0/default.jpg')"
                  />
                </field>
                <field name="uri" access="object in context" usage="primary">
                  <xsl:value-of
                    select="$ssidLookup//*:image/*:ssid[. eq $thisSSID]/../*:objectInContext"/>
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
              </xsl:if>
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
                      <!--<xsl:value-of select="tokenize(normalize-space(*:Title), '\|')[1]"/>-->
                      <xsl:choose>
                        <xsl:when test="contains(*:Title, '|')">
                          <xsl:value-of select="tokenize(normalize-space(*:Title), '\|')[1]"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="normalize-space(*:Title)"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>
                    <xsl:value-of select="lower-case(replace($sortTitle, '^(a|an|the) ', '', 'i'))"
                    />
                  </field>

                  <!-- Abstract/Summary/Description -->
                  <xsl:apply-templates select="*:Image_View_Description"/>

                  <!-- Original info -->
                  <xsl:apply-templates select="*:Photographer"/>
                  <xsl:apply-templates select="*:Image_Date"/>
                  <xsl:apply-templates select="*:ID_Number"/>

                  <!-- Work info -->
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

                  <!-- Related material -->
                  <xsl:apply-templates select="*:Relationship_depicts | *:Relationship_relatedTo"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:variable name="rawTitle">
                    <xsl:choose>
                      <xsl:when test="*:Title">
                        <xsl:value-of select="normalize-space(*:Title)"/>
                      </xsl:when>
                      <xsl:when test="*:Image_View_Type">
                        <xsl:value-of select="normalize-space(*:Image_View_Type)"/>
                      </xsl:when>
                      <xsl:when test="*:Image_View_Description">
                        <xsl:value-of select="normalize-space(*:Image_View_Description)"/>
                      </xsl:when>
                    </xsl:choose>
                  </xsl:variable>
                  <xsl:if test="normalize-space($rawTitle) ne ''">
                    <!-- title -->
                    <xsl:analyze-string select="$rawTitle" regex="(;|\|)">
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
                        <xsl:value-of
                          select="concat(normalize-space(tokenize(*:Title, '\|')[1]), ', ')"/>
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
                        <xsl:choose>
                          <xsl:when test="contains($rawTitle, '|')">
                            <xsl:value-of
                              select="normalize-space(tokenize(normalize-space($rawTitle), '\|')[1])"
                            />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="normalize-space($rawTitle)"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:variable>
                      <xsl:value-of
                        select="lower-case(replace($sortTitle, '^(a|an|the) ', '', 'i'))"/>
                    </field>
                  </xsl:if>

                  <!-- Abstract/summary/description -->
                  <xsl:apply-templates select="*:Image_View_Description"/>

                  <!-- Original info -->
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

                  <xsl:apply-templates
                    select="*:Creator[not(matches(../*:Work_Type, 'photographs', 'i'))]"/>
                  <xsl:apply-templates select="*:Date"/>
                  <xsl:apply-templates
                    select="*:Repository[not(matches(., 'University of Virginia', 'i'))] | *:Current_Site | *:Former_Site | *:Spatial_coordinates"/>
                  <xsl:apply-templates
                    select="*:Description[not(matches(../*:Work_Type, 'photographs', 'i'))]"/>
                  <xsl:apply-templates select="*:Measurements"/>
                  <xsl:apply-templates select="*:Materials_Techniques"/>

                  <!-- Related material -->
                  <xsl:apply-templates
                    select="*:Complex_Title | *:Relationship_depicts | *:Relationship_relatedTo"/>

                </xsl:otherwise>
              </xsl:choose>

              <!-- Collection name -->
              <xsl:apply-templates select="*:Collection"/>

              <!-- Acquisition info -->
              <xsl:apply-templates select="*:Source | *:Collector"/>

              <!-- orig_useRestrict / rights -->
              <xsl:choose>
                <!-- Process non-empty Rights and License elements -->
                <xsl:when
                  test="*:Rights[normalize-space(.) ne ''] | *:License[normalize-space(.) ne '']">
                  <xsl:apply-templates select="*:Rights | *:License"/>
                </xsl:when>
                <!-- Default useRestrict value if one has been provided  -->
                <xsl:when test="normalize-space($defaultRightsText) ne ''">
                  <field name="useRestrict">
                    <xsl:if test="normalize-space($defaultRightsURI) ne ''">
                      <xsl:attribute name="valueURI">
                        <xsl:value-of select="normalize-space($defaultRightsURI)"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="normalize-space($defaultRightsText)"/>
                  </field>
                </xsl:when>
              </xsl:choose>

              <!-- Subject terms -->
              <xsl:apply-templates
                select="*:Artstor_Classification | *:Category | *:Image_Subject | *:Subjects | *:Work_Subject"/>
              <xsl:apply-templates select="*:Culture | *:Style_Period"/>
            </doc>
          </uvaMAP>
        </xsl:result-document>
      </xsl:when>
      <!-- Report records that don't have a corresponding imageUrl in the supplemental-metadata.xml file -->
      <xsl:otherwise>
        <xsl:message>URL for SSID <xsl:value-of select="$thisSSID"/> not found in <xsl:value-of
            select="$externalSSIDfile"/>!</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*:Rights | *:License">
    <field name="useRestrict">
      <!-- @valueURI -->
      <xsl:variable name="thisRights">
        <xsl:value-of select="concat('^', normalize-space(.), '$')"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$licenseLookup/*:license/*:label[matches(., $thisRights, 'i')]">
          <xsl:attribute name="valueURI">
            <xsl:value-of
              select="$licenseLookup/*:license/*:label[matches(., $thisRights, 'i')]/../*:uri"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="$licenseLookup/*:license/*:uri[matches(., $thisRights, 'i')]">
          <xsl:attribute name="valueURI">
            <xsl:value-of select="normalize-space(.)"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <!-- content -->
      <xsl:choose>
        <!-- contains a URI matching one in $licenseLookup -->
        <xsl:when test="$licenseLookup/*:license/*:uri[matches(., $thisRights, 'i')]">
          <xsl:value-of
            select="$licenseLookup/*:license/*:uri[matches(., $thisRights, 'i')]/../*:label"/>
        </xsl:when>
        <!-- contains text matching a license in $licenseLookup; use the standardized label
          in $licenseLookup -->
        <xsl:when test="$licenseLookup/*:license/*:label[matches(., $thisRights, 'i')]">
          <xsl:value-of select="$licenseLookup/*:license/*:label[matches(., $thisRights, 'i')]"/>
        </xsl:when>
        <!-- contains other text -->
        <xsl:otherwise>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>

  <xsl:template match="*:Relationship_depicts | *:Relationship_relatedTo | *:Complex_Title">
    <xsl:variable name="thisElement">
      <xsl:value-of select="local-name()"/>
    </xsl:variable>
    <xsl:variable name="relatedWorks">
      <xsl:analyze-string select="." regex=";">
        <xsl:non-matching-substring>
          <work>
            <xsl:value-of
              select="normalize-space(replace(tokenize(normalize-space(.), '\|')[1], 'component is', ''))"
            />
          </work>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:variable>
    <xsl:for-each select="distinct-values($relatedWorks/*:work)">
      <xsl:sort/>
      <field name="work_relatedWork">
        <xsl:attribute name="rel">
          <xsl:choose>
            <xsl:when test="$thisElement = 'Relationship_depicts'">
              <xsl:text>depicts</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>relatedTo</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select="."/>
      </field>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="*:ID_Number">
    <field name="orig_identifier">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:Source | *:Collector">
    <field name="orig_acqInfo">
      <xsl:if test="../*:Source_Qualifier[normalize-space(.) ! '']">
        <xsl:value-of select="concat(../*:Source_Qualifier, ': ')"/>
      </xsl:if>
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

  <xsl:template match="*:Current_Site | *:Former_Site">
    <xsl:variable name="fieldName">
      <xsl:choose>
        <xsl:when test="matches(normalize-space(.), '^creation: ', 'i')"
          >work_creationPlace</xsl:when>
        <xsl:otherwise>work_workLocation</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <field name="{$fieldName}">
      <xsl:choose>
        <xsl:when test="local-name() = 'Current_Site'">
          <xsl:attribute name="type">
            <xsl:text>site</xsl:text>
          </xsl:attribute>
        </xsl:when>
        <xsl:when
          test="matches(normalize-space(.), '^(discovery|exhibition|installation|intended|owner|repository|site): ', 'i')">
          <xsl:attribute name="type">
            <xsl:value-of select="normalize-space(substring-before(., ':'))"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="matches(normalize-space(.), '^former owner: ', 'i')">
          <xsl:attribute name="type">
            <xsl:text>formerOwner</xsl:text>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="matches(normalize-space(.), '^former repository: ', 'i')">
          <xsl:attribute name="type">
            <xsl:text>formerRepository</xsl:text>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="matches(normalize-space(.), '^former site: ', 'i')">
          <xsl:attribute name="type">
            <xsl:text>formerSite</xsl:text>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:variable name="locationSteps">
        <xsl:if test="../*:Street_Address[normalize-space(.) != '']">
          <locationStep>
            <xsl:value-of select="normalize-space(../*:Street_Address)"/>
          </locationStep>
        </xsl:if>
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
      <xsl:value-of
        select="concat('https://forum.jstor.org/assets/', normalize-space(../*:SSID), '/representation-view')"/>
      <!-- Media_URL is broken in latest export from JStor Forum -->
      <!--<xsl:value-of select="normalize-space(.)"/>-->
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
    <xsl:variable name="creatorSep">
      <xsl:choose>
        <xsl:when test="contains(*:Creator, '|')">
          <xsl:text>|</xsl:text>
        </xsl:when>
        <xsl:when test="contains(*:Creator, ';')">
          <xsl:text>;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>;|\|</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:analyze-string
      select="normalize-space(replace(replace(., '[\s;:,\|]+$', ''), ';+\|;*', '|'))"
      regex="{$creatorSep}">
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
            <xsl:value-of
              select="replace(tokenize(normalize-space(.), '\([^\)]+\)')[last()], '[\(\)]', '')"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when
              test="normalize-space($role) ne '' and normalize-space($role) ne normalize-space(.)">
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

  <xsl:template match="*:Date | *:Work_Date">
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

  <xsl:template match="*:Description | *:Description_Commentary">
    <xsl:analyze-string select="normalize-space(.)" regex="\|+">
      <xsl:non-matching-substring>
        <field name="work_abstractSummary">
          <xsl:value-of select="replace(normalize-space(.), '^RLV:\s?', '')"/>
          <xsl:if test="matches(normalize-space(.), '^RLV')">
            <xsl:text> -- Robert L. Vickery</xsl:text>
          </xsl:if>
        </field>
      </xsl:non-matching-substring>
    </xsl:analyze-string>

    <!--<field name="work_abstractSummary">
      <xsl:value-of select="normalize-space(replace(., '\|', ' '))"/>
    </field>-->
  </xsl:template>

  <xsl:template match="*:Culture | *:Style_Period">
    <xsl:variable name="fieldName">
      <xsl:choose>
        <xsl:when test="local-name() = 'Culture'">
          <xsl:text>culturalContext</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>stylePeriod</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:analyze-string select="." regex=";">
      <xsl:non-matching-substring>
        <field name="{$fieldName}">
          <xsl:value-of select="normalize-space(.)"/>
        </field>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template match="*:Repository">
    <field name="host" type="Repository">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:Repository_Accession_Number">
    <field name="orig_identifier" type="Accession Number">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>

  <xsl:template match="*:Artstor_Classification">
    <xsl:analyze-string select="." regex="(;|\|)">
      <xsl:non-matching-substring>
        <xsl:if test="normalize-space(.) ne ''">
          <field name="subject" authority="AAT">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:if>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template match="*:Category | *:Image_Subject | *:Subjects | *:Work_Subject">
    <xsl:analyze-string select="." regex="(;|\|)">
      <xsl:non-matching-substring>
        <xsl:if test="normalize-space(.) ne ''">
          <field name="subject" authority="AAT">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:if>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <!-- Discard empty elements -->
  <xsl:template match="*[normalize-space(.) = '']" priority="3"/>

  <xsl:template match="* | comment() | @*" mode="#all">
    <xsl:copy>
      <xsl:apply-templates select="node() | comment() | @*" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text()" mode="#all">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

</xsl:stylesheet>
