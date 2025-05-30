#!/bin/bash

# ------------------------------------------------------------------------------
# usage
# ------------------------------------------------------------------------------
function usage () {
    echo -e "\nusage:\tcreate_docker.sh [options]"
    echo -e "\tcreates a docker image for the specified software and version"
    echo -e "\noptions:"
    echo -e "\t-s|--software <software>\tsoftware name (required)"
    echo -e "\t-v|--version <version>\t\tsoftware version (required)"
    echo -e "\t-h|--help\t\t\tdisplay help message"
    echo -e ""
}

if [[ $# -eq 0 ]]; then
    usage
    exit 0
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        -s|--software)
            software=$2
            if [[ -z ${software} ]]; then
                usage
                echo -e "[ERROR]\tsoftware name not specified"
                exit 1
            fi
            shift 2
            ;;
        -v|--version)
            version=$2
            if [[ -z ${version} ]]; then
                usage
                echo -e "[ERROR]\tversion not specified"
                exit 1
            fi
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo -e "[ERROR]\tunknown option $1"
            usage
            exit 1
            ;;
    esac
done

if [[ -z ${software} ]]; then
    
    usage
    echo -e "[ERROR]\tsoftware name not specified"
    exit 1
elif [[ -z ${version} ]]; then
    usage
    echo -e "[ERROR]\tversion not specified"
    exit 1
fi

# ------------------------------------------------------------------------------
# paths
# ------------------------------------------------------------------------------
code_dir=$(dirname $0)
code_dir=$(dirname ${code_dir})

declare -A in_paths
in_paths[dir]="${code_dir}/dockerfiles/${software}/${version}"
in_paths[file]="${software}_v-${version}.dockerfile"

if [[ ! -f ${in_paths[dir]}/${in_paths[file]} ]]; then
    echo -e "[ERROR]\tfile ${in_paths[dir]}/${in_paths[file]} does not exist"
    exit 1
fi

# ------------------------------------------------------------------------------
# main
# ------------------------------------------------------------------------------
cmd="time \
docker build \
${in_paths[dir]} \
-t ${software}:${version} \
-f ${in_paths[file]}"
echo -e "\ncommand:\n${cmd}\n"
eval ${cmd}
