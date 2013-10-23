portlet-crousmenus
==================

## Description générale ##
Ce service consiste à générer des fichiers HTML à partir des flux XML fournis CROUS pour obtenir la description des différents RUs implantés dans une région (mais regroupés par campus) mais aussi le listing des menus qui y sont servis. 
Pour éviter un nombre de requêtes trop important vers les serveurs des CROUS, il est recommandé de ne pas relancer la génération trop souvent (bien que les flux soient mis à jour toutes les minutes).

#### Pour Poitiers ####
* fichier XML decrivant les RU : http://crous.parking.einden.com/static/poitiers-resto.xml
* fichier XML decrivant les menus : http://crous.parking.einden.com/static/poitiers-menu.xml

#### Pour Dijon ####
* fichier XML decrivant les RU : http://crous.parking.einden.com/static/dijon-resto.xml
* fichier XML decrivant les menus : http://crous.parking.einden.com/static/dijon-menu.xml

etc.

##  Instructions ##

#### Editer le fichier ru.xsl ####
* spécifier les 3 variables :
  	  - menuXmlSource    : URL du fichier XML décrivant les menus
  	  - crousSourceUrl   : URL du Crous d'où proviennent les données (ex: 'http://www.crous-poitiers.fr')
  	  - crousSourceLabel : Label du Crous source, cette valeur sera utilisée pour le lien "Source: <label_Crous>" (ex: avec  crousSourceLabel='Crous de Poitiers' -> "Source: Crous de Poitiers")
* définir les zones (crous:zone) à afficher dans l'ordre souhaité et spécifier pour chacune d'elles si le noeud qui la représentera dans l'arbre doit être ouvert (ou non) par défaut (openInTree : Y = yes, N = no).
Pour que cela fonctionne, il faut utiliser EXACTEMENT les même noms de zones que ceux affichés dans le flux XML fr_resto.xml (/root/resto/@zone): 

```
  <crous:zones>
        <crous:zone openInTree="Y">LA ROCHELLE</crous:zone>
        <crous:zone openInTree="N">ANGOULEME</crous:zone>
        <crous:zone openInTree="N">CHATELLERAULT</crous:zone>
        <crous:zone openInTree="N">NIORT</crous:zone>
        <crous:zone openInTree="Y">POITIERS CAMPUS</crous:zone>
        <crous:zone openInTree="N">POITIERS CENTRE VILLE</crous:zone>
        <crous:zone openInTree="N">POITIERS FUTUROSCOPE</crous:zone>
    </crous:zones>
```

#### Lancer la génération du HTML ####
* modifier generateHTML.sh: spécifier le chemin de votre JAVA_HOME et votre conf proxy si besoin.
* mode DEMO: tester pour le Crous de Poitiers:

* déploiement réel:
  	  - modifier scripts/generateCrousMenus.sh: 
  	  		BASE_DIR  : là où se trouve les sources du projet
  	  		DEPLOY_DIR: là où seront placés les HTML générés
  	  		RU_XML    : URL du fichier XML décrivant les restaurants
  	  - modifier scripts/every20min_generateCrousMenus.cron pour spécifier le chemin vers generateCrousMenus.sh: 

#### Intégrer ce résultat à un uPortal ####
* Déclarer les CSS et JS dans les skin.xml de votre portail : 
Par exemple :
   - skins/universality/yourSkinName/skin.xml:
  	  +   <css>/crous/media/css/ru.css</css>
  	  +   <js>/crous/media/js/custom.js</js>
           
    - skins/muniversality/android/skin.xml ET skins/muniversality/iphone/skin.xml
  	  +   <css>/crous/media/css/ru_mob.css</css>
  	  +   <js>/crous/media/js/custom_mob.js</js>

* Créer une nouvelle portlet (WebProxyPortlet) qui va intégrer ce contenu à l'ENT:
  * Titre/Nom: Crous - RU & menus (Merci de ne pas modifier ce libellé qui a été "validé" par le CROUS)
  * sBaseUrl : https://ent.univ.fr/crousmenus/results.html (par exemple)
  		
    
#### Tester !!! ####
