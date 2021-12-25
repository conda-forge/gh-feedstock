#!/bin/bash

set -ex

export GOPATH=$SRC_DR
export PATH=${GOPATH}/bin:$PATH

if [[ $target_platform == "osx-arm64" ]]; then
    export GOARCH=arm64
fi

# Build
make bin/gh manpages

# Install
make install prefix=$PREFIX
