#!/bin/sh
# Script to launch the XSL transformation and generate the HTML file.
#
# Several parameters are needed:
#	1) filepath for saxon.jar
#	2) XML file to read from
#	3) XSL file used to transform from XML to HTML
#   3) Path of generated HTML file

# >>>> CUSTOMIZATION (start)
BASE_DIR="."
JAVA_HOME=/path/to/jdk
OPTS=" -Dhttp.proxyHost=proxy.univ.fr -Dhttp.proxyPort=666 "
# <<<< CUSTOMIZATION (end)

SAXON_JAR=$1
if [[ "$SAXON_JAR" = "" ]]; then
	SAXON_JAR="$BASE_DIR/utils/saxon.jar";
fi

XML_FILE=$2
if [[ "$XML_FILE" = "" ]]; then
	XML_FILE="http://crous.parking.einden.com/static/poitiers-resto.xml";
fi

XSL_FILE=$3
if [[ "$XSL_FILE" = "" ]]; then
	XSL_FILE="$BASE_DIR/ru.xsl";
fi

OUTPUT_FILE=$4
if [[ "$OUTPUT_FILE" = "" ]]; then
	OUTPUT_FILE="$BASE_DIR/results.html";
fi

$JAVA_HOME/bin/java -jar $OPTS $SAXON_JAR $XML_FILE $XSL_FILE > $OUTPUT_FILE
