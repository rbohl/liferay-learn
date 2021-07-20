#!/bin/bash

# User input for API resource name and API cURL endpoint name.
read -p "Enter the API resource name (e.g. TaxonomyVocabulary): " resource
read -p "Enter the API endpoint name (e.g. taxonomy-vocabularies): " endpoint

# Set the source directory for the cURL template files.
CURL_SRC_DIR="$HOME/Documents/liferay/liferay-learn/docs/_template/api/curl"

# Set the destination directory for the API tutorial cURL files.
CURL_DST_DIR="$HOME/Documents/liferay/liferay-learn/docs/test/curl"

# Copy the cURL template files from the source folder to the destination folder.
cp -rp $CURL_SRC_DIR/ $CURL_DST_DIR/

# Change directory to the cURL destination folder.
cd $CURL_DST_DIR

# Replace the endpoint name inside the cURL files.
sed -i "s/Endpoint/$endpoint/g" *

# Rename the cURL files to the resource name.
for f in Resource*
do
	mv "$f" "${f/Resource/$resource}"
done

# Set the source directory for the Java template files.
JAVA_SRC_DIR="$HOME/Documents/liferay/liferay-learn/docs/_template/api/java"

# Set the destination directory for the API tutorial Java files.
JAVA_DST_DIR="$HOME/Documents/liferay/liferay-learn/docs/test/java"

# Copy the Java template files from the source folder to the destination folder.
cp -rp $JAVA_SRC_DIR/ $JAVA_DST_DIR/

# Change directory to the Java destination folder.
cd $JAVA_DST_DIR

# Set separate variables for uppercase and lowercase resource name.
UPPERCASE=$resource
lowerCASE="$(tr '[:upper:]' '[:lower:]' <<< ${resource:0:1})${resource:1}"

# Replace the uppercase resource names inside the Java file.
sed -i "s/UPPERCASE/$UPPERCASE/g" *

# Replace the lowercase resource name inside the Java file.
sed -i "s/lowerCASE/$lowerCASE/g" *

# Rename the Java file to the resource name.
for f in Resource*
do
	mv "$f" "${f/Resource/$resource}"
done
