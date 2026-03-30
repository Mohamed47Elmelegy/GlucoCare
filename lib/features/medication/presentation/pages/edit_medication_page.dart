import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/widgets/premium_card.dart';
import '../../../../core/widgets/premium_app_bar.dart';
import '../../domain/entities/medication.dart';
import '../../domain/entities/medication_type.dart';
import '../../domain/entities/meal_slot.dart';
import '../../domain/entities/schedule_type.dart';
import '../widgets/medication_form.dart';
import '../bloc/medication_bloc.dart';
import '../bloc/medication_event.dart';
import '../bloc/medication_state.dart';

class EditMedicationPage extends StatefulWidget {
  final Medication medication;

  const EditMedicationPage({super.key, required this.medication});

  @override
  State<EditMedicationPage> createState() => _EditMedicationPageState();
}

class _EditMedicationPageState extends State<EditMedicationPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _dosageController;
  late final TextEditingController _unitController;
  late final TextEditingController _notesController;
  late MedicationType _selectedType;
  late ScheduleType _selectedScheduleType;
  late Set<MealSlot> _selectedMealSlots;
  late Map<MealSlot, TimeOfDay> _customTimes;
  late DateTime _startDate;
  late int? _durationDays;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medication.name);
    _dosageController = TextEditingController(text: widget.medication.dosage);
    _unitController = TextEditingController(text: widget.medication.unit);
    _notesController = TextEditingController(text: widget.medication.notes);
    _selectedType = widget.medication.type;
    _selectedScheduleType = widget.medication.scheduleType;
    _selectedMealSlots = widget.medication.mealSlots.toSet();
    _customTimes = Map.from(widget.medication.customTimes);
    _startDate = widget.medication.startDate;
    _durationDays = widget.medication.durationDays;
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

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _unitController.dispose();
    _notesController.dispose();
    super.dispose();
  }


  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final updated = widget.medication.copyWith(
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
      );

      context.read<MedicationBloc>().add(
        UpdateMedicationEvent(medication: updated),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: context.l10n.editMedication,
      ),
      body: BlocListener<MedicationBloc, MedicationState>(
        listener: (context, state) {
          if (state is MedicationActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.medicationUpdated),
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
                // Header Icon and Title
                PremiumCard(
                  glassmorphic: true,
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: AppColors.premiumGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.premiumMint.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          PhosphorIcons.pill(PhosphorIconsStyle.fill),
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        context.l10n.editMedication,
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.updateMedicationDetails,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
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
