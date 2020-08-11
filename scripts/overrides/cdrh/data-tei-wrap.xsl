<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xsl tei xs" version="2.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0">
  
  <xsl:output method="xhtml" indent="no" encoding="UTF-8" omit-xml-declaration="yes"/>
  
  <xsl:import href="data-tei.xsl"/>

  <xsl:template match="TEI">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
    <html>
      <head>
        <title><!-- todo: add title --></title>
        <link rel="stylesheet" href="../../../files/assets/style.css"/>
      </head>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
