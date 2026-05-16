import '../domain/interfaces.dart';
import '../domain/models.dart';

class GemmaOnDeviceLLMEngine implements ILLMEngine {
  @override
  Future<void> initialize() async {
    // No-op on unsupported platforms
  }

  @override
  Future<LLMInferenceOutput> reconcile(MultimodalScanInput input) async {
    return LLMInferenceOutput.fallback;
  }

  @override
  Future<void> dispose() async {
    // No-op
  }
}
