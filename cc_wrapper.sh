#!/bin/bash

set -e
REQUIRED_ENVS=("PROJECT_ROOT" "BUILD_ROOT" "PROJECT_SYMLINKS")
for var in "${REQUIRED_ENVS[@]}"; do
    [ -z "${!var}" ] && echo "Please set ${var}" && exit -1
done

# Tell gcc/clang to remap absolute src paths to make enclaves' signature more reproducible
exec "${CC}" "$@" -fdebug-prefix-map=${PROJECT_ROOT}=${PROJECT_SYMLINKS}/teaclave_src -fdebug-prefix-map=${BUILD_ROOT}=${PROJECT_SYMLINKS}/teaclave_build
