import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/lab_test.dart';
import '../cubit/lab_test_cubit.dart';

class LabTestsPage extends StatefulWidget {
  const LabTestsPage({super.key});

  @override
  State<LabTestsPage> createState() => _LabTestsPageState();
}

class _LabTestsPageState extends State<LabTestsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'الكل';
  bool _isGridView = false;

  final List<String> _categories = [
    'الكل',
    'المختبر',
    'الأشعة',
    'الوصفات',
    'التقارير',
  ];

  @override
  void initState() {
    super.initState();
    context.read<LabTestCubit>().getLabTests();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddFileDialog() {
    final titleCtrl = TextEditingController();
    final resultCtrl = TextEditingController();
    final doctorCtrl = TextEditingController(text: 'مختبر البرج');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
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
                    'إضافة فحص أو تقرير طبي',
                    style: AppTextStyles.h2.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ارفع نتيجة التحليل أو التقرير لحفظها في ملفك الصحي',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: titleCtrl,
                    label: 'اسم الفحص / التقرير',
                    icon: PhosphorIconsRegular.fileText,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: resultCtrl,
                    label: 'النتيجة (مثلاً: 5.7 % أو طبيعي)',
                    icon: PhosphorIconsRegular.flask,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: doctorCtrl,
                    label: 'المختبر / الطبيب المعالج',
                    icon: PhosphorIconsRegular.buildings,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'حفظ الفحص',
                    onPressed: () {
                      if (titleCtrl.text.isNotEmpty) {
                        final newTest = LabTest(
                          id: const Uuid().v4(),
                          testName: titleCtrl.text.trim(),
                          result: resultCtrl.text.isNotEmpty ? resultCtrl.text.trim() : 'طبيعي',
                          unit: '',
                          referenceRange: '',
                          date: DateTime.now(),
                          notes: doctorCtrl.text.trim(),
                          category: 'Medical File',
                        );
                        context.read<LabTestCubit>().addLabTest(labTest: newTest);
                        Navigator.pop(ctx);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: const AppTopBar(title: 'صحتي'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              height: 52,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'البحث في الملفات الطبية...',
                  hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  prefixIcon: Icon(
                    PhosphorIconsRegular.magnifyingGlass,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Section Header & View Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ملفاتي الطبية',
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkText : AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _isGridView = true),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _isGridView ? (isDark ? AppColors.darkBackground : Colors.white) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: _isGridView ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)] : null,
                          ),
                          child: Icon(
                            PhosphorIconsRegular.squaresFour,
                            size: 18,
                            color: _isGridView ? AppColors.primary : AppColors.textSecondary,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _isGridView = false),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: !_isGridView ? (isDark ? AppColors.darkBackground : Colors.white) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: !_isGridView ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)] : null,
                          ),
                          child: Icon(
                            PhosphorIconsRegular.listBullets,
                            size: 18,
                            color: !_isGridView ? AppColors.primary : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) setState(() => _selectedCategory = cat);
                      },
                      selectedColor: AppColors.primary,
                      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : (isDark ? AppColors.darkText : AppColors.textSecondary),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.border),
                        ),
                      ),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Files Content
            BlocBuilder<LabTestCubit, LabTestState>(
              builder: (context, state) {
                if (state is LabTestLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  );
                }

                List<LabTest> tests = [];
                if (state is LabTestLoaded) {
                  tests = state.labTests;
                }

                if (tests.isEmpty) {
                  return _buildSampleMedicalFiles(isDark);
                }

                return _isGridView
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.88,
                        ),
                        itemCount: tests.length,
                        itemBuilder: (ctx, i) => _buildGridCard(tests[i], isDark),
                      )
                    : Column(
                        children: tests.map((t) => _buildListCard(t, isDark)).toList(),
                      );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton.extended(
          heroTag: 'lab-tests-add-file',
          onPressed: _showAddFileDialog,
          backgroundColor: AppColors.primary,
          elevation: 6,
          icon: const Icon(PhosphorIconsBold.scan, color: Colors.white, size: 20),
          label: Text(
            'مسح / رفع ملف',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSampleMedicalFiles(bool isDark) {
    final samples = [
      {
        'title': 'تحليل السكر التراكمي (HbA1c)',
        'date': '10 أكتوبر 2026',
        'facility': 'مختبر البرج',
        'status': 'طبيعي (5.6%)',
        'icon': PhosphorIconsFill.flask,
        'color': AppColors.secondary,
        'bg': AppColors.statusTakenBg,
      },
      {
        'title': 'أشعة الصدر السينية',
        'date': '15 سبتمبر 2026',
        'facility': 'مستشفى السلام الدولي',
        'status': 'سليم ومعتمد',
        'icon': PhosphorIconsFill.image,
        'color': AppColors.primary,
        'bg': AppColors.statusUpcomingBg,
      },
      {
        'title': 'وصفة أدوية السكري والضغط',
        'date': '01 سبتمبر 2026',
        'facility': 'د. أحمد كمال',
        'status': 'سارية',
        'icon': PhosphorIconsFill.prescription,
        'color': AppColors.warning,
        'bg': const Color(0xFFFEF3C7),
      },
      {
        'title': 'تقرير الفحص السنوي الشامل',
        'date': '20 أغسطس 2026',
        'facility': 'مركز النخبة الطبي',
        'status': 'مكتمل',
        'icon': PhosphorIconsFill.fileText,
        'color': const Color(0xFF9333EA),
        'bg': const Color(0xFFF3E8FF),
      },
    ];

    if (_isGridView) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.88,
        ),
        itemCount: samples.length,
        itemBuilder: (ctx, i) {
          final s = samples[i];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: s['bg'] as Color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(s['icon'] as IconData, color: s['color'] as Color, size: 22),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s['title'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.h3.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s['facility'] as String,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Text(
                  s['date'] as String,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Column(
      children: samples.map((s) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: s['bg'] as Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(s['icon'] as IconData, color: s['color'] as Color, size: 24),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s['title'] as String,
                      style: AppTextStyles.h3.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${s['facility']} • ${s['date']}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(PhosphorIconsRegular.downloadSimple, color: AppColors.primary),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('جاري فتح ملف ${s['title']}...')),
                  );
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildListCard(LabTest test, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.statusTakenBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(PhosphorIconsFill.flask, color: AppColors.secondary, size: 24),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  test.testName,
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${test.result} ${test.unit} • ${DateFormat('d MMMM yyyy', 'ar').format(test.date)}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(PhosphorIconsRegular.downloadSimple, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildGridCard(LabTest test, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.statusTakenBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(PhosphorIconsFill.flask, color: AppColors.secondary, size: 22),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                test.testName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.h3.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'النتيجة: ${test.result}',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Text(
            DateFormat('d MMM yyyy', 'ar').format(test.date),
            style: AppTextStyles.caption.copyWith(
              fontSize: 10,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
