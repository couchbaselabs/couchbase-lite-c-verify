#!/bin/bash -e

if [ "$#" -lt 3 ]; then
    echo "Usage: verify_macos_zip.sh <version: 3.1.0> <build: 1> <edition: community, enterprise>" >&2
    exit 1
fi

VERSION=$1
BLD_NUM=$2
EDITION=$3

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CBL_LIB_DIR=$SCRIPT_DIR/../lib
BUILD_DIR=$SCRIPT_DIR/../build

rm -rf $CBL_LIB_DIR 2> /dev/null
mkdir -p $CBL_LIB_DIR
pushd $CBL_LIB_DIR > /dev/null

if [ "$BLD_NUM" = "0" ]; then
    ZIP_FILENAME=couchbase-lite-c-${EDITION}-${VERSION}-macos.zip
    curl -O https://packages.couchbase.com/releases/couchbase-lite-c/${VERSION}/${ZIP_FILENAME}
else
    ZIP_FILENAME=couchbase-lite-c-${EDITION}-${VERSION}-${BLD_NUM}-macos.zip
    curl -O http://latestbuilds.service.couchbase.com/builds/latestbuilds/couchbase-lite-c/${VERSION}/${BLD_NUM}/${ZIP_FILENAME}
fi

unzip ${ZIP_FILENAME}
rm ${ZIP_FILENAME}
popd > /dev/null

mkdir -p $BUILD_DIR
pushd $BUILD_DIR > /dev/null

cmake -DCMAKE_PREFIX_PATH=$CBL_LIB_DIR/libcblite-$VERSION -DCMAKE_BUILD_TYPE=Release ..
make
./verify

popd > /dev/null