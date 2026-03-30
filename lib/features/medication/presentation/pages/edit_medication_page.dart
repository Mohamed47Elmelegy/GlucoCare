import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/premium_card.dart';
import '../../../../core/widgets/premium_app_bar.dart';
import '../../domain/entities/medication.dart';
import '../../domain/entities/medication_type.dart';
import '../../domain/entities/intake_timing.dart';
import '../../domain/entities/time_value.dart';
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
  late IntakeTiming _selectedIntake;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medication.name);
    _dosageController = TextEditingController(text: widget.medication.dosage);
    _unitController = TextEditingController(text: widget.medication.unit);
    _notesController = TextEditingController(text: widget.medication.notes);
    _selectedType = widget.medication.type;
    _selectedIntake = widget.medication.intakeTiming;
    _selectedTime = widget.medication.scheduleTimes.isNotEmpty
        ? TimeOfDay(
            hour: widget.medication.scheduleTimes.first.hour,
            minute: widget.medication.scheduleTimes.first.minute,
          )
        : TimeOfDay.now();
  }

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
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final updated = Medication(
        id: widget.medication.id,
        name: _nameController.text,
        dosage: _dosageController.text,
        unit: _unitController.text,
        type: _selectedType,
        intakeTiming: _selectedIntake,
        notes: _notesController.text,
        scheduleTimes: [
          TimeValue(hour: _selectedTime.hour, minute: _selectedTime.minute),
        ],
      );

      context.read<MedicationBloc>().add(
        UpdateMedicationEvent(medication: updated),
      );
      context.pop();
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

                PremiumCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppTextField(
                          controller: _nameController,
                          label: context.l10n.medicationName,
                          icon: PhosphorIcons.pencilLine(
                            PhosphorIconsStyle.bold,
                          ),
                          validator: (value) => value!.isEmpty
                              ? context.l10n.enterMedicationName
                              : null,
                        ),
                        const SizedBox(height: 20),
                        AppTextField(
                          controller: _dosageController,
                          label: context.l10n.dosageExample,
                          icon: PhosphorIcons.scales(PhosphorIconsStyle.bold),
                          validator: (value) =>
                              value!.isEmpty ? context.l10n.enterDosage : null,
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<MedicationType>(
                          initialValue: _selectedType,
                          decoration: InputDecoration(
                            labelText: context.l10n.type,
                            prefixIcon: Icon(
                              PhosphorIcons.squaresFour(
                                PhosphorIconsStyle.bold,
                              ),
                            ),
                          ),
                          items: MedicationType.values
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(
                                    type.name[0].toUpperCase() +
                                        type.name.substring(1),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            setState(() => _selectedType = val!);
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<IntakeTiming>(
                          initialValue: _selectedIntake,
                          decoration: InputDecoration(
                            labelText: context.l10n.intakeTiming,
                            prefixIcon: const Icon(Icons.access_time),
                          ),
                          items: IntakeTiming.values
                              .map(
                                (timing) => DropdownMenuItem(
                                  value: timing,
                                  child: Text(
                                    timing.name[0].toUpperCase() +
                                        timing.name.substring(1),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedIntake = val!;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        AppTextField(
                          controller: _unitController,
                          label: context.l10n.unitHint,
                          icon: PhosphorIcons.hash(PhosphorIconsStyle.bold),
                          validator: (value) =>
                              value!.isEmpty ? context.l10n.enterUnit : null,
                        ),
                        const SizedBox(height: 20),
                        AppTextField(
                          controller: _notesController,
                          label: context.l10n.notes,
                          icon: PhosphorIcons.notePencil(
                            PhosphorIconsStyle.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: context.colorScheme.primaryContainer.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: context.colorScheme.primaryContainer.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.l10n.scheduleTime,
                                      style: context.textTheme.labelLarge?.copyWith(
                                        color: context.colorScheme.primary,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _selectedTime.format(context),
                                      style: context.textTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                            color: context.colorScheme.onSurface,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: _pickTime,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(context.l10n.pickTime),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        AppButton(
                          text: context.l10n.saveMedication,
                          onPressed: _onSave,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
