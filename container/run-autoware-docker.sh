#!/usr/bin/env bash
set -e
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"

DOCKER_IMAGE=zenoh-autoware
DOCKER_FILE=Dockerfile_autoware

if [ ! "$(docker images -q ${DOCKER_IMAGE})" ]; then
    echo "${DOCKER_IMAGE} does not exist. Creating..."
    docker build -f ${DOCKER_FILE} -t ${DOCKER_IMAGE} .
fi

rocker \
    --nvidia \
    --privileged \
    --x11 \
    --user \
    --volume "$(pwd):${HOME}/autoware_carla_launch" \
    -- \
    ${DOCKER_IMAGE}

