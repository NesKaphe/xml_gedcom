<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns="http://www.w3.org/1999/xhtml">
	<xsl:output method="xml" 
	doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
	indent="yes" />
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
	</style>	
				<title><xsl:text>Gegcom</xsl:text></title>	<!-- TODO remplacer par le nom du fichier si possible -->
				<xsl:apply-templates select="./head" />
			</head>
			<body>
				<h1>Individuals</h1>
				<xsl:apply-templates select="gedcom/indi"/>
				<br/><br/><br/><br/>
				<h1>Familys</h1>
				<xsl:apply-templates select="gedcom/fam"/>
			</body>
		</html>
	</xsl:template>
	
	
	
	
	<!--======== HEAD ============-->
	<xsl:template match="gedcom/head">
	</xsl:template>
		
	 <!--======= INDI ============-->
	 <xsl:template match="gedcom/indi" >

		<xsl:call-template name="tmpl_id_a"/>
	 	<table style="width:100%">
			<xsl:apply-templates select="./name[@*]"/>
		 	<xsl:apply-templates select="./sex"/>
		 	<xsl:apply-templates select="./birt"/>
		 	<xsl:apply-templates select="./deat"/>
		 	<xsl:apply-templates select="./famc"/>
		 	<xsl:apply-templates select="./fams"/>
	 	</table>
	 	<br/><br/>
	 	
	 </xsl:template>

	<xsl:template name="tmpl_id_a">
		<xsl:element name="a">
			<xsl:attribute name="name">
	 		<xsl:value-of select="@id" />
		</xsl:attribute>
		</xsl:element>
	</xsl:template>
	 
	 
	<!--======= NAME -->
	<xsl:template match="name[@*]">
		<th colspan="2">
			<td ><xsl:apply-templates select="@alias"/>
			<xsl:apply-templates select="@surname"/></td>
			<td>
				<xsl:text>id :  </xsl:text>
				<xsl:value-of select="ancestor::*/@id"/>
			</td>
		</th>
	</xsl:template>
	
	<xsl:template match="@alias"><xsl:value-of select="." />
	</xsl:template>
	
	<xsl:template match="@surname">  <xsl:value-of select="." />
	</xsl:template>
	
	<!--======= SEX -->
	<xsl:template match="sex">
		<tr>
		<td>sex</td>
			<td>
				<xsl:choose>
					<xsl:when test="@type='m'">
						<xsl:text>male</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>female</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>
	
	<!--======= BIRT -->
	<xsl:template match="birt">
		<tr>
		<td>born</td>
		<td>
			<tr>
				<td>date</td>
				<td><xsl:apply-templates select="date"/></td>
			</tr>
			<tr>
				<td>place</td>
				<td><xsl:apply-templates select="plac"/></td>
			</tr>
		</td>
		</tr>
	</xsl:template>
	
	<!--======= DEAT -->
	<xsl:template match="deat">
		<tr>
			<td>death</td>
			<td>
			<tr>
				<td>date</td>
				<td><xsl:apply-templates select="date"/></td>
			</tr>
			<tr>
				<td>place</td>
				<td><xsl:apply-templates select="plac"/></td>
			</tr>
			</td>
		</tr>
	</xsl:template>
	
	<!--======= FAMS  -->
	<xsl:template match="fams">
		<tr>
			<td>family spouse</td>
			<tr>
				<td>ref</td>
				<td><xsl:value-of select="@ref"/></td>
				<td>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>#</xsl:text>
							<xsl:value-of select="@ref" />
						</xsl:attribute>
							<xsl:text>link-to fams</xsl:text>
					</xsl:element>
				</td>
			</tr>
		</tr>
	</xsl:template>
	
	<!--======= FAMC  -->
	<xsl:template match="famc">
		<tr>
		<td>family child</td>
		<tr>
			<td>ref</td>
			<td><xsl:value-of select="@ref"/></td>
			<td>
			<xsl:element name="a">
				<xsl:attribute name="href">
					<xsl:text>#</xsl:text>
				<xsl:value-of select="@ref" />
				</xsl:attribute>
				<xsl:text>link-to famc</xsl:text>
			</xsl:element>
			</td>
		</tr>
		</tr>
	</xsl:template>
	
	<!--======= DATE -->
	<xsl:template match="date">
		<xsl:value-of select="text()"/>
	</xsl:template>
	
	<!--======= PLAC -->
	<xsl:template match="plac">
		<xsl:value-of select="text()"/>
	</xsl:template>
	

	
	<!--=========== FAM ===========-->
	<xsl:template match="gedcom/fam">
		<xsl:call-template name="tmpl_id_a"/>

	 	<table style="width:100%">
	 		<th colspan="2">
	 			<td>
	 				<xsl:text>family</xsl:text>
	 			</td>
	 			<td>
	 				<xsl:text>id : </xsl:text>
	 				<xsl:value-of select="@id"/>
	 			</td>
	 		</th>
	 		<!--  <xsl:call-template name="fam_name">  TODO -->
			<xsl:apply-templates select="./husb"/>
			<xsl:apply-templates select="./wife"/>
			<xsl:apply-templates select="./chil"/>
			<xsl:apply-templates select="./marr"/>
	 	</table>
	 	<br/><br/>	
	</xsl:template>
	
	<!--====== HUSB -->
	<xsl:template match="husb">
		<tr>
			<td>husband</td>
			<td>
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:text>#</xsl:text>
						<xsl:value-of select="@ref" />
					</xsl:attribute>
					<xsl:text>link-to husband</xsl:text>		
				</xsl:element>
			</td>
		</tr>
	</xsl:template>
	
	<!--========= WIFE -->
	<xsl:template match="wife">
		<tr>
			<td>wife</td>
			<td>
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:text>#</xsl:text>
						<xsl:value-of select="@ref" />
					</xsl:attribute>
					<xsl:text>link-to wife</xsl:text>		
				</xsl:element>
			</td>
		</tr>
	</xsl:template>
	
	<!--========== CHIL -->
	<xsl:template match="chil">
		<tr>
			<td>child</td>
			<td>
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:text>#</xsl:text>
						<xsl:value-of select="@ref" />
					</xsl:attribute>
					<xsl:text>link-to child</xsl:text>		
				</xsl:element>
			</td>
		</tr>
	</xsl:template>
	
	<!--========== MARR  -->
	<xsl:template match="marr">
		<tr>
			<td>marriage</td>
			<td>
				<tr>
					<td>date</td>
					<td><xsl:apply-templates select="date"/></td>
				</tr>
				<tr>
					<td>place</td>
					<td><xsl:apply-templates select="plac"/></td>
				</tr>
			</td>
		</tr>
	</xsl:template>
	
	<!--  
	<xsl:template name="tmpl_id_a">
		
	</xsl:template>
	-->
</xsl:stylesheet>