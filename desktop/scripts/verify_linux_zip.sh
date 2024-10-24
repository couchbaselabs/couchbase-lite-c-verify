#!/bin/bash -e

if [ "$#" -lt 2 ]; then
    echo "Usage: verify_linux_zip.sh <arch:arm64,amd64,armhf> <version: 3.2.1> <build: 1> <edition: community, enterprise>" >&2
    exit 1
fi

ARCH=$1
VERSION=$2
BLD_NUM=$3
EDITION=$4

echo "PARAMS : $ARCH $VERSION $BLD_NUM $EDITION"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CBL_LIB_DIR=$SCRIPT_DIR/../lib
BUILD_DIR=$SCRIPT_DIR/../build

rm -rf $CBL_LIB_DIR 2> /dev/null
mkdir -p $CBL_LIB_DIR
pushd $CBL_LIB_DIR > /dev/null

if [ "$ARCH" = "amd64" ]; then
    ARCH="x86_64"
fi

if [ "$BLD_NUM" = "0" ]; then
    ZIP_FILENAME=couchbase-lite-c-${EDITION}-${VERSION}-linux-${ARCH}.tar.gz
    wget https://packages.couchbase.com/releases/couchbase-lite-c/${VERSION}/${ZIP_FILENAME}
else
    ZIP_FILENAME=couchbase-lite-c-${EDITION}-${VERSION}-${BLD_NUM}-linux-${ARCH}.tar.gz
    wget http://latestbuilds.service.couchbase.com/builds/latestbuilds/couchbase-lite-c/${VERSION}/${BLD_NUM}/${ZIP_FILENAME}
fi

tar xvf ${ZIP_FILENAME}
rm ${ZIP_FILENAME}
popd > /dev/null

mkdir -p $BUILD_DIR
pushd $BUILD_DIR > /dev/null
cmake -DCMAKE_PREFIX_PATH=$CBL_LIB_DIR/libcblite-$VERSION -DCMAKE_BUILD_TYPE=Release ..
make
./verify
popd > /dev/null
