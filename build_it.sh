#!/bin/bash
set -x

TORCH_DIR="$(python -c 'import os;import torch;print(os.path.dirname(torch.__file__))')"
echo "TORCH_DIR=$TORCH_DIR"
TORCH_INCLUDE_DIR="$TORCH_DIR/include"
LIB_DIR="$TORCH_DIR/lib"

PY_INCLUDE_DIR="$(python -c 'import sysconfig;print(sysconfig.get_config_var("INCLUDEPY"))')"
LINK="$(python -c 'import sysconfig;print(sysconfig.get_config_var("LDCXXSHARED"))')"

clang++ -c -o module.o -I$TORCH_INCLUDE_DIR -I$PY_INCLUDE_DIR -fPIC module.cpp
$LINK -o ptbindrepro.so module.o
