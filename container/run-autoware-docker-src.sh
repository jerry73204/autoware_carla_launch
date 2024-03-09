#!/usr/bin/env bash
set -e
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"

DOCKER_IMAGE=zenoh-autoware-src
DOCKER_FILE=Dockerfile_autoware_src
AUTOWARE_VERSION=2023.08

if [ ! "$(docker images -q ${DOCKER_IMAGE})" ]; then
    echo "${DOCKER_IMAGE} does not exist. Creating..."
    docker build -f ${DOCKER_FILE} -t ${DOCKER_IMAGE} .
fi

# Download Autoware source code
if [ ! -d autoware ]; then
    git clone https://github.com/autowarefoundation/autoware.git -b ${AUTOWARE_VERSION}
fi

rocker \
    --nvidia \
    --privileged \
    --x11 \
    --user \
    --volume "$(pwd):$HOME/autoware_carla_launch" \
    -- \
    ${DOCKER_IMAGE}

