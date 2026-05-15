import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/meal_scan_notifier.dart';
import '../domain/models.dart';
import '../../../core/di/providers.dart';

class MealScanConfirmingSheet extends ConsumerWidget {
  final MealScanConfirming state;

  const MealScanConfirmingSheet({super.key, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final llmOutput = state.llmOutput;
    final isDisagreement = !llmOutput.signalAgreement;
    final resolution = state.resolution;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _Header(isDisagreement: isDisagreement),
            const SizedBox(height: 24),
            
            if (isDisagreement) ...[
              _DisagreementPanel(
                note: llmOutput.disagreementNote ?? 'I detected a mismatch between the photo and your description.',
                resolution: resolution,
                onResolve: (r) => ref.read(mealScanProvider.notifier).resolveDisagreement(r),
              ),
              const SizedBox(height: 24),
            ],

            if (state.thermalHint != null) ...[
              _ThermalHint(hint: state.thermalHint!),
              const SizedBox(height: 24),
            ],

            if (llmOutput.confidence < 0.40 || 
                llmOutput.source == InferenceSource.parserFallback ||
                llmOutput.source == InferenceSource.categoryFallback ||
                llmOutput.dishId == 'unknown' || 
                llmOutput.category == MealCategory.unknown) ...[
              _ManualHint(text: 'We aren\'t completely sure about this dish. The calories shown are a rough estimate. Please confirm or edit if this looks wrong.'),
              const SizedBox(height: 24),
            ],

            _RuntimeIndicator(runtime: ref.watch(appConfigProvider).selectedRuntime),
            const SizedBox(height: 16),

            _NutritionSummary(
              output: llmOutput,
              calories: state.resolvedNutrition.calories,
            ),
            const SizedBox(height: 16),
            
            _DiagnosticButton(state: state),
            const SizedBox(height: 32),

            _ActionButtons(
              canSave: state.canSave,
              isDisagreement: isDisagreement,
              onAccept: () => ref.read(mealScanProvider.notifier).saveConfirmedMeal(),
              onOverride: () {
                Navigator.of(context).pushNamed('/manual-override');
              },
              onCancel: () => ref.read(mealScanProvider.notifier).reset(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool isDisagreement;
  const _Header({required this.isDisagreement});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isDisagreement ? Icons.warning_amber_rounded : Icons.check_circle_outline,
          color: isDisagreement ? Colors.orange : Colors.teal,
          size: 28,
        ),
        const SizedBox(width: 12),
        Text(
          isDisagreement ? 'Review Required' : 'Ready to Log',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _DisagreementPanel extends StatelessWidget {
  final String note;
  final DisagreementResolution? resolution;
  final ValueChanged<DisagreementResolution> onResolve;

  const _DisagreementPanel({
    required this.note,
    required this.resolution,
    required this.onResolve,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note,
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          const Text('Which one is correct?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _ResolutionOption(
            label: 'Use AI Suggestion',
            isSelected: resolution == DisagreementResolution.useAISuggestion,
            onTap: () => onResolve(DisagreementResolution.useAISuggestion),
          ),
          _ResolutionOption(
            label: 'Use My Description',
            isSelected: resolution == DisagreementResolution.useMyDescription,
            onTap: () => onResolve(DisagreementResolution.useMyDescription),
          ),
        ],
      ),
    );
  }
}

class _ResolutionOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ResolutionOption({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: isSelected ? Colors.orange : Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? Colors.orange.withValues(alpha: 0.1) : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 20,
                color: isSelected ? Colors.orange : Colors.grey,
              ),
              const SizedBox(width: 12),
              Text(label, style: TextStyle(color: isSelected ? Colors.orange.shade900 : Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NutritionSummary extends StatelessWidget {
  final LLMInferenceOutput output;
  final int calories;

  const _NutritionSummary({required this.output, required this.calories});

  @override
  Widget build(BuildContext context) {
    final isLowConfidence = output.confidence < 0.40 ||
        output.source == InferenceSource.parserFallback ||
        output.source == InferenceSource.categoryFallback ||
        output.isDishUnknown;
    
    String displayName = output.safeDisplayName;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLowConfidence)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(
                'UNSURE • BEST GUESS',
                style: TextStyle(
                  color: Colors.amber.shade800,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          Text(
            displayName,
            style: TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold,
              color: isLowConfidence ? Colors.black87 : Colors.black,
            ),
          ),
          if (output.modifiers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                output.modifiers.join(', ').replaceAll('_', ' '),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
              ),
            ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 6.0),
                child: Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
              ),
              const SizedBox(width: 8),
              Text(
                '$calories',
                style: const TextStyle(
                  fontSize: 40, 
                  fontWeight: FontWeight.w800, 
                  color: Colors.orange,
                  height: 1.0,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 6.0, left: 4.0),
                child: Text(
                  'kcal',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getSourceLabel(output.source),
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  String _getSourceLabel(InferenceSource source) {
    switch (source) {
      case InferenceSource.recognition: return 'AI Recognition';
      case InferenceSource.disagreement: return 'Refined Prediction';
      case InferenceSource.parserFallback: return 'System Fallback';
      case InferenceSource.categoryFallback: return 'Category Analysis';
    }
  }
}

class _ActionButtons extends StatelessWidget {
  final bool canSave;
  final bool isDisagreement;
  final VoidCallback onAccept;
  final VoidCallback onOverride;
  final VoidCallback onCancel;

  const _ActionButtons({
    required this.canSave,
    required this.isDisagreement,
    required this.onAccept,
    required this.onOverride,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: canSave ? onAccept : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
          ),
          child: const Text('Log Meal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: onOverride,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text('Manual Override', style: TextStyle(color: Colors.teal, fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

class _ThermalHint extends StatelessWidget {
  final String hint;
  const _ThermalHint({required this.hint});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.thermostat, color: Colors.amber, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            hint,
            style: const TextStyle(fontSize: 12, color: Colors.amber, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class _ManualHint extends StatelessWidget {
  final String text;
  const _ManualHint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
class _RuntimeIndicator extends StatelessWidget {
  final InferenceRuntime runtime;
  const _RuntimeIndicator({required this.runtime});

  @override
  Widget build(BuildContext context) {
    final isGemma = runtime == InferenceRuntime.gemma;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isGemma ? Colors.purple.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isGemma ? Colors.purple.shade200 : Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isGemma ? Icons.auto_awesome : Icons.bug_report_outlined,
              size: 14,
              color: isGemma ? Colors.purple : Colors.grey.shade700,
            ),
            const SizedBox(width: 6),
            Text(
              isGemma ? 'GEMMA 4' : 'MOCK RUNTIME',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isGemma ? Colors.purple : Colors.grey.shade700,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiagnosticButton extends StatelessWidget {
  final MealScanConfirming state;
  const _DiagnosticButton({required this.state});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => _DiagnosticsSheet(state: state),
        );
      },
      icon: const Icon(Icons.analytics_outlined, size: 16),
      label: const Text('View Diagnostics', style: TextStyle(fontSize: 13)),
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey.shade600,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _DiagnosticsSheet extends StatelessWidget {
  final MealScanConfirming state;
  const _DiagnosticsSheet({required this.state});

  @override
  Widget build(BuildContext context) {
    final llm = state.llmOutput;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Runtime Diagnostics',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white54),
              ),
            ],
          ),
          const Divider(color: Colors.white12),
          const SizedBox(height: 16),
          _DiagnosticRow(label: 'Active Runtime', value: llm.ttftMs > 0 || Platform.isAndroid ? 'Gemma 4' : 'Mock'),
          _DiagnosticRow(label: 'Inference Source', value: llm.source.name),
          _DiagnosticRow(label: 'Confidence Score', value: (llm.confidence * 100).toStringAsFixed(1) + '%'),
          _DiagnosticRow(label: 'Dish ID', value: llm.dishId),
          _DiagnosticRow(label: 'Category', value: llm.category.name),
          _DiagnosticRow(label: 'Total Latency', value: 'N/A'), // Calculated in notifier
          _DiagnosticRow(label: 'TTFT', value: '${llm.ttftMs}ms'),
          _DiagnosticRow(label: 'Signal Agreement', value: llm.signalAgreement.toString()),
          const SizedBox(height: 16),
          const Text(
            'RAW LLM OUTPUT',
            style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white10),
            ),
            child: Text(
              llm.rawOutput.isEmpty ? '[No raw output recorded]' : llm.rawOutput,
              style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontFamily: 'monospace'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _DiagnosticRow extends StatelessWidget {
  final String label;
  final String value;
  const _DiagnosticRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
