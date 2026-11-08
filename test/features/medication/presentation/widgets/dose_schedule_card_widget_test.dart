import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ai/core/theme/app_theme.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/meal_slot.dart';
import 'package:flutter_test_ai/features/medication/presentation/widgets/dose_schedule_card_widget.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  // Regression: the app theme gives buttons an infinite minimum width, which
  // broke layout ("RenderBox was not laid out") for the dose-time button
  // inside a Row as soon as Add Medication opened.
  testWidgets('lays out under the app theme with one row per dose', (tester) async {
    final durationController = TextEditingController();
    addTearDown(durationController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            child: DoseScheduleCardWidget(
              slots: MealSlot.forDailyDoses(3),
              doseTimes: {
                for (final slot in MealSlot.values)
                  slot: TimeOfDay(
                    hour: slot.defaultTime.hour,
                    minute: slot.defaultTime.minute,
                  ),
              },
              durationController: durationController,
              onDoseCountChanged: (_) {},
              onDoseTimeChanged: (_, __) {},
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(OutlinedButton), findsNWidgets(3));
  });
}
