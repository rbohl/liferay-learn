#!/bin/bash

# User input for API resource name and API cURL endpoint name.
read -p "Enter the API resource name (e.g. TaxonomyVocabulary): " resource
read -p "Enter the API endpoint name (e.g. taxonomy-vocabularies): " endpoint

# Set the source directory to the template location.
SRC_DIR="$HOME/Documents/liferay/liferay-learn/docs/_template/api/curl"

# Set the destination directory to the location of the API tutorial resource.
DST_DIR="$HOME/Documents/liferay/liferay-learn/docs/test/"

# Copy the template files from the source folder to the destination folder.
cp -rp $SRC_DIR/ $DST_DIR/

# Change directory to the destination folder.
cd $DST_DIR

# Rename the endpoint name to the user input inside the cURL files.
sed -i "s/Endpoint/$endpoint/g" *

# Rename the cURL files to the user input.
for f in Resource*
do
	mv "$f" "${f/Resource/$resource}"
done