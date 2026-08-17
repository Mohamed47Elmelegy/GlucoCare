import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../core/routes/route_constants.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/widgets/app_top_bar.dart';
import '../../../domain/entities/medication.dart';

class MedicationListView extends StatefulWidget {
  final bool isLoading;
  final bool hasError;
  final List<Medication> medications;
  final VoidCallback onRetry;

  const MedicationListView({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.medications,
    required this.onRetry,
  });

  @override
  State<MedicationListView> createState() => _MedicationListViewState();
}

class _MedicationListViewState extends State<MedicationListView> {
  String _selectedFilter = 'الكل';
  final TextEditingController _searchController = TextEditingController();
  final Map<String, bool> _medToggles = {};

  final List<String> _filters = [
    'الكل',
    'الصباح',
    'الظهيرة',
    'المساء',
    'عند الحاجة',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (widget.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppTopBar(title: 'صحتي'),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (widget.hasError) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
        appBar: const AppTopBar(title: 'صحتي'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                PhosphorIconsFill.warningCircle,
                size: 56,
                color: AppColors.danger,
              ),
              const SizedBox(height: 16),
              Text(
                'حدث خطأ في تحميل الأدوية',
                style: AppTextStyles.h3.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: widget.onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    final query = _searchController.text.trim().toLowerCase();
    final filteredMeds = widget.medications.where((med) {
      final matchesSearch = query.isEmpty ||
          med.name.toLowerCase().contains(query) ||
          med.dosage.toLowerCase().contains(query);
      if (!matchesSearch) return false;

      if (_selectedFilter == 'الكل') return true;
      if (_selectedFilter == 'الصباح') {
        return med.mealSlots.any((s) => s.label.contains('إفطار') || s.label.contains('صباح'));
      }
      if (_selectedFilter == 'الظهيرة') {
        return med.mealSlots.any((s) => s.label.contains('غداء') || s.label.contains('ظهر'));
      }
      if (_selectedFilter == 'المساء') {
        return med.mealSlots.any((s) => s.label.contains('عشاء') || s.label.contains('مساء') || s.label.contains('نوم'));
      }
      if (_selectedFilter == 'عند الحاجة') {
        return med.type.name.toLowerCase().contains('prn') || med.mealSlots.isEmpty;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: const AppTopBar(title: 'صحتي'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              'قائمة الأدوية',
              style: AppTextStyles.h1.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkText : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'تتبع مواعيد أدويتك اليومية بدقة',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),

            // Search Bar
            Container(
              height: 52,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'ابحث عن دواء...',
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
            const SizedBox(height: 16),

            // Filter Chips Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedFilter = filter);
                      },
                      selectedColor: AppColors.primary,
                      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isDark ? AppColors.darkText : AppColors.textSecondary),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark ? AppColors.darkBorder : AppColors.border),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Active Prescription Featured Card (Bento Style)
            _buildActivePrescriptionCard(isDark),
            const SizedBox(height: 18),

            // Medications List
            if (filteredMeds.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(
                      PhosphorIconsLight.pill,
                      size: 64,
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'لا توجد أدوية مطابقة',
                      style: AppTextStyles.h3.copyWith(
                        color: isDark ? AppColors.darkText : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...filteredMeds.map((med) => _buildMedicationCard(med, isDark)),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          onPressed: () => context.push(RouteConstants.addMedication),
          backgroundColor: AppColors.primary,
          elevation: 6,
          child: const Icon(PhosphorIconsBold.plus, color: Colors.white, size: 26),
        ),
      ),
    );
  }

  Widget _buildActivePrescriptionCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                PhosphorIconsFill.sealCheck,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                'وصفة علاجية نشطة',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'ميتفورمين 500 ملغ',
            style: AppTextStyles.h2.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'جرعة استراتيجية لتنظيم السكر التراكمي. يجب تناوله بعد الوجبة الأساسية.',
            style: AppTextStyles.body.copyWith(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(PhosphorIconsRegular.clock, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      'مرتان يومياً',
                      style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(PhosphorIconsRegular.archive, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      'المتبقي: 14 حبة',
                      style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationCard(Medication med, bool isDark) {
    final isEnabled = _medToggles[med.id] ?? true;
    final isInjection = med.type.name.toLowerCase().contains('injection');

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Icon + Switch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: isInjection ? AppColors.statusMissedBg : AppColors.statusUpcomingBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    isInjection ? PhosphorIconsFill.syringe : PhosphorIconsFill.pill,
                    color: isInjection ? AppColors.danger : AppColors.primary,
                    size: 24,
                  ),
                ),
              ),
              Switch(
                value: isEnabled,
                activeColor: AppColors.primary,
                onChanged: (val) {
                  setState(() {
                    _medToggles[med.id] = val;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Name
          Text(
            med.name,
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? AppColors.darkText : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),

          // Dosage & Frequency
          Text(
            '${med.dosage} ${med.unit} • ${med.mealSlots.map((s) => s.label).join("، ")}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 10),

          // Bottom Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الموعد القادم',
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '10:00 مساءً',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.statusUpcomingBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'قادم',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.statusUpcomingText,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
