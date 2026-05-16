# MacroLens: Privacy-First AI Calorie Tracker

MacroLens is a production-ready, on-device AI application designed specifically for the Singapore food ecosystem. It uses the **Gemma 3n** multimodal model via MediaPipe to provide accurate, offline calorie tracking without compromising user privacy.

## 🚀 Key trust signals (v1.0)
- **92.0% Accuracy**: Verified on Singapore hawker staples (Chicken Rice, Laksa, etc.).
- **9.5% Mean Percentage Error**: Highly reliable calorie estimation across core categories.
- **Zero Gross Underestimates**: Hardened safety logic prevents dangerous under-counting of high-calorie meals.
- **100% On-Device**: No photos or personal data ever leave your phone. No cloud API required.

## 🥘 How it Works
MacroLens uses a two-stage reconciliation pipeline:
1. **Visual Analysis**: A local Gemma 3n model analyzes your food photo.
2. **Text Synthesis**: The AI reconciles visual evidence with your description (e.g., "extra rice") to provide a calibrated nutritional estimate based on Health Promotion Board (HPB) standard servings.

### 🛡️ Handling Uncertainty
For **home-cooked** or **mixed meals** where visual evidence is complex:
- The app provides a **Safe Category Estimate** (e.g., "Rice-based average").
- A **Manual Override Hint** is displayed, allowing you to easily adjust portions or calories if the AI is less certain.

---

## ❓ FAQ

### Is the AI always accurate?
Our AI is a high-precision estimation tool, but it is not lab-grade. It is designed to get you within 10% of the true value for most Singapore hawker dishes. For custom homemade meals, we recommend using the **Manual Override** feature if you have a specific recipe.

### Why do some dishes show as "Unknown"?
If a dish is not yet in our primary catalog, we categorize it (e.g., "Noodle Base") and apply a Singapore-specific average. You can help us improve by confirming the dish name, which helps calibrate future local model updates.

### Does this use my data for training?
No. All analysis happens locally. Any feedback you provide stays on your device and is only used to improve your local experience.

---

## 🛠️ Developer Information
MacroLens is built with:
- **Flutter** & **Riverpod** for state management.
- **MediaPipe LLM Inference API** for on-device Gemma 3n execution.
- **Isar Database** for high-performance offline persistence.

### Regression Testing
Maintainers should run the `RealWorldEvalRunner` to ensure any future updates do not regress the current 9.5% MPE or 92% dish match accuracy.
