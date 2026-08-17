import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/routes/route_constants.dart';
import '../../../../../core/widgets/app_top_bar.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../auth/presentation/cubit/auth_state.dart';
import '../../../../medication/presentation/cubit/medication_state.dart';
import '../../../../medication/presentation/cubit/insulin_state.dart';

class PremiumDashboardView extends StatefulWidget {
  final AuthState authState;
  final MedicationState medState;
  final InsulinState insulinState;

  const PremiumDashboardView({
    super.key,
    required this.authState,
    required this.medState,
    required this.insulinState,
  });

  @override
  State<PremiumDashboardView> createState() => _PremiumDashboardViewState();
}

class _PremiumDashboardViewState extends State<PremiumDashboardView> {
  bool _snoozed = false;
  bool _doseTaken = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String userName = 'أحمد';
    if (widget.authState is AuthAuthenticated) {
      final user = (widget.authState as AuthAuthenticated).user;
      userName = user.name.split(' ').first;
    }

    String glucoseValue = '110';
    if (widget.insulinState is InsulinLoaded) {
      final loaded = widget.insulinState as InsulinLoaded;
      if (loaded.readings.isNotEmpty) {
        glucoseValue = loaded.readings.first.value.toStringAsFixed(0);
      }
    }

    int totalMeds = 4;
    int takenMeds = 3;
    if (widget.medState is TodayScheduleLoaded) {
      final loaded = widget.medState as TodayScheduleLoaded;
      totalMeds = loaded.activeMedications.length;
      takenMeds = loaded.takenHistory.length;
    }
    final int adherencePercentage = totalMeds > 0 ? ((takenMeds / totalMeds) * 100).toInt() : 75;

    final String todayDate = DateFormat('EEEE، d MMMM', 'ar').format(DateTime.now());

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: const AppTopBar(title: 'صحتي'),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Welcome Greeting Header
            _buildWelcomeHeader(userName, isDark),
            const SizedBox(height: 20),

            // 2. Missed Dose Alert
            _buildMissedDoseAlert(isDark),
            const SizedBox(height: 20),

            // 3. Bento Grid: Adherence & Metrics
            _buildBentoGrid(adherencePercentage, glucoseValue, isDark),
            const SizedBox(height: 24),

            // 4. Upcoming Dose Featured Card
            _buildUpcomingDoseCard(isDark),
            const SizedBox(height: 24),

            // 5. Quick Actions
            _buildQuickActions(isDark),
            const SizedBox(height: 28),

