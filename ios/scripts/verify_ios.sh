#!/bin/bash -e

if [ "$#" -lt 2 ]; then
    echo "Usage: verify_ios.sh <version: 3.1.0> <edition: community, enterprise>" >&2
    exit 1
fi

VERSION=$1
EDITION=$2

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
WORKSPACE=$SCRIPT_DIR/..

pushd "$WORKSPACE" > /dev/null

pushd Frameworks > /dev/null
ZIP_FILENAME=couchbase-lite-c-${EDITION}-${VERSION}-ios.zip
curl -O https://packages.couchbase.com/releases/couchbase-lite-c/${VERSION}/${ZIP_FILENAME}
unzip ${ZIP_FILENAME}
rm ${ZIP_FILENAME}
popd > /dev/null

DEVICE=`xcrun xctrace list devices 2>&1 | grep -oE 'iPhone.*?[^\(]+' | head -1 | sed 's/Simulator//g' | awk '{$1=$1;print}'`
echo "Selected testing device : ${DEVICE}"
xcodebuild test -project CBLC-Verify.xcodeproj -scheme "CBLC-Verify" -destination "platform=iOS Simulator,name=${DEVICE}" 

popd > /dev/null
