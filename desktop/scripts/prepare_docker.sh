#!/bin/bash -e

if [ "$#" -lt 1 ]; then
    echo "Usage: prepare_docker.sh <arch: arm64, amd64, armhf>"
    exit 1
fi

if [ "$ARCH" = "armhf" ]; then
    dpkg --add-architecture armhf
    apt -yqq update
    DEBIAN_FRONTEND=noninteractive apt -yqq install wget cmake build-essential g++-arm-linux-gnueabihf 
else
    apt -yqq update
    DEBIAN_FRONTEND=noninteractive apt -yqq install wget cmake build-essential
fi
