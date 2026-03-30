import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/extensions/context_extension.dart';
import '../bloc/medication_bloc.dart';
import '../bloc/medication_event.dart';
import '../bloc/medication_state.dart';
import 'medication_list_page_body.dart';

class MedicationListPageBodyConsumer extends StatelessWidget {
  const MedicationListPageBodyConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<MedicationBloc>().add(const SyncMedicationsEvent());
      },
      child: BlocConsumer<MedicationBloc, MedicationState>(
        listener: (context, state) {
          if (state is MedicationActionSuccess) {
            context.read<MedicationBloc>().add(
              LoadTodaySchedule(DateTime.now()),
            );
          }
        },
        builder: (context, state) {
          if (state is MedicationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MedicationLoaded) {
            return MedicationListPageBody(medications: state.medications);
          }

          if (state is TodayScheduleLoaded) {
            return MedicationListPageBody(medications: state.activeMedications);
          }

          if (state is MedicationError) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height - 200,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      PhosphorIcons.warningCircle(PhosphorIconsStyle.fill),
                      size: 48,
                      color: context.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(context.l10n.errorOccurred),
                    TextButton(
                      onPressed: () => context.read<MedicationBloc>().add(
                        const GetMedicationsEvent(),
                      ),
                      child: Text(context.l10n.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height - 200,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    PhosphorIcons.pill(PhosphorIconsStyle.light),
                    size: 64,
                    color: context.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(context.l10n.noMedicationsScheduled),
                  TextButton(
                    onPressed: () => context.read<MedicationBloc>().add(
                      const GetMedicationsEvent(),
                    ),
                    child: Text(context.l10n.retry),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
