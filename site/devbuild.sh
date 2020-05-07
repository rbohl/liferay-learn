#!/bin/bash

set -eou pipefail

#
# This is the entry point to the script. See the last line in the script file,
# where we call main $1 $2 (accepting 2 positional parameters as command line
# arguments). 
# 
# There are several utility scripts run here, to set up the build environment.
# Afterward, the site build function, build_the_site, is called with both
# arguments passed.
#
function main {

	#
	# sudo dnf install python3-sphinx
	#

	python3 -m venv venv

	source venv/bin/activate

	check_utils pip3 sphinx-build zip

	pip_install recommonmark sphinx-intl sphinx-copybutton sphinx-markdown-tables sphinx-notfound-page

    build_the_site $1 $2

}

#
# This is where the logic for each build level is defined: build a single
# product and version, build all products and versions for development and
# testing, or build all products and versions for production
# (dangerous: includes a git clean -dfx of the liferay-learn/docs folder).
# 
# Product-parsing logic (via case statements) and some loops over the build
# directories (for multi-product builds) are defined depending on the build
# level, but several functions hold the actual commands that accomplish the
# build. These functions, called from within build_the_site, are treated like
# private Java methods and fields, and are in alphabetical order at the end of
# the script, prepended with a _ character.
#
function build_the_site {

    _set_build_data $1 $2
    # deal with each argument we want to accept
    case $product_name in
        "commerce")      
            if [[ $version_name == "default" ]]; then
              version_name=${COMMERCE_DEFLT_VER}
            fi
        ;;&
        "dxp")
            if [[ $version_name == "default" ]]; then
              version_name=${DXP_DEFLT_VER}
            fi
        ;;& 
        "dxp-cloud")
            if [[ $version_name == "default" ]]; then
              version_name=${DXP_CLOUD_DEFLT_VER}
            fi
        ;;&
        "commerce"|"dxp"|"dxp-cloud")
            # do common stuff for a single-product-build
            echo "Building $product_name $version_name"
            _pre_process_input
            _generate_input 
            dir_name="homepage"
            _generate_static_html_output
            _post_process_output
            dir_name="${product_name}-${version_name}"
            _generate_static_html_output
            _post_process_output
            _zip_src_code
            _post_process_homepage
        ;;
        "prod")
            _pre_clean_for_prod
            ;&
        "all"|"prod")
            # do the common stuff for prod and all
            echo "Building all products and versions"
            _pre_process_input
            _util_scripts
            for product_name in `find ../docs -maxdepth 1 -mindepth 1 -printf "%f\n" -type d`; do
                for version_name in `find ../docs/${product_name} -maxdepth 1 -mindepth 1 -printf "%f\n" -type d`; do
                    echo "Currently generating input for $product_name $version_name"
                    _generate_input
                done
            done
            for dir_name in `find build/input -maxdepth 1 -mindepth 1 -printf "%f\n" -type d`
            do
                _generate_static_html_output
                _post_process_output
                _zip_src_code
            done
            _post_process_homepage
            ;;&
        "prod")
            echo "Uploading to server"
            _post_clean_for_prod
            upload_to_server
        ;&
        "all"|"prod")
        ;;
        *)
        # handle invalid args: because we pass a default product name of "all",
        # this only gets called if a bad argument is passed
            echo "ERROR: invalid argument: please enter a valid product name, or no arguments at all"
            echo "Product name options: all | prod | commerce | dxp | dxp-cloud" 
            exit 1
        ;;
    esac
}

#
# bashDoc
#
function check_utils {

	#
	# https://stackoverflow.com/a/677212
	#

	for util in "${@}"
	do
		command -v ${util} >/dev/null 2>&1 || { echo >&2 "The utility ${util} is not installed."; exit 1; }
	done
}

#
# bashDoc
#
function pip_install {
	for package_name in "$@"
	do
		if [[ -z `pip3 list --disable-pip-version-check --format=columns | grep ${package_name}` ]]
		then
			pip3 install --disable-pip-version-check ${package_name}
		fi
	done
}

#
# bashDoc
#
function upload_to_server {

	#
	# TODO: Should only be called when the "prod" arg is passed
	#

	echo upload_to_server
}

#
# For a production build, we must delete the build directory entirely and make
# sure the git index is clean.
#
function _pre_clean_for_prod {

    echo "Cleaning in preparation for production build"
    echo "Removing the /build directory, cleaning the git index"
    rm -fr build
    pushd $(git rev-parse --show-toplevel)/docs
        git clean -dfx .
    popd
}

