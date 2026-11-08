import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/widgets/app_top_bar.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../domain/entities/insulin_reading.dart';
import '../../cubit/insulin_cubit.dart';
import 'insulin_readings_listener.dart';

class InsulinReadingsPage extends StatefulWidget {
  const InsulinReadingsPage({super.key});

  @override
  State<InsulinReadingsPage> createState() => _InsulinReadingsPageState();
}

class _InsulinReadingsPageState extends State<InsulinReadingsPage> {
  final _readingController = TextEditingController();
  final _noteController = TextEditingController();
  ReadingType _selectedReadingType = ReadingType.fasting;

  @override
  void initState() {
    super.initState();
    context.read<InsulinCubit>().loadReadings();
  }

  @override
  void dispose() {
    _readingController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _addReading() {
    final value = double.tryParse(_readingController.text);
    if (value == null) return;

    final reading = InsulinReading(
      id: const Uuid().v4(),
      value: value,
      readingType: _selectedReadingType,
      timestamp: DateTime.now(),
      note: _noteController.text.isEmpty ? null : _noteController.text,
    );

    context.read<InsulinCubit>().addReading(reading: reading);
    Navigator.pop(context);
    _readingController.clear();
    _noteController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تسجيل قراءة السكر بنجاح'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'تسجيل قراءة سكر جديدة',
                    style: AppTextStyles.h2.copyWith(
                      color: isDark
                          ? AppColors.darkText
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'أدخل قيمة السكر وتوقيت القياس لمتابعة دقيقة',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: _readingController,
                    label: 'قيمة السكر (mg/dL)',
                    icon: PhosphorIconsRegular.drop,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<ReadingType>(
                        value: _selectedReadingType,
                        isExpanded: true,
                        icon: const Icon(PhosphorIconsBold.caretDown, size: 16),
                        style: AppTextStyles.body.copyWith(
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.textPrimary,
                          fontSize: 14,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: ReadingType.fasting,
                            child: Text('صائم'),
                          ),
                          DropdownMenuItem(
                            value: ReadingType.postprandial,
                            child: Text('بعد الأكل'),
                          ),
                          DropdownMenuItem(
                            value: ReadingType.beforeSleep,
                            child: Text('قبل النوم'),
                          ),
                          DropdownMenuItem(
                            value: ReadingType.hba1c,
                            child: Text('تراكمي'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => _selectedReadingType = val);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: _noteController,
                    label: 'ملاحظات (اختياري)',
                    icon: PhosphorIconsRegular.notePencil,
                  ),
                  const SizedBox(height: 24),
                  AppButton(text: 'حفظ القراءة', onPressed: _addReading),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(title: 'صحتي'),
      body: const InsulinReadingsListener(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          heroTag: 'insulin-readings-list-add',
          onPressed: _showAddDialog,
          backgroundColor: AppColors.primary,
          elevation: 6,
          child: const Icon(
            PhosphorIconsBold.plus,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }
}
