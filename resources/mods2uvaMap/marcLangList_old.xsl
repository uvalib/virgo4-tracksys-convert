<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

  <!-- MARC Code List for Languages, 2007 Edition, continuously updated, retrieved 2020/09/25 -->
  <xsl:variable name="marcLangList">
    <lang code="aar">Afar</lang>
    <lang code="abk">Abkhaz</lang>
    <lang code="ace">Achinese</lang>
    <lang code="ach">Acoli</lang>
    <lang code="ada">Adangme</lang>
    <lang code="ady">Adygei</lang>
    <lang code="afa">Afroasiatic (Other)</lang>
    <lang code="afh">Afrihili (Artificial language)</lang>
    <lang code="afr">Afrikaans</lang>
    <lang code="ain">Ainu</lang>
    <lang code="ajm" status="discontinued">Aljamía</lang>
    <lang code="aka">Akan</lang>
    <lang code="akk">Akkadian</lang>
    <lang code="alb">Albanian</lang>
    <lang code="ale">Aleut</lang>
    <lang code="alg">Algonquian (Other)</lang>
    <lang code="alt">Altai</lang>
    <lang code="amh">Amharic</lang>
    <lang code="ang">English, Old (ca. 450-1100)</lang>
    <lang code="anp">Angika</lang>
    <lang code="apa">Apache languages</lang>
    <lang code="ara">Arabic</lang>
    <lang code="arc">Aramaic</lang>
    <lang code="arg">Aragonese</lang>
    <lang code="arm">Armenian</lang>
    <lang code="arn">Mapuche</lang>
    <lang code="arp">Arapaho</lang>
    <lang code="art">Artificial (Other)</lang>
    <lang code="arw">Arawak</lang>
    <lang code="asm">Assamese</lang>
    <lang code="ast">Bable</lang>
    <lang code="ath">Athapascan (Other)</lang>
    <lang code="aus">Australian languages</lang>
    <lang code="ava">Avaric</lang>
    <lang code="ave">Avestan</lang>
    <lang code="awa">Awadhi</lang>
    <lang code="aym">Aymara</lang>
    <lang code="aze">Azerbaijani</lang>
    <lang code="bad">Banda languages</lang>
    <lang code="bai">Bamileke languages</lang>
    <lang code="bak">Bashkir</lang>
    <lang code="bal">Baluchi</lang>
    <lang code="bam">Bambara</lang>
    <lang code="ban">Balinese</lang>
    <lang code="baq">Basque</lang>
    <lang code="bas">Basa</lang>
    <lang code="bat">Baltic (Other)</lang>
    <lang code="bej">Beja</lang>
    <lang code="bel">Belarusian</lang>
    <lang code="bem">Bemba</lang>
    <lang code="ben">Bengali</lang>
    <lang code="ber">Berber (Other)</lang>
    <lang code="bho">Bhojpuri</lang>
    <lang code="bih">Bihari (Other) </lang>
    <lang code="bik">Bikol</lang>
    <lang code="bin">Edo</lang>
    <lang code="bis">Bislama</lang>
    <lang code="bla">Siksika</lang>
    <lang code="bnt">Bantu (Other)</lang>
    <lang code="bos">Bosnian</lang>
    <lang code="bra">Braj</lang>
    <lang code="bre">Breton</lang>
    <lang code="btk">Batak</lang>
    <lang code="bua">Buriat</lang>
    <lang code="bug">Bugis</lang>
    <lang code="bul">Bulgarian</lang>
    <lang code="bur">Burmese</lang>
    <lang code="byn">Bilin</lang>
    <lang code="cad">Caddo</lang>
    <lang code="cai">Central American Indian (Other)</lang>
    <lang code="cam" status="discontinued">Khmer</lang>
    <lang code="car">Carib</lang>
    <lang code="cat">Catalan</lang>
    <lang code="cau">Caucasian (Other)</lang>
    <lang code="ceb">Cebuano</lang>
    <lang code="cel">Celtic (Other)</lang>
    <lang code="cha">Chamorro</lang>
    <lang code="chb">Chibcha</lang>
    <lang code="che">Chechen</lang>
    <lang code="chg">Chagatai</lang>
    <lang code="chi">Chinese</lang>
    <lang code="chk">Chuukese</lang>
    <lang code="chm">Mari</lang>
    <lang code="chn">Chinook jargon</lang>
    <lang code="cho">Choctaw</lang>
    <lang code="chp">Chipewyan</lang>
    <lang code="chr">Cherokee</lang>
    <lang code="chu">Church Slavic</lang>
    <lang code="chv">Chuvash</lang>
    <lang code="chy">Cheyenne</lang>
    <lang code="cmc">Chamic languages</lang>
    <lang code="cop">Coptic</lang>
    <lang code="cor">Cornish</lang>
    <lang code="cos">Corsican</lang>
    <lang code="cpe">Creoles and Pidgins, English-based (Other)</lang>
    <lang code="cpf">Creoles and Pidgins, French-based (Other)</lang>
    <lang code="cpp">Creoles and Pidgins, Portuguese-based (Other)</lang>
    <lang code="cre">Cree</lang>
    <lang code="crh">Crimean Tatar</lang>
    <lang code="crp">Creoles and Pidgins (Other)</lang>
    <lang code="csb">Kashubian</lang>
    <lang code="cus">Cushitic (Other)</lang>
    <lang code="cze">Czech</lang>
    <lang code="dak">Dakota</lang>
    <lang code="dan">Danish</lang>
    <lang code="dar">Dargwa</lang>
    <lang code="day">Dayak</lang>
    <lang code="del">Delaware</lang>
    <lang code="den">Slavey</lang>
    <lang code="dgr">Dogrib</lang>
    <lang code="din">Dinka</lang>
    <lang code="div">Divehi</lang>
    <lang code="doi">Dogri</lang>
    <lang code="dra">Dravidian (Other)</lang>
    <lang code="dsb">Lower Sorbian</lang>
    <lang code="dua">Duala</lang>
    <lang code="dum">Dutch, Middle (ca. 1050-1350)</lang>
    <lang code="dut">Dutch</lang>
    <lang code="dyu">Dyula</lang>
    <lang code="dzo">Dzongkha</lang>
    <lang code="efi">Efik</lang>
    <lang code="egy">Egyptian</lang>
    <lang code="eka">Ekajuk</lang>
    <lang code="elx">Elamite</lang>
    <lang code="eng">English</lang>
    <lang code="enm">English, Middle (1100-1500)</lang>
    <lang code="epo">Esperanto</lang>
    <lang code="esk" status="discontinued">Eskimo languages</lang>
    <lang code="esp" status="discontinued">Esperanto</lang>
    <lang code="est">Estonian</lang>
    <lang code="eth" status="discontinued">Ethiopic</lang>
    <lang code="ewe">Ewe</lang>
    <lang code="ewo">Ewondo</lang>
    <lang code="fan">Fang</lang>
    <lang code="fao">Faroese</lang>
    <lang code="far" status="discontinued">Faroese</lang>
    <lang code="fat">Fanti</lang>
    <lang code="fij">Fijian</lang>
    <lang code="fil">Filipino</lang>
    <lang code="fin">Finnish</lang>
    <lang code="fiu">Finno-Ugrian (Other)</lang>
    <lang code="fon">Fon</lang>
    <lang code="fre">French</lang>
    <lang code="fri" status="discontinued">Frisian</lang>
    <lang code="frm">French, Middle (ca. 1300-1600)</lang>
    <lang code="fro">French, Old (ca. 842-1300)</lang>
    <lang code="frr">North Frisian</lang>
    <lang code="frs">East Frisian</lang>
    <lang code="fry">Frisian</lang>
    <lang code="ful">Fula</lang>
    <lang code="fur">Friulian</lang>
    <lang code="gaa">Gã</lang>
    <lang code="gae" status="discontinued">Scottish Gaelix</lang>
    <lang code="gag" status="discontinued">Galician</lang>
    <lang code="gal" status="discontinued">Oromo</lang>
    <lang code="gay">Gayo</lang>
    <lang code="gba">Gbaya</lang>
    <lang code="gem">Germanic (Other)</lang>
    <lang code="geo">Georgian</lang>
    <lang code="ger">German</lang>
    <lang code="gez">Ethiopic</lang>
    <lang code="gil">Gilbertese</lang>
    <lang code="gla">Scottish Gaelic</lang>
    <lang code="gle">Irish</lang>
    <lang code="glg">Galician</lang>
    <lang code="glv">Manx</lang>
    <lang code="gmh">German, Middle High (ca. 1050-1500)</lang>
    <lang code="goh">German, Old High (ca. 750-1050)</lang>
    <lang code="gon">Gondi</lang>
    <lang code="gor">Gorontalo</lang>
    <lang code="got">Gothic</lang>
    <lang code="grb">Grebo</lang>
    <lang code="grc">Greek, Ancient (to 1453)</lang>
    <lang code="gre">Greek, Modern (1453-)</lang>
    <lang code="grn">Guarani</lang>
    <lang code="gsw">Swiss German</lang>
    <lang code="gua" status="discontinued">Guarani</lang>
    <lang code="guj">Gujarati</lang>
    <lang code="gwi">Gwich'in</lang>
    <lang code="hai">Haida</lang>
    <lang code="hat">Haitian French Creole</lang>
    <lang code="hau">Hausa</lang>
    <lang code="haw">Hawaiian</lang>
    <lang code="heb">Hebrew</lang>
    <lang code="her">Herero</lang>
    <lang code="hil">Hiligaynon</lang>
    <lang code="him">Western Pahari languages</lang>
    <lang code="hin">Hindi</lang>
    <lang code="hit">Hittite</lang>
    <lang code="hmn">Hmong</lang>
    <lang code="hmo">Hiri Motu</lang>
    <lang code="hrv">Croatian</lang>
    <lang code="hsb">Upper Sorbian</lang>
    <lang code="hun">Hungarian</lang>
    <lang code="hup">Hupa</lang>
    <lang code="iba">Iban</lang>
    <lang code="ibo">Igbo</lang>
    <lang code="ice">Icelandic</lang>
    <lang code="ido">Ido</lang>
    <lang code="iii">Sichuan Yi</lang>
    <lang code="ijo">Ijo</lang>
    <lang code="iku">Inuktitut</lang>
    <lang code="ile">Interlingue</lang>
    <lang code="ilo">Iloko</lang>
    <lang code="ina">Interlingua (International Auxiliary Language Association)</lang>
    <lang code="inc">Indic (Other)</lang>
    <lang code="ind">Indonesian</lang>
    <lang code="ine">Indo-European (Other)</lang>
    <lang code="inh">Ingush</lang>
    <lang code="int" status="discontinued">Interlingua (International Auxiliary Language
      Association)</lang>
    <lang code="ipk">Inupiaq</lang>
    <lang code="ira">Iranian (Other)</lang>
    <lang code="iri" status="discontinued">Irish</lang>
    <lang code="iro">Iroquoian (Other)</lang>
    <lang code="ita">Italian</lang>
    <lang code="jav">Javanese</lang>
    <lang code="jbo">Lojban (Artificial language)</lang>
    <lang code="jpn">Japanese</lang>
    <lang code="jpr">Judeo-Persian</lang>
    <lang code="jrb">Judeo-Arabic</lang>
    <lang code="kaa">Kara-Kalpak</lang>
    <lang code="kab">Kabyle</lang>
    <lang code="kac">Kachin</lang>
    <lang code="kal">Kalâtdlisut</lang>
    <lang code="kam">Kamba</lang>
    <lang code="kan">Kannada</lang>
    <lang code="kar">Karen languages</lang>
    <lang code="kas">Kashmiri</lang>
    <lang code="kau">Kanuri</lang>
    <lang code="kaw">Kawi</lang>
    <lang code="kaz">Kazakh</lang>
    <lang code="kbd">Kabardian</lang>
    <lang code="kha">Khasi</lang>
    <lang code="khi">Khoisan (Other)</lang>
    <lang code="khm">Khmer</lang>
    <lang code="kho">Khotanese</lang>
    <lang code="kik">Kikuyu</lang>
    <lang code="kin">Kinyarwanda</lang>
    <lang code="kir">Kyrgyz</lang>
    <lang code="kmb">Kimbundu</lang>
    <lang code="kok">Konkani</lang>
    <lang code="kom">Komi</lang>
    <lang code="kon">Kongo</lang>
    <lang code="kor">Korean</lang>
    <lang code="kos">Kosraean</lang>
    <lang code="kpe">Kpelle</lang>
    <lang code="krc">Karachay-Balkar</lang>
    <lang code="krl">Karelian</lang>
    <lang code="kro">Kru (Other)</lang>
    <lang code="kru">Kurukh</lang>
    <lang code="kua">Kuanyama</lang>
    <lang code="kum">Kumyk</lang>
    <lang code="kur">Kurdish</lang>
    <lang code="kus" status="discontinued">Kusaie</lang>
    <lang code="kut">Kootenai</lang>
    <lang code="lad">Ladino</lang>
    <lang code="lah">Lahndā</lang>
    <lang code="lam">Lamba (Zambia and Congo)</lang>
    <lang code="lan" status="discontinued">Occitan (post 1500)</lang>
    <lang code="lao">Lao</lang>
    <lang code="lap" status="discontinued">Sami</lang>
    <lang code="lat">Latin</lang>
    <lang code="lav">Latvian</lang>
    <lang code="lez">Lezgian</lang>
    <lang code="lim">Limburgish</lang>
    <lang code="lin">Lingala</lang>
    <lang code="lit">Lithuanian</lang>
    <lang code="lol">Mongo-Nkundu</lang>
    <lang code="loz">Lozi</lang>
    <lang code="ltz">Luxembourgish</lang>
    <lang code="lua">Luba-Lulua</lang>
    <lang code="lub">Luba-Katanga</lang>
    <lang code="lug">Ganda</lang>
    <lang code="lui">Luiseño</lang>
    <lang code="lun">Lunda</lang>
    <lang code="luo">Luo (Kenya and Tanzania)</lang>
    <lang code="lus">Lushai</lang>
    <lang code="mac">Macedonian</lang>
    <lang code="mad">Madurese</lang>
    <lang code="mag">Magahi</lang>
    <lang code="mah">Marshallese</lang>
    <lang code="mai">Maithili</lang>
    <lang code="mak">Makasar</lang>
    <lang code="mal">Malayalam</lang>
    <lang code="man">Mandingo</lang>
    <lang code="mao">Maori</lang>
    <lang code="map">Austronesian (Other)</lang>
    <lang code="mar">Marathi</lang>
    <lang code="mas">Maasai</lang>
    <lang code="max" status="discontinued">Manx</lang>
    <lang code="may">Malay</lang>
    <lang code="mdf">Moksha</lang>
    <lang code="mdr">Mandar</lang>
    <lang code="men">Mende</lang>
    <lang code="mga">Irish, Middle (ca. 1100-1550)</lang>
    <lang code="mic">Micmac</lang>
    <lang code="min">Minangkabau</lang>
    <lang code="mis">Miscellaneous languages</lang>
    <lang code="mkh">Mon-Khmer (Other)</lang>
    <lang code="mla" status="discontinued">Malagasy</lang>
    <lang code="mlg">Malagasy</lang>
    <lang code="mlt">Maltese</lang>
    <lang code="mnc">Manchu</lang>
    <lang code="mni">Manipuri</lang>
    <lang code="mno">Manobo languages</lang>
    <lang code="moh">Mohawk</lang>
    <lang code="mol" status="discontinued">Moldavian</lang>
    <lang code="mon">Mongolian</lang>
    <lang code="mos">Mooré</lang>
    <lang code="mul">Multiple languages</lang>
    <lang code="mun">Munda (Other)</lang>
    <lang code="mus">Creek</lang>
    <lang code="mwl">Mirandese</lang>
    <lang code="mwr">Marwari</lang>
    <lang code="myn">Mayan languages</lang>
    <lang code="myv">Erzya</lang>
    <lang code="nah">Nahuatl</lang>
    <lang code="nai">North American Indian (Other)</lang>
    <lang code="nap">Neapolitan Italian</lang>
    <lang code="nau">Nauru</lang>
    <lang code="nav">Navajo</lang>
    <lang code="nbl">Ndebele (South Africa)</lang>
    <lang code="nde">Ndebele (Zimbabwe)</lang>
    <lang code="ndo">Ndonga</lang>
    <lang code="nds">Low German</lang>
    <lang code="nep">Nepali</lang>
    <lang code="new">Newari</lang>
    <lang code="nia">Nias</lang>
    <lang code="nic">Niger-Kordofanian (Other)</lang>
    <lang code="niu">Niuean</lang>
    <lang code="nno">Norwegian (Nynorsk)</lang>
    <lang code="nob">Norwegian (Bokmål)</lang>
    <lang code="nog">Nogai</lang>
    <lang code="non">Old Norse</lang>
    <lang code="nor">Norwegian</lang>
    <lang code="nqo">N'Ko</lang>
    <lang code="nso">Northern Sotho</lang>
    <lang code="nub">Nubian languages</lang>
    <lang code="nwc">Newari, Old</lang>
    <lang code="nya">Nyanja</lang>
    <lang code="nym">Nyamwezi</lang>
    <lang code="nyn">Nyankole</lang>
    <lang code="nyo">Nyoro</lang>
    <lang code="nzi">Nzima</lang>
    <lang code="oci">Occitan (post-1500)</lang>
    <lang code="oji">Ojibwa</lang>
    <lang code="ori">Oriya</lang>
    <lang code="orm">Oromo</lang>
    <lang code="osa">Osage</lang>
    <lang code="oss">Ossetic</lang>
    <lang code="ota">Turkish, Ottoman</lang>
    <lang code="oto">Otomian languages</lang>
    <lang code="paa">Papuan (Other)</lang>
    <lang code="pag">Pangasinan</lang>
    <lang code="pal">Pahlavi</lang>
    <lang code="pam">Pampanga</lang>
    <lang code="pan">Panjabi</lang>
    <lang code="pap">Papiamento</lang>
    <lang code="pau">Palauan</lang>
    <lang code="peo">Old Persian (ca. 600-400 B.C.)</lang>
    <lang code="per">Persian</lang>
    <lang code="phi">Philippine (Other)</lang>
    <lang code="phn">Phoenician</lang>
    <lang code="pli">Pali</lang>
    <lang code="pol">Polish</lang>
    <lang code="pon">Pohnpeian</lang>
    <lang code="por">Portuguese</lang>
    <lang code="pra">Prakrit languages</lang>
    <lang code="pro">Provençal (to 1500)</lang>
    <lang code="pus">Pushto</lang>
    <lang code="que">Quechua</lang>
    <lang code="raj">Rajasthani</lang>
    <lang code="rap">Rapanui</lang>
    <lang code="rar">Rarotongan</lang>
    <lang code="roa">Romance (Other)</lang>
    <lang code="roh">Raeto-Romance</lang>
    <lang code="rom">Romani</lang>
    <lang code="rum">Romanian</lang>
    <lang code="run">Rundi</lang>
    <lang code="rup">Aromanian</lang>
    <lang code="rus">Russian</lang>
    <lang code="sad">Sandawe</lang>
    <lang code="sag">Sango (Ubangi Creole)</lang>
    <lang code="sah">Yakut</lang>
    <lang code="sai">South American Indian (Other)</lang>
    <lang code="sal">Salishan languages</lang>
    <lang code="sam">Samaritan Aramaic</lang>
    <lang code="san">Sanskrit</lang>
    <lang code="sao" status="discontinued">Samoan</lang>
    <lang code="sas">Sasak</lang>
    <lang code="sat">Santali</lang>
    <lang code="scc" status="discontinued">Serbian</lang>
    <lang code="scn">Sicilian Italian</lang>
    <lang code="sco">Scots</lang>
    <lang code="scr" status="discontinued">Croatian</lang>
    <lang code="sel">Selkup</lang>
    <lang code="sem">Semitic (Other)</lang>
    <lang code="sga">Irish, Old (to 1100)</lang>
    <lang code="sgn">Sign languages</lang>
    <lang code="shn">Shan</lang>
    <lang code="sho" status="discontinued">Shona</lang>
    <lang code="sid">Sidamo</lang>
    <lang code="sin">Sinhalese</lang>
    <lang code="sio">Siouan (Other)</lang>
    <lang code="sit">Sino-Tibetan (Other)</lang>
    <lang code="sla">Slavic (Other)</lang>
    <lang code="slo">Slovak</lang>
    <lang code="slv">Slovenian</lang>
    <lang code="sma">Southern Sami</lang>
    <lang code="sme">Northern Sami</lang>
    <lang code="smi">Sami</lang>
    <lang code="smj">Lule Sami</lang>
    <lang code="smn">Inari Sami</lang>
    <lang code="smo">Samoan</lang>
    <lang code="sms">Skolt Sami</lang>
    <lang code="sna">Shona</lang>
    <lang code="snd">Sindhi</lang>
    <lang code="snh" status="discontinued">Sinhalese</lang>
    <lang code="snk">Soninke</lang>
    <lang code="sog">Sogdian</lang>
    <lang code="som">Somali</lang>
    <lang code="son">Songhai</lang>
    <lang code="sot">Sotho</lang>
    <lang code="spa">Spanish</lang>
    <lang code="srd">Sardinian</lang>
    <lang code="srn">Sranan</lang>
    <lang code="srp">Serbian</lang>
    <lang code="srr">Serer</lang>
    <lang code="ssa">Nilo-Saharan (Other)</lang>
    <lang code="sso" status="discontinued">Sotho</lang>
    <lang code="ssw">Swazi</lang>
    <lang code="suk">Sukuma</lang>
    <lang code="sun">Sundanese</lang>
    <lang code="sus">Susu</lang>
    <lang code="sux">Sumerian</lang>
    <lang code="swa">Swahili</lang>
    <lang code="swe">Swedish</lang>
    <lang code="swz" status="discontinued">Swazi</lang>
    <lang code="syc">Syriac</lang>
    <lang code="syr">Syriac, Modern</lang>
    <lang code="tag" status="discontinued">Tagalog</lang>
    <lang code="tah">Tahitian</lang>
    <lang code="tai">Tai (Other)</lang>
    <lang code="taj" status="discontinued">Tajik</lang>
    <lang code="tam">Tamil</lang>
    <lang code="tar" status="discontinued">Tatar</lang>
    <lang code="tat">Tatar</lang>
    <lang code="tel">Telugu</lang>
    <lang code="tem">Temne</lang>
    <lang code="ter">Terena</lang>
    <lang code="tet">Tetum</lang>
    <lang code="tgk">Tajik</lang>
    <lang code="tgl">Tagalog</lang>
    <lang code="tha">Thai</lang>
    <lang code="tib">Tibetan</lang>
    <lang code="tig">Tigré</lang>
    <lang code="tir">Tigrinya</lang>
    <lang code="tiv">Tiv</lang>
    <lang code="tkl">Tokelauan</lang>
    <lang code="tlh">Klingon (Artificial language)</lang>
    <lang code="tli">Tlingit</lang>
    <lang code="tmh">Tamashek</lang>
    <lang code="tog">Tonga (Nyasa)</lang>
    <lang code="ton">Tongan</lang>
    <lang code="tpi">Tok Pisin</lang>
    <lang code="tru" status="discontinued">Truk</lang>
    <lang code="tsi">Tsimshian</lang>
    <lang code="tsn">Tswana</lang>
    <lang code="tso">Tsonga</lang>
    <lang code="tsw" status="discontinued">Tswana</lang>
    <lang code="tuk">Turkmen</lang>
    <lang code="tum">Tumbuka</lang>
    <lang code="tup">Tupi languages</lang>
    <lang code="tur">Turkish</lang>
    <lang code="tut">Altaic (Other)</lang>
    <lang code="tvl">Tuvaluan</lang>
    <lang code="twi">Twi</lang>
    <lang code="tyv">Tuvinian</lang>
    <lang code="udm">Udmurt</lang>
    <lang code="uga">Ugaritic</lang>
    <lang code="uig">Uighur</lang>
    <lang code="ukr">Ukrainian</lang>
    <lang code="umb">Umbundu</lang>
    <lang code="und">Undetermined</lang>
    <lang code="urd">Urdu</lang>
    <lang code="uzb">Uzbek</lang>
    <lang code="vai">Vai</lang>
    <lang code="ven">Venda</lang>
    <lang code="vie">Vietnamese</lang>
    <lang code="vol">Volapük</lang>
    <lang code="vot">Votic</lang>
    <lang code="wak">Wakashan languages</lang>
    <lang code="wal">Wolayta</lang>
    <lang code="war">Waray</lang>
    <lang code="was">Washoe</lang>
    <lang code="wel">Welsh</lang>
    <lang code="wen">Sorbian (Other)</lang>
    <lang code="wln">Walloon</lang>
    <lang code="wol">Wolof</lang>
    <lang code="xal">Oirat</lang>
    <lang code="xho">Xhosa</lang>
    <lang code="yao">Yao (Africa)</lang>
    <lang code="yap">Yapese</lang>
    <lang code="yid">Yiddish</lang>
    <lang code="yor">Yoruba</lang>
    <lang code="ypk">Yupik languages</lang>
    <lang code="zap">Zapotec</lang>
    <lang code="zbl">Blissymbolics</lang>
    <lang code="zen">Zenaga</lang>
    <lang code="zha">Zhuang</lang>
    <lang code="znd">Zande languages</lang>
    <lang code="zul">Zulu</lang>
    <lang code="zun">Zuni</lang>
    <lang code="zxx">No linguistic content</lang>
    <lang code="zza">Zaza</lang>
  </xsl:variable>

</xsl:stylesheet>
