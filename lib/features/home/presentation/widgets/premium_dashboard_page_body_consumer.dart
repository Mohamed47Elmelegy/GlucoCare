import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_ai/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_test_ai/features/medication/presentation/cubit/medication_cubit.dart';
import 'package:flutter_test_ai/features/medication/presentation/cubit/insulin_cubit.dart';
import 'package:flutter_test_ai/features/medication/presentation/cubit/intake_cubit.dart';
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
    context.read<MedicationCubit>().loadTodaySchedule(date: DateTime.now());
    context.read<InsulinCubit>().loadReadings();
    context.read<IntakeCubit>().loadTasks(date: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final medState = context.watch<MedicationCubit>().state;
    final insulinState = context.watch<InsulinCubit>().state;
    final intakeState = context.watch<IntakeCubit>().state;

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
