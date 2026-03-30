import 'package:flutter/material.dart';
import 'package:flutter_test_ai/core/extensions/context_extension.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_test_ai/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/premium_card.dart';
import '../../domain/entities/medication_type.dart';
import '../../domain/entities/intake_timing.dart';
import 'time_picker_field.dart';

class MedicationForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController dosageController;
  final TextEditingController unitController;
  final TextEditingController notesController;
  final MedicationType selectedType;
  final IntakeTiming selectedIntake;
  final TimeOfDay? selectedTime;
  final Function(MedicationType) onTypeChanged;
  final Function(IntakeTiming) onIntakeChanged;
  final VoidCallback onPickTime;
  final VoidCallback onSave;

  const MedicationForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.dosageController,
    required this.unitController,
    required this.notesController,
    required this.selectedType,
    required this.selectedIntake,
    required this.selectedTime,
    required this.onTypeChanged,
    required this.onIntakeChanged,
    required this.onPickTime,
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
            _buildDropdownLabel(context, l10n.intakeTiming),
            _buildIntakeDropdown(context),
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
            const SizedBox(height: 24),
            TimePickerField(
              selectedTime: widget.selectedTime,
              onPickTime: widget.onPickTime,
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

  Widget _buildIntakeDropdown(BuildContext context) {
    return DropdownButtonFormField<IntakeTiming>(
      initialValue: widget.selectedIntake,
      style: context.textTheme.bodyLarge?.copyWith(color: context.colorScheme.onSurface),
      decoration: _getInputDecoration(context, Icons.access_time_filled_rounded),
      items: IntakeTiming.values
          .map((timing) => DropdownMenuItem(
                value: timing,
                child: Text(timing.name.capitalize()),
              ))
          .toList(),
      onChanged: (val) => widget.onIntakeChanged(val!),
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
