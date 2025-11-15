# Native Module Build Guide

## Overview
This guide explains how to build the Android native inference module (`native_modules/android_inference`) on your local machine or in a proper Android development environment.

## Prerequisites

### System Requirements
- **macOS** (recommended for iOS/Android development)
- **Linux** (Ubuntu 20.04+)
- **Windows** (with WSL2 for development)

### Required Software
1. **Android NDK** (r26b or later recommended)
2. **Android SDK** (API 33+)
3. **CMake** (3.10 or later)
4. **Gradle** (7.0+)
5. **Java JDK** (11+)

## Installation Steps

### 1. Install Android Studio
Download from: https://developer.android.com/studio

Android Studio includes:
- Android SDK
- Build tools
- Gradle
- Android NDK (installable via SDK Manager)

### 2. Configure Android NDK
After installing Android Studio:

**via Android Studio GUI:**
- Open Settings/Preferences → Appearance & Behavior → System Settings → Android SDK
- Go to "SDK Tools" tab
- Check "NDK (Side by side)" and select version 26.1 (or later)
- Click "OK" to install

**via Command Line (after Android SDK is installed):**
```bash
# On macOS/Linux
sdkmanager "ndk;26.1.10909125"

# Set environment variables
export ANDROID_NDK_HOME="$ANDROID_HOME/ndk/26.1.10909125"
export PATH="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH"
# (on Linux, replace darwin-x86_64 with linux-x86_64)
```

### 3. Set Required Environment Variables
Add to your shell profile (~/.bashrc, ~/.zshrc, or ~/.bash_profile):

```bash
# Android SDK and NDK
export ANDROID_HOME="$HOME/Library/Android/sdk"  # macOS
# or
export ANDROID_HOME="$HOME/Android/Sdk"           # Linux
# or
export ANDROID_HOME="%LOCALAPPDATA%\Android\Sdk" # Windows/WSL

export ANDROID_NDK_HOME="$ANDROID_HOME/ndk/26.1.10909125"
export PATH="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH"
# (replace darwin-x86_64 with linux-x86_64 on Linux, or windows-x86_64 on Windows)
```

## Building the Native Module

### Option 1: Build via Gradle (Recommended)
From the Flutter app root (`app_flutter/`):

```bash
cd app_flutter

# Build the entire project (includes native modules)
./gradlew assembleDebug

# Or just build the native module
./gradlew native_modules:android_inference:assembleDebug
```

### Option 2: Build via CMake Directly
From the native module root:

```bash
cd native_modules/android_inference

# Configure for Android ARM64
cmake -B build \
  -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake \
  -DANDROID_ABI=arm64-v8a \
  -DANDROID_PLATFORM=android-33 \
  -DCMAKE_BUILD_TYPE=Release

# Build
cmake --build build --config Release
```

### Option 3: Build for Multiple ABIs
```bash
# For ARM64
cmake -B build-arm64 \
  -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake \
  -DANDROID_ABI=arm64-v8a \
  -DANDROID_PLATFORM=android-33

# For ARMv7
cmake -B build-arm32 \
  -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake \
  -DANDROID_ABI=armeabi-v7a \
  -DANDROID_PLATFORM=android-33

# For x86_64
cmake -B build-x86 \
  -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake \
  -DANDROID_ABI=x86_64 \
  -DANDROID_PLATFORM=android-33
```

## Building the Flutter App with Native Module

### Debug APK
```bash
cd app_flutter
flutter build apk --debug
```

### Release APK
```bash
cd app_flutter
flutter build apk --release
```

### For Specific ABI
```bash
flutter build apk --target-platform android-arm64
# or
flutter build apk --target-platform android-arm
```

## Troubleshooting

### Error: "NDK not found"
**Solution:** Verify `$ANDROID_NDK_HOME` is set correctly:
```bash
echo $ANDROID_NDK_HOME
ls $ANDROID_NDK_HOME/toolchains/llvm/prebuilt/
```

### Error: "clang: not found"
**Solution:** The NDK's clang may have missing dependencies. Install build essentials:
```bash
# macOS
xcode-select --install

# Ubuntu/Debian
sudo apt-get install build-essential

# Fedora/RHEL
sudo yum groupinstall "Development Tools"
```

### Error: "CMake version too old"
**Solution:** Upgrade CMake:
```bash
# macOS
brew install cmake

# Linux
sudo apt-get install cmake

# or download from https://cmake.org/download/
```

### Error: "Gradle wrapper not found"
**Solution:** Regenerate Flutter project:
```bash
cd app_flutter
flutter create --platforms=android .
```

## Testing the Build

After successful build, output files will be located at:

```
app_flutter/build/app/intermediates/cmake/debug/obj/
├── arm64-v8a/
│   └── libnative-lib.so
├── armeabi-v7a/
│   └── libnative-lib.so
└── x86_64/
    └── libnative-lib.so
```

Or in the APK at:
```
app.apk/lib/arm64-v8a/libnative-lib.so
```

## Additional Resources

- [Android NDK Documentation](https://developer.android.com/ndk)
- [CMake for Android](https://developer.android.com/ndk/guides/cmake)
- [Flutter Platform Channels](https://flutter.dev/docs/development/platform-integration/platform-channels)
- [JNI Documentation](https://docs.oracle.com/javase/8/docs/technotes/guides/jni/)

## Next Steps

1. Set up Android development environment on your local machine
2. Follow "Building the Native Module" section above
3. For Flutter integration, modify `app_flutter/android/app/build.gradle` to link the native library
4. Run `flutter run` or build APK as needed

---

**Note:** The native module is an Android library (`com.oedx.inference.InferenceBridge.kt`) that provides JNI bindings to the C++ inference code. Full compilation requires proper Android NDK setup as described above.
