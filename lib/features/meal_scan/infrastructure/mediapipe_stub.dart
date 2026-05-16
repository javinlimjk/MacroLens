// Stub classes to allow compilation on unsupported platforms (like Windows)
// These will be overridden by the real mediapipe_genai package on Android/iOS.

class LlmInference {
  static Future<LlmInference> create(dynamic options) async => throw UnimplementedError();
  Future<String> generateResponse(String prompt, {List<dynamic>? images}) async => throw UnimplementedError();
  Future<void> close() async {}
}

class LlmInferenceOptions {
  final String modelPath;
  final int maxNumImages;
  LlmInferenceOptions({required this.modelPath, required this.maxNumImages});
}

class MPImage {
  static MPImage fromByteData(dynamic data, {int? width, int? height, dynamic format}) => throw UnimplementedError();
}

enum MPImageFormat { rgba }
