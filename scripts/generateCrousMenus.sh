#!/bin/sh
#
# Utilitaire pour générer des 
#

# >>>> CUSTOMIZATION (start)

#Répertoire où se trouve les sources du projet
BASE_DIR=/path/to/portlet-crousmenus
#Répertoire où seront déployés les fichiers HTML générés (par exemple: /path/to/webapps/crousmenus)
DEPLOY_DIR=/path/to/deploy/dir
#URL du flux XML décrivant les menus
RU_XML=http://crous.parking.einden.com/static/poitiers-resto.xml

# <<<< CUSTOMIZATION (end)

# Warning: 
# Il est recommandé d'utiliser le jar fourni dans le projet car toutes les versions de Saxon ne sont pas compatibles 
SAXON_JAR=${BASE_DIR}/utils/saxon.jar


#Lancement de la génération du fichier HTML à partir des différents flux du CROUS
${BASE_DIR}/generateHTML.sh ${SAXON_JAR} ${RU_XML} ${BASE_DIR}/ru.xsl ${DEPLOY_DIR}/results.html
