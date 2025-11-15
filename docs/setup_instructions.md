# Setup Instructions (high-level)

## Android (dev machine)
1. Install Flutter SDK and Android SDK/NDK.
2. Ensure `flutter doctor` passes.
3. Build native inference libs:
   - Replace native stubs with real `llama.cpp` or ONNX mobile build.
   - Build for `arm64-v8a`.
4. Place model in `models/model.gguf` (run scripts/download_small_model.sh).
5. Run Flutter app.

## iOS
- Requires Xcode; compile native inference lib for iOS targets.
- Use CoreML if convenient; convert model accordingly.

Detailed steps and flags will be added as we finalize the runtime and model.
