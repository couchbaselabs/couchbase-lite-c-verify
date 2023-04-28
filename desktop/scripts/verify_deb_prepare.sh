#!/bin/bash -e

if [ "$#" -lt 1 ]; then
    echo "Usage: verify_deb_prepare.sh <arch: arm64, amd64, armhf>"
    exit 1
fi

ARCH=$1

if [ $ARCH = "armhf" ]; then
    dpkg --add-architecture armhf
    apt -yqq update
    DEBIAN_FRONTEND=noninteractive apt -yqq install wget cmake build-essential g++-arm-linux-gnueabihf 
else
    apt -yqq update
    DEBIAN_FRONTEND=noninteractive apt -yqq install wget cmake build-essential
fi
