#!/bin/bash

export ANDROID_USE_SHARED_LIBC=ON
. universal-android-toolchain/toolchain.sh "$@"

build_libevent "OFF" "ON"

rm -rf build && mkdir build && cd build || exit

android_cmake_command \
    -DUSE_MBEDTLS=ON \
    -DUSE_STATIC=ON \
    ..

"$CMAKE/bin/cmake" --build . --config Release

cp libpegasocks.so "$OUTPUT_DIR/"
