#!/bin/bash

set -eou pipefail

#
# bashDoc
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
# bashDoc
#
function set_build_data {
    echo "Processing your arguments to understand what to build: All, Prod, Commerce 2.x, DXP 7.x, or DXP Cloud Latest"
    product_name=$1
    version_name=$2

    COMMERCE_DEFLT_VER="2.x"
    DXP_DEFLT_VER="7.x"
    DXP_CLOUD_DEFLT_VER="latest"

}

#
# This is where the build behavior is defined. The logic and loops are defined
# in the function, but several functions hold the bash commands that accomplish
# the build. The functions called from build_the_site are treated like private
# methods and fields, and are in alphabetical order at the end of the script.
#
function build_the_site {

    _pre_process_input
    set_build_data $1 $2
    # deal with each argument we want to accept
    case $product_name in
        # For each specific product, set the default version name if none is
        # provided, then populate the input dir with only that product/ver
        "commerce")      
            if [[ $version_name == "default" ]]; then
              version_name=${COMMERCE_DEFLT_VER}
            fi
        ;&
        "dxp")
            if [[ $version_name == "default" ]]; then
              version_name=${DXP_DEFLT_VER}
            fi
        ;& 
        "dxp-cloud")
            if [[ $version_name == "default" ]]; then
              version_name=${DXP_CLOUD_DEFLT_VER}
            fi
        ;&
        "commerce"|"dxp"|"dxp-cloud")
            # do common stuff for a single-product-build
            echo "Building $product_name $version_name"
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
            echo "Cleaning for production build"
            _clean_for_prod
        ;&
        "prod"|"all")
            echo "Building all products and versions"
            _util_scripts
            for product_name in `find ../docs -maxdepth 1 -mindepth 1 -printf "%f\n" -type d`; do
                for version_name in `find ../docs/${product_name} -maxdepth 1 -mindepth 1 -printf "%f\n" -type d`; do
                    echo "Currently generating input for $product_name $version_name"
                    _generate_input
                done
            done
	        for dir_name in `find build/input -maxdepth 1 -mindepth 1 -printf "%f\n" -type d`
            do
                echo "Currently generating output for $product_name $version_name"
                _generate_static_html_output
                _post_process_output
                _zip_src_code
                _post_process_homepage
            done
        ;&
        "prod")
            echo "Uloading to server"
            upload_to_server
        ;;
        *)
        #handle invalid args: because I'm passing defaults (all default), this
        # only gets called if an unhandled case gets passed
            echo "You must enter at least one argument: product_name"
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
	# TODO: Should only be called when the "prod" arg is passes
	#

	echo upload_to_server
}

#
# bashDoc
#
function _clean_for_prod {
    echo "Removing the /build directory, cleaning the git index"
    rm -fr build
    pushd $(git rev-parse --show-toplevel)/docs
        git clean -dfx .
    popd
}

#
# bashDoc
#
function _generate_input {

    echo "Syncing the existing input directory, if it exists, with the src for $product_name-$version_name"
    mkdir -p build/input/${product_name}-${version_name}

    rsync -av ../docs/${product_name}/${version_name}/en/* build/input/${product_name}-${version_name} --exclude=.gradle --exclude=.classpath --exclude=.project --exclude=.settings --exclude=build --exclude=classes --delete-excluded
    rsync -a docs/* build/input/${product_name}-${version_name}
}

#
# Use Sphinx to generate static HTML.
#
function _generate_static_html_output {

        echo "Calling sphinx-build for $dir_name"

		sphinx-build -M html build/input/${dir_name} build/output/${dir_name}
}

#
# Homepage bumps up a dir, just kind of orphaned here for now
#
function _post_process_homepage {
    
    echo "Moving the homepage contents up a dir"
    rsync -a build/output/homepage/* build/output
}
   
function _post_process_output {
    echo "Done building, processing output for $dir_name"
		rsync -a build/output/${dir_name}/html/* build/output/${dir_name}

        find build/output/$dir_name -name "*.html" -exec sed -i s/README.html/index.html/g {} +

		for readme_file_name in `find build/output/${dir_name} -name *README.html -type f`
		do
			rsync -a ${readme_file_name} $(dirname ${readme_file_name})/index.html
		done

		sed -i 's/README"/index"/g' build/output/${dir_name}/searchindex.js
}

#
# bashDoc
#
function _pre_process_input {
    echo "Just doing some initial prep for building"
    mkdir -p build/input/homepage
	rsync -a homepage/* build/input/homepage --exclude={'*.json','node_modules'}
}

#
# bashDoc
#
function _util_scripts {
    echo "Calling some utility scripts"
	pushd $(git rev-parse --show-toplevel)/docs
    ./update_examples.sh && ./update_permissions.sh
	popd
}

#
# bashDoc
#
function _zip_src_code {

    echo "Done building, zipping src code for $dir_name"
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
        # detect updated files (using the time-stamp of the last updated
        # file in the src dir
        if [[ $src_zip_latest_file -nt $existing_output_zip ]]
        then
            echo "I found files in $src_zip_dir/$src_zip_latest_file newer than the $existing_output_zip, rebuilding the zip"
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
