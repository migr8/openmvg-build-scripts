#!/bin/bash

source common.sh

cd $BUILD_DIR

if [[ ! -d "openMVG" ]]; then
    git clone https://github.com/openMVG/openMVG.git --depth 1 --branch v2.0
    cd openMVG
    
    # Don't know why the version file is included in compilation,
    # but it errors it as it's not a valid C/CPP syntax:
    git apply $SCRIPTS_DIR/patches/openmvg_clear_version_file.patch

    # When cross-compiling the script assumes wrong flags 
    # (correct for host, but not for target), resulting in clang seg-faulting:
    git apply $SCRIPTS_DIR/patches/openmvg_dont_optimize_for_architecture.patch

    # Explicitly use only bundled image libs:
    git apply $SCRIPTS_DIR/patches/openmvg_use_internal_img_libs.patch

    # Otherwise ARM build fails:
    git apply $SCRIPTS_DIR/patches/openmvg_dont_use_x86_header_file.patch
    git apply $SCRIPTS_DIR/patches/openmvg_dont_use_neon_optimisations.patch
    cd -
fi

cd openMVG
git submodule update -i

cmake -B build -S src $CMAKE_FLAGS \
      -DOpenMVG_BUILD_DOC=OFF \
      -DOpenMVG_BUILD_EXAMPLES=OFF \
      -DOpenMVG_BUILD_TESTS=ON \
      -DOpenMVG_BUILD_GUI_SOFTWARES=OFF \
      -DOpenMVG_USE_OPENMP=OFF

cmake --build build --config $BUILD_TYPE --target install -j $CPU_COUNT

# For some reason OpenMVG still builds some utilities:
rm $INSTALL_DIR/bin/openMVG_main_*

# OpenMVG exports absolute paths - breaks find_package when consuming:
# https://unix.stackexchange.com/questions/265267/bash-converting-path-names-for-sed-so-they-escape
ESCAPED_INSTALL_DIR=$(echo ${INSTALL_DIR//\//\\/})

sed -i $INSTALL_DIR/share/openMVG/cmake/OpenMVGTargets.cmake \
    -e "s/${ESCAPED_INSTALL_DIR}/\$\{_IMPORT_PREFIX\}/g"

