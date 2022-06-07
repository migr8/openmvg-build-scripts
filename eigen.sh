#!/bin/bash

source common.sh

VERSION=3.4.0
cd $BUILD_DIR
download https://gitlab.com/libeigen/eigen/-/archive/$VERSION/eigen-$VERSION.tar.gz
tar -xf eigen-$VERSION.tar.gz

cd eigen-$VERSION

cmake -B build -S . $CMAKE_FLAGS
cmake --build build --config $BUILD_TYPE --target install -j $CPU_COUNT

