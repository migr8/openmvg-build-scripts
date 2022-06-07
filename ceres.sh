#!/bin/bash

source common.sh

VERSION=1.13.0
cd $BUILD_DIR

download https://github.com/ceres-solver/ceres-solver/archive/refs/tags/$VERSION.tar.gz
tar -xf $VERSION.tar.gz

cd ceres-solver-$VERSION

cmake -B build -S . $CMAKE_FLAGS \
    -DBUILD_TESTING=OFF \
    -DLAPACK=OFF \
    -DGFLAGS=OFF \
    -DCXSPARSE=OFF \
    -DMINIGLOG=ON \
    -DOPENMP=OFF \
    -DBUILD_EXAMPLES=OFF

cmake --build build --config $BUILD_TYPE --target install -j $CPU_COUNT

