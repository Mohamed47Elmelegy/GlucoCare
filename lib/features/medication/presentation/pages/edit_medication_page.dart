import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/medication.dart';
import '../../domain/entities/medication_type.dart';
import '../../domain/entities/meal_slot.dart';
import '../../domain/entities/schedule_type.dart';
import '../cubit/medication_cubit.dart';

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
        name: _nameController.text.trim(),
        dosage: _dosageController.text.trim(),
        unit: _unitController.text.trim(),
        type: _selectedType,
        notes: _notesController.text.trim(),
        mealSlots: _selectedMealSlots.toList(),
        customTimes: _customTimes,
        scheduleType: _selectedScheduleType,
        startDate: _startDate,
        durationDays: _durationDays,
      );

      context.read<MedicationCubit>().updateMedication(medication: updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            PhosphorIconsBold.caretLeft,
            color: isDark ? AppColors.darkText : AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<MedicationCubit, MedicationState>(
        listener: (context, state) {
          if (state is MedicationActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.pop();
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'تعديل بيانات الدواء',
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkText : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'تحديث الجرعة والمواعيد المحددة',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),

                // Card: Medication Info
                _buildCard(
                  isDark: isDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اسم الدواء',
                        style: AppTextStyles.h3.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkText : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _nameController,
                        label: 'اسم الدواء',
                        icon: PhosphorIconsRegular.pill,
                        validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _dosageController,
                              label: 'الجرعة',
                              icon: PhosphorIconsRegular.scales,
                              keyboardType: TextInputType.number,
                              validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              controller: _unitController,
                              label: 'الوحدة (ملجم، مل...)',
                              icon: PhosphorIconsRegular.hash,
                              validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _notesController,
                        label: 'ملاحظات وإرشادات',
                        icon: PhosphorIconsRegular.notePencil,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                AppButton(
                  text: 'حفظ التعديلات',
                  onPressed: _onSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
