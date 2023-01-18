<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

  <!-- MARC Geographic Areas Code List, 2006 Edition, [Updated April 7, 2008] -->
  <xsl:variable name="geographicAreas">
    <geoArea code="a">Asia</geoArea>
    <geoArea code="a-af">Afghanistan</geoArea>
    <geoArea code="a-ai">Armenia (Republic)</geoArea>
    <geoArea code="a-aj">Azerbaijan</geoArea>
    <geoArea code="a-ba">Bahrain</geoArea>
    <geoArea code="a-bg">Bangladesh</geoArea>
    <geoArea code="a-bn">Borneo</geoArea>
    <geoArea code="a-br">Burma</geoArea>
    <geoArea code="a-bt">Bhutan</geoArea>
    <geoArea code="a-bx">Brunei</geoArea>
    <geoArea code="a-cb">Cambodia</geoArea>
    <geoArea code="a-cc">China</geoArea>
    <geoArea code="a-cc-an">Anhui Sheng (China)</geoArea>
    <geoArea code="a-cc-ch">Zhejiang Sheng (China)</geoArea>
    <geoArea code="a-cc-cq">Chongqing (China)</geoArea>
    <geoArea code="a-cc-fu">Fujian Sheng (China)</geoArea>
    <geoArea code="a-cc-ha">Hainan Sheng (China)</geoArea>
    <geoArea code="a-cc-he">Heilongjiang Sheng (China)</geoArea>
    <geoArea code="a-cc-hh">Hubei Sheng (China)</geoArea>
    <geoArea code="a-cc-hk">Hong Kong (China)</geoArea>
    <geoArea code="a-cc-ho">Henan Sheng (China)</geoArea>
    <geoArea code="a-cc-hp">Hebei Sheng (China)</geoArea>
    <geoArea code="a-cc-hu">Hunan Sheng (China)</geoArea>
    <geoArea code="a-cc-im">Inner Mongolia (China)</geoArea>
    <geoArea code="a-cc-ka">Gansu Sheng (China)</geoArea>
    <geoArea code="a-cc-kc">Guangxi Zhuangzu Zizhiqu (China)</geoArea>
    <geoArea code="a-cc-ki">Jiangxi Sheng (China)</geoArea>
    <geoArea code="a-cc-kn">Guangdong Sheng (China)</geoArea>
    <geoArea code="a-cc-kr">Jilin Sheng (China)</geoArea>
    <geoArea code="a-cc-ku">Jiangsu Sheng (China)</geoArea>
    <geoArea code="a-cc-kw">Guizhou Sheng (China)</geoArea>
    <geoArea code="a-cc-lp">Liaoning Sheng (China)</geoArea>
    <geoArea code="a-cc-mh">Macau (China : Special Administrative Region)</geoArea>
    <geoArea code="a-cc-nn">Ningxia Huizu Zizhiqu (China)</geoArea>
    <geoArea code="a-cc-pe">Beijing (China)</geoArea>
    <geoArea code="a-cc-sh">Shanxi Sheng (China)</geoArea>
    <geoArea code="a-cc-sm">Shanghai (China)</geoArea>
    <geoArea code="a-cc-sp">Shandong Sheng (China)</geoArea>
    <geoArea code="a-cc-ss">Shaanxi Sheng (China)</geoArea>
    <geoArea code="a-cc-su">Xinjiang Uygur Zizhiqu (China)</geoArea>
    <geoArea code="a-cc-sz">Sichuan Sheng (China)</geoArea>
    <geoArea code="a-cc-ti">Tibet (China)</geoArea>
    <geoArea code="a-cc-tn">Tianjin (China)</geoArea>
    <geoArea code="a-cc-ts">Qinghai Sheng (China)</geoArea>
    <geoArea code="a-cc-yu">Yunnan Sheng (China)</geoArea>
    <geoArea code="a-ccg">Yangtze River (China)</geoArea>
    <geoArea code="a-cck">Kunlun Mountains (China and India)</geoArea>
    <geoArea code="a-ccp">Bo Hai (China)</geoArea>
    <geoArea code="a-ccs">Xi River (China)</geoArea>
    <geoArea code="a-ccy">Yellow River (China)</geoArea>
    <geoArea code="a-ce">Sri Lanka</geoArea>
    <geoArea code="a-ch">Taiwan</geoArea>
    <geoArea code="a-cy">Cyprus</geoArea>
    <geoArea code="a-em">Timor-Leste</geoArea>
    <geoArea code="a-gs">Georgia (Republic)</geoArea>
    <geoArea code="a-hk" status="obsolete">Hong Kong</geoArea>
    <geoArea code="a-ii">India</geoArea>
    <geoArea code="a-io">Indonesia</geoArea>
    <geoArea code="a-iq">Iraq</geoArea>
    <geoArea code="a-ir">Iran</geoArea>
    <geoArea code="a-is">Israel</geoArea>
    <geoArea code="a-ja">Japan</geoArea>
    <geoArea code="a-jo">Jordan</geoArea>
    <geoArea code="a-kg">Kyrgyzstan</geoArea>
    <geoArea code="a-kn">Korea (North)</geoArea>
    <geoArea code="a-ko">Korea (South)</geoArea>
    <geoArea code="a-kr">Korea</geoArea>
    <geoArea code="a-ku">Kuwait</geoArea>
    <geoArea code="a-kz">Kazakhstan</geoArea>
    <geoArea code="a-le">Lebanon</geoArea>
    <geoArea code="a-ls">Laos</geoArea>
    <geoArea code="a-mh" status="obsolete">Macao</geoArea>
    <geoArea code="a-mk">Oman</geoArea>
    <geoArea code="a-mp">Mongolia</geoArea>
    <geoArea code="a-my">Malaysia</geoArea>
    <geoArea code="a-np">Nepal</geoArea>
    <geoArea code="a-nw">New Guinea</geoArea>
    <geoArea code="a-ok" status="obsolete">Okinawa</geoArea>
    <geoArea code="a-ph">Philippines</geoArea>
    <geoArea code="a-pk">Pakistan</geoArea>
    <geoArea code="a-pp">Papua New Guinea</geoArea>
    <geoArea code="a-pt" status="obsolete">Portuguese Timor</geoArea>
    <geoArea code="a-qa">Qatar</geoArea>
    <geoArea code="a-si">Singapore</geoArea>
    <geoArea code="a-sk" status="obsolete">Sikkim</geoArea>
    <geoArea code="a-su">Saudi Arabia</geoArea>
    <geoArea code="a-sy">Syria</geoArea>
    <geoArea code="a-ta">Tajikistan</geoArea>
    <geoArea code="a-th">Thailand</geoArea>
    <geoArea code="a-tk">Turkmenistan</geoArea>
    <geoArea code="a-ts">United Arab Emirates</geoArea>
    <geoArea code="a-tu">Turkey</geoArea>
    <geoArea code="a-uz">Uzbekistan</geoArea>
    <geoArea code="a-vn" status="obsolete">Viet Nam, North</geoArea>
    <geoArea code="a-vs" status="obsolete">Viet Nam, South</geoArea>
    <geoArea code="a-vt">Vietnam</geoArea>
    <geoArea code="a-ye">Yemen (Republic)</geoArea>
    <geoArea code="a-ys" status="obsolete">Yemen (People's Democratic Republic)</geoArea>
    <geoArea code="aa">Amur River (China and Russia)</geoArea>
    <geoArea code="ab">Bengal, Bay of</geoArea>
    <geoArea code="ac">Asia, Central</geoArea>
    <geoArea code="ae">East Asia</geoArea>
    <geoArea code="af">Thailand, Gulf of</geoArea>
    <geoArea code="ag">Mekong River</geoArea>
    <geoArea code="ah">Himalaya Mountains</geoArea>
    <geoArea code="ai">Indochina</geoArea>
    <geoArea code="ak">Caspian Sea</geoArea>
    <geoArea code="am">Malaya</geoArea>
    <geoArea code="an">East China Sea</geoArea>
    <geoArea code="ao">South China Sea</geoArea>
    <geoArea code="aopf">Paracel Islands</geoArea>
    <geoArea code="aoxp">Spratly Islands</geoArea>
    <geoArea code="ap">Persian Gulf</geoArea>
    <geoArea code="ar">Arabian Peninsula</geoArea>
    <geoArea code="as">Southeast Asia</geoArea>
    <geoArea code="at">Tien Shan</geoArea>
    <geoArea code="au">Arabian Sea</geoArea>
    <geoArea code="aw">Middle East</geoArea>
    <geoArea code="awba">West Bank</geoArea>
    <geoArea code="awgz">Gaza Strip</geoArea>
    <geoArea code="awiu" status="obsolete">Israel-Syria Demilitarized Zones</geoArea>
    <geoArea code="awiw" status="obsolete">Israel-Jordan Demilitarized Zones</geoArea>
    <geoArea code="awiy" status="obsolete">Iraq-Saudi Arabia Neutral Zone</geoArea>
    <geoArea code="ay">Yellow Sea</geoArea>
    <geoArea code="az">South Asia</geoArea>
    <geoArea code="b">Commonwealth countries</geoArea>
    <geoArea code="c">Intercontinental areas (Western Hemisphere)</geoArea>
    <geoArea code="cc">Caribbean Area; Caribbean Sea</geoArea>
    <geoArea code="cl">Latin America</geoArea>
    <geoArea code="cm" status="obsolete">Middle America</geoArea>
    <geoArea code="cr" status="obsolete">Circumcaribbean</geoArea>
    <geoArea code="d">Developing countries</geoArea>
    <geoArea code="dd">Developed countries</geoArea>
    <geoArea code="e">Europe</geoArea>
    <geoArea code="e-aa">Albania</geoArea>
    <geoArea code="e-an">Andorra</geoArea>
    <geoArea code="e-au">Austria</geoArea>
    <geoArea code="e-be">Belgium</geoArea>
    <geoArea code="e-bn">Bosnia and Herzegovina</geoArea>
    <geoArea code="e-bu">Bulgaria</geoArea>
    <geoArea code="e-bw">Belarus</geoArea>
    <geoArea code="e-ci">Croatia</geoArea>
    <geoArea code="e-cs">Czechoslovakia</geoArea>
    <geoArea code="e-dk">Denmark</geoArea>
    <geoArea code="e-er">Estonia</geoArea>
    <geoArea code="e-fi">Finland</geoArea>
    <geoArea code="e-fr">France</geoArea>
    <geoArea code="e-ge">Germany (East)</geoArea>
    <geoArea code="e-gg">Guernsey</geoArea>
    <geoArea code="e-gi">Gibraltar</geoArea>
    <geoArea code="e-gr">Greece</geoArea>
    <geoArea code="e-gw">Germany (West)</geoArea>
    <geoArea code="e-gx">Germany</geoArea>
    <geoArea code="e-hu">Hungary</geoArea>
    <geoArea code="e-ic">Iceland</geoArea>
    <geoArea code="e-ie">Ireland</geoArea>
    <geoArea code="e-im">Isle of Man</geoArea>
    <geoArea code="e-it">Italy</geoArea>
    <geoArea code="e-je">Jersey</geoArea>
    <geoArea code="e-kv">Kosovo</geoArea>
    <geoArea code="e-lh">Liechtenstein</geoArea>
    <geoArea code="e-li">Lithuania</geoArea>
    <geoArea code="e-lu">Luxembourg</geoArea>
    <geoArea code="e-lv">Latvia</geoArea>
    <geoArea code="e-mc">Monaco</geoArea>
    <geoArea code="e-mm">Malta</geoArea>
    <geoArea code="e-mo">Montenegro</geoArea>
    <geoArea code="e-mv">Moldova</geoArea>
    <geoArea code="e-ne">Netherlands</geoArea>
    <geoArea code="e-no">Norway</geoArea>
    <geoArea code="e-pl">Poland</geoArea>
    <geoArea code="e-po">Portugal</geoArea>
    <geoArea code="e-rb">Serbia</geoArea>
    <geoArea code="e-rm">Romania</geoArea>
    <geoArea code="e-ru">Russia (Federation)</geoArea>
    <geoArea code="e-sm">San Marino</geoArea>
    <geoArea code="e-sp">Spain</geoArea>
    <geoArea code="e-sw">Sweden</geoArea>
    <geoArea code="e-sz">Switzerland</geoArea>
    <geoArea code="e-uk">Great Britain</geoArea>
    <geoArea code="e-uk-en">England</geoArea>
    <geoArea code="e-uk-ni">Northern Ireland</geoArea>
    <geoArea code="e-uk-st">Scotland</geoArea>
    <geoArea code="e-uk-ui" status="obsolete">Great Britain Miscellaneous Island
      Dependencies</geoArea>
    <geoArea code="e-uk-wl">Wales</geoArea>
    <geoArea code="e-un">Ukraine</geoArea>
    <geoArea code="e-ur">Russia. Russian Empire. Soviet Union. Former Soviet Republics</geoArea>
    <geoArea code="e-ur-ai" status="obsolete">Armenia (Republic)</geoArea>
    <geoArea code="e-ur-aj" status="obsolete">Azerbaijan</geoArea>
    <geoArea code="e-ur-bw" status="obsolete">Belarus</geoArea>
    <geoArea code="e-ur-er" status="obsolete">Estonia</geoArea>
    <geoArea code="e-ur-gs" status="obsolete">Georgia (Republic)</geoArea>
    <geoArea code="e-ur-kg" status="obsolete">Kyrgyzstan</geoArea>
    <geoArea code="e-ur-kz" status="obsolete">Kazakhstan</geoArea>
    <geoArea code="e-ur-li" status="obsolete">Lithuania</geoArea>
    <geoArea code="e-ur-lv" status="obsolete">Latvia</geoArea>
    <geoArea code="e-ur-mv" status="obsolete">Moldova</geoArea>
    <geoArea code="e-ur-ru" status="obsolete">Russia (Federation)</geoArea>
    <geoArea code="e-ur-ta" status="obsolete">Tajikistan</geoArea>
    <geoArea code="e-ur-tk" status="obsolete">Turkmenistan</geoArea>
    <geoArea code="e-ur-un" status="obsolete">Ukraine</geoArea>
    <geoArea code="e-ur-uz" status="obsolete">Uzbekistan</geoArea>
    <geoArea code="e-urc">Central Chernozem Region (Russia)</geoArea>
    <geoArea code="e-ure">Siberia, Eastern (Russia)</geoArea>
    <geoArea code="e-urf">Russian Far East (Russia)</geoArea>
    <geoArea code="e-urk">Caucasus</geoArea>
    <geoArea code="e-url" status="obsolete">Central Region, RSFSR</geoArea>
    <geoArea code="e-urn">Soviet Union, Northwestern</geoArea>
    <geoArea code="e-uro" status="obsolete">Soviet Central Asia</geoArea>
    <geoArea code="e-urp">Volga River (Russia)</geoArea>
    <geoArea code="e-urr">Caucasus, Northern (Russia)</geoArea>
    <geoArea code="e-urs">Siberia (Russia)</geoArea>
    <geoArea code="e-uru">Ural Mountains (Russia)</geoArea>
    <geoArea code="e-urv" status="obsolete">Volgo-Viatskii Region, RSFSR</geoArea>
    <geoArea code="e-urw">Siberia, Western (Russia)</geoArea>
    <geoArea code="e-vc">Vatican City</geoArea>
    <geoArea code="e-xn">North Macedonia</geoArea>
    <geoArea code="e-xo">Slovakia</geoArea>
    <geoArea code="e-xr">Czech Republic</geoArea>
    <geoArea code="e-xv">Slovenia</geoArea>
    <geoArea code="e-yu">Serbia and Montenegro; Yugoslavia</geoArea>
    <geoArea code="ea">Alps</geoArea>
    <geoArea code="eb">Baltic States</geoArea>
    <geoArea code="ec">Europe, Central</geoArea>
    <geoArea code="ed">Balkan Peninsula</geoArea>
    <geoArea code="ee">Europe, Eastern</geoArea>
    <geoArea code="ei" status="obsolete">Iberian Peninsula</geoArea>
    <geoArea code="el">Benelux countries</geoArea>
    <geoArea code="en">Europe, Northern</geoArea>
    <geoArea code="eo">Danube River</geoArea>
    <geoArea code="ep">Pyrenees</geoArea>
    <geoArea code="er">Rhine River</geoArea>
    <geoArea code="es">Europe, Southern</geoArea>
    <geoArea code="et" status="obsolete">Europe, East Central</geoArea>
    <geoArea code="ev">Scandinavia</geoArea>
    <geoArea code="ew">Europe, Western</geoArea>
    <geoArea code="f">Africa</geoArea>
    <geoArea code="f-ae">Algeria</geoArea>
    <geoArea code="f-ao">Angola</geoArea>
    <geoArea code="f-bd">Burundi</geoArea>
    <geoArea code="f-bs">Botswana</geoArea>
    <geoArea code="f-by" status="obsolete">Biafra</geoArea>
    <geoArea code="f-cd">Chad</geoArea>
    <geoArea code="f-cf">Congo (Brazzaville)</geoArea>
    <geoArea code="f-cg">Congo (Democratic Republic)</geoArea>
    <geoArea code="f-cm">Cameroon</geoArea>
    <geoArea code="f-cx">Central African Republic</geoArea>
    <geoArea code="f-dm">Benin</geoArea>
    <geoArea code="f-ea">Eritrea</geoArea>
    <geoArea code="f-eg">Equatorial Guinea</geoArea>
    <geoArea code="f-et">Ethiopia</geoArea>
    <geoArea code="f-ft">Djibouti</geoArea>
    <geoArea code="f-gh">Ghana</geoArea>
    <geoArea code="f-gm">Gambia</geoArea>
    <geoArea code="f-go">Gabon</geoArea>
    <geoArea code="f-gv">Guinea</geoArea>
    <geoArea code="f-if" status="obsolete">Ifni</geoArea>
    <geoArea code="f-iv">Côte d'Ivoire</geoArea>
    <geoArea code="f-ke">Kenya</geoArea>
    <geoArea code="f-lb">Liberia</geoArea>
    <geoArea code="f-lo">Lesotho</geoArea>
    <geoArea code="f-ly">Libya</geoArea>
    <geoArea code="f-mg">Madagascar</geoArea>
    <geoArea code="f-ml">Mali</geoArea>
    <geoArea code="f-mr">Morocco</geoArea>
    <geoArea code="f-mu">Mauritania</geoArea>
    <geoArea code="f-mw">Malawi</geoArea>
    <geoArea code="f-mz">Mozambique</geoArea>
    <geoArea code="f-ng">Niger</geoArea>
    <geoArea code="f-nr">Nigeria</geoArea>
    <geoArea code="f-pg">Guinea-Bissau</geoArea>
    <geoArea code="f-rh">Zimbabwe</geoArea>
    <geoArea code="f-rw">Rwanda</geoArea>
    <geoArea code="f-sa">South Africa</geoArea>
    <geoArea code="f-sd">South Sudan</geoArea>
    <geoArea code="f-sf">Sao Tome and Principe</geoArea>
    <geoArea code="f-sg">Senegal</geoArea>
    <geoArea code="f-sh">Spanish North Africa</geoArea>
    <geoArea code="f-sj">Sudan</geoArea>
    <geoArea code="f-sl">Sierra Leone</geoArea>
    <geoArea code="f-so">Somalia</geoArea>
    <geoArea code="f-sq">Eswatini</geoArea>
    <geoArea code="f-ss">Western Sahara</geoArea>
    <geoArea code="f-sx">Namibia</geoArea>
    <geoArea code="f-tg">Togo</geoArea>
    <geoArea code="f-ti">Tunisia</geoArea>
    <geoArea code="f-tz">Tanzania</geoArea>
    <geoArea code="f-ua">Egypt</geoArea>
    <geoArea code="f-ug">Uganda</geoArea>
    <geoArea code="f-uv">Burkina Faso</geoArea>
    <geoArea code="f-za">Zambia</geoArea>
    <geoArea code="fa">Atlas Mountains</geoArea>
    <geoArea code="fb">Africa, Sub-Saharan</geoArea>
    <geoArea code="fc">Africa, Central</geoArea>
    <geoArea code="fd">Sahara</geoArea>
    <geoArea code="fe">Africa, Eastern</geoArea>
    <geoArea code="ff">Africa, North</geoArea>
    <geoArea code="fg">Congo River</geoArea>
    <geoArea code="fh">Africa, Northeast</geoArea>
    <geoArea code="fi">Niger River</geoArea>
    <geoArea code="fl">Nile River</geoArea>
    <geoArea code="fn">Sudan (Region)</geoArea>
    <geoArea code="fq">Africa, French-speaking Equatorial</geoArea>
    <geoArea code="fr">Great Rift Valley</geoArea>
    <geoArea code="fs">Africa, Southern</geoArea>
    <geoArea code="fu">Suez Canal (Egypt)</geoArea>
    <geoArea code="fv">Volta River (Ghana)</geoArea>
    <geoArea code="fw">Africa, West</geoArea>
    <geoArea code="fz">Zambezi River</geoArea>
    <geoArea code="h">French Community</geoArea>
    <geoArea code="i">Indian Ocean</geoArea>
    <geoArea code="i-bi">British Indian Ocean Territory</geoArea>
    <geoArea code="i-cq">Comoros</geoArea>
    <geoArea code="i-fs">Terres australes et antarctiques françaises</geoArea>
    <geoArea code="i-hm">Heard and McDonald Islands</geoArea>
    <geoArea code="i-mf">Mauritius</geoArea>
    <geoArea code="i-my">Mayotte</geoArea>
    <geoArea code="i-re">Réunion</geoArea>
    <geoArea code="i-se">Seychelles</geoArea>
    <geoArea code="i-xa">Christmas Island (Indian Ocean)</geoArea>
    <geoArea code="i-xb">Cocos (Keeling) Islands</geoArea>
    <geoArea code="i-xc">Maldives</geoArea>
    <geoArea code="i-xo" status="obsolete">Socotra Island</geoArea>
    <geoArea code="l">Atlantic Ocean</geoArea>
    <geoArea code="ln">North Atlantic Ocean</geoArea>
    <geoArea code="lnaz">Azores</geoArea>
    <geoArea code="lnbm">Bermuda Islands</geoArea>
    <geoArea code="lnca">Canary Islands</geoArea>
    <geoArea code="lncv">Cabo Verde</geoArea>
    <geoArea code="lnfa">Faroe Islands</geoArea>
    <geoArea code="lnjn">Jan Mayen Island</geoArea>
    <geoArea code="lnma">Madeira Islands</geoArea>
    <geoArea code="lnsb">Svalbard (Norway)</geoArea>
    <geoArea code="ls">South Atlantic Ocean</geoArea>
    <geoArea code="lsai">Ascension Island (Atlantic Ocean)</geoArea>
    <geoArea code="lsbv">Bouvet Island</geoArea>
    <geoArea code="lsfk">Falkland Islands</geoArea>
    <geoArea code="lstd">Tristan da Cunha</geoArea>
    <geoArea code="lsxj">Saint Helena</geoArea>
    <geoArea code="lsxs">South Georgia and South Sandwich Islands</geoArea>
    <geoArea code="m">Intercontinental areas (Eastern Hemisphere)</geoArea>
    <geoArea code="ma">Arab countries</geoArea>
    <geoArea code="mb">Black Sea</geoArea>
    <geoArea code="me">Eurasia</geoArea>
    <geoArea code="mm">Mediterranean Region; Mediterranean Sea</geoArea>
    <geoArea code="mr">Red Sea</geoArea>
    <geoArea code="n">North America</geoArea>
    <geoArea code="n-cn">Canada</geoArea>
    <geoArea code="n-cn-ab">Alberta</geoArea>
    <geoArea code="n-cn-bc">British Columbia</geoArea>
    <geoArea code="n-cn-mb">Manitoba</geoArea>
    <geoArea code="n-cn-nf">Newfoundland and Labrador</geoArea>
    <geoArea code="n-cn-nk">New Brunswick</geoArea>
    <geoArea code="n-cn-ns">Nova Scotia</geoArea>
    <geoArea code="n-cn-nt">Northwest Territories</geoArea>
    <geoArea code="n-cn-nu">Nunavut</geoArea>
    <geoArea code="n-cn-on">Ontario</geoArea>
    <geoArea code="n-cn-pi">Prince Edward Island</geoArea>
    <geoArea code="n-cn-qu">Québec (Province)</geoArea>
    <geoArea code="n-cn-sn">Saskatchewan</geoArea>
    <geoArea code="n-cn-yk">Yukon Territory</geoArea>
    <geoArea code="n-cnh">Hudson Bay</geoArea>
    <geoArea code="n-cnm">Maritime Provinces</geoArea>
    <geoArea code="n-cnp">Prairie Provinces</geoArea>
    <geoArea code="n-gl">Greenland</geoArea>
    <geoArea code="n-mx">Mexico</geoArea>
    <geoArea code="n-us">United States</geoArea>
    <geoArea code="n-us-ak">Alaska</geoArea>
    <geoArea code="n-us-al">Alabama</geoArea>
    <geoArea code="n-us-ar">Arkansas</geoArea>
    <geoArea code="n-us-az">Arizona</geoArea>
    <geoArea code="n-us-ca">California</geoArea>
    <geoArea code="n-us-co">Colorado</geoArea>
    <geoArea code="n-us-ct">Connecticut</geoArea>
    <geoArea code="n-us-dc">Washington (D.C.)</geoArea>
    <geoArea code="n-us-de">Delaware</geoArea>
    <geoArea code="n-us-fl">Florida</geoArea>
    <geoArea code="n-us-ga">Georgia</geoArea>
    <geoArea code="n-us-hi">Hawaii</geoArea>
    <geoArea code="n-us-ia">Iowa</geoArea>
    <geoArea code="n-us-id">Idaho</geoArea>
    <geoArea code="n-us-il">Illinois</geoArea>
    <geoArea code="n-us-in">Indiana</geoArea>
    <geoArea code="n-us-ks">Kansas</geoArea>
    <geoArea code="n-us-ky">Kentucky</geoArea>
    <geoArea code="n-us-la">Louisiana</geoArea>
    <geoArea code="n-us-ma">Massachusetts</geoArea>
    <geoArea code="n-us-md">Maryland</geoArea>
    <geoArea code="n-us-me">Maine</geoArea>
    <geoArea code="n-us-mi">Michigan</geoArea>
    <geoArea code="n-us-mn">Minnesota</geoArea>
    <geoArea code="n-us-mo">Missouri</geoArea>
    <geoArea code="n-us-ms">Mississippi</geoArea>
    <geoArea code="n-us-mt">Montana</geoArea>
    <geoArea code="n-us-nb">Nebraska</geoArea>
    <geoArea code="n-us-nc">North Carolina</geoArea>
    <geoArea code="n-us-nd">North Dakota</geoArea>
    <geoArea code="n-us-nh">New Hampshire</geoArea>
    <geoArea code="n-us-nj">New Jersey</geoArea>
    <geoArea code="n-us-nm">New Mexico</geoArea>
    <geoArea code="n-us-nv">Nevada</geoArea>
    <geoArea code="n-us-ny">New York</geoArea>
    <geoArea code="n-us-oh">Ohio</geoArea>
    <geoArea code="n-us-ok">Oklahoma</geoArea>
    <geoArea code="n-us-or">Oregon</geoArea>
    <geoArea code="n-us-pa">Pennsylvania</geoArea>
    <geoArea code="n-us-ri">Rhode Island</geoArea>
    <geoArea code="n-us-sc">South Carolina</geoArea>
    <geoArea code="n-us-sd">South Dakota</geoArea>
    <geoArea code="n-us-tn">Tennessee</geoArea>
    <geoArea code="n-us-tx">Texas</geoArea>
    <geoArea code="n-us-ut">Utah</geoArea>
    <geoArea code="n-us-va">Virginia</geoArea>
    <geoArea code="n-us-vt">Vermont</geoArea>
    <geoArea code="n-us-wa">Washington (State)</geoArea>
    <geoArea code="n-us-wi">Wisconsin</geoArea>
    <geoArea code="n-us-wv">West Virginia</geoArea>
    <geoArea code="n-us-wy">Wyoming</geoArea>
    <geoArea code="n-usa">Appalachian Mountains</geoArea>
    <geoArea code="n-usc">Middle West</geoArea>
    <geoArea code="n-use">Northeastern States</geoArea>
    <geoArea code="n-usl">Middle Atlantic States</geoArea>
    <geoArea code="n-usm">Mississippi River</geoArea>
    <geoArea code="n-usn">New England</geoArea>
    <geoArea code="n-uso">Ohio River</geoArea>
    <geoArea code="n-usp">West (U.S.)</geoArea>
    <geoArea code="n-usr">East (U.S.)</geoArea>
    <geoArea code="n-uss">Missouri River</geoArea>
    <geoArea code="n-ust">Southwest, New</geoArea>
    <geoArea code="n-usu">Southern States</geoArea>
    <geoArea code="n-usw" status="obsolete">Northwest (U.S.)</geoArea>
    <geoArea code="n-xl">Saint Pierre and Miquelon</geoArea>
    <geoArea code="nc">Central America</geoArea>
    <geoArea code="ncbh">Belize</geoArea>
    <geoArea code="nccr">Costa Rica</geoArea>
    <geoArea code="nccz">Canal Zone</geoArea>
    <geoArea code="nces">El Salvador</geoArea>
    <geoArea code="ncgt">Guatemala</geoArea>
    <geoArea code="ncho">Honduras</geoArea>
    <geoArea code="ncnq">Nicaragua</geoArea>
    <geoArea code="ncpn">Panama</geoArea>
    <geoArea code="nl">Great Lakes (North America); Lake States</geoArea>
    <geoArea code="nm">Mexico, Gulf of</geoArea>
    <geoArea code="np">Great Plains</geoArea>
    <geoArea code="nr">Rocky Mountains</geoArea>
    <geoArea code="nw">West Indies</geoArea>
    <geoArea code="nwaq">Antigua and Barbuda</geoArea>
    <geoArea code="nwaw">Aruba</geoArea>
    <geoArea code="nwbb">Barbados</geoArea>
    <geoArea code="nwbc" status="obsolete">Barbuda</geoArea>
    <geoArea code="nwbf">Bahamas</geoArea>
    <geoArea code="nwbn">Bonaire</geoArea>
    <geoArea code="nwcj">Cayman Islands</geoArea>
    <geoArea code="nwco">Curaçao</geoArea>
    <geoArea code="nwcu">Cuba</geoArea>
    <geoArea code="nwdq">Dominica</geoArea>
    <geoArea code="nwdr">Dominican Republic</geoArea>
    <geoArea code="nweu">Sint Eustatius</geoArea>
    <geoArea code="nwga" status="obsolete">Greater Antilles</geoArea>
    <geoArea code="nwgd">Grenada</geoArea>
    <geoArea code="nwgp">Guadeloupe</geoArea>
    <geoArea code="nwgs" status="obsolete">Grenadines</geoArea>
    <geoArea code="nwhi">Hispaniola</geoArea>
    <geoArea code="nwht">Haiti</geoArea>
    <geoArea code="nwjm">Jamaica</geoArea>
    <geoArea code="nwla">Antilles, Lesser</geoArea>
    <geoArea code="nwli">Leeward Islands (West Indies)</geoArea>
    <geoArea code="nwmj">Montserrat</geoArea>
    <geoArea code="nwmq">Martinique</geoArea>
    <geoArea code="nwna" status="obsolete">Netherlands Antilles</geoArea>
    <geoArea code="nwpr">Puerto Rico</geoArea>
    <geoArea code="nwsb" status="obsolete">Saint-Barthélemy</geoArea>
    <geoArea code="nwsc">Saint-Barthélemy</geoArea>
    <geoArea code="nwsd">Saba</geoArea>
    <geoArea code="nwsn">Sint Maarten</geoArea>
    <geoArea code="nwst">Saint-Martin</geoArea>
    <geoArea code="nwsv">Swan Islands (Honduras)</geoArea>
    <geoArea code="nwtc">Turks and Caicos Islands</geoArea>
    <geoArea code="nwtr">Trinidad and Tobago</geoArea>
    <geoArea code="nwuc">United States Miscellaneous Caribbean Islands</geoArea>
    <geoArea code="nwvb">British Virgin Islands</geoArea>
    <geoArea code="nwvi">Virgin Islands of the United States</geoArea>
    <geoArea code="nwvr" status="obsolete">Virgin Islands</geoArea>
    <geoArea code="nwwi">Windward Islands (West Indies)</geoArea>
    <geoArea code="nwxa">Anguilla</geoArea>
    <geoArea code="nwxi">Saint Kitts and Nevis</geoArea>
    <geoArea code="nwxk">Saint Lucia</geoArea>
    <geoArea code="nwxm">Saint Vincent and the Grenadines</geoArea>
    <geoArea code="p">Pacific Ocean</geoArea>
    <geoArea code="pn">North Pacific Ocean</geoArea>
    <geoArea code="po">Oceania</geoArea>
    <geoArea code="poas">American Samoa</geoArea>
    <geoArea code="pobp">Solomon Islands</geoArea>
    <geoArea code="poci">Caroline Islands</geoArea>
    <geoArea code="pocp" status="obsolete">Canton and Enderbury Islands</geoArea>
    <geoArea code="pocw">Cook Islands</geoArea>
    <geoArea code="poea">Easter Island</geoArea>
    <geoArea code="pofj">Fiji</geoArea>
    <geoArea code="pofp">French Polynesia</geoArea>
    <geoArea code="pogg">Galapagos Islands</geoArea>
    <geoArea code="pogn" status="obsolete">Gilbert and Ellice Islands</geoArea>
    <geoArea code="pogu">Guam</geoArea>
    <geoArea code="poji">Johnston Island</geoArea>
    <geoArea code="pokb">Kiribati</geoArea>
    <geoArea code="poki">Kermadec Islands</geoArea>
    <geoArea code="poln">Line Islands</geoArea>
    <geoArea code="pome">Melanesia</geoArea>
    <geoArea code="pomi">Micronesia (Federated States)</geoArea>
    <geoArea code="ponl">New Caledonia</geoArea>
    <geoArea code="ponn">Vanuatu</geoArea>
    <geoArea code="ponu">Nauru</geoArea>
    <geoArea code="popc">Pitcairn Island</geoArea>
    <geoArea code="popl">Palau</geoArea>
    <geoArea code="pops">Polynesia</geoArea>
    <geoArea code="pory" status="obsolete">Ryukyu Islands, Southern</geoArea>
    <geoArea code="posc" status="obsolete">Santa Cruz Islands</geoArea>
    <geoArea code="posh">Samoan Islands</geoArea>
    <geoArea code="posn" status="obsolete">Solomon Islands</geoArea>
    <geoArea code="potl">Tokelau</geoArea>
    <geoArea code="poto">Tonga</geoArea>
    <geoArea code="pott">Micronesia</geoArea>
    <geoArea code="potv">Tuvalu</geoArea>
    <geoArea code="poup">United States Miscellaneous Pacific Islands</geoArea>
    <geoArea code="powf">Wallis and Futuna Islands</geoArea>
    <geoArea code="powk">Wake Island</geoArea>
    <geoArea code="pows">Samoa</geoArea>
    <geoArea code="poxd">Mariana Islands</geoArea>
    <geoArea code="poxe">Marshall Islands</geoArea>
    <geoArea code="poxf">Midway Islands</geoArea>
    <geoArea code="poxh">Niue</geoArea>
    <geoArea code="ps">South Pacific Ocean</geoArea>
    <geoArea code="q">Cold regions</geoArea>
    <geoArea code="r">Arctic Ocean; Arctic regions</geoArea>
    <geoArea code="s">South America</geoArea>
    <geoArea code="s-ag">Argentina</geoArea>
    <geoArea code="s-bl">Brazil</geoArea>
    <geoArea code="s-bo">Bolivia</geoArea>
    <geoArea code="s-ck">Colombia</geoArea>
    <geoArea code="s-cl">Chile</geoArea>
    <geoArea code="s-ec">Ecuador</geoArea>
    <geoArea code="s-fg">French Guiana</geoArea>
    <geoArea code="s-gy">Guyana</geoArea>
    <geoArea code="s-pe">Peru</geoArea>
    <geoArea code="s-py">Paraguay</geoArea>
    <geoArea code="s-sr">Suriname</geoArea>
    <geoArea code="s-uy">Uruguay</geoArea>
    <geoArea code="s-ve">Venezuela</geoArea>
    <geoArea code="sa">Amazon River</geoArea>
    <geoArea code="sn">Andes</geoArea>
    <geoArea code="sp">Rio de la Plata (Argentina and Uruguay)</geoArea>
    <geoArea code="t">Antarctic Ocean; Antarctica</geoArea>
    <geoArea code="t-ay" status="obsolete">Antarctica</geoArea>
    <geoArea code="u">Australasia</geoArea>
    <geoArea code="u-ac">Ashmore and Cartier Islands</geoArea>
    <geoArea code="u-at">Australia</geoArea>
    <geoArea code="u-at-ac">Australian Capital Territory</geoArea>
    <geoArea code="u-atc">Central Australia</geoArea>
    <geoArea code="u-ate">Eastern Australia</geoArea>
    <geoArea code="u-atn">Northern Australia</geoArea>
    <geoArea code="u-at-ne">New South Wales</geoArea>
    <geoArea code="u-at-no">Northern Territory</geoArea>
    <geoArea code="u-at-qn">Queensland</geoArea>
    <geoArea code="u-at-sa">South Australia</geoArea>
    <geoArea code="u-at-tm">Tasmania</geoArea>
    <geoArea code="u-at-vi">Victoria</geoArea>
    <geoArea code="u-at-we">Western Australia</geoArea>
    <geoArea code="u-cs">Coral Sea Islands</geoArea>
    <geoArea code="u-nz">New Zealand</geoArea>
    <geoArea code="v" status="obsolete">Communist countries</geoArea>
    <geoArea code="w">Tropics</geoArea>
    <geoArea code="x">Earth</geoArea>
    <geoArea code="xa">Eastern Hemisphere</geoArea>
    <geoArea code="xb">Northern Hemisphere</geoArea>
    <geoArea code="xc">Southern Hemisphere</geoArea>
    <geoArea code="xd">Western Hemisphere</geoArea>
    <geoArea code="zd">Deep space</geoArea>
    <geoArea code="zju">Jupiter</geoArea>
    <geoArea code="zma">Mars</geoArea>
    <geoArea code="zme">Mercury</geoArea>
    <geoArea code="zmo">Moon</geoArea>
    <geoArea code="zne">Neptune</geoArea>
    <geoArea code="zo">Outer space</geoArea>
    <geoArea code="zpl">Pluto</geoArea>
    <geoArea code="zs">Solar system</geoArea>
    <geoArea code="zsa">Saturn</geoArea>
    <geoArea code="zsu">Sun</geoArea>
    <geoArea code="zur">Uranus</geoArea>
    <geoArea code="zve">Venus</geoArea>
  </xsl:variable>

</xsl:stylesheet>
