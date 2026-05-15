import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:macrolens/main.dart' as app;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macrolens/core/di/providers.dart';
import 'package:macrolens/database/models/meal_log_isar.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Meal Scan Flows', () {
    late Isar isar;

    setUpAll(() async {
      // Initialize Isar for tests
      final dir = await getTemporaryDirectory();
      // Ensure we don't have conflicting instances
      if (Isar.instanceNames.isEmpty) {
        isar = await Isar.open(
          [MealLogIsarSchema, DailyProgressIsarSchema],
          directory: dir.path,
        );
      } else {
        isar = Isar.getInstance()!;
      }
    });

    testWidgets('Full meal scan flow: recognized chicken rice', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isarProvider.overrideWithValue(isar),
          ],
          child: const app.MacroLensApp(),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Navigate to Scan tab
      await tester.tap(find.byIcon(Icons.camera_alt_outlined));
      await tester.pumpAndSettle();

      // 2. Simulate Capture
      // Note: We are using the FAB which in the app takes a real picture.
      // But since we are in a test with MockInferenceEngine, it will just work.
      final fab = find.byType(FloatingActionButton);
      await tester.tap(fab);
      await tester.pump(); // Starts classification

      // MockInferenceEngine delay (1s + 2s)
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Should show Text Input Sheet
      expect(find.text('Confirm Dish'), findsOneWidget);
      
      // 3. Submit Text
      await tester.tap(find.text('Continue to Analysis'));
      await tester.pump(); // Starts reconciliation

      // MockLLMEngine delay (1s)
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should show Confirmation Sheet
      expect(find.text('Ready to Log'), findsOneWidget);
      expect(find.text('CHICKEN RICE'), findsOneWidget);

      // 4. Final Log
      await tester.tap(find.text('Log Meal'));
      await tester.pumpAndSettle();

      // Verify success snackbar
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Disagreement flow: user types duck rice', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isarProvider.overrideWithValue(isar),
          ],
          child: const app.MacroLensApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Navigate to Scan
      await tester.tap(find.byIcon(Icons.camera_alt_outlined));
      await tester.pumpAndSettle();

      // Capture
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Enter "duck rice" to trigger disagreement in MockLLMEngine
      await tester.enterText(find.byType(TextField), 'duck rice');
      await tester.tap(find.text('Continue to Analysis'));
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should show Review Required
      expect(find.text('Review Required'), findsOneWidget);
      expect(find.textContaining('photo appears to be Chicken Rice'), findsOneWidget);

      // Resolution options
      expect(find.text('Use AI Suggestion'), findsOneWidget);
      expect(find.text('Use My Description'), findsOneWidget);

      // Log button should be disabled initially
      var logButton = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Log Meal'));
      expect(logButton.enabled, isFalse);

      // Resolve disagreement
      await tester.tap(find.text('Use My Description'));
      await tester.pumpAndSettle();

      // Log button should now be enabled
      logButton = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Log Meal'));
      expect(logButton.enabled, isTrue);

      await tester.tap(find.text('Log Meal'));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Manual override path', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isarProvider.overrideWithValue(isar),
          ],
          child: const app.MacroLensApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Navigate to Scan
      await tester.tap(find.byIcon(Icons.camera_alt_outlined));
      await tester.pumpAndSettle();

      // Capture
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Continue to Analysis
      await tester.tap(find.text('Continue to Analysis'));
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Tap Manual Override
      await tester.tap(find.text('Manual Override'));
      await tester.pumpAndSettle();

      // Should be on ManualLogScreen (Search Food)
      expect(find.text('Search Food'), findsOneWidget);
    });
  });
}
