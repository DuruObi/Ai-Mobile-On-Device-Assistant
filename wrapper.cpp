#include <jni.h>
#include <string>

extern "C" JNIEXPORT jstring JNICALL
Java_com_example_ai_1assistant_MainActivity_runModelJNI(
    JNIEnv* env,
    jobject /* this */,
    jstring prompt) {

    const char* c_prompt = env->GetStringUTFChars(prompt, nullptr);
    std::string result = "[AI Stub Response] " + std::string(c_prompt); // Replace with llama.cpp call
    env->ReleaseStringUTFChars(prompt, c_prompt);

    return env->NewStringUTF(result.c_str());
}
