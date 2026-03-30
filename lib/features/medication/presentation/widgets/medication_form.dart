import 'package:flutter/material.dart';
import 'package:flutter_test_ai/core/extensions/context_extension.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_test_ai/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/premium_card.dart';
import '../../domain/entities/medication_type.dart';
import '../../domain/entities/meal_slot.dart';
import '../../domain/entities/schedule_type.dart';

class MedicationForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController dosageController;
  final TextEditingController unitController;
  final TextEditingController notesController;
  final MedicationType selectedType;
  final ScheduleType selectedScheduleType;
  final Set<MealSlot> selectedMealSlots;
  final Map<MealSlot, TimeOfDay> customTimes;
  final DateTime startDate;
  final int? durationDays;
  final Function(MedicationType) onTypeChanged;
  final Function(ScheduleType) onScheduleTypeChanged;
  final Function(MealSlot) onMealSlotToggled;
  final Function(MealSlot, TimeOfDay) onTimeChanged;
  final Function(DateTime) onStartDateChanged;
  final Function(String) onDurationChanged;
  final VoidCallback onSave;

  const MedicationForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.dosageController,
    required this.unitController,
    required this.notesController,
    required this.selectedType,
    required this.selectedScheduleType,
    required this.selectedMealSlots,
    required this.customTimes,
    required this.startDate,
    this.durationDays,
    required this.onTypeChanged,
    required this.onScheduleTypeChanged,
    required this.onMealSlotToggled,
    required this.onTimeChanged,
    required this.onStartDateChanged,
    required this.onDurationChanged,
    required this.onSave,
  });

  @override
  State<MedicationForm> createState() => _MedicationFormState();
}

class _MedicationFormState extends State<MedicationForm> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PremiumCard(
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: widget.nameController,
              label: l10n.medicationName,
              icon: PhosphorIcons.pencilLine(PhosphorIconsStyle.bold),
              validator: (value) => value!.isEmpty ? l10n.enterMedicationName : null,
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: widget.dosageController,
              label: l10n.dosageExample,
              icon: PhosphorIcons.scales(PhosphorIconsStyle.bold),
              validator: (value) => value!.isEmpty ? l10n.enterDosage : null,
            ),
            const SizedBox(height: 20),
            _buildDropdownLabel(context, l10n.type),
            _buildTypeDropdown(context),
            const SizedBox(height: 20),
            _buildDropdownLabel(context, 'Schedule Type'),
            _buildScheduleTypeDropdown(context),
            const SizedBox(height: 20),
            if (widget.selectedScheduleType == ScheduleType.fixedDuration) ...[
              AppTextField(
                controller: TextEditingController(text: widget.durationDays?.toString() ?? ''),
                label: 'Duration (Days)',
                icon: PhosphorIcons.calendarCheck(PhosphorIconsStyle.bold),
                keyboardType: TextInputType.number,
                onChanged: widget.onDurationChanged,
              ),
              const SizedBox(height: 20),
            ],
            _buildMealSlotsSection(context),
            const SizedBox(height: 20),
            AppTextField(
              controller: widget.unitController,
              label: l10n.unitHint,
              icon: PhosphorIcons.hash(PhosphorIconsStyle.bold),
              validator: (value) => value!.isEmpty ? l10n.enterUnit : null,
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: widget.notesController,
              label: l10n.notes,
              icon: PhosphorIcons.notePencil(PhosphorIconsStyle.bold),
            ),
            const SizedBox(height: 40),
            AppButton(
              text: l10n.saveMedication,
              onPressed: widget.onSave,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Text(
        label,
        style: context.textTheme.labelLarge?.copyWith(
          color: context.colorScheme.onSurface.withValues(alpha: 0.7),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTypeDropdown(BuildContext context) {
    return DropdownButtonFormField<MedicationType>(
      initialValue: widget.selectedType,
      style: context.textTheme.bodyLarge?.copyWith(color: context.colorScheme.onSurface),
      decoration: _getInputDecoration(context, Icons.category_rounded),
      items: MedicationType.values
          .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type.name.capitalize()),
              ))
          .toList(),
      onChanged: (val) => widget.onTypeChanged(val!),
    );
  }

  Widget _buildScheduleTypeDropdown(BuildContext context) {
    return DropdownButtonFormField<ScheduleType>(
      initialValue: widget.selectedScheduleType,
      style: context.textTheme.bodyLarge?.copyWith(color: context.colorScheme.onSurface),
      decoration: _getInputDecoration(context, Icons.calendar_today_rounded),
      items: ScheduleType.values
          .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type.name.capitalize()),
              ))
          .toList(),
      onChanged: (val) => widget.onScheduleTypeChanged(val!),
    );
  }

  Widget _buildMealSlotsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownLabel(context, 'Meal Slots & Times'),
        const SizedBox(height: 8),
        ...MealSlot.values.map((slot) {
          final isSelected = widget.selectedMealSlots.contains(slot);
          final time = widget.customTimes[slot];
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => widget.onMealSlotToggled(slot),
                  activeColor: context.colorScheme.primary,
                ),
                Expanded(
                  child: Text(slot.label, style: context.textTheme.bodyLarge),
                ),
                if (isSelected)
                  TextButton.icon(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: time ?? const TimeOfDay(hour: 8, minute: 0),
                      );
                      if (picked != null) {
                        widget.onTimeChanged(slot, picked);
                      }
                    },
                    icon: const Icon(Icons.access_time, size: 18),
                    label: Text(time?.format(context) ?? 'Set Time'),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  InputDecoration _getInputDecoration(BuildContext context, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(
        icon,
        color: context.isDark ? AppColors.premiumMint : context.colorScheme.primary,
        size: 22,
      ),
      filled: true,
      fillColor: context.isDark 
          ? context.colorScheme.onSurface.withValues(alpha: 0.05)
          : context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: context.colorScheme.outline.withValues(alpha: context.isDark ? 0.1 : 0.2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: context.isDark ? AppColors.premiumMint : context.colorScheme.primary,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
