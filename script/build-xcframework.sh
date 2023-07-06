#!/bin/zsh
#
# build_xctframework.sh
# Copyright © 2023 Dmitriy Borovikov. All rights reserved.
#

#Functions
fetchSource () {
  local url=$1
  local filename=$2
  local dstpath=$3
  local file=$BUILD/$filename

  mkdir -p "$dstpath"
  echo "Downloading $filename"
  curl -L -S -s "$url" --output "$file"
  local md5
  md5=$(md5 -q "$file")
  echo "MD5: $md5"

  tar -zxkf "$file" -C "$dstpath" --strip-components 1 2>&-
  rm -f "$file"
}

buildLibrary () {
  export BUILT_PRODUCTS_DIR=$1
  export SDK_PLATFORM=$2
  export PLATFORM=$3
  export EFFECTIVE_PLATFORM_NAME=$4
  export ARCHS=$5
  export MIN_VERSION=$6

  "$ROOT_PATH/script/build-openssl.sh"
  "$ROOT_PATH/script/build-libssh2.sh"

  rm -rf "$TEMPPATH"
}


#====================================================================#

set -e

#Config

BUILD_THREADS=$(sysctl hw.ncpu | awk '{print $2}')
export BUILD_THREADS
LIBSSH_TAG=$1
LIBSSL_TAG=$2
DATE=$3

autoload is-at-least
export XCODE_VER=$(xcodebuild -version 2>&1 | awk '/Xcode/{print $2}')

TAG=$LIBSSH_TAG+$LIBSSL_TAG
if is-at-least "15.0" "$XCODE_VER"; then
TAG+="+beta"
fi
ZIPNAME=CSSH-$TAG.xcframework.zip
GIT_REMOTE_URL_UNFINISHED=$(git config --get remote.origin.url|sed "s=^ssh://==; s=^https://==; s=:=/=; s/git@//; s/.git$//;")
DOWNLOAD_URL=https://$GIT_REMOTE_URL_UNFINISHED/releases/download/$TAG/$ZIPNAME

ROOT_PATH=$(cd "$(dirname "$0")/.."; pwd -P)
export ROOT_PATH
pushd "$ROOT_PATH" > /dev/null

export BUILD=$ROOT_PATH/build
export TEMPPATH=$ROOT_PATH/temp

export LIBSSLDIR="$TEMPPATH/openssl"
export LIBSSHDIR="$TEMPPATH/libssh2"
export OPENSSL_SOURCE="$BUILD/openssl/src/"
export LIBSSH_SOURCE="$BUILD/libssh2/src/"

#Download

if [[ -d "$OPENSSL_SOURCE" ]] && [[ -d "$LIBSSH_SOURCE" ]]; then
  echo "Sources already downloaded"
else
  fetchSource "https://github.com/libssh2/libssh2/releases/download/libssh2-$LIBSSH_TAG/libssh2-$LIBSSH_TAG.tar.gz" "libssh2.tar.gz" "$LIBSSH_SOURCE"
  fetchSource "https://github.com/openssl/openssl/archive/$LIBSSL_TAG.tar.gz" "openssl.tar.gz" "$OPENSSL_SOURCE"
fi

#Build

#buildLibrary () {
#export BUILT_PRODUCTS_DIR=$1
#export SDK_PLATFORM=$2
#export PLATFORM=$3
#export EFFECTIVE_PLATFORM_NAME=$4
#export ARCHS=$5
#export MIN_VERSION=$6

buildLibrary "$BUILD/iphoneos" "iphoneos" "iPhoneOS" "" "arm64" "9.0"
buildLibrary "$BUILD/iphonesimulator" "iphonesimulator" "iPhoneSimulator" "" "x86_64 arm64" "9.0"
buildLibrary "$BUILD/macosx" "macosx" "MacOSX" "" "x86_64 arm64" "10.10"
buildLibrary "$BUILD/maccatalyst" "macosx" "MacOSX" "-maccatalyst" "x86_64 arm64" "10.15"
buildLibrary "$BUILD/appletvsimulator" "appletvsimulator" "AppleTVSimulator" "" "x86_64 arm64" "9.0"
buildLibrary "$BUILD/appletvos" "appletvos" "AppleTVOS" "" "arm64" "9.0"

