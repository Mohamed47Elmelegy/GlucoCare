import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_test_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test_ai/features/medication/presentation/bloc/medication_state.dart';
import 'package:flutter_test_ai/features/medication/presentation/bloc/insulin_state.dart';
import '../../../../core/extensions/context_extension.dart';
import '../widgets/premium_header.dart';
import '../widgets/premium_summary_card.dart';
import '../widgets/premium_category_tabs.dart';
import '../widgets/premium_timeline_section.dart';
import '../widgets/premium_action_grid.dart';

class PremiumDashboardPageBody extends StatefulWidget {
  final AuthState authState;
  final MedicationState medState;
  final InsulinState insulinState;

  const PremiumDashboardPageBody({
    super.key,
    required this.authState,
    required this.medState,
    required this.insulinState,
  });

  @override
  State<PremiumDashboardPageBody> createState() => _PremiumDashboardPageBodyState();
}

class _PremiumDashboardPageBodyState extends State<PremiumDashboardPageBody> {
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      context.l10n.catAllHealth,
      context.l10n.catGlucose,
      context.l10n.catMedication,
      context.l10n.catDiet,
    ];

    String userName = "User";
    if (widget.authState is AuthSuccess) {
      userName = (widget.authState as AuthSuccess).user.name.split(' ').first;
    }

    String glucoseValue = "--";
    double insulinToday = 0;
    if (widget.insulinState is InsulinLoaded) {
      final loadedState = widget.insulinState as InsulinLoaded;
      if (loadedState.readings.isNotEmpty) {
        glucoseValue = loadedState.readings.first.value.toStringAsFixed(0);
      }
      final today = DateTime.now();
      insulinToday = loadedState.readings
          .where(
            (r) =>
                r.timestamp.year == today.year &&
                r.timestamp.month == today.month &&
                r.timestamp.day == today.day,
          )
          .fold(0.0, (sum, r) => sum + r.value);
    }

    int medsRemaining = 0;
    if (widget.medState is TodayScheduleLoaded) {
      final loadedState = widget.medState as TodayScheduleLoaded;
      medsRemaining =
          loadedState.activeMedications.length - loadedState.takenHistory.length;
    }

    final String todayDate = DateFormat.yMMMMEEEEd(
      Localizations.localeOf(context).toString(),
    ).format(DateTime.now());

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PremiumHeader(name: userName, date: todayDate),
          const SizedBox(height: 32),
          PremiumSummaryCard(
            title: context.l10n.stable,
            subtitle: context.l10n.glucoseNormal,
            mainValue: glucoseValue,
            metrics: [
              SummaryMetric(
                label: context.l10n.glucose,
                value: "$glucoseValue mg/dL",
              ),
              SummaryMetric(
                label: context.l10n.insulin,
                value: "${insulinToday.toStringAsFixed(1)}u",
              ),
            ],
          ),
          const SizedBox(height: 32),
          PremiumTimelineSection(medState: widget.medState),
          const SizedBox(height: 32),
          PremiumCategoryTabs(
            categories: categories,
            selectedIndex: _selectedCategoryIndex,
            onSelected: (index) {
              setState(() => _selectedCategoryIndex = index);
            },
          ),
          const SizedBox(height: 24),
          PremiumActionGrid(
            medsRemaining: medsRemaining,
            insulinToday: insulinToday,
          ),
          const SizedBox(height: 100), // Space for bottom nav
        ],
      ),
    );
  }
}
