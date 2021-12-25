#!/bin/bash

set -ex

export GOPATH=$SRC_DR
export PATH=${GOPATH}/bin:$PATH

if [[ $target_platform == "osx-arm64" ]]; then
    # build gen-docs manually as it needs to be run to create the man-pages
    export GOARCH=amd64
    make manpages
    export GOARCH=arm64
else
    make manpages
fi

# Build
make bin/gh

# Install
mkdir -p $PREFIX/bin
install -m755 bin/gh ${PREFIX}/bin
mkdir -p $PREFIX/share/man/man1
install -m644 ./share/man/man1/* $PREFIX/share/man/man1/
