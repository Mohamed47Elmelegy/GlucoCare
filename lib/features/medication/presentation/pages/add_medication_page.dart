import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/medication.dart';
import '../../domain/entities/medication_type.dart';
import '../../domain/entities/meal_slot.dart';
import '../../domain/entities/schedule_type.dart';
import '../widgets/dose_schedule_card_widget.dart';
import '../widgets/medication_type_selector_widget.dart';
import '../cubit/medication_cubit.dart';
import '../cubit/medication_state.dart';

class AddMedicationPage extends StatefulWidget {
  const AddMedicationPage({super.key});

  @override
  State<AddMedicationPage> createState() => _AddMedicationPageState();
}

class _AddMedicationPageState extends State<AddMedicationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController(text: '1');
  String _selectedUnit = 'ملجم (mg)';
  MedicationType _selectedType = MedicationType.pill;
  List<MealSlot> _doseSlots = MealSlot.forDailyDoses(2);
  final Map<MealSlot, TimeOfDay> _doseTimes = {
    for (final slot in MealSlot.values)
      slot: TimeOfDay(hour: slot.defaultTime.hour, minute: slot.defaultTime.minute),
  };
  String _mealRelation = 'بعد الأكل';
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _stockController = TextEditingController(text: '30');
  final TextEditingController _durationController = TextEditingController();

  final List<String> _units = [
    'ملجم (mg)',
    'مل (ml)',
    'كبسولة',
    'قرص',
    'وحدة (IU)',
    'قطرة',
  ];

  final List<String> _mealRelations = [
    'قبل الأكل',
    'بعد الأكل',
    'مع الأكل',
    'بدون وجبة',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _notesController.dispose();
    _stockController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      // Empty duration = ongoing treatment. The validator guarantees a valid
      // number otherwise.
      final durationDays = int.tryParse(_durationController.text.trim());
      final newMed = Medication(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        dosage: _dosageController.text.trim(),
        unit: _selectedUnit,
        type: _selectedType,
        notes: '${_notesController.text.trim()} • $_mealRelation',
        mealSlots: _doseSlots,
        customTimes: {for (final slot in _doseSlots) slot: _doseTimes[slot]!},
        scheduleType:
            durationDays == null ? ScheduleType.daily : ScheduleType.fixedDuration,
        startDate: DateTime.now(),
        durationDays: durationDays,
        isActive: true,
      );

      context.read<MedicationCubit>().addMedication(medication: newMed);
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
                // Title Section
                Text(
                  'إضافة دواء جديد',
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkText : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'أدخل تفاصيل الدواء والجدول الزمني بدقة',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),

                // Card 1: Medication Name
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
                        label: 'مثلاً: بنادول، لانتوس...',
                        icon: PhosphorIconsRegular.magnifyingGlass,
                        validator: (v) => v == null || v.isEmpty ? 'يرجى إدخال اسم الدواء' : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Card 2: Dose & Unit
                _buildCard(
                  isDark: isDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الجرعة والوحدة',
                        style: AppTextStyles.h3.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkText : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _dosageController,
                              label: 'كمية الجرعة',
                              icon: PhosphorIconsRegular.scales,
                              keyboardType: TextInputType.number,
                              validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 52,
                              margin: const EdgeInsets.only(top: 26),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkSurface : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isDark ? AppColors.darkBorder : AppColors.border,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedUnit,
                                  isExpanded: true,
                                  icon: const Icon(PhosphorIconsBold.caretDown, size: 16),
                                  style: AppTextStyles.body.copyWith(
                                    color: isDark ? AppColors.darkText : AppColors.textPrimary,
                                    fontSize: 13,
                                  ),
                                  items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _selectedUnit = val);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Card 3: Medication Type
                _buildCard(
                  isDark: isDark,
                  child: MedicationTypeSelectorWidget(
                    selected: _selectedType,
                    onChanged: (type) => setState(() => _selectedType = type),
                  ),
                ),
                const SizedBox(height: 14),

                // Card 4: Dose Schedule (count, times, duration)
                _buildCard(
                  isDark: isDark,
                  child: DoseScheduleCardWidget(
                    slots: _doseSlots,
                    doseTimes: _doseTimes,
                    durationController: _durationController,
                    onDoseCountChanged: (count) => setState(
                      () => _doseSlots = MealSlot.forDailyDoses(count),
                    ),
                    onDoseTimeChanged: (slot, time) =>
                        setState(() => _doseTimes[slot] = time),
                  ),
                ),
                const SizedBox(height: 14),

                // Card 5: Meal Relation
                _buildCard(
                  isDark: isDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'علاقة الدواء بالطعام',
                        style: AppTextStyles.h3.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkText : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: _mealRelations.map((relation) {
                          final isSelected = _mealRelation == relation;
                          return ChoiceChip(
                            label: Text(relation),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) setState(() => _mealRelation = relation);
                            },
                            selectedColor: AppColors.primary,
                            backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : (isDark ? AppColors.darkText : AppColors.textPrimary),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : AppColors.border,
                              ),
                            ),
                            showCheckmark: false,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Card 6: Inventory & Notes
                _buildCard(
                  isDark: isDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'المخزون والملاحظات',
                        style: AppTextStyles.h3.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkText : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _stockController,
                        label: 'كمية الحبوب المتوفرة للتنبيه',
                        icon: PhosphorIconsRegular.archive,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _notesController,
                        label: 'ملاحظات إضافية (اختياري)',
                        icon: PhosphorIconsRegular.notePencil,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Submit Button
                AppButton(
                  text: 'حفظ الدواء',
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
