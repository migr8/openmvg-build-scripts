#!/bin/bash

source common.sh

./eigen.sh $@
./ceres.sh $@
./openmvg.sh $@

