import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_ai/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_test_ai/features/medication/presentation/cubit/medication_cubit.dart';
import 'package:flutter_test_ai/features/medication/presentation/cubit/insulin_cubit.dart';
import 'package:flutter_test_ai/features/medication/presentation/cubit/intake_cubit.dart';
import 'premium_dashboard_view.dart';

class PremiumDashboardListener extends StatefulWidget {
  const PremiumDashboardListener({super.key});

  @override
  State<PremiumDashboardListener> createState() => _PremiumDashboardListenerState();
}

class _PremiumDashboardListenerState extends State<PremiumDashboardListener> {
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    context.read<MedicationCubit>().loadTodaySchedule(date: DateTime.now());
    context.read<InsulinCubit>().loadReadings();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final medState = context.watch<MedicationCubit>().state;
    final insulinState = context.watch<InsulinCubit>().state;

    return RefreshIndicator(
      onRefresh: () async {
        _refreshData();
        // Only on explicit refresh: the app already loads today's doses at
        // startup and after every dose action.
        context.read<IntakeCubit>().loadTasks(date: DateTime.now());
      },
      child: PremiumDashboardView(
        authState: authState,
        medState: medState,
        insulinState: insulinState,
      ),
    );
  }
}
