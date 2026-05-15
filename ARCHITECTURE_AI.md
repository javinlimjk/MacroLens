# MacroLens AI Architecture

This document defines the constraints and protocols for the on-device AI pipeline.

## LLM Reconciliation Contract

### Prompt Information
- **Model**: Gemma 4 E2B (Multimodal)
- **Engine**: MediaPipe LLM Inference API
- **Prompt Version**: `2.1.0-PROD` (Open Domain)
- **Location**: `lib/features/meal_scan/infrastructure/gemma_multimodal_engine.dart`
- **Max History Length**: 1 turn (Stateless). Each scan is treated as a fresh multimodal interaction.

### Output Schema: `LLMInferenceOutput`
The LLM must return a JSON object with the following fields:

| Field | Type | Description |
| :--- | :--- | :--- |
| `dishId` | `string` | A unique snake_case identifier for the dish. |
| `displayName` | `string` | User-friendly name of the dish. |
| `cuisineType` | `string` | General cuisine, e.g. "Chinese", "Western". |
| `portionMultiplier` | `number` | Scaling factor (1.0 = standard). |
| `modifiers` | `string[]` | List of keys from `NutritionRulesEngine`. |
| `estimatedKcal` | `number` | Fallback calorie count if `dishId` is `unknown`. |
| `kcalHint` | `string?` | Explanation for the estimatedKcal. |
| `signalAgreement` | `boolean` | `true` if photo and text describe the same dish. |
| `disagreementNote` | `string?` | Human-readable explanation of conflicts. |
| `uncertaintyNote` | `string?` | Reason for fallback or generic category. |
| `category` | `string` | Generic category if unknown (e.g. riceBase). |
| `reasoning` | `string` | Chain-of-thought for transparency. |

## Performance Gates
The pipeline MUST pass the following performance targets on 8GB Android devices:
1. **Total Scan Latency**: < 3.0 seconds
2. **Peak RAM**: Managed natively via ML Kit without OOM
3. **Thermal Stability**: Maintain normal device temperature during repeated scans
4. **TTFT (Time To First Token)**: < 1.0 second

## Stability Protocol
1. **Freeze Rule**: The system prompt is a contract. Any modification requires a version bump and execution of the **LLM Acceptance Suite**.
2. **Resilience Layer**: The `LLMResponseParser` acts as a firewall, sanitizing raw generative text into this strict schema.
3. **Fallback Strategy**: On any parsing or validation failure, the system MUST return `LLMInferenceOutput.fallback` to prevent UI breakage.
