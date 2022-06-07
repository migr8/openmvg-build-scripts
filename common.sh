#!/bin/bash

# Exit on error:
set -e
# Error on referencing unset variable:
set -u

# Have GNU coreutils in path:
export PATH=\
/usr/local/opt/coreutils/libexec/gnubin:\
/usr/local/opt/gnu-sed/libexec/gnubin:\
$PATH

function detect_cpu_count
{
    for test_command in "sysctl -n hw.logicalcpu" "nproc"
    do
        if CPU_COUNT=$($test_command 2>/dev/null); then
            return
        fi
    done

    # Fallback value:
    CPU_COUNT=8
}

detect_cpu_count

SCRIPTS_DIR=$PWD
INSTALL_DIR=$SCRIPTS_DIR/install
BUILD_DIR=$SCRIPTS_DIR/build
BUILD_TYPE=Release
DOCKER_IMAGE=openmvg-ubuntu:latest
CMAKE_FLAGS="-DCMAKE_BUILD_TYPE=$BUILD_TYPE"
CMAKE_FLAGS="$CMAKE_FLAGS -DCMAKE_PREFIX_PATH=$INSTALL_DIR"
CMAKE_FLAGS="$CMAKE_FLAGS -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR"
CMAKE_FLAGS="$CMAKE_FLAGS -DCMAKE_FIND_ROOT_PATH=$INSTALL_DIR"
CMAKE_FLAGS="$CMAKE_FLAGS -DCMAKE_POSITION_INDEPENDENT_CODE=ON"

mkdir -p $INSTALL_DIR $BUILD_DIR

download ()
{
    ADDR=$1
    OUT=$(echo $ADDR | rev | cut -d / -f 1 | rev)
    if ! [ -f "$OUT" ]; then
        wget -q $ADDR
    else
        echo "$OUT already downloaded"
    fi
}

clone ()
{
    ADDR=$1
    OUT=$(echo $ADDR | rev | cut -d / -f 1 | rev)
    if ! [ -d "$OUT" ]; then
        git clone $ADDR --recursive
    else
        echo "$OUT already cloned"
    fi
}

