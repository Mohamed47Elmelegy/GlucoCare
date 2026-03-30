import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test_ai/features/medication/presentation/bloc/medication_bloc.dart';
import 'package:flutter_test_ai/features/medication/presentation/bloc/medication_event.dart';
import 'package:flutter_test_ai/features/medication/presentation/bloc/insulin_bloc.dart';
import 'package:flutter_test_ai/features/medication/presentation/bloc/insulin_event.dart';
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
    context.read<MedicationBloc>().add(LoadTodaySchedule(DateTime.now()));
    context.read<InsulinBloc>().add(const LoadInsulinReadings());
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final medState = context.watch<MedicationBloc>().state;
    final insulinState = context.watch<InsulinBloc>().state;

    return RefreshIndicator(
      onRefresh: () async {
        _refreshData();
      },
      child: PremiumDashboardView(
        authState: authState,
        medState: medState,
        insulinState: insulinState,
      ),
    );
  }
}
