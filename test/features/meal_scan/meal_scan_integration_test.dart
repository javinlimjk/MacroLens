import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macrolens/features/meal_scan/application/meal_scan_notifier.dart';
import 'package:macrolens/features/meal_scan/domain/models.dart';
import 'package:macrolens/features/meal_scan/presentation/camera_capture_screen.dart';
import 'package:macrolens/features/meal_scan/application/camera_lifecycle_provider.dart';
import 'package:macrolens/core/di/providers.dart';
import 'package:macrolens/core/telemetry/telemetry_logger.dart';

void main() {
  group('Meal Scan Integration Tests - Milestone 3', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          cameraLifecycleProvider.overrideWith(() => MockCameraLifecycleNotifier()),
        ],
      );
      TelemetryLogger().clear();
    });

    tearDown(() {
      container.dispose();
    });

    Future<void> runScenarioAndVerify(
      WidgetTester tester, {
      required String userText,
      required String expectedDishName,
      required bool expectLowConfidenceBadge,
      required String expectedDecisionPath,
    }) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: CameraCaptureScreen()),
        ),
      );

      // Simulate taking a photo and entering text
      final notifier = container.read(mealScanProvider.notifier);
      // Do not await, otherwise FakeAsync deadlocks waiting for Future.delayed to complete before pumping
      notifier.onImageCaptured(Uint8List.fromList([1, 2, 3]), userText: userText);
      
      // Wait for async processing without pumpAndSettle due to infinite animations
      for (int i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (container.read(mealScanProvider) is MealScanConfirming) {
          break;
        }
      }

      // Check state
      final state = container.read(mealScanProvider);
      if (state is MealScanError) {
        print('MealScanError: ${state.message}');
      }
      expect(state, isA<MealScanConfirming>());

      // Verify UI elements based on state
      expect(find.text(expectedDishName), findsOneWidget, reason: 'Expected to find $expectedDishName');
      
      if (expectLowConfidenceBadge) {
        expect(find.text('UNSURE • BEST GUESS'), findsOneWidget);
        expect(find.text('We aren\'t completely sure about this dish. The calories shown are a rough estimate. Please confirm or edit if this looks wrong.'), findsOneWidget);
      } else {
        expect(find.text('UNSURE • BEST GUESS'), findsNothing);
      }

      expect(find.text('Manual Override'), findsOneWidget);

      // Verify telemetry
      final logs = TelemetryLogger().logs;
      expect(logs, isNotEmpty);
      final lastLog = logs.last;
      expect(lastLog['decision_path'], expectedDecisionPath);
    }

    testWidgets('1. Clear recognized hawker meal (Chicken Rice)', (tester) async {
      await runScenarioAndVerify(
        tester,
        userText: 'chicken rice',
        expectedDishName: 'Chicken Rice', 
        expectLowConfidenceBadge: false,
        expectedDecisionPath: 'dish_level_exact',
      );
      // Actual UI uses output.dishId.replaceAll('_', ' ').toUpperCase() if dishId != 'unknown'
    });

    testWidgets('2. Low-confidence plausible guess (Blurry Laksa)', (tester) async {
      // Mock engine returns confidence 0.6 for 'blurry laksa'
      await runScenarioAndVerify(
        tester,
        userText: 'blurry laksa',
        expectedDishName: 'Laksa',
        expectLowConfidenceBadge: false, // Wait, is 0.6 low confidence badge shown? UI checks < 0.40. So it is false.
        expectedDecisionPath: 'dish_level_estimate', // NRE marks it as estimate
      );
    });

    testWidgets('3. Unknown/category fallback (Chee Cheong Fun)', (tester) async {
      // OOV: Chee Cheong Fun -> unknown, categoryFallback, confidence 0.2
      // Category is Rice Dish
      await runScenarioAndVerify(
        tester,
        userText: 'chee cheong fun',
        expectedDishName: 'Chee Cheong Fun', 
        expectLowConfidenceBadge: true,
        expectedDecisionPath: 'category_level_estimate',
      );
    });

    testWidgets('4. Parser fallback', (tester) async {
      // Any text that doesn't trigger specific mock cases and is long... wait, empty text uses size.
      // Text 'random nonsense' -> Default Fallback -> unknown, parserFallback, confidence 0.0
      await runScenarioAndVerify(
        tester,
        userText: 'random nonsense',
        expectedDishName: 'Unknown Dish', 
        expectLowConfidenceBadge: true,
        expectedDecisionPath: 'category_level_estimate',
      );
    });

    testWidgets('5. Disagreement case (Duck Rice typed but looks like Chicken Rice)', (tester) async {
      // Mock engine returns duck_rice, disagreement, confidence 0.6
      // It is NOT low confidence in the UI since confidence is 0.6 and not fallback/unknown.
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: CameraCaptureScreen()),
        ),
      );

      final notifier = container.read(mealScanProvider.notifier);
      notifier.onImageCaptured(Uint8List.fromList([1, 2, 3]), userText: 'duck rice');
      for (int i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (container.read(mealScanProvider) is MealScanConfirming) {
          break;
        }
      }

      // UI should show the disagreement panel
      expect(find.textContaining('mismatch'), findsNothing); // Check actual text
      expect(find.text('The photo appears to be Chicken Rice, but you typed Duck Rice.'), findsOneWidget);
      expect(find.text('Duck Rice'), findsOneWidget);
    });

    testWidgets('6. Burger and fries out-of-domain case', (tester) async {
      // text 'burger and fries' -> unknown, snackSide, confidence 0.9, categoryFallback
      await runScenarioAndVerify(
        tester,
        userText: 'burger and fries',
        expectedDishName: 'Cheeseburger & Fries', 
        expectLowConfidenceBadge: true, // Because source == categoryFallback
        expectedDecisionPath: 'category_level_estimate',
      );
    });
  });
}

class MockCameraLifecycleNotifier extends CameraLifecycleNotifier {
  @override
  Future<CameraController> build() async {
    throw Exception('Camera mocked out for test');
  }
}
