<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

  <!-- MARC relator codes and terms, https://www.loc.gov/standards/sourcelist/relator-role.html, retrieved 2020/09/25 -->
  <xsl:variable name="marcRelators">
    <relator term="abridger" code="abr"/>
    <relator term="actor" code="act"/>
    <relator term="adapter" code="adp"/>
    <relator term="addressee" code="rcp" usefor="recipient;"/>
    <relator term="analyst" code="anl"/>
    <relator term="animator" code="anm"/>
    <relator term="annotator" code="ann"/>
    <relator term="appellant" code="apl"/>
    <relator term="appellee" code="ape"/>
    <relator term="applicant" code="app"/>
    <relator term="architect" code="arc"/>
    <relator term="arranger" code="arr" usefor="arranger of music;"/>
    <relator term="art copyist" code="acp"/>
    <relator term="art director" code="adi"/>
    <relator term="artist" code="art" usefor="graphic technician;"/>
    <relator term="artistic director" code="ard"/>
    <relator term="assignee" code="asg"/>
    <relator term="associated name" code="asn"/>
    <relator term="attributed name" code="att" usefor="supposed name;"/>
    <relator term="auctioneer" code="auc"/>
    <relator term="author" code="aut" usefor="joint author;"/>
    <relator term="author in quotations or text abstracts" code="aqt"/>
    <relator term="author of afterword, colophon, etc." code="aft"/>
    <relator term="author of dialog" code="aud"/>
    <relator term="author of introduction, etc." code="aui"/>
    <relator term="autographer" code="ato"/>
    <relator term="bibliographic antecedent" code="ant"/>
    <relator term="binder" code="bnd"/>
    <relator term="binding designer" code="bdd" usefor="designer of binding;"/>
    <relator term="blurb writer" code="blw"/>
    <relator term="book designer" code="bkd" usefor="designer of book;designer of e-book;"/>
    <relator term="book producer" code="bkp" usefor="producer of book;"/>
    <relator term="bookjacket designer" code="bjd" usefor="designer of bookjacket;"/>
    <relator term="bookplate designer" code="bpd"/>
    <relator term="bookseller" code="bsl"/>
    <relator term="braille embosser" code="brl"/>
    <relator term="broadcaster" code="brd"/>
    <relator term="calligrapher" code="cll"/>
    <relator term="cartographer" code="ctg"/>
    <relator term="caster" code="cas"/>
    <relator term="censor" code="cns" usefor="bowdlerizer;expurgator;"/>
    <relator term="choreographer" code="chr"/>
    <relator term="cinematographer" code="cng" usefor="director of photography;"/>
    <relator term="client" code="cli"/>
    <relator term="collection registrar" code="cor"/>
    <relator term="collector" code="col"/>
    <relator term="collotyper" code="clt"/>
    <relator term="colorist" code="clr"/>
    <relator term="commentator" code="cmm"/>
    <relator term="commentator for written text" code="cwt"/>
    <relator term="compiler" code="com"/>
    <relator term="complainant" code="cpl"/>
    <relator term="complainant-appellant" code="cpt"/>
    <relator term="complainant-appellee" code="cpe"/>
    <relator term="composer" code="cmp"/>
    <relator term="compositor" code="cmt" usefor="typesetter;"/>
    <relator term="conceptor" code="ccp"/>
    <relator term="conductor" code="cnd"/>
    <relator term="conservator" code="con" usefor="preservationist;"/>
    <relator term="consultant" code="csl"/>
    <relator term="consultant to a project" code="csp"/>
    <relator term="contestant" code="cos"/>
    <relator term="contestant-appellant" code="cot"/>
    <relator term="contestant-appellee" code="coe"/>
    <relator term="contestee" code="cts"/>
    <relator term="contestee-appellant" code="ctt"/>
    <relator term="contestee-appellee" code="cte"/>
    <relator term="contractor" code="ctr"/>
    <relator term="contributor" code="ctb" usefor="collaborator;"/>
    <relator term="copyright claimant" code="cpc"/>
    <relator term="copyright holder" code="cph"/>
    <relator term="corrector" code="crr"/>
    <relator term="correspondent" code="crp"/>
    <relator term="costume designer" code="cst"/>
    <relator term="court governed" code="cou"/>
    <relator term="court reporter" code="crt"/>
    <relator term="cover designer" code="cov" usefor="designer of cover;"/>
    <relator term="creator" code="cre"/>
    <relator term="curator" code="cur" usefor="curator of an exhibition;"/>
    <relator term="dancer" code="dnc"/>
    <relator term="data contributor" code="dtc"/>
    <relator term="data manager" code="dtm"/>
    <relator term="dedicatee" code="dte" usefor="dedicatee of item;"/>
    <relator term="dedicator" code="dto"/>
    <relator term="defendant" code="dfd"/>
    <relator term="defendant-appellant" code="dft"/>
    <relator term="defendant-appellee" code="dfe"/>
    <relator term="degree granting institution" code="dgg" usefor="degree grantor;"/>
    <relator term="degree supervisor" code="dgs"/>
    <relator term="delineator" code="dln"/>
    <relator term="depicted" code="dpc"/>
    <relator term="depositor" code="dpt"/>
    <relator term="designer" code="dsr"/>
    <relator term="director" code="drt"/>
    <relator term="dissertant" code="dis"/>
    <relator term="distribution place" code="dbp"/>
    <relator term="distributor" code="dst"/>
    <relator term="donor" code="dnr"/>
    <relator term="draftsman" code="drm" usefor="technical draftsman;"/>
    <relator term="dubious author" code="dub"/>
    <!-- Incorrect code, but common error -->
    <relator term="editor" code="ed"/>
    <relator term="editor" code="edt" usefor="ed;"/>
    <relator term="editor of compilation" code="edc"/>
    <relator term="editor of moving image work" code="edm" usefor="moving image work editor;"/>
    <relator term="electrician" code="elg"
      usefor="chief electrician;house electrician;master electrician;"/>
    <relator term="electrotyper" code="elt"/>
    <relator term="enacting jurisdiction" code="enj"/>
    <relator term="engineer" code="eng"/>
    <relator term="engraver" code="egr"/>
    <relator term="etcher" code="etr"/>
    <relator term="event place" code="evp"/>
    <relator term="expert" code="exp" usefor="appraiser;"/>
    <relator term="facsimilist" code="fac" usefor="copier;"/>
    <relator term="field director" code="fld"/>
    <relator term="film director" code="fmd"/>
    <relator term="film distributor" code="fds"/>
    <relator term="film editor" code="flm" usefor="motion picture editor;"/>
    <relator term="film producer" code="fmp"/>
    <relator term="filmmaker" code="fmk"/>
    <relator term="first party" code="fpy"/>
    <relator term="forger" code="frg" usefor="copier;counterfeiter;"/>
    <relator term="former owner" code="fmo"/>
    <relator term="funder" code="fnd"/>
    <relator term="geographic information specialist" code="gis"
      usefor="geospatial information specialist;"/>
    <relator term="honoree" code="hnr" usefor="honouree;honouree of item;"/>
    <relator term="host" code="hst"/>
    <relator term="host institution" code="his"/>
    <relator term="illuminator" code="ilu"/>
    <relator term="illustrator" code="ill"/>
    <relator term="inscriber" code="ins"/>
    <relator term="instrumentalist" code="itr"/>
    <relator term="interviewee" code="ive"/>
    <relator term="interviewer" code="ivr"/>
    <relator term="inventor" code="inv" usefor="patent inventor;"/>
    <relator term="issuing body" code="isb"/>
    <relator term="judge" code="jud"/>
    <relator term="jurisdiction governed" code="jug"/>
    <relator term="laboratory" code="lbr"/>
    <relator term="laboratory director" code="ldr" usefor="lab director;"/>
    <relator term="landscape architect" code="lsa"/>
    <relator term="lead" code="led"/>
    <relator term="lender" code="len"/>
    <relator term="libelant" code="lil"/>
    <relator term="libelant-appellant" code="lit"/>
    <relator term="libelant-appellee" code="lie"/>
    <relator term="libelee" code="lel"/>
    <relator term="libelee-appellant" code="let"/>
    <relator term="libelee-appellee" code="lee"/>
    <relator term="librettist" code="lbt"/>
    <relator term="licensee" code="lse"/>
    <relator term="licensor" code="lso" usefor="imprimatur;"/>
    <relator term="lighting designer" code="lgd"/>
    <relator term="lithographer" code="ltg"/>
    <relator term="lyricist" code="lyr"/>
    <relator term="manufacture place" code="mfp"/>
    <relator term="manufacturer" code="mfr"/>
    <relator term="marbler" code="mrb"/>
    <relator term="markup editor" code="mrk" usefor="encoder;"/>
    <relator term="medium" code="med"/>
    <relator term="metadata contact" code="mdc"/>
    <relator term="metal-engraver" code="mte"/>
    <relator term="minute taker" code="mtk"/>
    <relator term="moderator" code="mod"/>
    <relator term="monitor" code="mon"/>
    <relator term="music copyist" code="mcp"/>
    <relator term="musical director" code="msd"/>
    <relator term="musician" code="mus"/>
    <relator term="narrator" code="nrt"/>
    <relator term="onscreen presenter" code="osp"/>
    <relator term="opponent" code="opn"/>
    <relator term="organizer" code="orm" usefor="organizer of meeting;"/>
    <relator term="originator" code="org"/>
    <relator term="other" code="oth"/>
    <relator term="owner" code="own" usefor="current owner;"/>
    <relator term="panelist" code="pan"/>
    <relator term="papermaker" code="ppm"/>
    <relator term="patent applicant" code="pta"/>
    <relator term="patent holder" code="pth" usefor="patentee;"/>
    <relator term="patron" code="pat"/>
    <relator term="performer" code="prf"/>
    <relator term="permitting agency" code="pma"/>
    <relator term="photographer" code="pht"/>
    <relator term="plaintiff" code="ptf"/>
    <relator term="plaintiff-appellant" code="ptt"/>
    <relator term="plaintiff-appellee" code="pte"/>
    <relator term="platemaker" code="plt"/>
    <relator term="praeses" code="pra"/>
    <relator term="presenter" code="pre"/>
    <relator term="printer" code="prt"/>
    <relator term="printer of plates" code="pop" usefor="plates, printer of;"/>
    <relator term="printmaker" code="prm"/>
    <relator term="process contact" code="prc"/>
    <relator term="producer" code="pro"/>
    <relator term="production company" code="prn"/>
    <relator term="production designer" code="prs"/>
    <relator term="production manager" code="pmn"/>
    <relator term="production personnel" code="prd"/>
    <relator term="production place" code="prp"/>
    <relator term="programmer" code="prg"/>
    <relator term="project director" code="pdr"/>
    <relator term="proofreader" code="pfr"/>
    <relator term="provider" code="prv"/>
    <relator term="publication place" code="pup"/>
    <relator term="publisher" code="pbl"/>
    <relator term="publishing director" code="pbd"/>
    <relator term="puppeteer" code="ppt"/>
    <relator term="radio director" code="rdd"/>
    <relator term="radio producer" code="rpc"/>
    <relator term="recording engineer" code="rce"/>
    <relator term="recordist" code="rcd"/>
    <relator term="redaktor" code="red"/>
    <relator term="renderer" code="ren"/>
    <relator term="reporter" code="rpt"/>
    <relator term="repository" code="rps"/>
    <relator term="research team head" code="rth"/>
    <relator term="research team member" code="rtm"/>
    <relator term="researcher" code="res" usefor="performer of research;"/>
    <relator term="respondent" code="rsp"/>
    <relator term="respondent-appellant" code="rst"/>
    <relator term="respondent-appellee" code="rse"/>
    <relator term="responsible party" code="rpy"/>
    <relator term="restager" code="rsg"/>
    <relator term="restorationist" code="rsr"/>
    <relator term="reviewer" code="rev"/>
    <relator term="rubricator" code="rbr"/>
    <relator term="scenarist" code="sce"/>
    <relator term="scientific advisor" code="sad"/>
    <relator term="screenwriter" code="aus" usefor="author of screenplay, etc.;"/>
    <relator term="scribe" code="scr"/>
    <relator term="sculptor" code="scl"/>
    <relator term="second party" code="spy"/>
    <relator term="secretary" code="sec"/>
    <relator term="seller" code="sll"/>
    <relator term="set designer" code="std"/>
    <relator term="setting" code="stg"/>
    <relator term="signer" code="sgn"/>
    <relator term="singer" code="sng" usefor="vocalist;"/>
    <relator term="sound designer" code="sds"/>
    <relator term="speaker" code="spk"/>
    <relator term="sponsor" code="spn" usefor="sponsoring body;"/>
    <relator term="stage director" code="sgd"/>
    <relator term="stage manager" code="stm"/>
    <relator term="standards body" code="stn"/>
    <relator term="stereotyper" code="str"/>
    <relator term="storyteller" code="stl"/>
    <relator term="supporting host" code="sht" usefor="host, supporting;"/>
    <relator term="surveyor" code="srv"/>
    <relator term="teacher" code="tch" usefor="instructor;"/>
    <relator term="technical director" code="tcd"/>
    <relator term="television director" code="tld"/>
    <relator term="television producer" code="tlp"/>
    <relator term="thesis advisor" code="ths" usefor="promoter;"/>
    <relator term="transcriber" code="trc"/>
    <!-- Incorrect code, but common error -->
    <relator term="translator" code="tr"/>
    <relator term="translator" code="trl" usefor="tr;"/>
    <relator term="type designer" code="tyd" usefor="designer of type;"/>
    <relator term="typographer" code="tyg"/>
    <relator term="university place" code="uvp"/>
    <relator term="videographer" code="vdg"/>
    <relator term="voice actor" code="vac"/>
    <relator term="witness" code="wit" usefor="deponent;eyewitness;observer;onlooker;testifier;"/>
    <relator term="wood engraver" code="wde"/>
    <relator term="woodcutter" code="wdc"/>
    <relator term="writer of accompanying material" code="wam"/>
    <relator term="writer of added commentary" code="wac"/>
    <relator term="writer of added lyrics" code="wal"/>
    <relator term="writer of added text" code="wat"/>
    <relator term="writer of introduction" code="win"/>
    <relator term="writer of preface" code="wpr"/>
    <relator term="writer of supplementary textual content" code="wst"/>
  </xsl:variable>

</xsl:stylesheet>
