#!/bin/bash

set -ex

export GOPATH=$SRC_DR
export PATH=${GOPATH}/bin:$PATH
export GOARCH=$target_goarch

# Build
make bin/gh manpages

# Install
make install prefix=$PREFIX
