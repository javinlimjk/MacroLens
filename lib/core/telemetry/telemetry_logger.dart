import 'package:flutter/foundation.dart';
import '../../features/meal_scan/domain/models.dart';

class TelemetryLogger {
  static final TelemetryLogger _instance = TelemetryLogger._internal();
  factory TelemetryLogger() => _instance;
  TelemetryLogger._internal();

  final List<Map<String, dynamic>> _logs = [];

  void logScan({
    required InferenceSource source,
    required double confidence,
    required int ttftMs,
    required int latencyMs,
    required String decisionPath,
    required bool isParserFallback,
    required bool isCategoryFallback,
    required String rawOutput,
    String? oldClassifierOutput,
  }) {
    final logEntry = {
      'timestamp': DateTime.now().toIso8601String(),
      'source': source.name,
      'confidence': confidence,
      'ttft_ms': ttftMs,
      'latency_ms': latencyMs,
      'decision_path': decisionPath,
      'is_parser_fallback': isParserFallback,
      'is_category_fallback': isCategoryFallback,
      'raw_output': rawOutput,
      if (oldClassifierOutput != null) 'old_classifier_output': oldClassifierOutput,
    };
    
    _logs.add(logEntry);
    
    if (kDebugMode) {
      print('=== [TELEMETRY LOG] ===');
      print('Source: ${source.name} | Confidence: $confidence | Latency: ${latencyMs}ms | TTFT: ${ttftMs}ms');
      print('Decision Path: $decisionPath | Category Fallback: $isCategoryFallback | Parser Fallback: $isParserFallback');
      print('Raw: $rawOutput');
      if (oldClassifierOutput != null) print('Old Classifier: $oldClassifierOutput');
      print('=======================');
    }
  }

  List<Map<String, dynamic>> get logs => List.unmodifiable(_logs);
  
  void clear() {
    _logs.clear();
  }
}
