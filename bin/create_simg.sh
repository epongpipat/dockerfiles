#!/bin/bash

# ------------------------------------------------------------------------------
# usage
# ------------------------------------------------------------------------------
function usage () {
    echo -e "\nusage:\tcreate_simg.sh [options]"
    echo -e "\tcreates a docker image for the specified software and version"
    echo -e "\noptions:"
    echo -e "\t-s|--software <software>\tsoftware name (required)"
    echo -e "\t-v|--version <version>\t\tsoftware version (required)"
    echo -e "\t-o|--out-dir <dir>\t\tdirectory to save the dockerfile (default: current directory)"
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
        -o|--out-dir)
            out_dir=$2
            if [[ -z ${out_dir} ]]; then
                usage
                echo -e "[ERROR]\tdirectory not specified"
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

if [[ -z ${out_dir} ]]; then
    out_dir=$(pwd)
fi

# ------------------------------------------------------------------------------
# paths
# ------------------------------------------------------------------------------
if [[ ! -d ${out_dir} ]]; then
    echo -e "[ERROR]\tdirectory does not exist: ${out_dir}"
    exit 1
fi

# ------------------------------------------------------------------------------
# main
# ------------------------------------------------------------------------------
cmd="time \
docker run \
-v /var/run/docker.sock:/var/run/docker.sock \
-v ${out_dir}:/output \
--privileged \
--tty \
--rm \
singularityware/docker2singularity \
${software}:${version}"
echo -e "\ncommand:\n${cmd}\n"
eval ${cmd}
