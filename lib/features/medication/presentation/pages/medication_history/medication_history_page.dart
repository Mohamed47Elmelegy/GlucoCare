import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/widgets/premium_app_bar.dart';
import '../../bloc/medication_bloc.dart';
import '../../bloc/medication_event.dart';
import '../../bloc/medication_state.dart';
import '../../../domain/entities/dose_history.dart';
import 'medication_history_view.dart';

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
      body: BlocBuilder<MedicationBloc, MedicationState>(
        builder: (context, state) {
          final isLoading = state is MedicationLoading;
          final List<DoseHistory> history = state is TodayScheduleLoaded ? state.takenHistory : [];
          final hasError = state is MedicationError || (state is! TodayScheduleLoaded && state is! MedicationLoading);

          return MedicationHistoryView(
            selectedDate: _selectedDate,
            isLoading: isLoading,
            history: history,
            hasError: hasError,
          );
        },
      ),
    );
  }
}
