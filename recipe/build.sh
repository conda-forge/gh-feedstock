#!/bin/bash

set -ex

export GOPATH=$SRC_DR
export PATH=${GOPATH}/bin:$PATH

# Build
if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
    make bin/gh manpages
    make test
else
    make bin/gh
fi

# Install
make install prefix=$PREFIX
