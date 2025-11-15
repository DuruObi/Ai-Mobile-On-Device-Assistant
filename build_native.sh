#!/bin/bash

###############################################################################
# Native Module Build Script
#
# Builds the Android native inference module for multiple architectures.
# Usage: ./build_native.sh [arm64|arm32|x86|all]
###############################################################################

set -e

# Check if ANDROID_NDK_HOME is set
if [ -z "$ANDROID_NDK_HOME" ]; then
    echo "ERROR: ANDROID_NDK_HOME is not set"
    echo ""
    echo "Please set it and try again:"
    echo "  export ANDROID_NDK_HOME=/path/to/ndk"
    echo ""
    echo "Or run the setup script:"
    echo "  ./setup_android_env.sh"
    exit 1
fi

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MODULE_DIR="$SCRIPT_DIR/native_modules/android_inference"

# Build configuration
BUILD_TYPE="${BUILD_TYPE:-Release}"
ANDROID_PLATFORM="${ANDROID_PLATFORM:-android-33}"
BUILD_ALL="${1:-arm64}"

echo "======================================"
echo "Native Module Build"
echo "======================================"
echo "NDK Home: $ANDROID_NDK_HOME"
echo "Module: $MODULE_DIR"
echo "Build Type: $BUILD_TYPE"
echo "Android Platform: $ANDROID_PLATFORM"
echo "======================================"
echo ""

# Function to build for a specific ABI
build_for_abi() {
    local ABI=$1
    local BUILD_DIR="$MODULE_DIR/build-$ABI"
    
    echo "Building for $ABI..."
    
    cmake -B "$BUILD_DIR" \
        -S "$MODULE_DIR" \
        -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake" \
        -DANDROID_ABI="$ABI" \
        -DANDROID_PLATFORM="$ANDROID_PLATFORM" \
        -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
        -G "Unix Makefiles" \
        || { echo "✗ CMake configuration failed for $ABI"; return 1; }
    
    cmake --build "$BUILD_DIR" --config "$BUILD_TYPE" \
        || { echo "✗ Build failed for $ABI"; return 1; }
    
    echo "✓ $ABI build complete: $BUILD_DIR/libnative-lib.so"
    echo ""
}

# Determine which ABIs to build
case "$BUILD_ALL" in
    arm64)
        build_for_abi "arm64-v8a"
        ;;
    arm32)
        build_for_abi "armeabi-v7a"
        ;;
    x86)
        build_for_abi "x86_64"
        ;;
    all)
        build_for_abi "arm64-v8a"
        build_for_abi "armeabi-v7a"
        build_for_abi "x86_64"
        ;;
    *)
        echo "Usage: $0 [arm64|arm32|x86|all]"
        exit 1
        ;;
esac

echo "======================================"
echo "✓ Build Complete!"
echo "======================================"
echo ""
echo "Output files:"
find "$MODULE_DIR/build-"* -name "libnative-lib.so" -type f 2>/dev/null | while read f; do
    echo "  $f"
done
echo ""
