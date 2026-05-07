import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/services.dart' show rootBundle;

/// Loads and caches the ordered label list from `assets/models/labels.json`.
///
/// Each index in the list corresponds to the TFLite output class at that
/// position. The strings are dish IDs that match keys in [NutritionRulesEngine].
class LabelRegistry {
  static const _assetPath = 'assets/models/labels.json';

  List<String>? _labels;

  /// Returns the number of classes known after loading.
  int get length => _labels?.length ?? 0;

  /// Returns the dish ID for [index], or 'unknown' if out of bounds.
  String labelAt(int index) {
    final labels = _labels;
    if (labels == null || index < 0 || index >= labels.length) return 'unknown';
    return labels[index];
  }

  /// Loads labels from the bundled asset. Safe to call multiple times —
  /// subsequent calls are no-ops if already loaded.
  Future<void> load() async {
    if (_labels != null) return;

    try {
      final raw = await rootBundle.loadString(_assetPath);
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        throw const FormatException('labels.json must be a JSON array.');
      }
      _labels = decoded.cast<String>();
      dev.log(
        '[LabelRegistry] Loaded ${_labels!.length} labels from $_assetPath.',
        name: 'GemmaEngine',
      );
    } catch (e) {
      throw Exception('Failed to load label registry: $e');
    }
  }

  void dispose() => _labels = null;
}
