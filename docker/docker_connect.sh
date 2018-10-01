#!/usr/bin/env bash

source "$(dirname $0)/_docker_utils.sh"

BASH_HISTORY_FILE="$(dirname $0)/.docker_bash_history"
if [ ! -f "${BASH_HISTORY_FILE}" ]; then
    touch "${BASH_HISTORY_FILE}"
fi

DEFAULT_USER="ithemal"
USER="${DEFAULT_USER}"

if [ "$#" -eq 1 ]; then
    USER="${1}"
elif [ "$#" -gt 1 ]; then
    echo "Usage: ./docker_connect.sh [user] to log in as 'user' (default: '${DEFAULT_USER}')"
    exit 1
fi

function container_id() {
    docker ps -q --filter 'name=ithemal$'
}


CONTAINER="$(container_id)"

if [[ -z "${CONTAINER}" ]]; then
    read -p "Container is not currently running. Would you like to start it? (y/n) " -r

    if [[ !($REPLY =~ ^[Yy]) ]]; then
	echo "Not starting."
	exit 1
    fi

    docker_compose up -d --force-recreate

    CONTAINER="$(container_id)"
fi

docker exec -it -u "${USER}" "${CONTAINER}" bash -l