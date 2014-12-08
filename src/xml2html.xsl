<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">
	<xsl:output method="xml" 
	doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
	indent="yes" />
	
	<xsl:key name="id_indi" match="gedcom/indi" use="@id"/>
	<xsl:key name="id_fam" match="gedcom/fam" use="@id"/>
	
	<xsl:template match="/">
	
		<html>
			<head>
				<style>
				table,th,tr {
				    border: 1px solid black;
				    border-collapse: collapse;
				}
				td {
				    border-collapse: collapse;
				    padding-right: 100px;
				}
				section {
					width: 98vw;
					height: 95vh;
				}
				.left {
					width: 25%;
					height:100%;
					background-color: #689bab;
					margin-left:0px;
					overflow-y : scroll;
					float:left;
				}
				.content {
					//width: 75%;
					height:100%;
					background-color: #b1e689;
					overflow-y: scroll;
				}
				ul{
					list-style-type:none;
				}
				.my_style{
					margin-left:2em;
				}
				.my2{
					position:fixed;
					width: 22%;
					background-color: #2e829e;
					padding : 10px;
					margin:0px;
					margin-top:0px;
					margin-left:0px;
					float:left;
					color:#12343f;
					font-size: 1.5em;
				}
				.info{
					color:#227f50;
					font-size: 1.2em;
				}
				.sub_info{
					color:#00a551;
					font-size: 1.05em;
				}
				.box_info{
					border:1px solid gray;
					margin-right:50%;
					margin-bottom:1em;
					background-color:#70bc96;
					border-style: none;
				}
				h1{
					color:#225d71;
					font-size: 3em;
				}
				h2{
					color:#3e7c90;
					font-size: 1.5em;
				}
				a:link{
					color:#990099;
					//color:#eb9600;
				}
				a:visited{
					color:#752075;
					//color:#b58531;
				}
				body{
					font-family: Arial, Helvetica, sans-serif;
				}
				</style>	
			<title><xsl:text>Gedcom</xsl:text></title>	<!-- TODO remplacer par le nom du fichier si possible -->
			<xsl:apply-templates select="./head" />
		</head>
			<body>
				<section>
					<div class="left">
						<div class="my2">
							individuals
						</div>
						<br/>
						<br/>
						<ul>
							<xsl:apply-templates select="gedcom/indi" mode="make_name_list">
								<xsl:sort select="name/@alias" order="ascending"/>
							</xsl:apply-templates>

						</ul>
					</div>

					<div class="content">
						<h1>Individuals</h1>
						<xsl:apply-templates select="gedcom/indi">
							<xsl:sort select="name/@alias" order="ascending"/>
						</xsl:apply-templates>
						<br/><br/><br/><br/>
						<h1>Familys</h1>
							<xsl:apply-templates select="gedcom/fam" mode="fam"/>
					</div>
				</section>
			</body>
		</html>
	</xsl:template>
	
	<!--======== HEAD ============-->
	<xsl:template match="gedcom/head">
	</xsl:template>
	
	<!--=====INDI mode=make_name_list  -->
	<xsl:template match="indi" mode="make_name_list">
		<xsl:for-each select="key('id_indi',@id)">
			<li>
				<xsl:element name="a">
					<xsl:attribute name="href">#<xsl:value-of select="@id" />
					</xsl:attribute>
					<xsl:choose>
						<xsl:when test="name/@alias != ''">
							<xsl:value-of select="name/@alias"/>
						</xsl:when>
						<xsl:otherwise> 
							<i> 
								<xsl:choose>
									<xsl:when test="name/@surname != ''">? 
										<xsl:value-of select="name/@surname"/>
									</xsl:when>
									<xsl:otherwise>
										unnamed
									</xsl:otherwise>
								</xsl:choose>
							</i>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:call-template name="make_space"/>
					<font size ="2">(<xsl:value-of select="@id"/>)</font>
				</xsl:element>
			</li>
		</xsl:for-each>
	</xsl:template>
	
	 <!--============== INDI ==================-->
	 <xsl:template match="gedcom/indi" >
		<h2><xsl:call-template name="tag_a_name"/></h2>
		<div>
			<ul class="my_style">
			 	<xsl:apply-templates select="sex"/>
			 	<xsl:apply-templates select="titl" mode="alter"/>
				<xsl:apply-templates select="birt"/>
				<xsl:apply-templates select="chr"/>
			 	<xsl:apply-templates select="deat"/>
			 	<xsl:apply-templates select="buri"/>			 	
			 	<xsl:apply-templates select="famc"/>
			 	<xsl:apply-templates select="fams"/>
			 	<xsl:apply-templates select="note"/>
		 	</ul>
	 	</div>
	 	<br/><br/>
	 </xsl:template>

	<!--========= NAME mode=tag_a_name  -->
	<xsl:template name="tag_a_name">
		<xsl:element name="a">
			<xsl:attribute name="name">
	 		<xsl:value-of select="@id" />
		</xsl:attribute>
			<xsl:choose>
				<xsl:when test="name">
					<xsl:apply-templates select="name"/>
				</xsl:when>
				<xsl:otherwise>
					<i><xsl:text>unnamed</xsl:text></i>
					<xsl:call-template name="make_space"/>
					<font size ="3">(<xsl:value-of select="@id"/>)</font>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	
	<!--============get_all_indi (by id)  -->
	<xsl:template name="get_all_indi">
		<xsl:for-each select="key('id_indi',gedcom/indi/@id)">
		</xsl:for-each>
	</xsl:template>
	 
	<!--======= NAME -->
	<xsl:template match="name">
		<xsl:if test="../titl">
			<i>[<xsl:apply-templates select="../titl"/>]</i>
		</xsl:if>
		<xsl:call-template name="make_space"/>
		<xsl:choose>
			<xsl:when test="@alias != ''">
				<xsl:value-of select="@alias"/>
			</xsl:when>
			<xsl:otherwise>?
			</xsl:otherwise>
		</xsl:choose>
		<xsl:call-template name="make_space"/>
		<font color="#225d71"><xsl:value-of select="@surname"/></font>
		<xsl:call-template name="make_space"/>
		<font size ="2">(<xsl:value-of select="../@id"/>)</font>
	</xsl:template>
	
	<!--======= TITL  -->
	<xsl:template name="titl" match="titl">
		<xsl:value-of select="text()"/>
	</xsl:template>
	
	<!--======= TITL mode="alter" -->
	<xsl:template match="titl" mode="alter">
		<li >
			<span class="info">title</span> :
			<xsl:call-template name="titl"/>
		</li>
		<xsl:apply-templates select="quay" mode="alter"/>
	</xsl:template>
	
	<!--======= SEX -->
	<xsl:template match="sex">
		<li ><span class="info">sex</span> :
			<xsl:choose>
				<xsl:when test="@type='m'">
					<xsl:text>male</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>female</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</li>
	</xsl:template>
	
	<!--======= BIRT -->
	<xsl:template match="birt">
		<xsl:if test="date or plac">
			<li><span class="info">born</span> :</li>
			<div class="box_info">
				<xsl:call-template name="date_place"/>
			</div>
		</xsl:if>
		<!--  <xsl:apply-templates select="quay" mode="alter"/> -->
	</xsl:template>
	
	<!--======= DEAT -->
	<xsl:template match="deat">
		<xsl:if test="date or plac">
			<li><span class="info">death</span> :</li>
			<div class="box_info">
				<xsl:call-template name="date_place"/>
			</div>
		</xsl:if>
	</xsl:template>

	<!--=========== BURI -->
	<xsl:template match="buri">
		<xsl:if test="date or plac">
			<li><span class="info">burried</span> :</li>
			<div class="box_info">
				<xsl:call-template name="date_place"/>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!--======= FAMC  -->
	<xsl:template match="famc">
		<li>
			<li>
				<span class="info">family child</span>:
			</li>
			<div class="box_info">
				<li>
					<xsl:element name="a">
						<xsl:attribute name="href">#<xsl:value-of select="@ref"/>
						</xsl:attribute>family
						<xsl:call-template name="make_space"/>(
						<xsl:value-of select="@ref"/>)
					</xsl:element>
				</li>
				<xsl:apply-templates select="key('id_fam',@ref)" mode="child"/>
			</div>
		</li>
	</xsl:template>
	
	<!--======= FAMS  -->
	<xsl:template match="fams">
		<li>
			<li>
				<span class="info">family spouse</span>:
			</li>
			<div class="box_info">
				<li>
					<xsl:element name="a">
						<xsl:attribute name="href">#<xsl:value-of select="@ref"/>
						</xsl:attribute>family
						<xsl:call-template name="make_space"/>(
						<xsl:value-of select="@ref"/>)
					</xsl:element>
				</li>
				<li>
					<ul class="my_style">
						<xsl:apply-templates select="key('id_fam',@ref)" mode="spouse"/>
					</ul>
				</li>
			</div>
		</li>
	</xsl:template>
	
	
	<!--========== NOTE -->
	<xsl:template match="note">
		<div class="box_info">
			<li ><span class="info">note</span> :</li>
			<li>
				<xsl:value-of select="text()"/>
			</li>
		</div>
	</xsl:template>

	<!--======= FAM mode=fam -->
	<xsl:template match="fam" mode="fam">
		<h2>
			<xsl:element name="a">
				<xsl:attribute name="name">
		 			<xsl:value-of select="@id" />
				</xsl:attribute>
				family
				<xsl:call-template name="make_space"/><font size ="3">(
					<xsl:value-of select="@id"/>)</font>
			</xsl:element>
		</h2>
		<ul class="my_style">
			<li><span class="info">relationship</span> :</li>
			<li>
				<div class="box_info">
					<xsl:apply-templates select="key('id_fam',@id)" mode="spouse"/>
				</div>
			</li>
			<li>
				<xsl:apply-templates select="marr"/>
			</li>
			<li>
				<xsl:apply-templates select="div"/>
			</li>
		</ul>
	</xsl:template>
	
	<!--=====FAM mode=child  -->
	<xsl:template match="fam" mode="child">
		<li>
			<ul class="my_style">
				<li>
					<span class="sub_info">father</span> :
					<xsl:apply-templates select="husb"/>
				</li>
				<li>
					<span class="sub_info">mother</span> :
					<xsl:apply-templates select="wife"/>
				</li>
				<li>
					<span class="sub_info">sitters/brothers</span> :
					<xsl:apply-templates select="chil"/>
				</li>
			</ul>
		</li>
	</xsl:template>
	
	<!--=====FAM mode=spouse  -->
	<xsl:template match="fam" mode="spouse">
		<li>
			<span class="sub_info">husband</span> :
			<xsl:apply-templates select="husb"/>
		</li>
		<li>
			<span class="sub_info">wife</span> :
			<xsl:apply-templates select="wife"/>
		</li>
		<xsl:if test="chil">
			<li>
				<span class="sub_info">childs</span> :
				<xsl:apply-templates select="chil"/>
			</li>
		</xsl:if>
	</xsl:template>
	
	<!--====== HUSB -->
	<xsl:template match="husb">
		<xsl:call-template name="href_to_name"/>
	</xsl:template>
	
	<!--====== WIFE -->
	<xsl:template match="wife">
		<xsl:call-template name="href_to_name"/>
	</xsl:template>
	
	<!--====== CHIL -->
	<xsl:template match="chil">
		<li>
			<ul class="my_style">
				<li><xsl:call-template name="href_to_name"/></li>
			</ul>
		</li>
	</xsl:template>
	
	<!--====== MARR  -->
	<xsl:template match="marr">
		<xsl:if test="date or plac or quay">
			<li><span class="info">marriage</span> :</li>
			<div class="box_info">
				<xsl:call-template name="date_place"/>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!--======= DIV  -->
	<xsl:template match="div">
		<span class="info">divorce</span> :
		<xsl:if test="text() = 'Y'">yes
		</xsl:if>
		<xsl:if test="text() = 'N'">no
		</xsl:if>
		<xsl:if test="quay">
			<xsl:apply-templates select="quay"/>
			<i> (quality of data)</i>
		</xsl:if>
	</xsl:template>
	
	<!--======= CHR  -->
	<xsl:template match="chr">
		<span class="info">christening</span> :
		<div class="box_info">
			<xsl:call-template name="date_place"/>
		</div>
	</xsl:template>
	
	<!--href to name (alias + name + link to indi)  -->
	<xsl:template name="href_to_name">
		<xsl:element name="a">
			<xsl:attribute name="href">
				<xsl:text>#</xsl:text>
				<xsl:value-of select="@ref" />
			</xsl:attribute>
			<xsl:call-template name="get_alias"/>
			<xsl:call-template name="make_space"/>
			<xsl:call-template name="get_surname"/>	
		</xsl:element>
	</xsl:template>
	
	<!--===== link to family  -->
	<xsl:template name="link_to_fam">
		<xsl:element name="a">
			<xsl:attribute name="href">#<xsl:value-of select="@ref"/>
			</xsl:attribute>link to family
		</xsl:element>
	</xsl:template>
		
	<!--====== date and place info  -->
	<xsl:template name="date_place">
		<xsl:if test="date">
			<li>
				<span class="sub_info">date</span> : 
				<xsl:apply-templates select="date"/>
			</li>
		</xsl:if>
		<xsl:if test="plac">
			<li>
				<span class="sub_info">place</span> :
				<xsl:apply-templates select="plac"/>
			</li>
		</xsl:if>
		<xsl:if test="quay">
			<xsl:apply-templates select="quay" mode="alter"/>
			</xsl:if>
	</xsl:template>
	
	<!--======= DATE ==========-->
	<xsl:template match="date">
		<xsl:value-of select="text()"/>
	</xsl:template>
	
	<!--======= PLAC ==========-->
	<xsl:template match="plac">
		<xsl:value-of select="text()"/>
	</xsl:template>
	
	<!--======= QUAY  -->
	<xsl:template match="quay">
		<xsl:value-of select="text()"/>
	</xsl:template>
	
	<!--======= QUAY  mode="alter"-->
	<xsl:template match="quay" mode="alter">
		<li>
			<span class="sub_info">quality of data</span> :
			<xsl:value-of select="text()"/>
		</li>
	</xsl:template>

	<!--====get_alias -->
	<xsl:template name="get_alias">
		<xsl:choose>
			<xsl:when test="key('id_indi',@ref)/name/@alias != ''">
				<xsl:value-of select="key('id_indi',@ref)/name/@alias"/>
			</xsl:when>
			<xsl:otherwise>?
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--====get_surname  -->
	<xsl:template name="get_surname">
		<xsl:if test="key('id_indi',@ref)/name/@surname != ''">
			<font color="#225d71">
				<xsl:value-of select="key('id_indi',@ref)/name/@surname"/>
			</font>
		</xsl:if>
	</xsl:template>

	<!-- make_space -->
	<xsl:template name="make_space">
		<xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
	</xsl:template>
	
</xsl:stylesheet>