            // 6. Today's Timeline
            _buildTodayTimeline(todayDate, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(String name, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'صباح الخير، $name 👋',
          style: AppTextStyles.h1.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkText : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'نتمنى لك يوماً صحياً ومليئاً بالنشاط.',
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildMissedDoseAlert(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.statusMissedBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFFECACA),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            PhosphorIconsFill.warningCircle,
            color: AppColors.statusMissedText,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'جرعة فائتة!',
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.statusMissedText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'لقد فاتك موعد "أموريل 2مجم" الساعة 8:00 صباحاً.',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 12,
                    color: AppColors.statusMissedText,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تسجيل تناول الجرعة الفائتة بنجاح'),
                  backgroundColor: AppColors.secondary,
                ),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'تدارك الآن',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.statusMissedText,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoGrid(int adherence, String glucose, bool isDark) {
    return Row(
      children: [
        // Left Card: Adherence Ring
        Expanded(
          flex: 1,
          child: Container(
            height: 160,
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
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CustomPaint(
                    painter: _ProgressRingPainter(
                      progress: adherence / 100.0,
                      progressColor: AppColors.primary,
                      backgroundColor: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                    ),
                    child: Center(
                      child: Text(
                        '$adherence%',
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'نسبة الالتزام اليومي',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Right Stacked Column
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 160,
            child: Column(
              children: [
                // Top: Glucose Card (Primary Blue)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        const Icon(
                          PhosphorIconsFill.drop,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'نسبة السكر',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 11,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: glucose,
                                    style: AppTextStyles.h3.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' mg/dL',
                                    style: AppTextStyles.caption.copyWith(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Bottom: Steps Card (White)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.statusTakenBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            PhosphorIconsFill.footprints,
                            color: AppColors.statusTakenText,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'الخطوات',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              '4,230',
                              style: AppTextStyles.h3.copyWith(
                                color: isDark ? AppColors.darkText : AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingDoseCard(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'الجرعة القادمة',
              style: AppTextStyles.h2.copyWith(
                color: isDark ? AppColors.darkText : AppColors.textPrimary,
                fontSize: 18,
              ),
            ),
            GestureDetector(
              onTap: () => context.push(RouteConstants.medicationHistory),
              child: Text(
                'التفاصيل',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
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
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.statusUpcomingBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        PhosphorIconsFill.pill,
                        color: AppColors.primary,
                        size: 28,
                      ),
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
                              'ميتفورمين 500مجم',
                              style: AppTextStyles.h3.copyWith(
                                color: isDark ? AppColors.darkText : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.statusUpcomingBg,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _snoozed ? 'تم التأجيل' : 'خلال 45 د',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.statusUpcomingText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              PhosphorIconsRegular.clock,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '1:30 ظهراً - بعد الغداء',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _doseTaken
                          ? null
                          : () {
                              setState(() => _doseTaken = true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تم تسجيل تناول الجرعة بنجاح!'),
                                  backgroundColor: AppColors.secondary,
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _doseTaken ? AppColors.secondary : AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 46),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        _doseTaken ? PhosphorIconsBold.check : PhosphorIconsBold.checkCircle,
                        size: 18,
                      ),
                      label: Text(
                        _doseTaken ? 'تم التناول' : 'تم التناول',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => _snoozed = true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم تأجيل الجرعة لمدة 15 دقيقة'),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.border),
                        minimumSize: const Size(double.infinity, 46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'تأجيل 15د',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkText : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(bool isDark) {
    return Row(
      children: [
        _buildActionItem(
          icon: PhosphorIconsFill.plusCircle,
          iconColor: AppColors.primary,
          bgColor: AppColors.statusUpcomingBg,
          label: 'إضافة دواء',
          onTap: () => context.push(RouteConstants.addMedication),
          isDark: isDark,
        ),
        const SizedBox(width: 12),
        _buildActionItem(
          icon: PhosphorIconsFill.drop,
          iconColor: AppColors.danger,
          bgColor: const Color(0xFFFEE2E2),
          label: 'أنسولين',
          onTap: () => context.push(RouteConstants.insulinReadings),
          isDark: isDark,
        ),
        const SizedBox(width: 12),
        _buildActionItem(
          icon: PhosphorIconsFill.firstAid,
          iconColor: AppColors.secondary,
          bgColor: AppColors.statusTakenBg,
          label: 'استشارة',
          onTap: () => context.push(RouteConstants.labTests),
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
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
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.textPrimary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTodayTimeline(String date, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'جدول اليوم',
              style: AppTextStyles.h2.copyWith(
                color: isDark ? AppColors.darkText : AppColors.textPrimary,
                fontSize: 18,
              ),
            ),
            Text(
              date,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Timeline Items
        _buildTimelineEntry(
          time: '08:00 ص',
          title: 'أموريل 2مجم',
          subtitle: 'قرص واحد قبل الإفطار',
          status: 'لم يتم',
          statusType: _TimelineStatus.missed,
          isDark: isDark,
          isFirst: true,
          isLast: false,
        ),
        _buildTimelineEntry(
          time: '10:00 ص',
          title: 'فيتامين د3',
          subtitle: '50,000 وحدة دولية',
          status: 'تم التناول',
          statusType: _TimelineStatus.taken,
          isDark: isDark,
          isFirst: false,
          isLast: false,
        ),
        _buildTimelineEntry(
          time: '01:30 ظ',
          title: 'ميتفورمين 500مجم',
          subtitle: 'قرص واحد بعد الغداء',
          status: 'قادمة',
          statusType: _TimelineStatus.upcoming,
          isDark: isDark,
          isFirst: false,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildTimelineEntry({
    required String time,
    required String title,
    required String subtitle,
    required String status,
    required _TimelineStatus statusType,
    required bool isDark,
    required bool isFirst,
    required bool isLast,
  }) {
    Color iconColor;
    Color iconBg;
    IconData icon;
    Color chipBg;
    Color chipText;

    switch (statusType) {
      case _TimelineStatus.missed:
        iconColor = AppColors.danger;
        iconBg = Colors.white;
        icon = PhosphorIconsBold.x;
        chipBg = AppColors.statusMissedBg;
        chipText = AppColors.statusMissedText;
        break;
      case _TimelineStatus.taken:
        iconColor = AppColors.statusTakenText;
        iconBg = Colors.white;
        icon = PhosphorIconsBold.check;
        chipBg = AppColors.statusTakenBg;
        chipText = AppColors.statusTakenText;
        break;
      case _TimelineStatus.upcoming:
        iconColor = AppColors.primary;
        iconBg = Colors.white;
        icon = PhosphorIconsFill.bell;
        chipBg = AppColors.statusUpcomingBg;
        chipText = AppColors.statusUpcomingText;
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Vertical Line & Dot Column
          SizedBox(
            width: 36,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Connecting line
                Positioned(
                  top: isFirst ? 18 : 0,
                  bottom: isLast ? 18 : 0,
                  child: Container(
                    width: 2,
                    color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                  ),
                ),
                // Badge Icon
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? AppColors.darkSurface : iconBg,
                    border: Border.all(color: iconColor, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: iconColor.withValues(alpha: 0.15),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(icon, size: 16, color: iconColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Content Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        time,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: chipBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          status,
                          style: AppTextStyles.caption.copyWith(
                            color: chipText,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: AppTextStyles.h3.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _TimelineStatus { missed, taken, upcoming }

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;

  _ProgressRingPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 6;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
