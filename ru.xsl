<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [
	<!ENTITY agrave "&#224;">
	<!ENTITY eacute "&#233;">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ex="http://exslt.org/dates-and-times" xmlns:crous="http://crous.fr" extension-element-prefixes="ex" exclude-result-prefixes="crous">
	<xsl:output method="html" />
	
	<!-- ________customization starts here________ -->
	
	<crous:zones>
		<crous:zone openInTree="Y">LA ROCHELLE</crous:zone>
		<crous:zone openInTree="N">ANGOULEME</crous:zone>
		<crous:zone openInTree="N">CHATELLERAULT</crous:zone>
		<crous:zone openInTree="N">NIORT</crous:zone>
		<crous:zone openInTree="N">POITIERS CAMPUS</crous:zone>
		<crous:zone openInTree="N">POITIERS CENTRE VILLE</crous:zone>
		<crous:zone openInTree="N">POITIERS FUTUROSCOPE</crous:zone>
	</crous:zones>
	
	<xsl:variable name="menuXmlSource" select="'http://crous.parking.einden.com/static/poitiers-menu.xml'" />
	<xsl:variable name="crousSourceUrl" select="'http://www.crous-poitiers.fr'"/>
	<xsl:variable name="crousSourceLabel" select="'http://www.crous-poitiers.fr'"/>
	
	
	<!-- ________customization ends here________ -->
	
	<xsl:variable name="todayDate" select="ex:date-time()" />
	<xsl:variable name="rootNode" select="/root" />
		
	<xsl:template match="/">
      <xsl:apply-templates select="root" />
	</xsl:template>

	<xsl:template match="root">
		<div id="crousContent">
			<div id="menusByResto">
			
				<xsl:call-template name="crousSources" />
				<xsl:for-each select="document('')/xsl:stylesheet/crous:zones/crous:zone">
					<xsl:call-template name="restoGrouping">
			  			<xsl:with-param name="currentZone" select="./text()" />
			  			<xsl:with-param name="isExpandedByDefault" select="@openInTree" />
			  		</xsl:call-template>
				</xsl:for-each>
			</div>
		
			<div id="restoPopups">
				<xsl:for-each select="resto">
					<xsl:call-template name="restoInfo" select="." />
				</xsl:for-each>
			</div>
		</div>
	
	</xsl:template>
	
	<xsl:template name="restoGrouping">
		<xsl:param name="currentZone" />
		<xsl:param name="isExpandedByDefault" select="'N'"/>
		
		<xsl:variable name="restoNodeStatus">
			<xsl:choose> 
				<xsl:when test="$isExpandedByDefault = 'Y'">expanded</xsl:when>
				<xsl:otherwise>expandable</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="zoneId">
			<xsl:call-template name="replace-substring">
				<xsl:with-param name="original" select="$currentZone" />
				<xsl:with-param name="substring" select="' '" />
			</xsl:call-template>
		</xsl:variable>
		
		<div class="zonePanel {$restoNodeStatus}">
			<h2>
				<a href="javascript:void(0);" name="{$zoneId}Restos" class="showZoneRestos"><xsl:value-of select="$currentZone" /></a> (<span class="nbOpenedRestos"><xsl:value-of select="count($rootNode/resto[@zone=$currentZone and (@closing='0' or (ex:year($todayDate) &gt;= ex:year(@closing)) and (ex:dayInYear($todayDate) &gt;= ex:dayInYear(@closing)))])" /></span>/<span class="nbRestos"><xsl:value-of select="count($rootNode/resto[@zone=$currentZone])" /></span>)
			</h2>
			<div id="{$zoneId}Restos" class="zonePanelContent">
				<xsl:for-each select="$rootNode/resto[@zone=$currentZone]">
					<xsl:call-template name="restoMenus" select="." mode="restoMenus" />
		   		</xsl:for-each>
	   		</div>
   		</div>
  	</xsl:template>
	
	<xsl:template name="restoMenus" match="resto" mode="restoMenus">
		<xsl:variable name="isRestoOpened">
			<xsl:choose> 
				<xsl:when test="@closing='0' or (ex:year($todayDate) &gt;= ex:year(@closing)) and (ex:dayInYear($todayDate) &gt;= ex:dayInYear(@closing))">Y</xsl:when>
				<xsl:otherwise>N</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div class="restoPanel">
	
			<xsl:variable name="restoId" select="@id" />
			<xsl:variable name="restoClass">
				<xsl:choose>
					<xsl:when test="$isRestoOpened = 'Y'">ruOpened</xsl:when>
					<xsl:otherwise>ruClosed</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<h3 class="{$restoClass}">
				<a href="javascript:void(0);" name="{$restoId}Menus" class="showRestoMenus"><xsl:value-of select="@title"/></a>
				<a href="javascript:void(0);" name="{$restoId}Info" class="showRestoInfo" />
			</h3>
			<div id="{$restoId}Menus" class="restoPanelContent" style="display: none;">
				
				<xsl:variable name="restoNode" select="document($menuXmlSource)/root/resto[@id=$restoId]" />
				<xsl:choose>
					<xsl:when test="($isRestoOpened = 'Y') and (count($restoNode/menu) &gt; 0)">
						<ul class="dateListContainer">
							<xsl:for-each select="$restoNode/menu">
								<xsl:variable name="date">
									<xsl:call-template name="formatMenuDate">
										<xsl:with-param name="node" select="." />
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="menuId" select="concat(@date, $restoId)" />
								<xsl:variable name="dateItemClass">
									<xsl:choose>
										<xsl:when test="position() = 1">dateItem currentDate</xsl:when>
										<xsl:otherwise>dateItem</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<li class="{$dateItemClass}">
									<a href="javascript:void(0);" name="{$menuId}" class="showDateMenu"><xsl:value-of select="$date" /></a>
								</li>
							</xsl:for-each>
						</ul>
						<xsl:for-each select="$restoNode/menu">
							<xsl:variable name="menuId" select="concat(@date, $restoId)" />
							<xsl:variable name="displayMenu">
								<xsl:choose>
									<xsl:when test="position() = 1">block</xsl:when>
									<xsl:otherwise>none</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<div id="{$menuId}" class="menuContainer" style="display:{$displayMenu};">
								<xsl:value-of select="text()" disable-output-escaping="yes" />
							</div>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<span class="noMenu">Aucun menu &agrave; afficher…</span>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div>
  	</xsl:template>

	
	<!-- Resto Info  -->
	<xsl:template name="restoInfo" match="resto" mode="restoInfo">
		<xsl:variable name="isRestoOpened">
			<xsl:choose> 
				<xsl:when test="@closing='0' or (ex:year($todayDate) &gt;= ex:year(@closing)) and (ex:dayInYear($todayDate) &gt;= ex:dayInYear(@closing))">Y</xsl:when>
				<xsl:otherwise>N</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="restoClass">
			<xsl:choose>
				<xsl:when test="$isRestoOpened = 'Y'">ruOpened</xsl:when>
				<xsl:otherwise>ruClosed</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<div id="{@id}Info" style="display:none;" class="restoInfoPopup">
			<a href="javascript:void(0);" class="closeRestoInfoPopup">Fermer X</a>
			<h3 class="{$restoClass}">Crous - <xsl:value-of select="@title"/></h3>
			<xsl:call-template name="crousSources" />
			
			<xsl:variable name="closingDate">
				<xsl:call-template name="formatClosingDate">
					<xsl:with-param name="node" select="." />
				</xsl:call-template>
			</xsl:variable>
			
			<div class="restoInfoDetails">
				<div class="infoSection">
					<span class="label">Ouverture: </span>
					<xsl:choose>
						<xsl:when test="$isRestoOpened = 'Y'">
							
							<xsl:variable name="mon" select="substring(@opening, 1, 3)" />
							<xsl:variable name="tue" select="substring(@opening, 5, 3)" />
							<xsl:variable name="wed" select="substring(@opening, 9, 3)" />
							<xsl:variable name="thu" select="substring(@opening, 13, 3)" />
							<xsl:variable name="fri" select="substring(@opening, 17, 3)" />
							<xsl:variable name="sat" select="substring(@opening, 21, 3)" />
							<xsl:variable name="sun" select="substring(@opening, 25, 3)" />
													
							<table class="opening">
								<thead>
									<tr>
										<th></th>
										<th>Matin</th>
										<th>Midi</th>
										<th>Soir</th>
									</tr>
								</thead>
								<tbody>
									<xsl:call-template name="openingForDay">
										<xsl:with-param name="day" select="'Lundi'" />
										<xsl:with-param name="openingData" select="$mon" />
									</xsl:call-template>
									<xsl:call-template name="openingForDay">
										<xsl:with-param name="day" select="'Mardi'" />
										<xsl:with-param name="openingData" select="$tue" />
									</xsl:call-template>
									<xsl:call-template name="openingForDay">
										<xsl:with-param name="day" select="'Mercredi'" />
										<xsl:with-param name="openingData" select="$wed" />
									</xsl:call-template>
									<xsl:call-template name="openingForDay">
										<xsl:with-param name="day" select="'Jeudi'" />
										<xsl:with-param name="openingData" select="$thu" />
									</xsl:call-template>
									<xsl:call-template name="openingForDay">
										<xsl:with-param name="day" select="'Vendredi'" />
										<xsl:with-param name="openingData" select="$fri" />
									</xsl:call-template>
									<xsl:call-template name="openingForDay">
										<xsl:with-param name="day" select="'Samedi'" />
										<xsl:with-param name="openingData" select="$sat" />
									</xsl:call-template>
									<xsl:call-template name="openingForDay">
										<xsl:with-param name="day" select="'Dimanche'" />
										<xsl:with-param name="openingData" select="$sun" />
									</xsl:call-template>
								</tbody>
							</table>			
						</xsl:when>
					  	<xsl:otherwise>				  		
					  		<span class="openingStatus reopeningInfo">R&eacute;ouverture le <xsl:value-of select="$closingDate" /> </span>
					  	</xsl:otherwise>
					</xsl:choose>
				</div>
				<xsl:if test="infos != ''">
	 				<div class="infoSection detail">
						<span class="label">Infos pratiques: </span><xsl:value-of select="infos/text()" disable-output-escaping="yes" />
					</div>
				</xsl:if>
				<xsl:if test="contact != ''">
	 				<div class="infoSection">
						<span class="label">Contact: </span><xsl:value-of select="contact/text()" disable-output-escaping="yes" />
					</div>
				</xsl:if>
			</div>			
		</div>
	</xsl:template>
	
	<xsl:template name="openingForDay">
		<xsl:param name="day" />
		<xsl:param name="openingData" />
		
		<xsl:variable name="morningOpening" select="substring($openingData, 1, 1)" />
		<xsl:variable name="lunchOpening" select="substring($openingData, 2, 1)" />
		<xsl:variable name="eveningOpening" select="substring($openingData, 3, 1)" />
				
		<xsl:variable name="morningClass">
			<xsl:choose>
				<xsl:when test="$morningOpening='0'">closed</xsl:when>
				<xsl:otherwise>opened</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="lunchClass">
			<xsl:choose>
				<xsl:when test="$lunchOpening='0'">closed</xsl:when>
			  	<xsl:otherwise>opened</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="eveningClass">
			<xsl:choose>
				<xsl:when test="$eveningOpening='0'">closed</xsl:when>
			  	<xsl:otherwise>opened</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<tr>
			<td class="openingDay"><xsl:value-of select="$day" /></td>
			<td class="{$morningClass}">O</td>
			<td class="{$lunchClass}">O</td>
			<td class="{$eveningClass}">O</td>
		</tr>
		
	</xsl:template>
	
	<xsl:template name="formatClosingDate">
		<xsl:param name="node" />
		<xsl:call-template name="formatDate">
			<xsl:with-param name="datestr" select="$node/@closing" />
		</xsl:call-template>	

	</xsl:template>
	
	<xsl:template name="formatMenuDate">
		<xsl:param name="node" />
		<xsl:call-template name="formatDate">
			<xsl:with-param name="datestr" select="$node/@date" />
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="formatDate">
		<xsl:param name="datestr" />
		<xsl:param name="separator" select="'/'"/>
		<!-- input format yyyy-mm-dd -->
		<!-- output format dd/mm/yyyy -->
		<xsl:variable name="yyyy">
			<xsl:value-of select="substring($datestr,1,4)" />
		</xsl:variable>
		<xsl:variable name="mm">
			<xsl:value-of select="substring($datestr,6,2)" />
		</xsl:variable>
		<xsl:variable name="dd">
			<xsl:value-of select="substring($datestr,9,2)" />
		</xsl:variable>
		<xsl:value-of select="$dd" />
		<xsl:value-of select="$separator" />
		<xsl:value-of select="$mm" />
		<xsl:value-of select="$separator" />
		<xsl:value-of select="$yyyy" />
	</xsl:template>


	<xsl:template name="replace-substring">
		<xsl:param name="original"/>
		<xsl:param name="substring"/>
		<xsl:param name="replacement" select="''"/>
		<xsl:choose>
		    <xsl:when test="contains($original, $substring)">
		        <xsl:value-of select="substring-before($original, $substring)"/>
		        <xsl:copy-of select="$replacement"/>
		        <xsl:call-template name="replace-substring">
		            <xsl:with-param name="original" select="substring-after($original, $substring)"/>
		            <xsl:with-param name="substring" select="$substring"/>
		            <xsl:with-param name="replacement" select="$replacement"/>
		        </xsl:call-template>
		    </xsl:when>
		    <xsl:otherwise>
		        <xsl:value-of select="$original"/>
		    </xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="crousSources">
		<span class="infoSource" style="display:none;">Source : <a href="{$crousSourceUrl}" target="_blank"><xsl:value-of select="$crousSourceLabel"/></a></span>
	</xsl:template>
	
	
	
</xsl:stylesheet>