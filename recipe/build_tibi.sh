#!/usr/bin/env bash

set -ex

CPPFLAGS="${CPPFLAGS} -D_NODEBUG -D_OMP -D_ELPA"
FFLAGS="${FFLAGS} -I${PREFIX}/include -I${PREFIX}/include/elpa_onenode_openmp/modules -fopenmp -funroll-loops"
LDFLAGS="${LDFLAGS} -lgomp -lxsmmf -lxsmm"
if [ -f "${PREFIX}/include/libxsmm.mod" ] && [ -f "${PREFIX}/lib/libxsmmext.so" ]; then
  echo "Building for LibXSMM < v2"
  LDFLAGS="${LDFLAGS} -lxsmmext"
else
  echo "Building for LibXSMM >= v2"
  FFLAGS="${FFLAGS} -I${PREFIX}/include/libxsmm"
fi
LDFLAGS="${LDFLAGS} -lelpa_onenode_openmp -lblas -llapack"

make clean
make -j${CPU_COUNT}
cp build/bin/* ${PREFIX}/bin/
