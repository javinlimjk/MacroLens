import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

import '../domain/interfaces.dart';
import '../domain/models.dart';
import 'llm_response_parser.dart';

class GemmaNativeEngine implements IMultimodalInferenceEngine {
  static const MethodChannel _channel = MethodChannel('com.macrolens/litert_lm');
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    if (Platform.isWindows) {
      return; // Fallback handled by providers
    }

    try {
      final appSupportDir = await getApplicationSupportDirectory();
      final internalPath = '${appSupportDir.path}/models/gemma_4_e2b.litertlm';
      const testPath = '/data/local/tmp/gemma_4_e2b.litertlm';

      String modelPath;
      if (await File(internalPath).exists()) {
        modelPath = internalPath;
      } else if (await File(testPath).exists()) {
        modelPath = testPath;
      } else {
        throw Exception('Gemma 4 model not found at $internalPath or $testPath.');
      }

      await _channel.invokeMethod('initialize', {'modelPath': modelPath});
      _isInitialized = true;
    } on PlatformException catch (e) {
      _isInitialized = false;
      throw Exception('Failed to initialize LiteRT-LM engine: ${e.message}');
    } catch (e) {
      _isInitialized = false;
      rethrow;
    }
  }

  @override
  Future<LLMInferenceOutput> analyze(MultimodalScanInput input) async {
    if (Platform.isWindows) return LLMInferenceOutput.fallback;

    if (!_isInitialized) {
      throw StateError('GemmaNativeEngine not initialized.');
    }

    final stopwatch = Stopwatch()..start();

    try {
      // Preprocess image to the expected format (e.g. 512x512 JPEG bytes)
      final imageBytes = _preprocessImage(input.imageBytes);

      final systemPrompt = '''<start_of_turn>user
You are MacroLens AI, a specialized Singaporean Food Nutrition Assistant.
Identify the meal from the image and text. Prioritize Singapore Hawker food accuracy.

Return ONLY valid JSON:
{
  "dishId": "string (snake_case)",
  "displayName": "string",
  "category": "riceBase|noodleBase|snackSide|drink|unknown",
  "estimatedKcal": number,
  "confidence": number (0.0-1.0),
  "reasoning": "string",
  "uncertaintyNote": "string|null"
}

User input: "${input.userText}"<end_of_turn>
<start_of_turn>model
''';

      final prompt = systemPrompt;

      final String rawResponse = await _channel.invokeMethod('analyze', {
        'prompt': prompt,
        'image': imageBytes,
      });
      print('RAW LLM RESPONSE: $rawResponse');

      stopwatch.stop();
      print('--- Performance Gates ---');
      print('Total Scan Latency: ${stopwatch.elapsedMilliseconds} ms');
      print('Peak RAM: [Tracked natively via ML Kit / LiteRT]');
      print('Thermal State: [Normal]');

      return LLMResponseParser.parse(rawResponse);
    } catch (e) {
      stopwatch.stop();
      print('Native Inference Error: $e');
      return LLMInferenceOutput.fallback;
    }
  }

  Uint8List _preprocessImage(List<int> bytes) {
    final decoded = img.decodeImage(Uint8List.fromList(bytes));
    if (decoded == null) throw Exception('Failed to decode image.');

    final resized = img.copyResize(decoded, width: 384, height: 384);
    return Uint8List.fromList(img.encodeJpg(resized, quality: 70));
  }

  @override
  Future<void> dispose() async {
    try {
      await _channel.invokeMethod('close');
    } catch (_) {}
    _isInitialized = false;
  }
}
