#!/bin/bash

set -ex

export GOPATH=$SRC_DR
export PATH=${GOPATH}/bin:$PATH

if [[ $target_platform == "osx-arm64" ]]; then
    # build gen-docs manually as it needs to be run to create the man-pages
    (export GOARCH=amd64; cd cmd/gen-docs; go build -v -o gen-docs .)
    file ./cmd/gen-docs/gen-docs
    go run ./cmd/gen-docs --man-page --doc-path ./share/man/man1/
    export GOARCH=arm64
fi

# Build
make bin/gh manpages

# Install
make install prefix=$PREFIX
