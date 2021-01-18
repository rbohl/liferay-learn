#!/bin/bash

readonly CURRENT_DIR_NAME=$(dirname "${0}")

readonly ZIP_DIR_NAME=$(find . -name liferay-${1}.zip -type d)
    
function init_project {
	if [[ -z ${ZIP_DIR_NAME} ]]
	then
		echo "FAILED: Target directory does not exist. Create a liferay-${1}.zip folder, then try again."
		exit
	elif [ "$(ls -A ${ZIP_DIR_NAME})" ]
	then
		echo "$(ls -A ${ZIP_DIR_NAME})"
		echo "FAILED: Target directory is not empty, cannot initialize a project"
		exit
	else
		local inner_project_dir_name=${ZIP_DIR_NAME}/${1}-ptype

		mkdir -p ${inner_project_dir_name}/src/main/java/
		mkdir -p ${inner_project_dir_name}/src/main/resources/content/
		mkdir -p ${inner_project_dir_name}/src/main/resources/META-INF/resources/

		local build_gradle_contents="dependencies {\n\tcompileOnly group: \"com.liferay.portal\", name: \"release.portal.api\"\n}"

		echo -ne "${build_gradle_contents}" > ${inner_project_dir_name}/build.gradle

		local bnd_bnd_contents="Bundle-Name: Acme $(echo ${1} | tr [:lower:] [:upper:]) PTYPE\nBundle-SymbolicName: com.acme.${1}.ptype\nBundle-Version: 1.0.0"

		echo -ne "${bnd_bnd_contents}" > ${inner_project_dir_name}/bnd.bnd
	fi
}

function log_next_steps {
	echo ""
	echo "--------------"
	echo "NEXT: Make sure you replace \"ptype\" with a project type (usually api, impl, or web) in this directory name:"
	echo "$(find ${ZIP_DIR_NAME} -name "*ptype*" -type d)"
	echo ""
	echo "--------------"
	echo "NEXT: Make sure you replace \"ptype\" with a project type (usually api, impl, or web) in these files' contents:"
	echo "$(grep -ir "ptype" ${ZIP_DIR_NAME})"
}

function main {
	pushd "${CURRENT_DIR_NAME}" || exit 1

	init_project ${1}

	./update_examples.sh ${1}

	log_next_steps
}

main "${@}"
