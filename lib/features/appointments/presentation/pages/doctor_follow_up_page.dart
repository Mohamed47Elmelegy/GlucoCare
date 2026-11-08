import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class DoctorAppointmentItem {
  final String id;
  final String doctorName;
  final String specialty;
  final String date;
  final String time;
  final String notes;
  final String status;
  final bool isUpcoming;

  const DoctorAppointmentItem({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.notes,
    required this.status,
    this.isUpcoming = false,
  });
}

class DoctorFollowUpPage extends StatefulWidget {
  const DoctorFollowUpPage({super.key});

  @override
  State<DoctorFollowUpPage> createState() => _DoctorFollowUpPageState();
}

class _DoctorFollowUpPageState extends State<DoctorFollowUpPage> {
  final List<DoctorAppointmentItem> _appointments = [
    const DoctorAppointmentItem(
      id: '1',
      doctorName: 'د. أحمد كمال',
      specialty: 'استشاري أمراض القلب والأوعية',
      date: '15 أكتوبر 2026',
      time: '10:30 صباحاً',
      notes: 'متابعة دورية لتنظيم ضغط الدم ومراجعة فاعلية جرعة ليبيدور.',
      status: 'موعد قريب',
      isUpcoming: true,
    ),
    const DoctorAppointmentItem(
      id: '2',
      doctorName: 'د. سارة المنصوري',
      specialty: 'أخصائية الغدد الصماء والسكري',
      date: '12 سبتمبر 2026',
      time: '04:00 مساءً',
      notes: 'فحص السكر التراكمي ومراجعة جرعات الأنسولين.',
      status: 'تمت الزيارة',
      isUpcoming: false,
    ),
    const DoctorAppointmentItem(
      id: '3',
      doctorName: 'د. خالد العتيبي',
      specialty: 'استشاري الباطنية والجهاز الهضمي',
      date: '05 أغسطس 2026',
      time: '11:00 صباحاً',
      notes: 'فحص شامل ومتابعة وظائف الكبد والكلى.',
      status: 'تمت الزيارة',
      isUpcoming: false,
    ),
  ];

  void _showAddDoctorSheet() {
    final nameCtrl = TextEditingController();
    final specCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: 'غداً، 11:00 ص');
    final notesCtrl = TextEditingController();

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
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
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
                    'إضافة موعد طبيب جديد',
                    style: AppTextStyles.h2.copyWith(
                      color: isDark
                          ? AppColors.darkText
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'سجل بيانات الطبيب وتفاصيل الزيارة القادمة',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: nameCtrl,
                    label: 'اسم الطبيب',
                    icon: PhosphorIconsRegular.user,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: specCtrl,
                    label: 'التخصص الطبي',
                    icon: PhosphorIconsRegular.stethoscope,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: dateCtrl,
                    label: 'تاريخ ووقت الموعد',
                    icon: PhosphorIconsRegular.calendar,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: notesCtrl,
                    label: 'ملاحظات وتوصيات',
                    icon: PhosphorIconsRegular.note,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'حفظ الموعد',
                    onPressed: () {
                      if (nameCtrl.text.isNotEmpty) {
                        setState(() {
                          _appointments.insert(
                            0,
                            DoctorAppointmentItem(
                              id: DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                              doctorName: nameCtrl.text,
                              specialty: specCtrl.text.isNotEmpty
                                  ? specCtrl.text
                                  : 'طبيب عام',
                              date: dateCtrl.text,
                              time: 'صباحاً',
                              notes: notesCtrl.text.isNotEmpty
                                  ? notesCtrl.text
                                  : 'متابعة وفحص عام',
                              status: 'موعد قريب',
                              isUpcoming: true,
                            ),
                          );
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تمت إضافة موعد الطبيب بنجاح'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
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
    final upcoming = _appointments.where((a) => a.isUpcoming).toList();
    final past = _appointments.where((a) => !a.isUpcoming).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: const AppTopBar(title: 'صحتي'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'متابعة الأطباء',
                        style: AppTextStyles.h1.copyWith(
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.textPrimary,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'إدارة مواعيدك واستشاراتك الطبية',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 120,
                  child: ElevatedButton.icon(
                    onPressed: _showAddDoctorSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(PhosphorIconsBold.plus, size: 16),
                    label: Text(
                      'إضافة موعد',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Upcoming Appointments Header
            if (upcoming.isNotEmpty) ...[
              Text(
                'المواعيد القادمة',
                style: AppTextStyles.h3.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...upcoming.map((app) => _buildUpcomingCard(app, isDark)),
              const SizedBox(height: 28),
            ],

            // Past Appointments Header
            Text(
              'سجل الزيارات السابقة',
              style: AppTextStyles.h3.copyWith(
                color: isDark ? AppColors.darkText : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...past.map((app) => _buildPastCard(app, isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingCard(DoctorAppointmentItem item, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor Profile Row
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.statusUpcomingBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Icon(
                    PhosphorIconsFill.stethoscope,
                    color: AppColors.primary,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.doctorName,
                      style: AppTextStyles.h3.copyWith(
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.specialty,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.statusUpcomingBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.status,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.statusUpcomingText,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Date & Time Chips Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  PhosphorIconsBold.calendar,
                  color: AppColors.primary,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  item.date,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(width: 1, height: 14, color: AppColors.border),
                const Spacer(),
                const Icon(
                  PhosphorIconsBold.clock,
                  color: AppColors.primary,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  item.time,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Notes
          Text(
            item.notes,
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkText.withValues(alpha: 0.8)
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('جاري الاتصال بـ ${item.doctorName}...'),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(PhosphorIconsBold.phone, size: 16),
                  label: const Text('اتصال'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم فتح موقع العيادة')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(PhosphorIconsBold.navigationArrow, size: 16),
                  label: const Text('الموقع'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPastCard(DoctorAppointmentItem item, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                PhosphorIconsRegular.userCheck,
                color: AppColors.textSecondary,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.doctorName,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${item.specialty} • ${item.date}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.statusTakenBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              item.status,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.statusTakenText,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
