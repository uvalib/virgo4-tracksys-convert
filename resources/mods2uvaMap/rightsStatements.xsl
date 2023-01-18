<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

  <!-- Map between URL and text of rights statements -->
  <xsl:variable name="rightsStatementList">
    <rights url="http://rightsstatements.org/vocab/InC/1.0/">In Copyright</rights>
    <rights url="http://rightsstatements.org/vocab/InC-OW-EU/1.0/">In Copyright - EU Orphan Work</rights>
    <rights url="http://rightsstatements.org/vocab/InC-EDU/1.0/">In Copyright - Educational Use Permitted</rights>    
    <rights url="http://rightsstatements.org/vocab/InC-NC/1.0/">In Copyright - Non-Commercial Use Permitted</rights>    
    <rights url="http://rightsstatements.org/vocab/InC-RUU/1.0/">In Copyright - Rights-holder(s) Unlocatable or Unidentifiable</rights>    
    <rights url="http://rightsstatements.org/vocab/NoC-CR/1.0/">No Copyright - Contractual Restrictions</rights>    
    <rights url="http://rightsstatements.org/vocab/NoC-NC/1.0/">No Copyright - Non-Commercial Use Only</rights>    
    <rights url="http://rightsstatements.org/vocab/NoC-OKLR/1.0/">No Copyright - Other Known Legal Restrictions</rights>    
    <rights url="http://rightsstatements.org/vocab/NoC-US/1.0/">No Copyright - United States</rights>    
    <rights url="http://rightsstatements.org/vocab/CNE/1.0/">Copyright Not Evaluated</rights>
    <rights url="http://rightsstatements.org/vocab/UND/1.0/">Copyright Undetermined</rights>
    <rights url="http://rightsstatements.org/vocab/NKC/1.0/">No Known Copyright</rights>
    <rights url="https://creativecommons.org/licenses/by-nd/4.0/legalcode">Attribution</rights>
    <rights url="https://creativecommons.org/licenses/by-nd/4.0/legalcode">CC BY-ND</rights>
    <rights url="https://creativecommons.org/licenses/by-nc/4.0/legalcode">Attribution-NonCommercial</rights>
    <rights url="https://creativecommons.org/licenses/by-nc/4.0/legalcode">CC BY-NC</rights>
    <rights url="https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode">Attribution-NonCommercial-ShareAlike</rights>
    <rights url="https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode">CC BY-NC-SA</rights>
    <rights url="https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode">Attribution-NonCommercial-NoDerivs</rights>
    <rights url="https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode">CC BY-NC-ND</rights>
  </xsl:variable>

</xsl:stylesheet>
