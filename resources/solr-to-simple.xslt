<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="/">
        <xsl:for-each select="response/result/doc">
            <record>
                <xsl:attribute name="pid" select="str[@name='id']" />
                <xsl:for-each select="arr[@name='media_resource_id_display']/str">
                    <imagePid><xsl:value-of select="."/></imagePid>
                </xsl:for-each>
            </record>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>