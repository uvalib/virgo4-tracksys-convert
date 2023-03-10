<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

  <!-- Based on MARC Initial Definite and Indefinite Articles, rev. Oct 2001, https://www.loc.gov/marc/bibliographic/bdapndxf.html, retrieved 2020/10/11 -->
  <xsl:variable name="marcArticleList">
    <entry>
      <article>a</article>
      <lang>English</lang>
      <lang>Galician</lang>
      <lang>Hungarian</lang>
      <lang>Portuguese</lang>
      <lang>Romanian</lang>
      <lang>Scots</lang>
      <lang>Yiddish</lang>
    </entry>
    <entry>
      <article>a'</article>
      <lang>Scottish Gaelic</lang>
    </entry>
    <entry>
      <article>aik</article>
      <lang>Urdu</lang>
    </entry>
    <entry>
      <article>ake</article>
      <lang>Persian</lang>
    </entry>
    <entry>
      <article>al</article>
      <lang>Romanian</lang>
    </entry>
    <entry>
      <article>al-</article>
      <lang>Arabic</lang>
      <lang>Baluchi</lang>
      <lang>Brahui</lang>
      <lang>Panjabi</lang>
      <lang>Punjabi</lang>
      <lang>Persian</lang>
      <lang>Turkish</lang>
      <lang>Urdu</lang>
    </entry>
    <entry>
      <article>am</article>
      <lang>Scottish Gaelic</lang>
    </entry>
    <entry>
      <article>an</article>
      <lang>English</lang>
      <lang>Irish</lang>
      <lang>Scots</lang>
      <lang>Scottish Gaelic</lang>
      <lang>Yiddish</lang>
    </entry>
    <entry>
      <article>an t-</article>
      <lang>Irish</lang>
      <lang>Scottish Gaelic</lang>
    </entry>
    <entry>
      <article>ane</article>
      <lang>Scots</lang>
    </entry>
    <entry>
      <article>ang</article>
      <lang>Tagalog</lang>
    </entry>
    <entry>
      <article>ang mga</article>
      <lang>Tagalog</lang>
    </entry>
    <entry>
      <article>as</article>
      <lang>Galician</lang>
      <lang>Portuguese</lang>
    </entry>
    <entry>
      <article>az</article>
      <lang>Hungarian</lang>
    </entry>
    <entry>
      <article>bat</article>
      <lang>Basque</lang>
    </entry>
    <entry>
      <article>bir</article>
      <lang>Turkish</lang>
    </entry>
    <entry>
      <article>d'</article>
      <lang>English</lang>
    </entry>
    <entry>
      <article>da</article>
      <lang>Shetland English</lang>
    </entry>
    <entry>
      <article>das</article>
      <lang>German</lang>
    </entry>
    <entry>
      <article>de</article>
      <lang>Danish</lang>
      <lang>Dutch</lang>
      <lang>English</lang>
      <lang>Frisian</lang>
      <lang>Norwegian</lang>
      <lang>Swedish</lang>
    </entry>
    <entry>
      <article>dei</article>
      <lang>Norwegian</lang>
    </entry>
    <entry>
      <article>dem</article>
      <lang>German</lang>
    </entry>
    <entry>
      <article>den</article>
      <lang>Danish</lang>
      <lang>German</lang>
      <lang>Norwegian</lang>
      <lang>Swedish</lang>
    </entry>
    <entry>
      <article>der</article>
      <lang>German</lang>
      <lang>Yiddish</lang>
    </entry>
    <entry>
      <article>des</article>
      <lang>German</lang>
      <lang>Walloon</lang>
    </entry>
    <entry>
      <article>det</article>
      <lang>Danish</lang>
      <lang>Norwegian</lang>
      <lang>Swedish</lang>
    </entry>
    <entry>
      <article>di</article>
      <lang>Yiddish</lang>
    </entry>
    <entry>
      <article>die</article>
      <lang>Afrikaans</lang>
      <lang>German</lang>
      <lang>Yiddish</lang>
    </entry>
    <entry>
      <article>dos</article>
      <lang>Yiddish</lang>
    </entry>
    <entry>
      <article>e</article>
      <lang>Norwegian</lang>
    </entry>
    <entry>
      <article>'e</article>
      <lang>Frisian</lang>
    </entry>
    <entry>
      <article>een</article>
      <lang>Dutch</lang>
    </entry>
    <entry>
      <article>eene</article>
      <lang>Dutch</lang>
    </entry>
    <entry>
      <article>egy</article>
      <lang>Hungarian</lang>
    </entry>
    <entry>
      <article>ei</article>
      <lang>Norwegian</lang>
    </entry>
    <entry>
      <article>ein</article>
      <lang>German</lang>
      <lang>Norwegian</lang>
      <lang>Walloon</lang>
    </entry>
    <entry>
      <article>eine</article>
      <lang>German</lang>
    </entry>
    <entry>
      <article>einem</article>
      <lang>German</lang>
    </entry>
    <entry>
      <article>einen</article>
      <lang>German</lang>
    </entry>
    <entry>
      <article>einer</article>
      <lang>German</lang>
    </entry>
    <entry>
      <article>eines</article>
      <lang>German</lang>
    </entry>
    <entry>
      <article>eit</article>
      <lang>Norwegian</lang>
    </entry>
    <entry>
      <article>el</article>
      <lang>Catalan</lang>
      <lang>Spanish</lang>
    </entry>
    <entry>
      <article>el-</article>
      <lang>Arabic</lang>
    </entry>
    <entry>
      <article>els</article>
      <lang>Catalan</lang>
    </entry>
    <entry>
      <article>en</article>
      <lang>Catalan</lang>
      <lang>Danish</lang>
      <lang>Norwegian</lang>
      <lang>Swedish</lang>
    </entry>
    <entry>
      <article>enne</article>
      <lang>Walloon</lang>
    </entry>
    <entry>
      <article>et</article>
      <lang>Danish</lang>
      <lang>Norwegian</lang>
    </entry>
    <entry>
      <article>ett</article>
      <lang>Swedish</lang>
    </entry>
    <entry>
      <article>eyn</article>
      <lang>Yiddish</lang>
    </entry>
    <entry>
      <article>eyne</article>
      <lang>Yiddish</lang>
    </entry>
    <entry>
      <article>gl'</article>
      <lang>Italian</lang>
    </entry>
    <entry>
      <article>gli</article>
      <lang>Italian</lang>
    </entry>
    <entry>
      <article>ha-</article>
      <lang>Hebrew</lang>
    </entry>
    <entry>
      <article>hai</article>
      <lang>Classical Greek</lang>
      <lang>Greek</lang>
    </entry>
    <entry>
      <article>he</article>
      <lang>Hawaiian</lang>
    </entry>
    <entry>
      <article>h??</article>
      <lang>Classical Greek</lang>
      <lang>Greek</lang>
    </entry>
    <entry>
      <article>he-</article>
      <lang>Hebrew</lang>
    </entry>
    <entry>
      <article>heis</article>
      <lang>Greek</lang>
    </entry>
    <entry>
      <article>hen</article>
      <lang>Greek</lang>
    </entry>
    <entry>
      <article>hena</article>
      <lang>Greek</lang>
    </entry>
    <entry>
      <article>henas</article>
      <lang>Greek</lang>
    </entry>
    <entry>
      <article>het</article>
      <lang>Dutch</lang>
    </entry>
    <entry>
      <article>hin</article>
      <lang>Icelandic</lang>
    </entry>
    <entry>
      <article>hina</article>
      <lang>Icelandic</lang>
    </entry>
    <entry>
      <article>hinar</article>
      <lang>Icelandic</lang>
    </entry>
    <entry>
      <article>hinir</article>
      <lang>Icelandic</lang>
    </entry>
    <entry>
      <article>hinn</article>
      <lang>Icelandic</lang>
    </entry>
    <entry>
      <article>hinna</article>
      <lang>Icelandic</lang>
    </entry>
    <entry>
      <article>hinnar</article>
      <lang>Icelandic</lang>
    </entry>
    <entry>
      <article>hinni</article>
      <lang>Icelandic</lang>
    </entry>
    <entry>
      <article>hins</article>
      <lang>Icelandic</lang>
    </entry>
    <entry>
      <article>hinu</article>
      <lang>Icelandic</lang>
    </entry>
    <entry>
      <article>hinum</article>
      <lang>Icelandic</lang>
    </entry>
    <entry>
      <article>hi??</article>
      <lang>Icelandic</lang>
    </entry>
    <entry>
      <article>ho</article>
      <lang>Classical Greek</lang>
      <lang>Greek</lang>
    </entry>
    <entry>
      <article>hoi</article>
      <lang>Classical Greek</lang>
      <lang>Greek</lang>
    </entry>
    <entry>
      <article>i</article>
      <lang>Italian</lang>
    </entry>
    <entry>
      <article>ih'</article>
      <lang>Proven??al</lang>
    </entry>
    <entry>
      <article>iha</article>
      <lang>Panjabi</lang>
      <lang>Punjabi</lang>
    </entry>
    <entry>
      <article>ika</article>
      <lang>Panjabi</lang>
      <lang>Punjabi</lang>
    </entry>
    <entry>
      <article>il</article>
      <lang>Italian</lang>
      <lang>Occitan</lang>
      <lang>Proven??al</lang>
    </entry>
    <entry>
      <article>il-</article>
      <lang>Maltese</lang>
    </entry>
    <entry>
      <article>in</article>
      <lang>Frisian</lang>
    </entry>
    <entry>
      <article>it</article>
      <lang>Frisian</lang>
    </entry>
    <entry>
      <article>ka</article>
      <lang>Hawaiian</lang>
    </entry>
    <entry>
      <article>ke</article>
      <lang>Hawaiian</lang>
    </entry>
    <entry>
      <article>l'</article>
      <lang>Catalan</lang>
      <lang>French</lang>
      <lang>Italian</lang>
      <lang>Occitan</lang>
      <lang>Proven??al</lang>
      <lang>Walloon</lang>
    </entry>
    <entry>
      <article>l-</article>
      <lang>Maltese</lang>
    </entry>
    <entry>
      <article>la</article>
      <lang>Catalan</lang>
      <lang>Esperanto</lang>
      <lang>French</lang>
      <lang>Italian</lang>
      <lang>Occitan</lang>
      <lang>Proven??al</lang>
      <lang>Spanish</lang>
    </entry>
    <entry>
      <article>las</article>
      <lang>Occitan</lang>
      <lang>Proven??al</lang>
      <lang>Spanish</lang>
    </entry>
    <entry>
      <article>le</article>
      <lang>French</lang>
      <lang>Italian</lang>
      <lang>Occitan</lang>
      <lang>Proven??al</lang>
    </entry>
    <entry>
      <article>les</article>
      <lang>Catalan</lang>
      <lang>French</lang>
      <lang>Occitan</lang>
      <lang>Proven??al</lang>
      <lang>Walloon</lang>
    </entry>
    <entry>
      <article>lh</article>
      <lang>Occitan</lang>
      <lang>Proven??al</lang>
    </entry>
    <entry>
      <article>lhi</article>
      <lang>Occitan</lang>
      <lang>Proven??al</lang>
    </entry>
    <entry>
      <article>li</article>
      <lang>Occitan</lang>
      <lang>Proven??al</lang>
    </entry>
    <entry>
      <article>lis</article>
      <lang>Occitan</lang>
      <lang>Proven??al</lang>
    </entry>
    <entry>
      <article>lo</article>
      <lang>Italian</lang>
      <lang>Occitan</lang>
      <lang>Proven??al</lang>
      <lang>Spanish</lang>
    </entry>
    <entry>
      <article>los</article>
      <lang>Occitan</lang>
      <lang>Proven??al</lang>
      <lang>Spanish</lang>
    </entry>
    <entry>
      <article>lou</article>
      <lang>Occitan</lang>
      <lang>Proven??al</lang>
    </entry>
    <entry>
      <article>lu</article>
      <lang>Occitan</lang>
      <lang>Proven??al</lang>
    </entry>
    <entry>
      <article>mga</article>
      <lang>Tagalog</lang>
    </entry>
    <entry>
      <article>mia</article>
      <lang>Greek</lang>
    </entry>
    <entry>
      <article>'n</article>
      <lang>Afrikaans</lang>
      <lang>Dutch</lang>
      <lang>Frisian</lang>
    </entry>
    <entry>
      <article>na</article>
      <lang>Hawaiian</lang>
      <lang>Irish</lang>
      <lang>Scottish Gaelic</lang>
    </entry>
    <entry>
      <article>na h-</article>
      <lang>Irish</lang>
      <lang>Scottish Gaelic</lang>
    </entry>
    <entry>
      <article>nj??</article>
      <lang>Albanian</lang>
    </entry>
    <entry>
      <article>ny</article>
      <lang>Malagasy</lang>
    </entry>
    <entry>
      <article>'o</article>
      <lang>Neapolitan Italian</lang>
    </entry>
    <entry>
      <article>o</article>
      <lang>Galician</lang>
      <lang>Hawaiian</lang>
      <lang>Portuguese</lang>
      <lang>Romanian</lang>
    </entry>
    <entry>
      <article>os</article>
      <lang>Portuguese</lang>
    </entry>
    <entry>
      <article>'r</article>
      <lang>Icelandic</lang>
    </entry>
    <entry>
      <article>'s</article>
      <lang>German</lang>
    </entry>
    <entry>
      <article>'t</article>
      <lang>Dutch</lang>
      <lang>Frisian</lang>
    </entry>
    <entry>
      <article>ta</article>
      <lang>Classical Greek</lang>
      <lang>Greek</lang>
    </entry>
    <entry>
      <article>tais</article>
      <lang>Classical Greek</lang>
    </entry>
    <entry>
      <article>tas</article>
      <lang>Classical Greek</lang>
    </entry>
    <entry>
      <article>t??</article>
      <lang>Classical Greek</lang>
    </entry>
    <entry>
      <article>t??n</article>
      <lang>Classical Greek</lang>
      <lang>Greek</lang>
    </entry>
    <entry>
      <article>t??s</article>
      <lang>Classical Greek</lang>
      <lang>Greek</lang>
    </entry>
    <entry>
      <article>the</article>
      <lang>English</lang>
    </entry>
    <entry>
      <article>to</article>
      <lang>Classical Greek</lang>
      <lang>Greek</lang>
    </entry>
    <entry>
      <article>t??</article>
      <lang>Classical Greek</lang>
    </entry>
    <entry>
      <article>tois</article>
      <lang>Classical Greek</lang>
    </entry>
    <entry>
      <article>ton</article>
      <lang>Classical Greek</lang>
      <lang>Greek</lang>
    </entry>
    <entry>
      <article>t??n</article>
      <lang>Classical Greek</lang>
      <lang>Greek</lang>
    </entry>
    <entry>
      <article>tou</article>
      <lang>Classical Greek</lang>
      <lang>Greek</lang>
    </entry>
    <entry>
      <article>um</article>
      <lang>Portuguese</lang>
    </entry>
    <entry>
      <article>uma</article>
      <lang>Portuguese</lang>
    </entry>
    <entry>
      <article>un</article>
      <lang>Catalan</lang>
      <lang>French</lang>
      <lang>Italian</lang>
      <lang>Occitan</lang>
      <lang>Proven??al</lang>
      <lang>Romanian</lang>
      <lang>Spanish</lang>
    </entry>
    <entry>
      <article>un'</article>
      <lang>Italian</lang>
    </entry>
    <entry>
      <article>una</article>
      <lang>Catalan</lang>
      <lang>Italian</lang>
      <lang>Occitan</lang>
      <lang>Proven??al</lang>
      <lang>Spanish</lang>
    </entry>
    <entry>
      <article>une</article>
      <lang>French</lang>
    </entry>
    <entry>
      <article>unei</article>
      <lang>Romanian</lang>
    </entry>
    <entry>
      <article>unha</article>
      <lang>Galician</lang>
    </entry>
    <entry>
      <article>uno</article>
      <lang>Italian</lang>
      <lang>Occitan</lang>
      <lang>Proven??al</lang>
    </entry>
    <entry>
      <article>uns</article>
      <lang>Occitan</lang>
      <lang>Proven??al</lang>
    </entry>
    <entry>
      <article>unui</article>
      <lang>Romanian</lang>
    </entry>
    <entry>
      <article>us</article>
      <lang>Occitan</lang>
      <lang>Proven??al</lang>
    </entry>
    <entry>
      <article>y</article>
      <lang>Welsh</lang>
    </entry>
    <entry>
      <article>ye</article>
      <lang>English</lang>
    </entry>
    <entry>
      <article>yr</article>
      <lang>Welsh</lang>
    </entry>
  </xsl:variable>
</xsl:stylesheet>
