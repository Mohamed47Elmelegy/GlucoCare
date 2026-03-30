import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/widgets/premium_app_bar.dart';
import '../../../../core/widgets/premium_card.dart';
import '../bloc/medication_bloc.dart';
import '../bloc/medication_event.dart';
import '../bloc/medication_state.dart';
import '../../domain/entities/dose_status.dart';

class MedicationHistoryPage extends StatefulWidget {
  const MedicationHistoryPage({super.key});

  @override
  State<MedicationHistoryPage> createState() => _MedicationHistoryPageState();
}

class _MedicationHistoryPageState extends State<MedicationHistoryPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    context.read<MedicationBloc>().add(LoadTodaySchedule(_selectedDate));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: context.l10n.medicationHistory,
        actions: [
          IconButton(
            icon: Image.asset(AppAssets.history, width: 24, height: 24),
            onPressed: _pickDate,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: context.colorScheme.surfaceContainerHighest,
            width: double.infinity,
            child: Text(
              '${context.l10n.showingHistoryFor}\n${DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate)}',
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: BlocBuilder<MedicationBloc, MedicationState>(
              builder: (context, state) {
                if (state is MedicationLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TodayScheduleLoaded) {
                  final history = state.takenHistory;

                  if (history.isEmpty) {
                    return Center(
                      child: Text(
                        context.l10n.noMedicationsRecorded,
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      // For a complete app, we'd look up the medication name by ID.
                      // For now, we display the raw ID and time taken.
                      return PremiumCard(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Image.asset(
                            AppAssets.check,
                            width: 32,
                            height: 32,
                          ),
                          title: Text(
                            '${context.l10n.medicationId} ${item.medicationId.substring(0, 8)}...',
                          ),
                          subtitle: Text(
                            '${context.l10n.takenAt} ${DateFormat('hh:mm a').format(item.dateTime)}',
                          ),
                          trailing: item.status == DoseStatus.taken
                              ? Text(
                                  context.l10n.onTime,
                                  style: const TextStyle(color: Colors.green),
                                )
                              : Text(
                                  context.l10n.late,
                                  style: const TextStyle(color: Colors.orange),
                                ),
                        ),
                      );
                    },
                  );
                }

                return Center(
                  child: Text(
                    context.l10n.failedToLoadHistory,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
