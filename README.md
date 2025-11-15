# Ai Mobile On-Device Assistant

Privacy-first, low-latency AI assistant that runs fully on Arm-based mobile devices.

## Contents
- Flutter app (app_flutter/)
- Android native inference stubs (native_modules/android_inference/)
- Model download and conversion scripts (scripts/, server_tools/)
- Docs and roadmap

## Quick Start

### Prerequisites
- Flutter SDK 3.38+
- Android SDK / NDK (for native module builds)
- CMake 3.10+

### Flutter Setup
1. Clone:
   ```bash
   git clone https://github.com/DuruObi/ai-mobile-ondevice-assistant.git
   cd ai-mobile-ondevice-assistant
   ```

2. Install dependencies:
   ```bash
   cd app_flutter
   flutter pub get
   ```

### Native Module Build (Android)

**For Local Development (macOS/Linux):**
1. Install Android Studio and NDK
2. Run setup script:
   ```bash
   ./setup_android_env.sh
   ```
3. Build native module:
   ```bash
   ./build_native.sh all  # arm64, arm32, x86_64
   ```

See [NATIVE_BUILD_GUIDE.md](./NATIVE_BUILD_GUIDE.md) for detailed instructions.

## Quick demo (Android)
1. Clone:
   ```bash
   git clone https://github.com/DuruObi/ai-mobile-ondevice-assistant.git
   cd ai-mobile-ondevice-assistant
