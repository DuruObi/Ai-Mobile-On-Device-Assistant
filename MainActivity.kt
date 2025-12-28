package com.example.ai_assistant

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "ai_inference"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "runModel") {
                    val prompt = call.argument<String>("prompt")!!
                    val response = runModelJNI(prompt)
                    result.success(response)
                } else {
                    result.notImplemented()
                }
            }
    }

    external fun runModelJNI(prompt: String): String

    companion object {
        init {
            System.loadLibrary("llamainference")
        }
    }
}
