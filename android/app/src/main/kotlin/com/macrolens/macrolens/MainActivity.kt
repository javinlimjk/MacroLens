package com.macrolens.macrolens

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.macrolens/litert_lm"
    private var engine: LiteRTEngine? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initialize" -> {
                    val modelPath = call.argument<String>("modelPath")
                    if (modelPath == null) {
                        result.error("INVALID_ARGUMENT", "modelPath is required", null)
                        return@setMethodCallHandler
                    }

                    if (engine == null) {
                        engine = LiteRTEngine(context)
                    }

                    CoroutineScope(Dispatchers.Main).launch {
                        try {
                            engine?.initialize(modelPath)
                            result.success(null)
                        } catch (e: Exception) {
                            result.error("INIT_FAILED", e.message, null)
                        }
                    }
                }
                "analyze" -> {
                    val prompt = call.argument<String>("prompt") ?: ""
                    val image = call.argument<ByteArray>("image")

                    CoroutineScope(Dispatchers.Main).launch {
                        try {
                            val response = engine?.analyze(prompt, image)
                            result.success(response)
                        } catch (e: Exception) {
                            result.error("INFERENCE_FAILED", e.message, null)
                        }
                    }
                }
                "close" -> {
                    engine?.close()
                    engine = null
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
