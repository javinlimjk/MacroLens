import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../domain/interfaces.dart';
import '../domain/models.dart';
import 'llm_response_parser.dart';

import 'mediapipe_stub.dart';
// import 'package:mediapipe_genai/mediapipe_genai.dart'; // To be re-enabled when symbols are exported

class GemmaMultimodalEngine implements IMultimodalInferenceEngine {
  LlmInference? _engine;
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    if (Platform.isWindows) {
      // Gracefully no-op on Windows; provider will return MockLLMEngine
      return;
    }

    try {
      final appSupportDir = await getApplicationSupportDirectory();
      final modelPath = '${appSupportDir.path}/models/gemma_4_e2b.task';
      
      if (!await File(modelPath).exists()) {
        throw Exception(
          'Gemma 4 model not found at $modelPath.\n\n'
          'To run the app without the model file, please switch the InferenceRuntime to "mock" in providers.dart '
          'or ensure the .task file is downloaded to the application support directory.'
        );
      }

      final options = LlmInferenceOptions(
        modelPath: modelPath,
        maxNumImages: 1,
      );

      _engine = await LlmInference.create(options);
      

      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      rethrow;
    }
  }

  @override
  Future<LLMInferenceOutput> analyze(MultimodalScanInput input) async {
    if (Platform.isWindows) return LLMInferenceOutput.fallback;

    if (!_isInitialized || _engine == null) {
      throw StateError('GemmaMultimodalEngine not initialized.');
    }

    final stopwatch = Stopwatch()..start();

    try {
      final mpImage = _preprocessImage(input.imageBytes);

      const systemPrompt = '''
You are MacroLens AI, a JSON-only multimodal API for food identification.
Output ONLY valid JSON. No markdown backticks. No conversational filler.
Schema: { "dishId": "string", "displayName": "string", "cuisineType": "string", "portionMultiplier": number, "modifiers": ["string"], "estimatedKcal": number, "kcalHint": "string|null", "signalAgreement": boolean, "disagreementNote": "string|null", "uncertaintyNote": "string|null", "reasoning": "string", "category": "riceBase | noodleBase | snackSide | drink | unknown", "metadata": { "meatCount": number, "vegCount": number, "friedItemCount": number, "gravy": boolean } }
IMPORTANT: Identify the dish accurately based on visual and textual signals. Use your internal knowledge for all cuisines. Provide a specific dishId (snake_case) and a user-friendly displayName. If highly uncertain, provide a broad category and explain in uncertaintyNote.
''';

      final prompt = '$systemPrompt\nUser says: "${input.userText}"';

      final rawResponse = await _engine!.generateResponse(
        prompt,
        images: [mpImage],
      );

      stopwatch.stop();
      // Track TTFT, peak RAM, thermal stability (placeholders for now)
      print('--- Performance Gates ---');
      print('Total Scan Latency: \${stopwatch.elapsedMilliseconds} ms');
      print('Peak RAM: [Tracked natively via ML Kit]');
      print('Thermal State: [Normal]');

      return LLMResponseParser.parse(rawResponse);
    } catch (e) {
      stopwatch.stop();
      return LLMInferenceOutput.fallback;
    }
  }

  dynamic _preprocessImage(List<int> bytes) {
    final decoded = img.decodeImage(Uint8List.fromList(bytes));
    if (decoded == null) throw Exception('Failed to decode image.');

    final resized = img.copyResize(decoded, width: 512, height: 512);
    
    return MPImage.fromByteData(
      Uint8List.fromList(img.encodeJpg(resized)),
      width: 512,
      height: 512,
      format: MPImageFormat.rgba,
    );
  }

  @override
  Future<void> dispose() async {
    await _engine?.close();
    _engine = null;
    _isInitialized = false;
  }
}
