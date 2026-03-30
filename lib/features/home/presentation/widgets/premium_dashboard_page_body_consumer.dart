import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test_ai/features/medication/presentation/bloc/medication_bloc.dart';
import 'package:flutter_test_ai/features/medication/presentation/bloc/medication_event.dart';
import 'package:flutter_test_ai/features/medication/presentation/bloc/insulin_bloc.dart';
import 'package:flutter_test_ai/features/medication/presentation/bloc/insulin_event.dart';
import 'package:flutter_test_ai/features/medication/presentation/bloc/intake_bloc.dart';
import 'package:flutter_test_ai/features/medication/presentation/bloc/intake_event.dart';
import 'premium_dashboard_page_body.dart';

class PremiumDashboardPageBodyConsumer extends StatefulWidget {
  const PremiumDashboardPageBodyConsumer({super.key});

  @override
  State<PremiumDashboardPageBodyConsumer> createState() => _PremiumDashboardPageBodyConsumerState();
}

class _PremiumDashboardPageBodyConsumerState extends State<PremiumDashboardPageBodyConsumer> {
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    context.read<MedicationBloc>().add(LoadTodaySchedule(DateTime.now()));
    context.read<InsulinBloc>().add(const LoadInsulinReadings());
    context.read<IntakeBloc>().add(IntakeTasksLoadRequested(date: DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final medState = context.watch<MedicationBloc>().state;
    final insulinState = context.watch<InsulinBloc>().state;
    final intakeState = context.watch<IntakeBloc>().state;

    return RefreshIndicator(
      onRefresh: () async {
        _refreshData();
      },
      child: PremiumDashboardPageBody(
        authState: authState,
        medState: medState,
        insulinState: insulinState,
        intakeState: intakeState,
      ),
    );
  }
}