#
# Generate and populate the liferay-learn/build/input directory.
#
# Sync, or create and populate, a product-version input directory with the
# matching content from liferay-learn/doc/product/version/en
# 
# Sync the contents of the liferay-learn/site/docs folder with the
# build/input/product-version folder: conf.py, _static, and _templates cone in
# with this command.
#
function _generate_input {

    echo "Syncing the existing input directory, if it exists, with the src for $product_name-$version_name"
    mkdir -p build/input/${product_name}-${version_name}

    rsync -av ../docs/${product_name}/${version_name}/en/* build/input/${product_name}-${version_name} \
        --exclude=.gradle --exclude=.classpath --exclude=.project \
        --exclude=.settings --exclude=build --exclude=classes --delete-excluded

    rsync -a docs/* build/input/${product_name}-${version_name}
}

#
# Call sphinx-build to generate the static HTML.
#
# Called from the build_the_site function, after generating input and
# pre-processing things.
#
function _generate_static_html_output {

        echo "Calling sphinx-build for $dir_name"

		sphinx-build -M html build/input/${dir_name} build/output/${dir_name}
}

#
# The homepage bumps up a dir at the end of the build process.
#
function _post_process_homepage {
    
    echo "Moving the homepage contents up a dir"
    rsync -a build/output/homepage/* build/output
}
   
#
# After sphinx-build, we want to reorganize some things in the built site. For
# instance, we don't want the docs to be underneath a /html/ folder, because
# this will translate to a URL. We're only serving html, so we get rid of this.
#
# In addition, Sphinx won't process some RST syntax in our admonitions, so
# various sed substitutions are required to make sure links work inside
# admonitions.
#
function _post_process_output {
    echo "Done building, processing output for $dir_name"

		rsync -a build/output/${dir_name}/html/. build/output/${dir_name}

        find build/output/$dir_name -type f -name "*.html" -exec sed -i \
                -e s/.md\"/.html\"/g \
                -e s/.md\#/.html\#/g \
                -e s/README.html\"/index.html\"/g \
                -e s/README.html\#/index.html\#/g \
            {} + 

		for readme_file_name in `find build/output/${dir_name} -name *README.html -type f`
		do
			rsync -a ${readme_file_name} $(dirname ${readme_file_name})/index.html
		done

		sed -i 's/README"/index"/g' build/output/${dir_name}/searchindex.js
}

#
# Our partial build support wants speed above all else, so it leaves our
# build/output directory in a production unfriendly state. This function cleans
# it up, by doing three things:
#   1.  Delete all README.html files throughout the output folder.
#   2.  Delete the build/output/homepage folder
#   3.  For every "html" folder in the output folder, leave only the hidden
#   .buildinfo file behind. All other contents are deleted.
#
function _post_clean_for_prod {

    echo "Cleaning up for production" 

    rm -r build/output/homepage

    find build/output/ -name "README.html" -type f -exec rm {} +

    cp build/output/html/.buildinfo build/output/.

    find build/output -name "html" -type d -exec rm -r {} +

}

#
# Before doing anything with the liferay-learn/docs content, make the dir for
# the homepage, then bring the homepage content in from
# liferay-learn/site/homepage.
#
function _pre_process_input {
    echo "Just doing some initial prep for building"
    mkdir -p build/input/homepage
	rsync -a homepage/* build/input/homepage --exclude={'*.json','node_modules'}
}

#
# Parse the command line arguments. If no arguments are passed, default values
# are set: "all" for product name and "default" for product version. If a
# single product is passed without a version, the build_the_site function uses
# the DEFLT_VER variables here to know what it should build. Currently, these
# are the only versions in the liferay-learn/docs folder.
#
function _set_build_data {
    echo "Processing your arguments to understand what to build: All, Prod, Commerce 2.x, DXP 7.x, or DXP Cloud Latest"
    product_name=$1
    version_name=$2

    COMMERCE_DEFLT_VER="2.x"
    DXP_DEFLT_VER="7.x"
    DXP_CLOUD_DEFLT_VER="latest"

}

#
# These scripts can update the source code files in any of the products. We are
# not currently calling these scripts for single-product builds, only for prod
# and all. This logic can be changed in the build_the_site function.
#
function _util_scripts {
    echo "Calling some utility scripts"
	pushd $(git rev-parse --show-toplevel)/docs
    ./update_examples.sh && ./update_permissions.sh
	popd
}

#
# Zip the source code folders named *.zip.
#
# If any file in a source code directory has been updated since the last build
# (or if the build directory is cleaned for prod), we'll rezip it. Otherwise,
# we do not call the zip command because it takes a lot of time to be zipping
# folders unnecessarily.
#
function _zip_src_code {

    echo "Done building HTML, now looking for new or updated source code for $dir_name"
    for input_zip_dir_name in `find build/input/${dir_name} -name *.zip -type d` 
    do

        # we need the name of the .zip dir to use as the zip file's name
        local zip_file_name=$(basename ${input_zip_dir_name})

        # search the liferay-learn/docs folder for a directory matching the
        # name from the input directory. we need it for checking its
        # file's timestamps
        local src_zip_dir=$(find ../docs/ -name ${zip_file_name} -type d)

        # get the most recently updated file from the zip directory in 
        # the matching docs zip directory
        local src_zip_latest_file=$(find $src_zip_dir -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" ")

        # get the matching existing zip file from the output dir
        local existing_output_zip=$(find build/output/$dir_name -name ${zip_file_name} -type f)

        # zipping the src code is time consuming, let's skip it unless we
        # detect updated files (using the newer than -nt comparator) of the last updated
        # file in the src dir
        if [[ $src_zip_latest_file -nt $existing_output_zip ]]
        then
            echo "Building Zip: $src_zip_dir/$src_zip_latest_file"
            pushd ${input_zip_dir_name}

            zip -r ${zip_file_name} .

            local output_dir_name=$(dirname ${input_zip_dir_name})

            output_dir_name=$(dirname ${output_dir_name})
            output_dir_name=${output_dir_name/input/output}

            popd

            rsync -a ${input_zip_dir_name}/${zip_file_name} ${output_dir_name}
        fi
    done
}
main ${1:-all} ${2:-default}
