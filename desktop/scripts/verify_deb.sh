#!/bin/bash -e

if [ "$#" -lt 4 ]; then
    echo "Usage: verify_deb.sh <platform: debian9, debian10, debian11, ubuntu22.04, ubuntu20.04> <arch: arm64, amd64, armhf> <version: 3.1.0> <edition: community, enterprise>" >&2
    exit 1
fi

PLATFORM=$1
ARCH=$2
VERSION=$3
EDITION=$4

echo "Platform : ${PLATFORM}"
echo "Architecture : ${ARCH}"
echo "Version : ${VERSION}" 
echo "Edition : ${EDITION}"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
WORKSPACE=$SCRIPT_DIR/..

pushd "${WORKSPACE}" > /dev/null

# Step 1: Download the pair lib and dev deb file:
DEB_DIR="deb"
rm -rf ${DEB_DIR} && mkdir ${DEB_DIR}
pushd ${DEB_DIR} > /dev/null

DEB_FILE="libcblite-${EDITION}_${VERSION}-${PLATFORM}_${ARCH}.deb"
DEV_DEB_FILE="libcblite-dev-${EDITION}_${VERSION}-${PLATFORM}_${ARCH}.deb"

DEB_URL="https://packages.couchbase.com/releases/couchbase-lite-c/${VERSION}/${DEB_FILE}"
DEV_DEB_URL="https://packages.couchbase.com/releases/couchbase-lite-c/${VERSION}/${DEV_DEB_FILE}"

echo "Download : ${DEB_URL}"
wget "${DEB_URL}"
echo "Download : ${DEV_DEB_URL}"
wget "${DEV_DEB_URL}"

popd > /dev/null

# Step 2: Install the deb files
DEBIAN_FRONTEND=noninteractive apt install -yqq "./${DEB_DIR}/${DEB_FILE}"
DEBIAN_FRONTEND=noninteractive apt install -yqq "./${DEB_DIR}/${DEV_DEB_FILE}"

# Step 3: Build and Verify
rm -rf build && mkdir build
pushd build > /dev/null

if [ $ARCH != "armhf" ]
then
    cmake -DCMAKE_BUILD_TYPE=Release ..
    make
    ./verify
else
    arm-linux-gnueabihf-g++ ../src/main.cpp -lcblite -o verify
    ./verify
fi

popd > /dev/null

# Done

popd > /dev/null