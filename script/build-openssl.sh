#!/bin/bash
#
# build-openssl.sh
# Copyright © 2020 Dmitriy Borovikov. All rights reserved.
#

source "$ROOT_PATH/script/build-commons"

set -e

if [[ -f "$BUILT_PRODUCTS_DIR/lib/libssl.a" ]]; then
    echo "$PLATFORM libssl already build"
    exit 0
fi

CLANG=$(xcrun --find clang)
export CLANG
DEVELOPER=$(xcode-select --print-path)
export DEVELOPER
mkdir -p "$BUILT_PRODUCTS_DIR"

for ARCH in $ARCHS
do
    echo "Building $ARCH for $SDK_PLATFORM $EFFECTIVE_PLATFORM_NAME"
    if [[ "$SDK_PLATFORM" == "macosx" ]]; then
      CONF="no-shared"
    else
      CONF="no-asm no-hw no-shared no-async"
    fi
    
    if [[ "$EFFECTIVE_PLATFORM_NAME" == "-maccatalyst" ]]; then
      export CFLAGS="-target $ARCH-apple-ios13.1-macabi -Wno-overriding-t-option"
    fi

    OPENSSLDIR="$LIBSSLDIR/$PLATFORM$EFFECTIVE_PLATFORM_NAME-$ARCH"
    LOG="$BUILT_PRODUCTS_DIR/$PLATFORM$EFFECTIVE_PLATFORM_NAME-$ARCH-openssl-build.log"
    LIPO_LIBSSL="$LIPO_LIBSSL $OPENSSLDIR/libssl.a"
    LIPO_LIBCRYPTO="$LIPO_LIBCRYPTO $OPENSSLDIR/libcrypto.a"

    mkdir -p "$OPENSSLDIR"
    cp -R "$OPENSSL_SOURCE" "$OPENSSLDIR"
    cd "$OPENSSLDIR"

    touch "$LOG"
    echo "LOG: $LOG"

    if [[ "$SDK_PLATFORM" == "macosx" ]]; then
      if [[ "$ARCH" == "x86_64" ]]; then
        HOST="darwin64-x86_64-cc"
      elif [[ "$ARCH" == "arm64" ]]; then
        HOST="darwin64-arm64-cc"
        CONF="$CONF no-asm"
      else
        HOST="darwin-$ARCH-cc"
      fi
    else
      HOST="iphoneos-cross"
    fi

    if [[ "${ARCH}" == *64 ]] || [[ "${ARCH}" == arm64* ]]; then
      CONF="$CONF enable-ec_nistp_64_gcc_128"
    fi

    export CROSS_TOP="$DEVELOPER/Platforms/$PLATFORM.platform/Developer"
    export CROSS_SDK="$PLATFORM.sdk"
    export SDKROOT="$CROSS_TOP/SDKs/$CROSS_SDK"
    export CC="$CLANG -arch $ARCH"
    export BITCODE_GENERATION_MODE=bitcode
    export CFLAGS="$CFLAGS -fembed-bitcode"

    CONF="$CONF"

    # TODO: XROS MIN VERSION
    if [[ "$SDK_PLATFORM" != "xros" ]] || [[ "$SDK_PLATFORM" != "xros*" ]]; then
      CONF="$CONF -m$SDK_PLATFORM-version-min=$MIN_VERSION"
    fi

    {
      # split $CONF by space into parameter list
      ./Configure $HOST $CONF
    } >> "$LOG" 2>&1

    if [[ "$ARCH" == "x86_64" ]]; then
      sed -ie "s!^CFLAG=!CFLAG=-isysroot $SDKROOT !" "Makefile"
    fi

    make depend >> "$LOG" 2>&1
    make -j "$BUILD_THREADS" build_libs >> "$LOG" 2>&1

    echo "Openssl - $PLATFORM $ARCH done."
done

buildFatLibrary "$LIPO_LIBSSL" "$BUILT_PRODUCTS_DIR/lib/libssl.a"
buildFatLibrary "$LIPO_LIBCRYPTO" "$BUILT_PRODUCTS_DIR/lib/libcrypto.a"

copyHeaders "$OPENSSLDIR/include/" "$BUILT_PRODUCTS_DIR/include"

echo "Openssl - $PLATFORM done."
