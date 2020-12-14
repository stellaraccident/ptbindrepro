#!/bin/bash
set -x

TORCH_DIR="$(python -c 'import os;import torch;print(os.path.dirname(torch.__file__))')"
echo "TORCH_DIR=$TORCH_DIR"
TORCH_INCLUDE_DIR="$TORCH_DIR/include"
TORCH_LIB_DIR="$TORCH_DIR/lib"

PY_INCLUDE_DIR="$(python -c 'import sysconfig;print(sysconfig.get_config_var("INCLUDEPY"))')"
LINK="$(python -c 'import sysconfig;print(sysconfig.get_config_var("LDCXXSHARED"))')"

# Use -H to print include paths and make sure that using pybind from torch.
# If those mismatch and it crosses a PYBIND11_INTERNALS_VERSION version bump,
# modules won't be able to share types.

GCC_CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0 -fabi-version=11"
CLANG_CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0 -U__GXX_ABI_VERSION -D__GXX_ABI_VERSION=1011 -DPYBIND11_COMPILER_TYPE=\"_gcc\""

# Pybind forks its world based on what it computes for its PYBIND11_INTERNALS_ID.
# Components of this that are likely to change on a Linux system are
# PYBIND11_COMPILER_TYPE (_clang vs _gcc), PYBIND11_STDLIB (_libcpp vs _libstdcpp)
# and PYBIND11_BUILD_ABI (_cxxabi1011 vs _cxxabi1013).
clang++ -c -o module.o -I$TORCH_INCLUDE_DIR -I$PY_INCLUDE_DIR \
  -fPIC -fvisibility=hidden -frtti -fexceptions $CLANG_CXXFLAGS module.cpp
# g++ -c -o module.o -I$TORCH_INCLUDE_DIR -I$PY_INCLUDE_DIR \
#   -fPIC -fvisibility=hidden -frtti -fexceptions $GCC_CXXFLAGS module.cpp

$LINK -o ptbindrepro.so -Wl,-rpath,$TORCH_LIB_DIR -L$TORCH_LIB_DIR -ltorch_python module.o \
  -ltorch_python -ltorch_cpu
