#!/bin/bash

set -ex

export GOPATH=$SRC_DR
export PATH=${GOPATH}/bin:$PATH

if [[ $target_platform == "osx-arm64" ]]; then
    # build gen-docs manually as it needs to be run to create the man-pages
    echo XX$GOARCH
    export GOARCH=amd64
    go run ./cmd/gen-docs --man-page --doc-path ./share/man/man1/
    export GOARCH=arm64
fi

# Build
make bin/gh manpages

# Install
make install prefix=$PREFIX
