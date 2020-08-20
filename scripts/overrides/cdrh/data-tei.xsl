<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xsl tei xs" version="2.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0">
  
  <xsl:output method="xhtml" indent="no" encoding="UTF-8" omit-xml-declaration="yes"/>

  <xsl:variable name="attribute_prefix">data-tei-</xsl:variable>

  <xsl:template name="make_xml">
    <element>
      <xsl:attribute name="name" select="translate(name(), ':', '')" />
      <xsl:for-each select="@*">
        <attribute>
          <xsl:attribute name="name" select="translate(name(), ':', '')" />
          <value>
            <xsl:choose>
              <xsl:when test="starts-with(.,'http')">
                <xsl:value-of select="." />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(., ':', '-')" />
              </xsl:otherwise>
            </xsl:choose>
          </value>
        </attribute>
      </xsl:for-each>
    </element>
  </xsl:template>

  <xsl:template name="add_attributes">

    <xsl:variable name="local_xml">
      <xsl:copy-of select="//titleStmt/author" />
      <xsl:copy-of select="//handNote" />

      <xsl:call-template name="make_xml" />
    </xsl:variable>
    <xsl:for-each select="$local_xml/element" xpath-default-namespace="">
      <!-- exclude tei elements with analogous html elements 
           from getting data-tei-e attribute -->
      <xsl:if test="
        (@name != 'p') and 
        (@name != 'item') and
        (@name != 'list')">
        <xsl:variable name="attribute">
          <xsl:value-of select="$attribute_prefix" />
          <xsl:text>e</xsl:text>
        </xsl:variable>
        <xsl:variable name="value" select="@name" />
        <xsl:attribute name="{$attribute}" select="$value" />
      </xsl:if>
      
    </xsl:for-each>

    <xsl:for-each select="$local_xml/element/attribute/value" xpath-default-namespace="">
      <xsl:choose>
        <!-- Turn xml:id's into id's -->
        <xsl:when test="../@name = 'xmlid'">
          <xsl:variable name="value">
            <xsl:value-of select="." />
          </xsl:variable>
          <xsl:attribute name="id" select="$value" />
        </xsl:when>
        <!-- Turn targets into links -->
        <xsl:when test="(../@name = 'target') and (../../@name = 'ref')">
          <xsl:variable name="value">
            <xsl:choose>
              <xsl:when test="starts-with(.,'http')">
                <xsl:value-of select="."/>
              </xsl:when>
              <xsl:when test="starts-with(.,'#')">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="substring-after(.,'#')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>#</xsl:text>
                <xsl:value-of select="."/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:attribute name="href" select="$value" />
        </xsl:when>
        <!-- pull hand info from tei header -->
        <xsl:when test="../@name = 'hand'">
          <xsl:variable name="full_hand_id" select="." />
          <xsl:variable name="hand_id" select="substring-after(., '#')" />

          <xsl:for-each select="//handNote[@xml:id = $hand_id]"
            xpath-default-namespace="http://www.tei-c.org/ns/1.0">
            <!-- setting variables for medium -->
            <xsl:variable name="attribute_medium">
              <xsl:value-of select="$attribute_prefix" />
              <xsl:text>a-hand-medium</xsl:text>
            </xsl:variable>
            <xsl:variable name="value_medium" select="@medium"/>
            
            <!-- setting variables for resp -->
            <xsl:variable name="attribute_resp">
              <xsl:value-of select="$attribute_prefix" />
              <xsl:text>a-hand-resp</xsl:text>
            </xsl:variable>
            <xsl:variable name="value_resp">
              <xsl:value-of select="substring-after(@resp, '#')" />
            </xsl:variable>
            
            <xsl:attribute name="{$attribute_medium}" select="$value_medium" />
            <xsl:attribute name="{$attribute_resp}" select="$value_resp" />
            
            <!-- adding full name as the title -->
            <xsl:variable name="resp" select="substring-after(@resp, '#')"/>
            <xsl:for-each select="//author[@xml:id = $resp]"
              xpath-default-namespace="http://www.tei-c.org/ns/1.0">
              
              <!-- setting variables for title/name -->
              <xsl:variable name="attribute_name">
                <xsl:text>title</xsl:text>
              </xsl:variable>
              <xsl:variable name="value_name">
                <xsl:value-of select="." />
              </xsl:variable>
              
              <xsl:attribute name="{$attribute_name}" select="$value_name" />
              
            </xsl:for-each> <!-- /adding full name as title -->   
          </xsl:for-each><!-- /adding data-tei-a-hand elements -->    
          
        </xsl:when>
        <!-- apply generic data- attributes -->
        <xsl:otherwise>
          
          <xsl:variable name="attribute">
            <xsl:value-of select="$attribute_prefix" />
            <xsl:text>a</xsl:text>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="../@name" />
          </xsl:variable>
          <xsl:variable name="value">
            <xsl:value-of select="." />
          </xsl:variable>
          <xsl:attribute name="{$attribute}" select="$value" />
          
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <!-- for testing, delete later -->
    <!--<test><xsl:copy-of select="$local_xml"/></test>-->
  </xsl:template>
  
  <!-- Generic template for all elements -->
  <xsl:template match="tei:text//*">
    <span>
      <xsl:call-template name="add_attributes" />
      <xsl:apply-templates />
    </span>
  </xsl:template>

  <xsl:template match="teiHeader" /><!-- do nothing -->
  
  <!-- ================
    Override elements for things that don't have HTML equivelents 
  =================== -->
  
  <xsl:template match="gap" priority="1">
    <span>
      <xsl:call-template name="add_attributes" />
      <xsl:apply-templates />
      <xsl:text>[</xsl:text>
      <xsl:value-of select="@reason"/>
      <xsl:text>]</xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template match="note" priority="1">
    <p>
      <xsl:call-template name="add_attributes" />
      <xsl:apply-templates />
      
      <xsl:call-template name="note_back_link"/>
    </p>
  </xsl:template>
  
  <xsl:template name="note_back_link">
    <span class="tei-note-back">
      <xsl:text> [</xsl:text>
      <a>
        <xsl:attribute name="href">
          <xsl:text>#</xsl:text>
          <xsl:value-of select="translate(@target,'#','')"/>
        </xsl:attribute>
        <xsl:text>back</xsl:text>
      </a>
      <xsl:text>] </xsl:text>
    </span>
  </xsl:template>

  <!-- ===============
    override elements for semantic HTML elements 
  =================== -->

  <!-- == Content Sectioning == -->

  <!-- <address> -->
  <!--<article> -->
  
  <!--<div> (force block level elements) -->
  <xsl:template 
    match="div | div1 | div2 | div3 | div4 | div5 | div6 | div7 | body | back" 
    priority="1">
    <div>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <!-- h1 - h6 -->
  <!-- todo: add head number based on div nesting and @type = sub -->
  <xsl:template match="head" priority="1">
    <h2>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates/>
    </h2>
  </xsl:template>
    
  <!-- <main> -->
  <!--<section> -->

  <!-- == Text content == -->

  <!-- <blockquote> and <q> -->
  
  <!--<figure> containing <figcaption> -->
  <!-- todo: in html figure is not allowed in p, eith alter p or figure -->
  <xsl:template match="figure" priority="1">
    <figure>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates/>
    </figure>
  </xsl:template>
  
  <xsl:template match="figDesc" priority="1">
    <figcaption>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates/>
    </figcaption>
  </xsl:template>
  
  <!--<hr> milestone -->
  <xsl:template match="milestone" priority="1">
    <hr>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates/>
    </hr>
  </xsl:template>
  
  <!--<ul><li> --> <!--<ol><li> since TEI lists have to number themselves I have not used <ol> -->
  <xsl:template match="list" priority="1">
    <span class="tei-list-container">
      <!-- move head outside list if there is one -->
      <xsl:if test="head">
        <xsl:for-each select="head">
          <span>
            <xsl:call-template name="add_attributes"/>
            <xsl:apply-templates />
          </span>
        </xsl:for-each>
      </xsl:if>
      <ul>
        <xsl:call-template name="add_attributes"/>
        <xsl:apply-templates/>
      </ul>
    </span>
  </xsl:template>
  
  <xsl:template match="item" priority="1">
    <li>
      <xsl:call-template name="add_attributes"/>
      <!-- move label inside list item -->
      <xsl:for-each select="preceding-sibling::label[1]">
        <span>
          <xsl:call-template name="add_attributes"/>
          <xsl:apply-templates/>
        </span>
        <xsl:text> </xsl:text>
      </xsl:for-each>
      <!-- use n to add numbers -->
      <xsl:for-each select="@n">
        <span>
          <xsl:attribute name="data-tei-a">n</xsl:attribute>
          <xsl:value-of select="."/>
          <xsl:text> </xsl:text>
        </span>
      </xsl:for-each>
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  
  <xsl:template match="list//label" priority="1"/>
  <xsl:template match="list//head" priority="2"/>
  
  
  <!-- p -->
  <xsl:template match="p" priority="1">
    <!-- unless inside another p, then span -->
    <xsl:choose>
      <xsl:when test="ancestor::p or descendant::head or descendant::figure or ancestor::list">
        <span>
          <xsl:call-template name="add_attributes"/>
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <xsl:call-template name="add_attributes"/>
          <xsl:apply-templates/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- == Inline text semantics == -->

  <!-- <a> -->
  <xsl:template match="xref[@n]">
    <a>
      <xsl:attribute name="href" select="@n"/>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates/>
    </a>
  </xsl:template>
  
  <xsl:template match="ref" priority="1">
    <a>
      <xsl:call-template name="add_attributes" />
      <xsl:apply-templates />
    </a>
  </xsl:template>
  
  <!-- <abbr> -->
  
  <xsl:template match="choice[child::abbr]" priority="2">
    <abbr>
      <xsl:attribute name="title" select="expan"/>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates select="abbr"/>
    </abbr>
  </xsl:template>

  
  <!-- <b> is used to draw the reader's attention to the element's contents, which are not otherwise granted special importance. -->
  
  <!-- <br> lb -->
  <xsl:template match="lb">
    <xsl:apply-templates/>
    <br/>
  </xsl:template>
  
  <!-- <cite> must contain title -->
  <!-- <data> -->
  
  <!-- <em> can be nested to represent levels of emphasis -->
  <xsl:template match="hi[@rend = 'italic'] | hi[@rend = 'italics']" priority="1">
    <em>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
  
  <!-- <i> represents a range of text that is set off from the normal text for some reason. -->
  <!-- <mark> represents text which is marked or highlighted for reference or notation purposes, 
              due to the marked passage's relevance or importance in the enclosing context. -->
  <!-- <s> -->
  <!-- <strong> -->
  <!-- <sub> -->
  
  <!-- <sup> -->
  <xsl:template match="add[@place = 'superlinear'] | add[@place = 'supralinear'] | *[@rendition='simple:superscript']" priority="3">
    <sup>
      <xsl:choose>
        <xsl:when test="name(.) = 'add'">
          <add>
            <xsl:call-template name="add_attributes"/>
            <xsl:apply-templates/>
          </add>
        </xsl:when>
        <xsl:otherwise>
          <span>
            <xsl:call-template name="add_attributes"/>
            <xsl:apply-templates/>
          </span>
        </xsl:otherwise>
      </xsl:choose>
    </sup>
  </xsl:template>
  
  <!-- <time> -->
  <!--  <u> represents a span of inline text which should be rendered in a way that indicates that it has a non-textual annotation. -->

  <!-- == Image and multimedia == -->

  <!-- <audio> -->
  
  <!-- <img> -->
  <xsl:template match="graphic" priority="1">

    <img>
      <xsl:attribute name="src">
        <xsl:text>../../../images/full/</xsl:text>
        <xsl:value-of select="@url"/>
      </xsl:attribute>
    </img>
  </xsl:template>
  
  <!-- <video> -->

  <!-- == Edits == -->

  <!-- del -->
  <xsl:template match="del" priority="1">
    <del>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates/>
    </del>
  </xsl:template>
  
  <!-- <ins> -->
  <xsl:template match="add" priority="2">
    <add>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates/>
    </add>
  </xsl:template>

  <!-- == Tables == -->

  <!-- <table> <caption> <thead> <tbody> <tfoot> -->

  <!-- see https://developer.mozilla.org/en-US/docs/Web/HTML/Element -->
  
  <!-- Notes form formatting.xsl 
   see DIV1 and DIV2 re @corresp
   language can be on any element, perhaps use family letters as an example to get that applied
  -->
  
  
</xsl:stylesheet>
