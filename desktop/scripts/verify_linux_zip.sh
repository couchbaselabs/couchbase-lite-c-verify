#!/bin/bash -e

if [ "$#" -lt 2 ]; then
    echo "Usage: verify_linux_zip.sh <version: 3.1.0> <edition: community, enterprise>" >&2
    exit 1
fi

VERSION=$1
EDITION=$2

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CBL_LIB_DIR=$SCRIPT_DIR/../lib
BUILD_DIR=$SCRIPT_DIR/../build

rm -rf $CBL_LIB_DIR 2> /dev/null
mkdir -p $CBL_LIB_DIR
pushd $CBL_LIB_DIR > /dev/null
ZIP_FILENAME=couchbase-lite-c-${EDITION}-${VERSION}-linux-x86_64.tar.gz
curl -O https://packages.couchbase.com/releases/couchbase-lite-c/${VERSION}/${ZIP_FILENAME}
tar xvf ${ZIP_FILENAME}
rm ${ZIP_FILENAME}
popd > /dev/null

mkdir -p $BUILD_DIR
pushd $BUILD_DIR > /dev/null
cmake -DCMAKE_PREFIX_PATH=$CBL_LIB_DIR/libcblite-$VERSION -DCMAKE_BUILD_TYPE=Release ..
make
./verify
popd > /dev/null
