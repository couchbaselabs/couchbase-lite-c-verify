## How to verify

### Jenkins

Currently there are 3 jobs that can be run by specifying Couchbase Lite version and build number for verifying as follows:

* [c-verify-linux](http://jenkins.mobiledev.couchbase.com/job/c-verify-linux) : Verify ARM64, AMD64, and ARMHF linux binaries
* [c-verify-windows](http://jenkins.mobiledev.couchbase.com/job/c-verify-wins) : Verify AMD64 Windows binaries
* [c-verify-apple](http://jenkins.mobiledev.couchbase.com/job/c-verify-apple) : Verify macOS and iOS binaries

### Local

#### Linux

1. cd desktop

2. Create .env file with the following environment variables

```
CBL_VERSION=<CBL Version such as 3.2.1>
CBL_BUILD=<Build Number>
CBL_EDITION=<enterprise, community>
CBL_ARCH=<arm64, amd64, armhf>
OS_NAME=<debian>
OS_VERSION=<11, 12>
```
3. Run docker compose up and check the result.

```
docker compose up --build
```

4. Clean up

```
docker compose down
```
#### Windows

1. cd desktop

2. Run `./scripts/verify_windows.sh <CBL Version: 3.2.1> <Build Number> <Edition: enterprise, community>`

#### macOS

1. cd desktop

2. Run `./scripts/verify_macos.sh <CBL Version: 3.2.1> <Build Number> <Edition: enterprise, community>`

#### iOS

1. cd ios

2. Run `./scripts/verify_ios.sh <CBL Version: 3.2.1> <Build Number> <Edition: enterprise, community>`