if is-at-least "15.0" "$XCODE_VER"; then
buildLibrary "$BUILD/xros" "xros" "XROS" "" "arm64" ""
buildLibrary "$BUILD/xrsimulator" "xrsimulator" "XRSimulator" "" "arm64" ""

xcodebuild -create-xcframework \
  -library "$BUILD/macosx/lib/libssh2.a" \
  -headers "$BUILD/macosx/include" \
  -library "$BUILD/iphoneos/lib/libssh2.a" \
  -headers "$BUILD/iphoneos/include" \
  -library "$BUILD/iphonesimulator/lib/libssh2.a" \
  -headers "$BUILD/iphonesimulator/include" \
  -library "$BUILD/maccatalyst/lib/libssh2.a" \
  -headers "$BUILD/maccatalyst/include" \
  -library "$BUILD/appletvsimulator/lib/libssh2.a" \
  -headers "$BUILD/appletvsimulator/include" \
  -library "$BUILD/appletvos/lib/libssh2.a" \
  -headers "$BUILD/appletvos/include" \
  -library "$BUILD/xros/lib/libssh2.a" \
  -headers "$BUILD/xros/include" \
  -library "$BUILD/xrsimulator/lib/libssh2.a" \
  -headers "$BUILD/xrsimulator/include" \
  -output CSSH.xcframework

else

xcodebuild -create-xcframework \
 -library "$BUILD/macosx/lib/libssh2.a" \
 -headers "$BUILD/macosx/include" \
 -library "$BUILD/iphoneos/lib/libssh2.a" \
 -headers "$BUILD/iphoneos/include" \
 -library "$BUILD/iphonesimulator/lib/libssh2.a" \
 -headers "$BUILD/iphonesimulator/include" \
 -library "$BUILD/maccatalyst/lib/libssh2.a" \
 -headers "$BUILD/maccatalyst/include" \
 -library "$BUILD/appletvsimulator/lib/libssh2.a" \
 -headers "$BUILD/appletvsimulator/include" \
 -library "$BUILD/appletvos/lib/libssh2.a" \
 -headers "$BUILD/appletvos/include" \
 -output CSSH.xcframework
 
fi

XCODE_STRING=$(xcodebuild -version 2>&1| tail -n 2)
XCODE_STRING=${XCODE_STRING//[$'\t\r\n']/ }
VERSION_STRING="Archive date:$DATE"
VERSION_STRING+=$'\n'
VERSION_STRING+="$XCODE_STRING"
echo $VERSION_STRING
xczip CSSH.xcframework --iso-date "$DATE" -o $ZIPNAME -c "$VERSION_STRING"
rm -rf CSSH.xcframework
CHECKSUM=$(shasum -a 256 -b $ZIPNAME | awk '{print $1}')

cat >Package.swift << EOL
// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CSSH",
    products: [
        .library(name: "CSSH", targets: ["CSSH"])
    ],
    targets: [
        .binaryTarget(name: "CSSH",
                      url: "$DOWNLOAD_URL",
                      checksum: "$CHECKSUM")
    ]
)
EOL

cat >build/release-note.md << EOL
Libssh2 $LIBSSH_TAG
$LIBSSL_TAG
$XCODE_STRING

### Supported platforms and architectures
| Platform          |  Architectures     |
|-------------------|--------------------|
| macOS             | x86_64 arm64       |
| iOS               | arm64              |
| iOS Simulator     | x86_64 arm64       |
| tvOS              | arm64              |
| tvOS Simulator    | x86_64 arm64       |
| Maccatalyst       | x86_64 arm64       |
EOL

if is-at-least "15.0" "$XCODE_VER"; then

cat >>build/release-note.md << EOL
| xrOS              | arm64              |
| xrOS Simulator    | arm64              |
EOL

fi

if [[ $4 == "commit" ]]; then

git add Package.swift
git commit -m "Build $TAG"
git tag $TAG
git push
git push --tags
gh release create "$TAG" $ZIPNAME --title "$TAG" --notes-file $ROOT_PATH/build/release-note.md

fi

popd > /dev/null
