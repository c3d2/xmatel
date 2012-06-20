<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
		xmlns="http://www.w3.org/2005/Atom"
		xmlns:xhtml="http://www.w3.org/1999/xhtml"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		exclude-result-prefixes="xsl">

  
  <xsl:output method="xml"
	      version="1.0"
	      encoding="utf-8"
	      indent="yes"/>
 
  <xsl:template match="index">
    <feed>
      <title>Mate-Rechnungen</title>

      <xsl:for-each select="file">
	<xsl:sort select="string(.)" order="descending"/>

	<xsl:apply-templates select="document(.)"/>
      </xsl:for-each>
    </feed>
  </xsl:template>

  <xsl:template match="balance">
    <entry>
      <title>Rechnung <xsl:value-of select="@date"/></title>
      <id><xsl:value-of select="@date"/></id>
      <content type="xhtml">
	<div xmlns="http://www.w3.org/1999/xhtml">
	  <xsl:apply-templates mode="xhtml"/>

	  <xsl:for-each select="base">
	    <xsl:variable name="sum">
	      <xsl:call-template name="calc-sum">
		<xsl:with-param name="b" select="string(.)"/>
	      </xsl:call-template>
	    </xsl:variable>
	    <xhtml:dl>
	      <xhtml:dt>Summe</xhtml:dt>
	      <xhtml:dd><xsl:value-of select="format-number($sum, '0.00')"/> €</xhtml:dd>
	    </xhtml:dl>
	  </xsl:for-each>
	</div>
      </content>
    </entry>
  </xsl:template>

  <!-- TODO:
       * Sum
       * Mail
  -->
  <xsl:template mode="xhtml" match="base">
    <xhtml:dl>
      <xhtml:dt>Kasse</xhtml:dt>
      <xhtml:dd><xsl:value-of select="format-number(., '0.00')"/> €</xhtml:dd>
    </xhtml:dl>
  </xsl:template>
  <xsl:template mode="xhtml" match="delta">
    <xhtml:dl>
      <xhtml:dt><xsl:value-of select="@name"/></xhtml:dt>
      <xhtml:dd><xsl:value-of select="format-number(., '0.00')"/> €</xhtml:dd>
    </xhtml:dl>
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