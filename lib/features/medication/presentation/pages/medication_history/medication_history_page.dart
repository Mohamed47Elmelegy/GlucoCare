import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/widgets/app_top_bar.dart';
import '../../cubit/medication_cubit.dart';
import '../../cubit/medication_state.dart';
import '../../../domain/entities/dose_history.dart';

class MedicationHistoryPage extends StatefulWidget {
  const MedicationHistoryPage({super.key});

  @override
  State<MedicationHistoryPage> createState() => _MedicationHistoryPageState();
}

class _MedicationHistoryPageState extends State<MedicationHistoryPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    context.read<MedicationCubit>().loadTodaySchedule(date: _selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: const AppTopBar(title: 'صحتي'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'سجل الأدوية اليومي',
              style: AppTextStyles.h1.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkText : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'متابعة الجرعات المتناولة ومواعيد الالتزام',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),

            // Horizontal Date Selector Strip
            _buildDateStrip(isDark),
            const SizedBox(height: 20),

            // Daily Adherence Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(PhosphorIconsFill.checkCircle, color: Colors.white, size: 26),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'نسبة إنجاز اليوم: 75%',
                          style: AppTextStyles.h3.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'تم تناول 3 من أصل 4 جرعات محددة',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Timeline Schedule For Day
            Text(
              'الجدول الزمني للجرعات',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkText : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),

            BlocBuilder<MedicationCubit, MedicationState>(
              builder: (context, state) {
                if (state is MedicationLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  );
                }

                return Column(
                  children: [
                    _buildLogItem(
                      time: '08:00 ص',
                      name: 'أموريل 2مجم',
                      dose: 'قرص واحد قبل الإفطار',
                      status: 'تم التناول في الموعد',
                      statusType: _LogStatus.taken,
                      isDark: isDark,
                    ),
                    _buildLogItem(
                      time: '01:30 ظ',
                      name: 'ميتفورمين 500مجم',
                      dose: 'قرص واحد بعد الغداء',
                      status: 'تم التناول في الموعد',
                      statusType: _LogStatus.taken,
                      isDark: isDark,
                    ),
                    _buildLogItem(
                      time: '06:00 م',
                      name: 'لانتوس أنسولين',
                      dose: '12 وحدة تحت الجلد',
                      status: 'فائتة',
                      statusType: _LogStatus.missed,
                      isDark: isDark,
                    ),
                    _buildLogItem(
                      time: '10:00 م',
                      name: 'ليبيدور 20 ملغ',
                      dose: 'حبة واحدة قبل النوم',
                      status: 'قادمة',
                      statusType: _LogStatus.upcoming,
                      isDark: isDark,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateStrip(bool isDark) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));

    return SizedBox(
      height: 76,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = startOfWeek.add(Duration(days: index));
          final isSelected = DateUtils.isSameDay(_selectedDate, date);
          final dayName = DateFormat('E', 'ar').format(date);
          final dayNumber = date.day;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedDate = date);
              _loadHistory();
            },
            child: Container(
              width: 52,
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.darkSurface : Colors.white),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.darkBorder : AppColors.border),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.9)
                          : AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$dayNumber',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.darkText : AppColors.textPrimary),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogItem({
    required String time,
    required String name,
    required String dose,
    required String status,
    required _LogStatus statusType,
    required bool isDark,
  }) {
    Color chipBg;
    Color chipText;
    IconData icon;

    switch (statusType) {
      case _LogStatus.taken:
        chipBg = AppColors.statusTakenBg;
        chipText = AppColors.statusTakenText;
        icon = PhosphorIconsBold.check;
        break;
      case _LogStatus.missed:
        chipBg = AppColors.statusMissedBg;
        chipText = AppColors.statusMissedText;
        icon = PhosphorIconsBold.x;
        break;
      case _LogStatus.upcoming:
        chipBg = AppColors.statusUpcomingBg;
        chipText = AppColors.statusUpcomingText;
        icon = PhosphorIconsRegular.clock;
        break;
    }

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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: chipBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(icon, color: chipText, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.h3.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      time,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  dose,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _LogStatus { taken, missed, upcoming }
