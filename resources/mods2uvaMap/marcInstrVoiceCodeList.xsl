<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

  <!-- MARC Instruments or Voices Code List, https://www.loc.gov/standards/valuelist/marcmusperf.html, retrieved 2020/09/25  -->
  <xsl:variable name="instrVoiceMap">
    <instrvoice code="ba" family="brass">horn</instrvoice>
    <instrvoice code="bb" family="brass">trumpet</instrvoice>
    <instrvoice code="bc" family="brass">cornet</instrvoice>
    <instrvoice code="bd" family="brass">trombone</instrvoice>
    <instrvoice code="be" family="brass">tuba</instrvoice>
    <instrvoice code="bf" family="brass">baritone</instrvoice>
    <instrvoice code="bn" family="brass">brass instrument</instrvoice>
    <instrvoice code="bu" family="brass">brass instrument</instrvoice>
    <instrvoice code="by" family="brass">ethnic brass</instrvoice>
    <instrvoice code="bz" family="brass">brass instrument</instrvoice>
    <instrvoice code="ca" family="choruses">mixed chorus</instrvoice>
    <instrvoice code="cb" family="choruses">women's chorus</instrvoice>
    <instrvoice code="cc" family="choruses">men's chorus</instrvoice>
    <instrvoice code="cd" family="choruses">children's chorus</instrvoice>
    <instrvoice code="cn" family="choruses">chorus</instrvoice>
    <instrvoice code="cu" family="choruses">chorus</instrvoice>
    <instrvoice code="cy" family="choruses">ethnic chorus</instrvoice>
    <instrvoice code="ea" family="electronic">synthesizer</instrvoice>
    <instrvoice code="eb" family="electronic">tape</instrvoice>
    <instrvoice code="ec" family="electronic">computer</instrvoice>
    <instrvoice code="ed" family="electronic">ondes martinot</instrvoice>
    <instrvoice code="en" family="electronic">electronics</instrvoice>
    <instrvoice code="eu" family="electronic">electronics</instrvoice>
    <instrvoice code="ez" family="electronic">electronics</instrvoice>
    <instrvoice code="ka" family="keyboard">piano</instrvoice>
    <instrvoice code="kb" family="keyboard">organ</instrvoice>
    <instrvoice code="kc" family="keyboard">harpsichord</instrvoice>
    <instrvoice code="kd" family="keyboard">clavichord</instrvoice>
    <instrvoice code="ke" family="keyboard">continuo</instrvoice>
    <instrvoice code="kf" family="keyboard">celeste</instrvoice>
    <instrvoice code="kn" family="keyboard">keyboard instrument</instrvoice>
    <instrvoice code="ku" family="keyboard">keyboard instrument</instrvoice>
    <instrvoice code="ky" family="keyboard">ethnic keyboard</instrvoice>
    <instrvoice code="kz" family="keyboard">keyboard instrument</instrvoice>
    <instrvoice code="oa" family="ensemble">full orchestra</instrvoice>
    <instrvoice code="ob" family="ensemble">chamber orchestra</instrvoice>
    <instrvoice code="oc" family="ensemble">string orchestra</instrvoice>
    <instrvoice code="od" family="ensemble">band</instrvoice>
    <instrvoice code="oe" family="ensemble">dance orchestra</instrvoice>
    <instrvoice code="of" family="ensemble">brass band</instrvoice>
    <instrvoice code="on" family="ensemble">ensemble</instrvoice>
    <instrvoice code="ou" family="ensemble">ensemble</instrvoice>
    <instrvoice code="oy" family="ensemble">ethnic ensemble</instrvoice>
    <instrvoice code="oz" family="ensemble">ensemble</instrvoice>
    <instrvoice code="pa" family="percussion">timpani</instrvoice>
    <instrvoice code="pb" family="percussion">xylophone</instrvoice>
    <instrvoice code="pc" family="percussion">marimba</instrvoice>
    <instrvoice code="pd" family="percussion">drum</instrvoice>
    <instrvoice code="pn" family="percussion">percussion</instrvoice>
    <instrvoice code="pu" family="percussion">percussion</instrvoice>
    <instrvoice code="py" family="percussion">ethnic percussion</instrvoice>
    <instrvoice code="pz" family="percussion">percussion</instrvoice>
    <instrvoice code="sa" family="strings, bowed">violin</instrvoice>
    <instrvoice code="sb" family="strings, bowed">viola</instrvoice>
    <instrvoice code="sc" family="strings, bowed">violoncello</instrvoice>
    <instrvoice code="sd" family="strings, bowed">double bass</instrvoice>
    <instrvoice code="se" family="strings, bowed">viol</instrvoice>
    <instrvoice code="sf" family="strings, bowed">viola d'amore</instrvoice>
    <instrvoice code="sg" family="strings, bowed">viola da gamba</instrvoice>
    <instrvoice code="sn" family="strings, bowed">bowed strings</instrvoice>
    <instrvoice code="su" family="strings, bowed">bowed strings</instrvoice>
    <instrvoice code="sy" family="strings, bowed">ethnic bowed strings</instrvoice>
    <instrvoice code="sz" family="strings, bowed">bowed strings</instrvoice>
    <instrvoice code="ta" family="strings, plucked">harp</instrvoice>
    <instrvoice code="tb" family="strings, plucked">guitar</instrvoice>
    <instrvoice code="tc" family="strings, plucked">lute</instrvoice>
    <instrvoice code="td" family="strings, plucked">mandolin</instrvoice>
    <instrvoice code="tn" family="strings, plucked">plucked strings</instrvoice>
    <instrvoice code="tu" family="strings, plucked">plucked strings</instrvoice>
    <instrvoice code="ty" family="strings, plucked">ethnic plucked strings</instrvoice>
    <instrvoice code="tz" family="strings, plucked">plucked strings</instrvoice>
    <instrvoice code="va" family="voices">soprano</instrvoice>
    <instrvoice code="vb" family="voices">mezzo soprano</instrvoice>
    <instrvoice code="vc" family="voices">alto</instrvoice>
    <instrvoice code="vd" family="voices">tenor</instrvoice>
    <instrvoice code="ve" family="voices">baritone</instrvoice>
    <instrvoice code="vf" family="voices">bass</instrvoice>
    <instrvoice code="vg" family="voices">counter tenor</instrvoice>
    <instrvoice code="vh" family="voices">high voice</instrvoice>
    <instrvoice code="vi" family="voices">medium voice</instrvoice>
    <instrvoice code="vj" family="voices">low voice</instrvoice>
    <instrvoice code="vn" family="voices">voice</instrvoice>
    <instrvoice code="vu" family="voices">voice</instrvoice>
    <instrvoice code="vy" family="voices">ethnic voice</instrvoice>
    <instrvoice code="wa" family="woodwinds">flute</instrvoice>
    <instrvoice code="wb" family="woodwinds">oboe</instrvoice>
    <instrvoice code="wc" family="woodwinds">clarinet</instrvoice>
    <instrvoice code="wd" family="woodwinds">bassoon</instrvoice>
    <instrvoice code="we" family="woodwinds">piccolo</instrvoice>
    <instrvoice code="wf" family="woodwinds">english horn</instrvoice>
    <instrvoice code="wg" family="woodwinds">bass clarinet</instrvoice>
    <instrvoice code="wh" family="woodwinds">recorder</instrvoice>
    <instrvoice code="wi" family="woodwinds">saxophone</instrvoice>
    <instrvoice code="wn" family="woodwinds">woodwind</instrvoice>
    <instrvoice code="wu" family="woodwinds">woodwind</instrvoice>
    <instrvoice code="wy" family="woodwinds">ethnic woodwind</instrvoice>
    <instrvoice code="wz" family="woodwinds">woodwind</instrvoice>
    <instrvoice code="zn" family="unspecified">unspecified</instrvoice>
    <instrvoice code="zu" family="unknown">instrument</instrvoice>
  </xsl:variable>
</xsl:stylesheet>
