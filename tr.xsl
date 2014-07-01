<?xml version="1.0"?>
<!-- (c) Miek Gieben 2014. Hereby put in the public domain. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="yes"/>
  <xsl:template match="/">
    <xsl:comment> This document was prepared using Pandoc2rfc 3.0.0, https://github.com/miekg/pandoc2rfc </xsl:comment>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="article">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="articleinfo"/>
  <xsl:template match="emphesis">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
  <xsl:template match="literal">
    <tt>
      <xsl:apply-templates/>
    </tt>
  </xsl:template>
  <xsl:template match="subscript">
    <sub>
      <xsl:apply-templates/>
    </sub>
  </xsl:template>
  <xsl:template match="superscript">
    <sup>
      <xsl:apply-templates/>
    </sup>
  </xsl:template>
  <xsl:template match="link">
    <xref>
      <xsl:attribute name="target">
        <xsl:value-of select="@linkend"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xref>
  </xsl:template>
  <xsl:template match="ulink">
    <eref>
      <xsl:attribute name="target">
        <xsl:value-of select="@url"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </eref>
  </xsl:template>
  <!-- Set of span elements that we need for titleelement and other fluff. -->
  <xsl:template match="emphesis" mode="span">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
  <xsl:template match="literal" mode="span">
    <tt>
      <xsl:apply-templates/>
    </tt>
  </xsl:template>
  <!-- The sup and sub tags script are not allowed, so kill the content.-->
  <!-- We use this in the titleelement to create references. -->
  <xsl:template match="subscript" mode="span"/>
  <xsl:template match="superscript" mode="span"/>
  <xsl:template match="link" mode="span">
    <xref>
      <xsl:attribute name="target">
        <xsl:value-of select="@linkend"/>
      </xsl:attribute>
      <xsl:apply-templates mode="span"/>
    </xref>
  </xsl:template>
  <xsl:template match="ulink" mode="span">
    <eref>
      <xsl:attribute name="target">
        <xsl:value-of select="@url"/>
      </xsl:attribute>
      <xsl:apply-templates mode="span"/>
    </eref>
  </xsl:template>
  <!-- Eat these links, so we can search for them when actually seeing a programlisting. -->
  <xsl:template match="programlisting">
    <figure>
      <xsl:if test="following-sibling::*[position()=1][name()='para']/footnote/para/subscript">
        <xsl:attribute name="anchor">
          <xsl:value-of select="following-sibling::*[position()=1][name()='para']/footnote/para/subscript"/>
        </xsl:attribute>
      </xsl:if>
      <titleelement>
        <xsl:apply-templates select="following-sibling::*[position()=1][name()='para']/footnote/para" mode="span"/>
      </titleelement>
      <artwork>
        <xsl:value-of select="."/>
      </artwork>
    </figure>
  </xsl:template>
  <!-- Discard these links because we want them for <aside>. -->
  <xsl:template match="blockquote/blockquote">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="blockquote">
    <xsl:choose>
      <xsl:when test="child::blockquote">
        <aside>
          <xsl:apply-templates/>
        </aside>
      </xsl:when>
      <xsl:otherwise>
        <blockquote>
          <xsl:apply-templates/>
        </blockquote>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="footnote"/>
  <xsl:template match="footnote/para/superscript">
      <iref>
          <xsl:attribute name="item">
              <xsl:value-of select="."/>
          </xsl:attribute>
          <xsl:attribute name="subitem">
              <xsl:value-of select="../text()"/>
          </xsl:attribute>
    </iref>
    </xsl:template>
</xsl:stylesheet>
