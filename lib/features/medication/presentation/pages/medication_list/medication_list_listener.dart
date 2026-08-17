import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/medication_cubit.dart';
import '../../cubit/medication_state.dart';
import 'medication_list_view.dart';
import '../../../domain/entities/medication.dart';

class MedicationListListener extends StatelessWidget {
  const MedicationListListener({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<MedicationCubit>().syncMedications();
      },
      child: BlocConsumer<MedicationCubit, MedicationState>(
        listener: (context, state) {
          if (state is MedicationActionSuccess) {
            context.read<MedicationCubit>().loadTodaySchedule(
              date: DateTime.now(),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is MedicationLoading;
          final hasError = state is MedicationError;
          
          List<Medication> medications = [];
          if (state is MedicationLoaded) {
            medications = state.medications;
          } else if (state is TodayScheduleLoaded) {
            medications = state.activeMedications;
          }

          return MedicationListView(
            isLoading: isLoading,
            hasError: hasError,
            medications: medications,
            onRetry: () {
              context.read<MedicationCubit>().getMedications();
            },
          );
        },
      ),
    );
  }
}
