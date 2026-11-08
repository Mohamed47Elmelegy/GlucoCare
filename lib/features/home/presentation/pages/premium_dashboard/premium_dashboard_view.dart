import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/routes/route_constants.dart';
import '../../../../../core/widgets/app_top_bar.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../auth/presentation/cubit/auth_state.dart';
import '../../../../medication/presentation/cubit/medication_state.dart';
import '../../../../medication/presentation/cubit/insulin_state.dart';
import '../../widgets/dashboard_dose_timeline.dart';
import '../../widgets/dashboard_missed_dose_alert.dart';
import '../../widgets/dashboard_next_dose_card.dart';
import '../../widgets/dashboard_settings_button.dart';

class PremiumDashboardView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String userName = 'أحمد';
    if (authState is AuthAuthenticated) {
      final user = (authState as AuthAuthenticated).user;
      userName = user.name.split(' ').first;
    }

    String glucoseValue = '110';
    if (insulinState is InsulinLoaded) {
      final loaded = insulinState as InsulinLoaded;
      if (loaded.readings.isNotEmpty) {
        glucoseValue = loaded.readings.first.value.toStringAsFixed(0);
      }
    }

    int totalMeds = 4;
    int takenMeds = 3;
    if (medState is TodayScheduleLoaded) {
      final loaded = medState as TodayScheduleLoaded;
      totalMeds = loaded.activeMedications.length;
      takenMeds = loaded.takenHistory.length;
    }
    final int adherencePercentage = totalMeds > 0 ? ((takenMeds / totalMeds) * 100).toInt() : 75;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: const AppTopBar(
        title: 'صحتي',
        actions: [DashboardSettingsButton()],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Welcome Greeting Header
            _buildWelcomeHeader(userName, isDark),
            const SizedBox(height: 20),

            // 2. Missed Dose Alert (adds its own spacing; hidden when none)
            const DashboardMissedDoseAlert(),

            // 3. Bento Grid: Adherence & Metrics
            _buildBentoGrid(adherencePercentage, glucoseValue, isDark),
            const SizedBox(height: 24),

            // 4. Upcoming Dose Featured Card
            const DashboardNextDoseCard(),
            const SizedBox(height: 24),

            // 5. Quick Actions
            _buildQuickActions(context, isDark),
            const SizedBox(height: 28),

            // 6. Today's Timeline
            const DashboardDoseTimeline(),
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

  Widget _buildQuickActions(BuildContext context, bool isDark) {
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
}

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
