import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

enum AICapabilityLevel {
  none,       // Fallback to manual entry only
  basic,      // Can run Gemma E2B (Mid-tier)
  advanced,   // Can run Gemma E4B (High-end)
}

class DeviceCapabilityService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Checks if the device meets the minimum requirements for Edge AI.
  /// Target: Android 14+ (API 34+), 8GB+ RAM.
  Future<AICapabilityLevel> checkCapability() async {
    if (!Platform.isAndroid) {
      // For MVP, iOS is not strictly required to run edge AI, 
      // but we might want to allow it later.
      return AICapabilityLevel.none;
    }

    try {
      final androidInfo = await _deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      // In real implementation, we would also check total RAM.
      // DeviceInfoPlugin does not provide RAM size out of the box directly in an easy way,
      // it might require a method channel to ActivityManager or using another package.
      // For now, we simulate the capability check.

      if (sdkInt >= 34) {
        // Assume API 34+ (Android 14) is mid-to-high end for now.
        // In a real app, we'd add RAM checks.
        return AICapabilityLevel.basic; 
      }

      return AICapabilityLevel.none;
    } catch (e) {
      // Fallback on error
      return AICapabilityLevel.none;
    }
  }

  Future<bool> canRunGemmaE2B() async {
    final level = await checkCapability();
    return level == AICapabilityLevel.basic || level == AICapabilityLevel.advanced;
  }
}
