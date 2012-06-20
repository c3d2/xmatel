<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:str="http://exslt.org/strings">

  <xsl:output method="text"
	      encoding="utf-8"/>

  <xsl:template match="balance">
    <xsl:text>=== Rechnung </xsl:text>
    <xsl:value-of select="@date"/>
    <xsl:text> ===&#10;&#10;</xsl:text>

    <xsl:apply-templates select="*[name() = 'base' or name() = 'delta']"/>

    <xsl:text>---------------------------&#10;</xsl:text>
    <xsl:for-each select="base">
      <xsl:variable name="sum">
	<xsl:call-template name="calc-sum">
	  <xsl:with-param name="b" select="string(.)"/>
	</xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="str:align('Summe:', '               ', 'left')"/>
      <xsl:value-of select="str:align(format-number($sum, '0.00'), '          ', 'right')"/>
      <xsl:text> €</xsl:text>
    </xsl:for-each>

    <xsl:text>&#10;&#10;</xsl:text>

  </xsl:template>
 
  <xsl:template match="base">
    <xsl:value-of select="str:align('Kasse:', '               ', 'left')"/>
    <xsl:value-of select="str:align(format-number(., '0.00'), '          ', 'right')"/>
    <xsl:text> €&#10;</xsl:text>
  </xsl:template>
  <xsl:template match="delta">
    <xsl:value-of select="str:align(concat(@name, ':'), '               ', 'left')"/>
    <xsl:value-of select="str:align(format-number(., '0.00'), '          ', 'right')"/>
    <xsl:text> €&#10;</xsl:text>
  </xsl:template>

  <xsl:template name="calc-sum">
    <xsl:param name="b"/>
    
    <xsl:choose>
      <xsl:when test="following-sibling::delta">
	<xsl:for-each select="following-sibling::delta[1]">
	  <xsl:call-template name="calc-sum">
	    <xsl:with-param name="b" select="$b + number(.)"/>
	  </xsl:call-template>
	</xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$b"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
