#!/bin/bash

. universal-android-toolchain/toolchain.sh "$@"

build_libevent "OFF" "ON"

rm -rf build && mkdir build && cd build || exit

android_cmake_command \
    -DUSE_MBEDTLS=ON \
    -DUSE_STATIC=ON \
    ..

"$CMAKE/bin/cmake" --build . --config Release

$STRIP -s pegas -o "$OUTPUT_DIR/libpegas.so"