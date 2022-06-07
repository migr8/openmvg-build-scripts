#!/bin/bash

source common.sh

# Same directory structure because tests have paths to their assets
# hardcoded during CMake project generation:
sudo docker run \
    --rm \
    -v "$PWD":"$PWD" \
    -w $PWD $DOCKER_IMAGE \
    /bin/bash -c "./build-all.sh"

