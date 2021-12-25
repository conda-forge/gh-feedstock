#!/bin/bash

set -ex

if [[ $target_platform == "osx-arm64" ]]; then
    # When cross-compiling, build gen-docs and manpages separately as
    # they need to be executed on the build platform.
    export GOARCH=amd64
    make manpages
    export GOARCH=arm64
else
    make manpages
fi

# Build bin/gh
make bin/gh

# Install manually, since `make install` will recreate the manpages
mkdir -p $PREFIX/bin
install -m755 bin/gh ${PREFIX}/bin
mkdir -p $PREFIX/share/man/man1
install -m644 ./share/man/man1/* $PREFIX/share/man/man1/
