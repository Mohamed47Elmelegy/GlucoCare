import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/widgets/premium_app_bar.dart';
import '../../domain/entities/medication.dart';
import '../../domain/entities/medication_type.dart';
import '../../domain/entities/meal_slot.dart';
import '../../domain/entities/schedule_type.dart';
import '../bloc/medication_bloc.dart';
import '../bloc/medication_event.dart';
import '../bloc/medication_state.dart';
import '../widgets/add_medication_header.dart';
import '../widgets/medication_form.dart';

class AddMedicationPage extends StatefulWidget {
  const AddMedicationPage({super.key});

  @override
  State<AddMedicationPage> createState() => _AddMedicationPageState();
}

class _AddMedicationPageState extends State<AddMedicationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _unitController = TextEditingController(text: 'mg');
  final _notesController = TextEditingController();
  MedicationType _selectedType = MedicationType.pill;
  ScheduleType _selectedScheduleType = ScheduleType.daily;
  final Set<MealSlot> _selectedMealSlots = {MealSlot.breakfast};
  final Map<MealSlot, TimeOfDay> _customTimes = {
    MealSlot.breakfast: const TimeOfDay(hour: 8, minute: 0),
    MealSlot.lunch: const TimeOfDay(hour: 13, minute: 0),
    MealSlot.dinner: const TimeOfDay(hour: 19, minute: 0),
  };
  DateTime _startDate = DateTime.now();
  int? _durationDays;

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _unitController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onMealSlotToggled(MealSlot slot) {
    setState(() {
      if (_selectedMealSlots.contains(slot)) {
        if (_selectedMealSlots.length > 1) {
          _selectedMealSlots.remove(slot);
        }
      } else {
        _selectedMealSlots.add(slot);
      }
    });
  }

  void _onTimeChanged(MealSlot slot, TimeOfDay time) {
    setState(() {
      _customTimes[slot] = time;
    });
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      if (_selectedMealSlots.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one meal slot')),
        );
        return;
      }

      final newMed = Medication(
        id: const Uuid().v4(),
        name: _nameController.text,
        dosage: _dosageController.text,
        unit: _unitController.text,
        type: _selectedType,
        notes: _notesController.text,
        mealSlots: _selectedMealSlots.toList(),
        customTimes: _customTimes,
        scheduleType: _selectedScheduleType,
        startDate: _startDate,
        durationDays: _durationDays,
        isActive: true,
      );

      context.read<MedicationBloc>().add(
        AddMedicationEvent(medication: newMed),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: context.l10n.addMedication,
      ),
      body: BlocListener<MedicationBloc, MedicationState>(
        listener: (context, state) {
          if (state is MedicationActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: context.colorScheme.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.pop();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const AddMedicationHeader(),
                const SizedBox(height: 24),
                MedicationForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  dosageController: _dosageController,
                  unitController: _unitController,
                  notesController: _notesController,
                  selectedType: _selectedType,
                  selectedScheduleType: _selectedScheduleType,
                  selectedMealSlots: _selectedMealSlots,
                  customTimes: _customTimes,
                  startDate: _startDate,
                  durationDays: _durationDays,
                  onTypeChanged: (type) => setState(() => _selectedType = type),
                  onScheduleTypeChanged: (type) =>
                      setState(() => _selectedScheduleType = type),
                  onMealSlotToggled: _onMealSlotToggled,
                  onTimeChanged: _onTimeChanged,
                  onStartDateChanged: (date) => setState(() => _startDate = date),
                  onDurationChanged: (val) =>
                      setState(() => _durationDays = int.tryParse(val)),
                  onSave: _onSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
