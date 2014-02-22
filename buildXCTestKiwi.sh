#!/bin/sh
#  
#
#  Created by Karim and modified by Goffredo.
#

if [ -z "${1}" ]; then
	echo "Missing project root"
	exit 1
fi

if [ -z "${2}" ]; then
    echo "Missing xcodeproj"
    exit 2
fi

if [ -z "${3}" ]; then
    echo "Missing target name"
    exit 3
fi

rm -rf $SRCROOT/build
mkdir -p $SRCROOT/build

set -e

SRCROOT="${1}"
cd $SRCROOT

PROJECT="${2}"
TARGET="${3}"

ACTION="clean build"

LIB_FOLDER_NAME=$TARGET
LIB_FILE_NAME=lib"$TARGET"-XCTest.a
OUTPUT_LIB_FILE_NAME=lib$TARGET.a

SDK_VERSION=`xcodebuild -showsdks | grep iphoneos | sort | tail -n 1 | awk '{ print $2 }'`
DEVICE_VERSION=iphoneos$SDK_VERSION
SIMULATOR_VERSION=iphonesimulator$SDK_VERSION

xcodebuild -project $PROJECT -configuration Debug -target $TARGET-XCTest -sdk $DEVICE_VERSION $ACTION
xcodebuild -project $PROJECT -configuration Debug -target $TARGET-XCTest -sdk $SIMULATOR_VERSION $ACTION

LIB_DIR=$SRCROOT/build/$LIB_FOLDER_NAME
rm -rf "$LIB_DIR"
mkdir "$LIB_DIR"

DEBUG_DEVICE_BUILD_DIR=$SRCROOT/build/Debug-iphoneos
DEBUG_SIMULATOR_BUILD_DIR=$SRCROOT/build/Debug-iphonesimulator
OUTPUT_DIR=$SRCROOT/build/universal
OUTPUT_DIR_KIWI="$OUTPUT_DIR/Kiwi"
FRAMEWORK_KIWI="$SRCROOT/build/Kiwi.framework"

mkdir -p "$OUTPUT_DIR"

lipo -create -output "$OUTPUT_DIR/$OUTPUT_LIB_FILE_NAME" "$DEBUG_DEVICE_BUILD_DIR/$LIB_FILE_NAME" "$DEBUG_SIMULATOR_BUILD_DIR/$LIB_FILE_NAME"
cd "$DEBUG_FAT_DIR"

cd $SRCROOT


rm -rf "$SRCROOT/build/$TARGET.build"

# Headers
cp -r "$DEBUG_SIMULATOR_BUILD_DIR"/Kiwi-XCTest "$OUTPUT_DIR_KIWI"
cd "$SRCROOT/build"

# Create framework
mkdir -p Kiwi.framework && mkdir -p Kiwi.framework/Versions/A/Resources
cp universal/libKiwi.a Kiwi.framework/Versions/A/Kiwi
cp -r universal/Kiwi Kiwi.framework/Versions/A/Headers
ln -s A Kiwi.framework/Versions/Current
ln -s Versions/Current/Kiwi Kiwi.framework/Kiwi && ln -s Versions/Current/Headers Kiwi.framework/Headers && ln -s Versions/Current/Resources Kiwi.framework/Resources

echo
lipo -info "$OUTPUT_DIR/$OUTPUT_LIB_FILE_NAME"

rm -rf "$DEBUG_DEVICE_BUILD_DIR"
rm -rf "$DEBUG_SIMULATOR_BUILD_DIR"

rm -rf "$SRCROOT/UniversalXCTestKiwiFramework"
mkdir -p "$SRCROOT/UniversalXCTestKiwiFramework"

# Mv framework in the output folder and cleanup...
mv "$FRAMEWORK_KIWI" "$SRCROOT/UniversalXCTestKiwiFramework"/
rm -rf $SRCROOT/build

echo "\nDone\n"

