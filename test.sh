#!/bin/bash

$(find build/ -type f -executable | grep openMVG_test_sift)
echo -e "\\n\\nImage hashes & sizes:"
md5sum gaussian_octave_0_*.png && ls -all gaussian_octave_0_*.png  

