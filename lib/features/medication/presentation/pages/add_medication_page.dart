import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/widgets/premium_app_bar.dart';
import '../../domain/entities/medication.dart';
import '../../domain/entities/medication_type.dart';
import '../../domain/entities/intake_timing.dart';
import '../../domain/entities/time_value.dart';
import '../bloc/medication_bloc.dart';
import '../bloc/medication_event.dart';
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
  IntakeTiming _selectedIntake = IntakeTiming.anytime;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _unitController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _onSave() {
    if (_formKey.currentState!.validate() && _selectedTime != null) {
      final newMed = Medication(
        id: const Uuid().v4(),
        name: _nameController.text,
        dosage: _dosageController.text,
        unit: _unitController.text,
        type: _selectedType,
        intakeTiming: _selectedIntake,
        notes: _notesController.text,
        scheduleTimes: [
          TimeValue(hour: _selectedTime!.hour, minute: _selectedTime!.minute),
        ],
      );

      context.read<MedicationBloc>().add(
        AddMedicationEvent(medication: newMed),
      );
      context.pop();
    } else if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.pleaseSelectTime),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: context.l10n.addMedication,
      ),
      body: SafeArea(
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
                selectedIntake: _selectedIntake,
                selectedTime: _selectedTime,
                onTypeChanged: (type) => setState(() => _selectedType = type),
                onIntakeChanged: (intake) =>
                    setState(() => _selectedIntake = intake),
                onPickTime: _pickTime,
                onSave: _onSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
