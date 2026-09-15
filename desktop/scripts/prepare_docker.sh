#!/bin/bash -e

if [ "$#" -lt 1 ]; then
    echo "Usage: prepare_docker.sh <arch: arm64, amd64, armhf>"
    exit 1
fi

# Debian 11 (bullseye) LTS ended 2026-08-31. Its security pool was removed from
# deb.debian.org (404) and is not on archive.debian.org yet, while the base image
# already ships security-patched libc6/perl, so the main pool alone cannot satisfy
# build-essential. Serve bullseye-security from snapshot.debian.org instead, using
# the snapshot date the debian:11 image records in its own sources.list so the
# security packages match the preinstalled ones.
# snapshot.debian.org drops connections under load, so retry and download serially.
if [ -f /etc/os-release ] && grep -q '^VERSION_CODENAME=bullseye' /etc/os-release; then
    SNAPSHOT=$(grep -o 'snapshot.debian.org/archive/debian/[0-9TZ]*' /etc/apt/sources.list | head -1 | sed 's|.*/||')
    SNAPSHOT=${SNAPSHOT:-20260824T000000Z}
    sed -i "s|http://deb.debian.org/debian-security|http://snapshot.debian.org/archive/debian-security/$SNAPSHOT|" /etc/apt/sources.list
    cat > /etc/apt/apt.conf.d/99snapshot <<'APTCONF'
Acquire::Check-Valid-Until "false";
Acquire::Retries "10";
Acquire::Queue-Mode "access";
APTCONF
fi

if [ "$ARCH" = "armhf" ]; then
    dpkg --add-architecture armhf
    apt -yqq update
    DEBIAN_FRONTEND=noninteractive apt -yqq install wget cmake build-essential g++-arm-linux-gnueabihf 
else
    apt -yqq update
    DEBIAN_FRONTEND=noninteractive apt -yqq install wget cmake build-essential
fi
