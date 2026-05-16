// This file is INTENTIONALLY REMOVED from the active build.
//
// It previously contained a direct `mediapipe_genai` implementation
// (LlmInference, MPImage, MPImageFormat) but the mediapipe_genai 0.0.1-dev.3
// package does not export those symbols.
//
// The real on-device LLM engine lives in `gemma_on_device_llm_engine.dart`
// which uses inline stubs for cross-platform compilation safety, and the DI
// layer (`providers.dart`) routes to MockLLMEngine on Windows / when the
// `InferenceRuntime.mock` is selected.
//
// When the MediaPipe GenAI package stabilises and exports the required types,
// this file should be rewritten against the actual API surface and registered
// in `providers.dart` as the `InferenceRuntime.gemma` backend.
//
// See: ARCHITECTURE_AI.md for the LLM Reconciliation Contract.
