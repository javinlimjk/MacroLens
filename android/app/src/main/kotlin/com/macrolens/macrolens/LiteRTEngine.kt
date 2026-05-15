package com.macrolens.macrolens

import android.content.Context
import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import com.google.ai.edge.litertlm.Engine
import com.google.ai.edge.litertlm.EngineConfig
import com.google.ai.edge.litertlm.Conversation
import com.google.ai.edge.litertlm.Backend
import com.google.ai.edge.litertlm.Contents
import com.google.ai.edge.litertlm.Content
import android.graphics.BitmapFactory
import android.graphics.Bitmap

class LiteRTEngine(private val context: Context) {
    companion object {
        private const val TAG = "LiteRTEngine"
    }

    private var engine: Engine? = null

    @Throws(Exception::class)
    suspend fun initialize(modelPath: String) {
        withContext(Dispatchers.IO) {
            Log.i(TAG, "Initializing LiteRT-LM with model: $modelPath")

            try {
                val config = EngineConfig(
                    modelPath = modelPath,
                    backend = Backend.CPU()
                )
                val newEngine = Engine(config)
                newEngine.initialize()
                engine = newEngine
                Log.i(TAG, "Engine initialized successfully.")
            } catch (e: Exception) {
                Log.e(TAG, "Engine initialization failed", e)
                throw e
            }
        }
    }

    @Throws(Exception::class)
    suspend fun analyze(prompt: String, imageBytes: ByteArray?): String {
        return withContext(Dispatchers.IO) {
            val currentEngine = engine ?: throw IllegalStateException("Engine not initialized")
            
            // Create a conversation for the request
            val conversation = currentEngine.createConversation()

            try {
                Log.i(TAG, "Starting multimodal inference...")
                
                val contents = if (imageBytes != null && imageBytes.isNotEmpty()) {
                    Log.i(TAG, "Building multimodal contents...")
                    Contents.of(
                        Content.Text(prompt),
                        Content.ImageBytes(imageBytes)
                    )
                } else {
                    Contents.of(Content.Text(prompt))
                }

                val responseMessage = conversation.sendMessage(contents)
                val responseText = responseMessage.toString()

                Log.i(TAG, "Inference complete. Response length: ${responseText.length}")
                responseText
            } finally {
                conversation.close()
            }
        }
    }

    fun close() {
        engine?.close()
        engine = null
        Log.i(TAG, "Engine closed.")
    }
}
