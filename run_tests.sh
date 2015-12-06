#!/usr/bin/env bash
export LIBCLANG_PATH=/Users/jon/DEV/LLVM/build-ninja/lib/libclang.dylib
export PYTHONPATH=/Users/jon/DEV/LLVM/src/tools/clang/bindings/python:$PYTHONPATH
export PYTHONPATH=$(pwd)/externals/clang_cpp_code_model:$PYTHONPATH

echo -n Cleaning output
rm -rf output || exit 1
mkdir output
echo " [OK]" 

HEADERS=Shape.h
for HEADER in input/*
  do echo -n Generating bindings for ${HEADER}
  ./build.sh ${HEADER} templates || exit 1
  echo " [OK]" 
done

echo Running tests
python -m unittest discover -v tests/ || exit 1

echo Running CPP tests
mkdir -p tests/build
pushd tests/build > /dev/null
cmake -DCMAKE_INSTALL_PREFIX:PATH=.. ../src/ 
make && make install 
popd > /dev/null
pushd tests/bin > /dev/null
for var in Test* ; do ./$var; done
popd > /dev/null

