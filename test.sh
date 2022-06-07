#!/bin/bash

source common.sh

# OMP is explicitly disabled when building both Ceres and OpenMVG,
# but just to be extra paranoid, also force one thread here:
export OMP_NUM_THREADS=1

$(find build/ -type f -executable | grep openMVG_test_sift)

echo -e "\\n\\nImage hashes & sizes:"
md5sum gaussian_octave_0_*.png && ls -all gaussian_octave_0_*.png  

