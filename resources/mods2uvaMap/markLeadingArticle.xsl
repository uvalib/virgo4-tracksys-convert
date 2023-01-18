<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.loc.gov/MARC21/slim"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs" version="2.0">

  <xsl:include href="../marc2mods_revision/MARC21slimUtils.xsl"/>

  <xsl:output method="xml" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- ======================================================================= -->
  <!-- GLOBAL VARIABLES                                                        -->
  <!-- ======================================================================= -->

  
  <!-- ======================================================================= -->
  <!-- UTILITIES / NAMED TEMPLATES                                             -->
  <!-- ======================================================================= -->

  <xsl:template name="splitTitle">
    <!--<nonSort>
      <xsl:value-of select="regex-group(1)"/>
    </nonSort>-->
    <!--<title>-->
    <xsl:value-of select="regex-group(2)"/>
    <!--</title>-->
  </xsl:template>

  <xsl:template name="markLeadingArticle">
    <xsl:param name="langCode"/>
    <xsl:param name="title"/>
    <xsl:choose>
      <xsl:when
        test="matches($title, '^a ', 'i') and matches($langCode, 'cpe|eng|enm|ang|sco|sgn|glg|gag|hun|cpp|nic|por|rup|rum|sco|gla|yid')">
        <xsl:analyze-string select="$title" regex="^(a )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test='matches($title, "^a&apos;", "i") and matches($langCode, "gla")'>
        <xsl:analyze-string select="$title" regex="^(a')(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^aik ', 'i') and matches($langCode, 'sgn|urd')">
        <xsl:analyze-string select="$title" regex="^(aik )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^ake ', 'i') and matches($langCode, 'jpr|peo|pal|per')">
        <xsl:analyze-string select="$title" regex="^(ake )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^al ', 'i') and matches($langCode, 'rup|rum')">
        <xsl:analyze-string select="$title" regex="^(al )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^al-', 'i') and matches($langCode, 'ara|jrb|sem|bal|dra|lah|pan|pan|jpr|peo|pal|per|tut|crh|tur|ota|sgn|urd')">
        <xsl:analyze-string select="$title" regex="^(al-)(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^am ', 'i') and matches($langCode, 'gla')">
        <xsl:analyze-string select="$title" regex="^(am )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^an ', 'i') and matches($langCode, 'cpe|eng|enm|ang|sco|sgn|gle|iri|mga|sga|sco|gla|gla|yid')">
        <xsl:analyze-string select="$title" regex="^(an )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^an t-', 'i') and matches($langCode, 'gle|iri|mga|sga|gla')">
        <xsl:analyze-string select="$title" regex="^(an t-)(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^ane ', 'i') and matches($langCode, 'sco|gla')">
        <xsl:analyze-string select="$title" regex="^(ane )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^ang ', 'i') and matches($langCode, 'tgl|tag')">
        <xsl:analyze-string select="$title" regex="^(ang )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^ang mga ', 'i') and matches($langCode, 'tgl|tag')">
        <xsl:analyze-string select="$title" regex="^(ang mga )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^as ', 'i') and matches($langCode, 'glg|gag|cpp|nic|por')">
        <xsl:analyze-string select="$title" regex="^(as )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^az ', 'i') and matches($langCode, 'hun')">
        <xsl:analyze-string select="$title" regex="^(az )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^bat ', 'i') and matches($langCode, 'baq')">
        <xsl:analyze-string select="$title" regex="^(bat )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^bir ', 'i') and matches($langCode, 'tut|crh|tur|ota')">
        <xsl:analyze-string select="$title" regex="^(bir )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test='matches($title, "^d&apos;", "i") and matches($langCode, "cpe|eng|enm|ang|sco|sgn")'>
        <xsl:analyze-string select="$title" regex="^(d')(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^das ', 'i') and matches($langCode, 'ger|gmh|goh|gem|nds|sco|gsw|yid')">
        <xsl:analyze-string select="$title" regex="^(das )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^de ', 'i') and matches($langCode, 'dan|gem|sgn|afr|dut|dum|gem|cpe|eng|enm|ang|sco|sgn|frs|fry|fri|gem|frr|nor|nob|nno|non|gem|smj|swe')">
        <xsl:analyze-string select="$title" regex="^(de )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^dei ', 'i') and matches($langCode, 'nor|nob|nno|non')">
        <xsl:analyze-string select="$title" regex="^(dei )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^dem ', 'i') and matches($langCode, 'ger|gmh|goh|gem|nds|sco|gsw|yid')">
        <xsl:analyze-string select="$title" regex="^(dem )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^den ', 'i') and matches($langCode, 'dan|gem|sgn|ger|gmh|goh|gem|nds|sco|gsw|yid|nor|nob|nno|non|gem|smj|swe')">
        <xsl:analyze-string select="$title" regex="^(den )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^der ', 'i') and matches($langCode, 'ger|gmh|goh|gem|nds|sco|gsw|yid|yid')">
        <xsl:analyze-string select="$title" regex="^(der )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^des ', 'i') and matches($langCode, 'ger|gmh|goh|gem|nds|sco|gsw|yid|wln')">
        <xsl:analyze-string select="$title" regex="^(des )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^det ', 'i') and matches($langCode, 'dan|gem|sgn|nor|nob|nno|non|gem|smj|swe')">
        <xsl:analyze-string select="$title" regex="^(det )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^di ', 'i') and matches($langCode, 'yid')">
        <xsl:analyze-string select="$title" regex="^(di )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^die ', 'i') and matches($langCode, 'afr|ger|gmh|goh|gem|nds|sco|gsw|yid|yid')">
        <xsl:analyze-string select="$title" regex="^(die )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^dos ', 'i') and matches($langCode, 'yid')">
        <xsl:analyze-string select="$title" regex="^(dos )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^e ', 'i') and matches($langCode, 'nor|nob|nno|non')">
        <xsl:analyze-string select="$title" regex="^(e )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test='matches($title, "^&apos;e ", "i") and matches($langCode, "frs|fry|fri|gem|frr")'>
        <xsl:analyze-string select="$title" regex="^('e )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^een ', 'i') and matches($langCode, 'afr|dut|dum|gem')">
        <xsl:analyze-string select="$title" regex="^(een )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^eene ', 'i') and matches($langCode, 'afr|dut|dum|gem')">
        <xsl:analyze-string select="$title" regex="^(eene )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^egy ', 'i') and matches($langCode, 'hun')">
        <xsl:analyze-string select="$title" regex="^(egy )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^ei ', 'i') and matches($langCode, 'nor|nob|nno|non')">
        <xsl:analyze-string select="$title" regex="^(ei )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^ein ', 'i') and matches($langCode, 'ger|gmh|goh|gem|nds|sco|gsw|yid|nor|nob|nno|non|wln')">
        <xsl:analyze-string select="$title" regex="^(ein )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^eine ', 'i') and matches($langCode, 'ger|gmh|goh|gem|nds|sco|gsw|yid')">
        <xsl:analyze-string select="$title" regex="^(eine )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^einem ', 'i') and matches($langCode, 'ger|gmh|goh|gem|nds|sco|gsw|yid')">
        <xsl:analyze-string select="$title" regex="^(einem )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^einen ', 'i') and matches($langCode, 'ger|gmh|goh|gem|nds|sco|gsw|yid')">
        <xsl:analyze-string select="$title" regex="^(einen )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^einer ', 'i') and matches($langCode, 'ger|gmh|goh|gem|nds|sco|gsw|yid')">
        <xsl:analyze-string select="$title" regex="^(einer )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^eines ', 'i') and matches($langCode, 'ger|gmh|goh|gem|nds|sco|gsw|yid')">
        <xsl:analyze-string select="$title" regex="^(eines )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^eit ', 'i') and matches($langCode, 'nor|nob|nno|non')">
        <xsl:analyze-string select="$title" regex="^(eit )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^el ', 'i') and matches($langCode, 'cat|arg|crp|lad|roa|spa')">
        <xsl:analyze-string select="$title" regex="^(el )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^el-', 'i') and matches($langCode, 'ara|jrb|sem')">
        <xsl:analyze-string select="$title" regex="^(el-)(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^els ', 'i') and matches($langCode, 'cat')">
        <xsl:analyze-string select="$title" regex="^(els )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^en ', 'i') and matches($langCode, 'cat|dan|gem|sgn|nor|nob|nno|non|gem|smj|swe')">
        <xsl:analyze-string select="$title" regex="^(en )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^enne ', 'i') and matches($langCode, 'wln')">
        <xsl:analyze-string select="$title" regex="^(enne )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^et ', 'i') and matches($langCode, 'dan|gem|sgn|nor|nob|nno|non')">
        <xsl:analyze-string select="$title" regex="^(et )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^ett ', 'i') and matches($langCode, 'gem|smj|swe')">
        <xsl:analyze-string select="$title" regex="^(ett )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^eyn ', 'i') and matches($langCode, 'yid')">
        <xsl:analyze-string select="$title" regex="^(eyn )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^eyne ', 'i') and matches($langCode, 'yid')">
        <xsl:analyze-string select="$title" regex="^(eyne )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test='matches($title, "^gl&apos;", "i") and matches($langCode, "ita|nap|roa|scn")'>
        <xsl:analyze-string select="$title" regex="^(gl')(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^gli ', 'i') and matches($langCode, 'ita|nap|roa|scn')">
        <xsl:analyze-string select="$title" regex="^(gli )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^ha-', 'i') and matches($langCode, 'heb|ira|yid')">
        <xsl:analyze-string select="$title" regex="^(ha-)(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^hai ', 'i') and matches($langCode, 'grc|tut|grc|gre')">
        <xsl:analyze-string select="$title" regex="^(hai )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^he ', 'i') and matches($langCode, 'cpe|haw')">
        <xsl:analyze-string select="$title" regex="^(he )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^hē', 'i') and matches($langCode, 'grc|tut|grc|gre')">
        <xsl:analyze-string select="$title" regex="^(hē)(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^he-', 'i') and matches($langCode, 'heb|ira|yid')">
        <xsl:analyze-string select="$title" regex="^(he-)(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^heis ', 'i') and matches($langCode, 'tut|grc|gre')">
        <xsl:analyze-string select="$title" regex="^(heis )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^hen ', 'i') and matches($langCode, 'tut|grc|gre')">
        <xsl:analyze-string select="$title" regex="^(hen )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^hena ', 'i') and matches($langCode, 'tut|grc|gre')">
        <xsl:analyze-string select="$title" regex="^(hena )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^henas ', 'i') and matches($langCode, 'tut|grc|gre')">
        <xsl:analyze-string select="$title" regex="^(henas )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^het ', 'i') and matches($langCode, 'afr|dut|dum|gem')">
        <xsl:analyze-string select="$title" regex="^(het )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^hin ', 'i') and matches($langCode, 'ice|non|sgn')">
        <xsl:analyze-string select="$title" regex="^(hin )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^hina ', 'i') and matches($langCode, 'ice|non|sgn')">
        <xsl:analyze-string select="$title" regex="^(hina )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^hinar ', 'i') and matches($langCode, 'ice|non|sgn')">
        <xsl:analyze-string select="$title" regex="^(hinar )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^hinir ', 'i') and matches($langCode, 'ice|non|sgn')">
        <xsl:analyze-string select="$title" regex="^(hinir )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^hinn ', 'i') and matches($langCode, 'ice|non|sgn')">
        <xsl:analyze-string select="$title" regex="^(hinn )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^hinna ', 'i') and matches($langCode, 'ice|non|sgn')">
        <xsl:analyze-string select="$title" regex="^(hinna )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^hinnar ', 'i') and matches($langCode, 'ice|non|sgn')">
        <xsl:analyze-string select="$title" regex="^(hinnar )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^hinni ', 'i') and matches($langCode, 'ice|non|sgn')">
        <xsl:analyze-string select="$title" regex="^(hinni )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^hins ', 'i') and matches($langCode, 'ice|non|sgn')">
        <xsl:analyze-string select="$title" regex="^(hins )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^hinu ', 'i') and matches($langCode, 'ice|non|sgn')">
        <xsl:analyze-string select="$title" regex="^(hinu )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^hinum ', 'i') and matches($langCode, 'ice|non|sgn')">
        <xsl:analyze-string select="$title" regex="^(hinum )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^hið', 'i') and matches($langCode, 'ice|non|sgn')">
        <xsl:analyze-string select="$title" regex="^(hið)(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^ho ', 'i') and matches($langCode, 'grc|tut|grc|gre')">
        <xsl:analyze-string select="$title" regex="^(ho )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^hoi ', 'i') and matches($langCode, 'grc|tut|grc|gre')">
        <xsl:analyze-string select="$title" regex="^(hoi )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^i ', 'i') and matches($langCode, 'ita|nap|roa|scn')">
        <xsl:analyze-string select="$title" regex="^(i )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test='matches($title, "^ih&apos;", "i") and matches($langCode, "oci|pro|roa")'>
        <xsl:analyze-string select="$title" regex="^(ih')(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^iha ', 'i') and matches($langCode, 'lah|pan|pan')">
        <xsl:analyze-string select="$title" regex="^(iha )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^ika ', 'i') and matches($langCode, 'lah|pan|pan')">
        <xsl:analyze-string select="$title" regex="^(ika )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^il ', 'i') and matches($langCode, 'ita|nap|roa|scn|oci|lan|pro|oci|pro|roa')">
        <xsl:analyze-string select="$title" regex="^(il )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^il-', 'i') and matches($langCode, 'mlt')">
        <xsl:analyze-string select="$title" regex="^(il-)(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^in ', 'i') and matches($langCode, 'frs|fry|fri|gem|frr')">
        <xsl:analyze-string select="$title" regex="^(in )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^it ', 'i') and matches($langCode, 'frs|fry|fri|gem|frr')">
        <xsl:analyze-string select="$title" regex="^(it )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^ka ', 'i') and matches($langCode, 'cpe|haw')">
        <xsl:analyze-string select="$title" regex="^(ka )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^ke ', 'i') and matches($langCode, 'cpe|haw')">
        <xsl:analyze-string select="$title" regex="^(ke )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test='matches($title, "^l&apos;", "i") and matches($langCode, "cat|cpf|fre|frm|fro|hat|roa|sgn|ita|nap|roa|scn|oci|lan|pro|oci|pro|roa|wln")'>
        <xsl:analyze-string select="$title" regex="^(l')(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^l-', 'i') and matches($langCode, 'mlt')">
        <xsl:analyze-string select="$title" regex="^(l-)(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^la ', 'i') and matches($langCode, 'cat|epo|esp|cpf|fre|frm|fro|hat|roa|sgn|ita|nap|roa|scn|oci|lan|pro|oci|pro|roa|arg|crp|lad|roa|spa')">
        <xsl:analyze-string select="$title" regex="^(la )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^las ', 'i') and matches($langCode, 'oci|lan|pro|oci|pro|roa|arg|crp|lad|roa|spa')">
        <xsl:analyze-string select="$title" regex="^(las )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^le ', 'i') and matches($langCode, 'cpf|fre|frm|fro|hat|roa|sgn|ita|nap|roa|scn|oci|lan|pro|oci|pro|roa')">
        <xsl:analyze-string select="$title" regex="^(le )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^les ', 'i') and matches($langCode, 'cat|cpf|fre|frm|fro|hat|roa|sgn|oci|lan|pro|oci|pro|roa|wln')">
        <xsl:analyze-string select="$title" regex="^(les )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^lh ', 'i') and matches($langCode, 'oci|lan|pro|oci|pro|roa')">
        <xsl:analyze-string select="$title" regex="^(lh )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^lhi ', 'i') and matches($langCode, 'oci|lan|pro|oci|pro|roa')">
        <xsl:analyze-string select="$title" regex="^(lhi )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^li ', 'i') and matches($langCode, 'oci|lan|pro|oci|pro|roa')">
        <xsl:analyze-string select="$title" regex="^(li )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^lis ', 'i') and matches($langCode, 'oci|lan|pro|oci|pro|roa')">
        <xsl:analyze-string select="$title" regex="^(lis )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^lo ', 'i') and matches($langCode, 'ita|nap|roa|scn|oci|lan|pro|oci|pro|roa|arg|crp|lad|roa|spa')">
        <xsl:analyze-string select="$title" regex="^(lo )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^los ', 'i') and matches($langCode, 'oci|lan|pro|oci|pro|roa|arg|crp|lad|roa|spa')">
        <xsl:analyze-string select="$title" regex="^(los )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^lou ', 'i') and matches($langCode, 'oci|lan|pro|oci|pro|roa')">
        <xsl:analyze-string select="$title" regex="^(lou )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^lu ', 'i') and matches($langCode, 'oci|lan|pro|oci|pro|roa')">
        <xsl:analyze-string select="$title" regex="^(lu )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^mga ', 'i') and matches($langCode, 'tgl|tag')">
        <xsl:analyze-string select="$title" regex="^(mga )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^mia ', 'i') and matches($langCode, 'tut|grc|gre')">
        <xsl:analyze-string select="$title" regex="^(mia )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test='matches($title, "^&apos;n ", "i") and matches($langCode, "afr|afr|dut|dum|gem|frs|fry|fri|gem|frr")'>
        <xsl:analyze-string select="$title" regex="^('n )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^na ', 'i') and matches($langCode, 'cpe|haw|gle|iri|mga|sga|gla')">
        <xsl:analyze-string select="$title" regex="^(na )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^na h-', 'i') and matches($langCode, 'gle|iri|mga|sga|gla')">
        <xsl:analyze-string select="$title" regex="^(na h-)(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^njē', 'i') and matches($langCode, 'alb')">
        <xsl:analyze-string select="$title" regex="^(njē)(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^ny ', 'i') and matches($langCode, 'mlg|mla')">
        <xsl:analyze-string select="$title" regex="^(ny )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test='matches($title, "^&apos;o ", "i") and matches($langCode, "nap")'>
        <xsl:analyze-string select="$title" regex="^('o )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^o ', 'i') and matches($langCode, 'glg|gag|cpe|haw|cpp|nic|por|rup|rum')">
        <xsl:analyze-string select="$title" regex="^(o )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^os ', 'i') and matches($langCode, 'cpp|nic|por')">
        <xsl:analyze-string select="$title" regex="^(os )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test='matches($title, "^&apos;r ", "i") and matches($langCode, "ice|non|sgn")'>
        <xsl:analyze-string select="$title" regex="^('r )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test='matches($title, "^&apos;s ", "i") and matches($langCode, "ger|gmh|goh|gem|nds|sco|gsw|yid")'>
        <xsl:analyze-string select="$title" regex="^('s )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test='matches($title, "^&apos;t ", "i") and matches($langCode, "afr|dut|dum|gem|frs|fry|fri|gem|frr")'>
        <xsl:analyze-string select="$title" regex="^('t )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^ta ', 'i') and matches($langCode, 'grc|tut|grc|gre')">
        <xsl:analyze-string select="$title" regex="^(ta )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^tais ', 'i') and matches($langCode, 'grc')">
        <xsl:analyze-string select="$title" regex="^(tais )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^tas ', 'i') and matches($langCode, 'grc')">
        <xsl:analyze-string select="$title" regex="^(tas )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^tē', 'i') and matches($langCode, 'grc')">
        <xsl:analyze-string select="$title" regex="^(tē)(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^tēn ', 'i') and matches($langCode, 'grc|tut|grc|gre')">
        <xsl:analyze-string select="$title" regex="^(tēn )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^tēs ', 'i') and matches($langCode, 'grc|tut|grc|gre')">
        <xsl:analyze-string select="$title" regex="^(tēs )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^the ', 'i') and matches($langCode, 'cpe|eng|enm|ang|sco|sgn')">
        <xsl:analyze-string select="$title" regex="^(the )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^to ', 'i') and matches($langCode, 'grc|tut|grc|gre')">
        <xsl:analyze-string select="$title" regex="^(to )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^tō', 'i') and matches($langCode, 'grc')">
        <xsl:analyze-string select="$title" regex="^(tō)(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^tois ', 'i') and matches($langCode, 'grc')">
        <xsl:analyze-string select="$title" regex="^(tois )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^ton ', 'i') and matches($langCode, 'grc|tut|grc|gre')">
        <xsl:analyze-string select="$title" regex="^(ton )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^tōn ', 'i') and matches($langCode, 'grc|tut|grc|gre')">
        <xsl:analyze-string select="$title" regex="^(tōn )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^tou ', 'i') and matches($langCode, 'grc|tut|grc|gre')">
        <xsl:analyze-string select="$title" regex="^(tou )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^um ', 'i') and matches($langCode, 'cpp|nic|por')">
        <xsl:analyze-string select="$title" regex="^(um )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^uma ', 'i') and matches($langCode, 'cpp|nic|por')">
        <xsl:analyze-string select="$title" regex="^(uma )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^un ', 'i') and matches($langCode, 'cat|cpf|fre|frm|fro|hat|roa|sgn|ita|nap|roa|scn|oci|lan|pro|oci|pro|roa|rup|rum|arg|crp|lad|roa|spa')">
        <xsl:analyze-string select="$title" regex="^(un )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test='matches($title, "^un&apos;", "i") and matches($langCode, "ita|nap|roa|scn")'>
        <xsl:analyze-string select="$title" regex="^(un')(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^una ', 'i') and matches($langCode, 'cat|ita|nap|roa|scn|oci|lan|pro|oci|pro|roa|arg|crp|lad|roa|spa')">
        <xsl:analyze-string select="$title" regex="^(una )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^une ', 'i') and matches($langCode, 'cpf|fre|frm|fro|hat|roa|sgn')">
        <xsl:analyze-string select="$title" regex="^(une )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^unei ', 'i') and matches($langCode, 'rup|rum')">
        <xsl:analyze-string select="$title" regex="^(unei )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^unha ', 'i') and matches($langCode, 'glg|gag')">
        <xsl:analyze-string select="$title" regex="^(unha )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^uno ', 'i') and matches($langCode, 'ita|nap|roa|scn|oci|lan|pro|oci|pro|roa')">
        <xsl:analyze-string select="$title" regex="^(uno )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^uns ', 'i') and matches($langCode, 'oci|lan|pro|oci|pro|roa')">
        <xsl:analyze-string select="$title" regex="^(uns )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^unui ', 'i') and matches($langCode, 'rup|rum')">
        <xsl:analyze-string select="$title" regex="^(unui )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^us ', 'i') and matches($langCode, 'oci|lan|pro|oci|pro|roa')">
        <xsl:analyze-string select="$title" regex="^(us )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^y ', 'i') and matches($langCode, 'cel|wel')">
        <xsl:analyze-string select="$title" regex="^(y )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when
        test="matches($title, '^ye ', 'i') and matches($langCode, 'cpe|eng|enm|ang|sco|sgn')">
        <xsl:analyze-string select="$title" regex="^(ye )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($title, '^yr ', 'i') and matches($langCode, 'cel|wel')">
        <xsl:analyze-string select="$title" regex="^(yr )(.*)$" flags="i">
          <xsl:matching-substring>
            <xsl:call-template name="splitTitle"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$title"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- ======================================================================= -->
  <!-- MAIN OUTPUT TEMPLATE                                                    -->
  <!-- ======================================================================= -->

  <xsl:template match="/">
    <test>
      <xsl:call-template name="markLeadingArticle">
        <!-- $langCode will come from 008/35-37 (36-38) -->
        <xsl:with-param name="langCode">eng</xsl:with-param>
        <xsl:with-param name="title">The University of Chicago stud- ies in Balzac</xsl:with-param>
      </xsl:call-template>
    </test>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- MATCH TEMPLATES                                                         -->
  <!-- ======================================================================= -->




  <!-- ======================================================================= -->
  <!-- DEFAULT TEMPLATE                                                        -->
  <!-- ======================================================================= -->

  <xsl:template match="element() | processing-instruction() | comment() | @*">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
