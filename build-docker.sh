#!/bin/bash

source common.sh

sudo docker build . -t $DOCKER_IMAGE --platform linux/amd64
