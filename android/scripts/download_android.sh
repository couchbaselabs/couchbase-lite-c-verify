#!/bin/bash -e

if [ "$#" -lt 2 ]; then
    echo "Usage: download_android.sh <version: 3.1.0> <edition: community, enterprise>" >&2
    exit 1
fi

VERSION=$1
EDITION=$2

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
WORKSPACE=$SCRIPT_DIR/..

pushd "$WORKSPACE" > /dev/null

pushd app/libs > /dev/null
ZIP_FILENAME=couchbase-lite-c-${EDITION}-${VERSION}-android.zip
curl -O https://packages.couchbase.com/releases/couchbase-lite-c/${VERSION}/${ZIP_FILENAME}
unzip ${ZIP_FILENAME}
mv "libcblite-${VERSION}" "libcblite"
rm ${ZIP_FILENAME}
popd > /dev/null

popd > /dev/null
