#!/bin/bash

export ANDROID_USE_SHARED_LIBC=OFF
export WORKING_DIRECTORY=$(pwd)/android

. ./universal-android-toolchain/toolchain.sh "$@"

#build_libevent "OFF" "ON"

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
PEGASOCKS_ANDROID_CPP_DIR="$HOME/Develop/Projects/pegasocks-android/app/src/main/cpp/prebuilt/"

if [ -d "$PEGASOCKS_ANDROID_CPP_DIR" ]; then
  mkdir -p "$PEGASOCKS_ANDROID_CPP_DIR/include/$ABI/event2"
  mkdir -p "$PEGASOCKS_ANDROID_CPP_DIR/lib/$ABI"

  rsync -av "$SYSROOT/usr/include/" "$PEGASOCKS_ANDROID_CPP_DIR/include"
  mv "$PEGASOCKS_ANDROID_CPP_DIR/include/event2/event-config.h" "$PEGASOCKS_ANDROID_CPP_DIR/include/$ABI/event2"

  LIBS=(
    "$SYSROOT/usr/lib/libpegas.a"
    "$SYSROOT/usr/lib/libevent"{,_mbedtls}.a
    "$SYSROOT/usr/lib/libmbed"*.a
  )

  cp -v "${LIBS[@]}" "$PEGASOCKS_ANDROID_CPP_DIR/lib/$ABI"
fi
