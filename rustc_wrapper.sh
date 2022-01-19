#!/bin/bash

set -e
REQUIRED_ENVS=("PROJECT_ROOT" "BUILD_ROOT" "PROJECT_SYMLINKS")
for var in "${REQUIRED_ENVS[@]}"; do
    [ -z "${!var}" ] && echo "Please set ${var}" && exit -1
done

# Tell rustc to remap absolute src paths to make enclaves' signature more reproducible
exec rustc "$@" --remap-path-prefix=${HOME}/.cargo=${PROJECT_SYMLINKS}/cargo_home --remap-path-prefix=${PROJECT_ROOT}=${PROJECT_SYMLINKS}/teaclave_src --remap-path-prefix=${BUILD_ROOT}=${PROJECT_SYMLINKS}/teaclave_build
