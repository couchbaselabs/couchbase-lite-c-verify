#!/bin/bash -e

if [ "$#" -lt 2 ]; then
    echo "Usage: verify_ios.sh <version: 3.2.0> <build: 1> <edition: community, enterprise>" >&2
    exit 1
fi

VERSION=$1
BLD_NUM=$2
EDITION=$3

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_DIR=$SCRIPT_DIR/..

pushd "$PROJECT_DIR" > /dev/null

pushd Frameworks > /dev/null
if [ "$BLD_NUM" = "0" ]; then
    ZIP_FILENAME=couchbase-lite-c-${EDITION}-${VERSION}-ios.zip
    curl -O https://packages.couchbase.com/releases/couchbase-lite-c/${VERSION}/${ZIP_FILENAME}
else
    ZIP_FILENAME=couchbase-lite-c-${EDITION}-${VERSION}-${BLD_NUM}-ios.zip
    curl -O http://latestbuilds.service.couchbase.com/builds/latestbuilds/couchbase-lite-c/${VERSION}/${BLD_NUM}/${ZIP_FILENAME}
fi
unzip -o ${ZIP_FILENAME}
rm ${ZIP_FILENAME}
popd > /dev/null

# Select any available iPhone simulator by UDID. Selecting by name alone fails
# when that model does not exist in the newest installed runtime, which is the
# only runtime xcodebuild resolves a bare name against.
DEVICE=$(xcrun simctl list devices available iPhone | grep -m1 -oE 'iPhone[^(]*\([0-9A-F-]{36}\)')
DEVICE_UDID=$(echo "$DEVICE" | grep -oE '[0-9A-F-]{36}')
echo "Selected testing device : ${DEVICE}"
xcodebuild test -project CBLC-Verify.xcodeproj -scheme "CBLC-Verify" -destination "platform=iOS Simulator,id=${DEVICE_UDID}" 

popd > /dev/null
