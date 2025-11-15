#!/bin/bash

###############################################################################
# Android Development Environment Setup Script
# 
# This script sets up the Android NDK and SDK for building the native module.
# Run this on macOS or Linux after installing Android Studio.
###############################################################################

set -e

echo "======================================"
echo "Android Development Environment Setup"
echo "======================================"

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    ARCH="darwin-x86_64"
    ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    ARCH="linux-x86_64"
    ANDROID_HOME="${ANDROID_HOME:-$HOME/Android/Sdk}"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    OS="windows"
    ARCH="windows-x86_64"
    ANDROID_HOME="${ANDROID_HOME:-%LOCALAPPDATA%\\Android\\Sdk}"
fi

echo "Detected OS: $OS"
echo "Android Home: $ANDROID_HOME"

# Check if Android SDK exists
if [ ! -d "$ANDROID_HOME" ]; then
    echo ""
    echo "ERROR: Android SDK not found at $ANDROID_HOME"
    echo ""
    echo "Please install Android Studio first:"
    echo "  https://developer.android.com/studio"
    echo ""
    echo "Then run this script again."
    exit 1
fi

echo "✓ Android SDK found"

# Check/install NDK
NDK_VERSION="26.1.10909125"
NDK_PATH="$ANDROID_HOME/ndk/$NDK_VERSION"

if [ -d "$NDK_PATH" ]; then
    echo "✓ Android NDK $NDK_VERSION already installed"
else
    echo ""
    echo "Installing Android NDK $NDK_VERSION..."
    echo "Please run this command in Android Studio or via command line:"
    echo ""
    echo "  sdkmanager \"ndk;$NDK_VERSION\""
    echo ""
    echo "Or open Android Studio and go to:"
    echo "  Settings → Appearance & Behavior → System Settings → Android SDK"
    echo "  → SDK Tools → NDK (Side by side) → Install version 26.1+"
    echo ""
    exit 1
fi

echo "✓ Android NDK $NDK_VERSION found at $NDK_PATH"

# Set environment variables
echo ""
echo "Setting environment variables..."

# Create or update shell profile
SHELL_RC=""
if [ -f ~/.zshrc ]; then
    SHELL_RC=~/.zshrc
elif [ -f ~/.bashrc ]; then
    SHELL_RC=~/.bashrc
elif [ -f ~/.bash_profile ]; then
    SHELL_RC=~/.bash_profile
fi

if [ -n "$SHELL_RC" ]; then
    echo ""
    echo "Add the following to your shell profile ($SHELL_RC):"
    echo ""
    echo "# Android SDK and NDK"
    echo "export ANDROID_HOME=\"$ANDROID_HOME\""
    echo "export ANDROID_NDK_HOME=\"$NDK_PATH\""
    echo "export PATH=\"\$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/$ARCH/bin:\$PATH\""
    echo ""
fi

# Export for current session
export ANDROID_HOME="$ANDROID_HOME"
export ANDROID_NDK_HOME="$NDK_PATH"
export PATH="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/$ARCH/bin:$PATH"

# Verify
echo ""
echo "Verifying setup..."

if command -v clang &> /dev/null; then
    CLANG_VERSION=$(clang --version | head -1)
    echo "✓ clang found: $CLANG_VERSION"
else
    echo "✗ clang not found in PATH"
    exit 1
fi

if command -v cmake &> /dev/null; then
    CMAKE_VERSION=$(cmake --version | head -1)
    echo "✓ cmake found: $CMAKE_VERSION"
else
    echo "⚠ cmake not found (required for native build)"
fi

if command -v gradle &> /dev/null; then
    GRADLE_VERSION=$(gradle --version 2>/dev/null | head -1 || echo "N/A")
    echo "✓ gradle found: $GRADLE_VERSION"
else
    echo "⚠ gradle not found (Flutter uses ./gradlew wrapper)"
fi

echo ""
echo "======================================"
echo "✓ Setup Complete!"
echo "======================================"
echo ""
echo "You can now build the native module:"
echo ""
echo "  cd native_modules/android_inference"
echo "  cmake -B build \\"
echo "    -DCMAKE_TOOLCHAIN_FILE=\$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake \\"
echo "    -DANDROID_ABI=arm64-v8a \\"
echo "    -DANDROID_PLATFORM=android-33"
echo "  cmake --build build"
echo ""
echo "Or build the entire Flutter app:"
echo ""
echo "  cd app_flutter"
echo "  flutter build apk --debug"
echo ""
