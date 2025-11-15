package com.oedx.inference

import android.content.Context
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

// NOTE: This is a minimal Flutter plugin style bridge. Integrate into plugin/project as needed.
class InferenceBridge: FlutterPlugin, ActivityAware {
    private lateinit var context: Context
    private var eventSink: EventChannel.EventSink? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        val methodChannel = MethodChannel(binding.binaryMessenger, "oedx.ai/inference")
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startInference" -> {
                    val prompt = call.argument<String>("prompt") ?: ""
                    // TODO: kickoff native inference on background thread, stream tokens via eventSink
                    result.success("started")
                }
                else -> result.notImplemented()
            }
        }

        val eventChannel = EventChannel(binding.binaryMessenger, "oedx.ai/stream")
        eventChannel.setStreamHandler(object: EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
                eventSink = sink
                // Example: push a welcome token
                sink?.success("...ready")
            }
            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // cleanup
    }

    // ActivityAware methods not implemented in this stub
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {}
    override fun onDetachedFromActivityForConfigChanges() {}
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}
    override fun onDetachedFromActivity() {}
}
