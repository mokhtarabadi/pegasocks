#!/bin/bash

export ANDROID_USE_SHARED_LIBC=OFF
export WORKING_DIRECTORY=$(pwd)/android

. ./universal-android-toolchain/toolchain.sh "$@"

build_libevent "OFF" "ON"

cd $CURRENT_DIR/../
rm -rf build && mkdir build && cd build || exit

android_cmake_command \
  -DUSE_MBEDTLS=ON \
  -DUSE_STATIC=ON \
  -DLibevent2_ROOT=$SYSROOT/usr \
  ..

"$CMAKE/bin/cmake" --build . --config Release
"$CMAKE/bin/cmake" --build . --target install

# I know it's ugly, but works!
cd $CURRENT_DIR
cp -r $SYSROOT/usr/{include,lib} $OUTPUT_DIR/
