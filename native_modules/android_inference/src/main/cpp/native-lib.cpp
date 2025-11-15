#include <jni.h>
#include <string>
#include <android/log.h>

#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, "native-lib", __VA_ARGS__)

// Minimal native function placeholder
extern "C" JNIEXPORT jstring JNICALL
Java_com_oedx_inference_InferenceNative_helloFromNative(JNIEnv* env, jobject /* this */) {
    std::string hello = "Hello from native inference stub";
    LOGI("%s", hello.c_str());
    return env->NewStringUTF(hello.c_str());
}
