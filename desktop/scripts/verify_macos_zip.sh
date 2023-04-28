#!/bin/bash -ex

# Global define
VERSION=${1}
EDITION=${2}

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CBL_LIB_DIR=$SCRIPT_DIR/../lib
BUILD_DIR=$SCRIPT_DIR/../build

rm -rf $CBL_LIB_DIR 2> /dev/null
mkdir -p $CBL_LIB_DIR
pushd $CBL_LIB_DIR

ZIP_FILENAME=couchbase-lite-c-${EDITION}-${VERSION}-macos.zip
curl -O https://packages.couchbase.com/releases/couchbase-lite-c/${VERSION}/${ZIP_FILENAME}
unzip ${ZIP_FILENAME}
rm ${ZIP_FILENAME}

popd
mkdir -p $BUILD_DIR
pushd $BUILD_DIR

cmake -DCMAKE_PREFIX_PATH=$CBL_LIB_DIR/libcblite-$VERSION -DCMAKE_BUILD_TYPE=Release ..
make

./verify