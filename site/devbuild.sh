#!/bin/bash

# some ideas are sprinkled throughout the file, which might solve some of these todos
# todo: do not copy git ignored files into the input folder
    # SOLVED by using exclude statements in the rsync to the input folder
# todo: when you build all products, then afterward build a single product, it
    # rebuilds everything now because sphinx-build is looking at the whole input
    # dir might be fine since it's now fast, but if we find an easy solution it
    # might be worth it
# todo: the condition for zipping finds more updated files than you'd expect,
    # because of two scripts called at the beginning which update the src code of
    # modules (at time of writing, all commerce modules).
# todo: can we check the input folder for updated files in the zip dir? then we
    # cannot match anything excluded (.gradle, etc.)? maybe there's a reason i
    # didn't in the first place, need to dig back in. will not solve above issue
# todo: smarter logic in zipper stuff. don't even look in the other dirs. if we
    # still have the product/version name just there for updates.

set -eou pipefail

function check_utils {

	#
	# https://stackoverflow.com/a/677212
	#

	for util in "${@}"
	do
		command -v ${util} >/dev/null 2>&1 || { echo >&2 "The utility ${util} is not installed."; exit 1; }
	done
}

function parse_args_generate_sphinx_input {
# This deals with the arguments for product names and versions, calling the
# populate_product_input_dir method for the handled product(s)

    product_name=$1
    version_name=$2

    # Hard-coding the current versions as defaults so we don't have to always
    # specify the version
    commerce_default_version="2.x"
    dxp_default_version="7.x"
    dxp_cloud_default_version="latest"

    # these lines stolen from the function I replaced: call some other scripts
    # and come back to the site folder. i'm no longer doing rm -fr here, but
    # only when building for prod. The can cause more zips to be rebuilt than
    # might be expected, because they're updating the src code files
	pushd ../docs
    ./update_examples.sh && ./update_permissions.sh
	popd

    # deal with each argument we want to accept
    case $product_name in
        # For each specific product, set the default version name if none is
        # provided, then populate the input dir with only that product/ver
        "commerce")      
            if [[ $version_name == "default" ]]; then
              version_name=${commerce_default_version}
            fi
            echo "Building $product_name $version_name"
            populate_product_input_dir 
        ;;
        "dxp")
            if [[ $version_name == "default" ]]; then
              version_name=${dxp_default_version}
            fi
            echo "Building $product_name $version_name"
            populate_product_input_dir 
        ;; 
        "dxp-cloud")
            if [[ $version_name == "default" ]]; then
              version_name=${dxp_cloud_default_version}
            fi
            echo "Building $product_name $version_name"
            populate_product_input_dir 
        ;;
        "all")      
        # The for loops are the same for prod and all, copied form the original
        # version of the script. I could combine them into one case and just
        # check for "prod" to run the git clean and the upload_to_server; would
        # be shorter but maybe messier. Use these loops to populate the input
        # dir with all products and versions 
            echo "Building All Products and Versions"
            # must use the loops to find everything 
            for product_name in `find ../docs -maxdepth 1 -mindepth 1 -printf "%f\n" -type d`; do
                for version_name in `find ../docs/${product_name} -maxdepth 1 -mindepth 1 -printf "%f\n" -type d`; do
                    echo "Currently Building $product_name $version_name"
                    populate_product_input_dir
                done
            done
        ;;
        "prod")
        # same as "all" plus a git clean, and a todo for the upload_to_server stuff
            # moved the rm -fr build into prod as well, so we don't need to
            # rebuild the entire build folder each time
            rm -fr build
            pushd ../docs
            git clean -dfx .
            popd
            echo "Building All Products and Versions for Production"
            for product_name in `find ../docs -maxdepth 1 -mindepth 1 -printf "%f\n" -type d`; do
                for version_name in `find ../docs/${product_name} -maxdepth 1 -mindepth 1 -printf "%f\n" -type d`; do
                    echo "Currently Building: $product_name $version_name"
                    populate_product_input_dir
                done
            done
            # TODO: upload_to_server should somehow only be called for the "prod" case, after html is generated.
        ;;
        *)
        #handle invalid args: because I'm passing defaults (all default), this
        # only gets called if an unhandled case gets passed
            echo "You must enter at least one argument: product_name"
            echo "Product name options: all | prod | commerce | dxp | dxp-cloud" 
            exit 1
        ;;
    esac

    # this was in the original script
	rsync -a homepage/* build/input/homepage --exclude={'*.json','node_modules'}
}

function populate_product_input_dir {

    mkdir -p build/input/${product_name}-${version_name}

    rsync -av ../docs/${product_name}/${version_name}/en/* build/input/${product_name}-${version_name} --exclude=.gradle --exclude=.classpath --exclude=.project --exclude=.settings --exclude=build --exclude=classes --delete-excluded
    rsync -a docs/* build/input/${product_name}-${version_name}
# what does this do? i'm getting rid of it and we'll see if something breaks.
#			if [ ! -f "build/input/${product_name}-${version_name}/contents.rst" ]
#			then
#				mv build/input/${product_name}-${version_name}/contents.rst build/input/${product_name}-${version_name}
#			fi
}

# function what_are_we_building {
# 
#     if [[ ${1} == "all" ]]
#     then
# 
# 	for dir_name in `find build/input -maxdepth 1 -mindepth 1 -printf "%f\n" -type d`
# 	do
# 		#
# 		# Use Sphinx to generate static HTML.
# 		#
# 
#         generate_static_html
# 
#     done
# else
#    $dir_name=$1
#    generate_static_html
#    $dir_name=
#     fi
# 
# }

function generate_static_html {
	for dir_name in `find build/input -maxdepth 1 -mindepth 1 -printf "%f\n" -type d`
	do

		#
		# Use Sphinx to generate static HTML.
		#

		sphinx-build -M html build/input/${dir_name} build/output/${dir_name}

        # i wonder if we kill the html dir after doing this, will we handle file deletions then?
		rsync -a build/output/${dir_name}/html/* build/output/${dir_name}

		#
		# Fix broken links.
		# does this mean everything gets updated? because then sphinx can't
        # tell what to rebuild? doesn't sphinx do the md-html bit already?

# 		for html_file_name in `find build/output/${dir_name} -name *.html -type f`
# 		do
##			sed -i 's/.md"/.html"/g' ${html_file_name}
##			sed -i 's/.md#/.html#/g' ${html_file_name}
        # These sed subsitutions do add some time, 8-11 seconds just for these two below
#			sed -i 's/README.html"/index.html"/g' ${html_file_name}
#			sed -i 's/README.html#/index.html#/g' ${html_file_name}
#		done

        # I'm replacing the above with the one find and replace command I
        # believe is necesesary:

        find build/output/$dir_name -name "*.html" -exec sed -i s/README.html/index.html/g {} +

		#
		# Rename README.html to index.html.
		#

		for readme_file_name in `find build/output/${dir_name} -name *README.html -type f`
		do
			rsync -a ${readme_file_name} $(dirname ${readme_file_name})/index.html
		done

		#
		# Update search references for README.html to index.html.
		#

		sed -i 's/README"/index"/g' build/output/${dir_name}/searchindex.js

		#
		# Make ZIP files.
		# we need to only zip these if we find updates to the folder, otherwise
        # it takes forever

        # we could check the equality of build/input/dir_name and
        # build/input/product_name-version_name. if not equal use dir_name as
        # here, but if equal, then someone passed a product to build, so we
        # should just process zips in that project
#		for input_zip_dir_name in `find build/input/${product_name}-${version_name} -name *.zip -type d`

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
	done

	rsync -a build/output/homepage/* build/output

	rm -r build/output/homepage
}

function main {

	#
	# sudo dnf install python3-sphinx
	#

	python3 -m venv venv

	source venv/bin/activate

	check_utils pip3 sphinx-build zip

	pip_install recommonmark sphinx-intl sphinx-copybutton sphinx-markdown-tables sphinx-notfound-page

	parse_args_generate_sphinx_input $1 $2

    what_are_we_building

 	generate_static_html

	upload_to_server

    chromium build/output/$product_name-$version_name/index.html
}

function pip_install {
	for package_name in "$@"
	do
		if [[ -z `pip3 list --disable-pip-version-check --format=columns | grep ${package_name}` ]]
		then
			pip3 install --disable-pip-version-check ${package_name}
		fi
	done
}

function upload_to_server {

	#
	# TODO: Should only be called when the "prod" arg is passes
	#

	echo upload_to_server
}

main ${1:-all} ${2:-default}
