#!/bin/bash

set -ex

export GOPATH=$SRC_DR
export PATH=${GOPATH}/bin:$PATH

# Build
make bin/gh manpages

# Install
make install prefix=$PREFIX
