import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../../core/theme/bloc/theme_cubit.dart';
import '../../../../core/localization/bloc/locale_cubit.dart';
import '../../../../core/routes/route_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/theme_bottom_sheet.dart';
import '../widgets/language_bottom_sheet.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _doseReminders = true;
  bool _insulinReminders = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _criticalAlerts = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: const AppTopBar(title: 'صحتي'),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          String userName = 'أحمد محمد';
          String email = 'ahmed@example.com';
          if (authState is AuthAuthenticated) {
            userName = authState.user.name;
            email = authState.user.email ?? '';
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Banner Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.statusUpcomingBg,
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: const Center(
                          child: Icon(
                            PhosphorIconsFill.user,
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
                            Text(
                              userName,
                              style: AppTextStyles.h3.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkText : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              email,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(PhosphorIconsRegular.pencilSimple, color: AppColors.primary),
                        onPressed: () => context.push(RouteConstants.editProfile),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Reminders & Notifications Section
                Text(
                  'إعدادات التنبيهات',
                  style: AppTextStyles.h3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildSwitchTile(
                        icon: PhosphorIconsRegular.bell,
                        title: 'تنبيهات مواعيد الأدوية',
                        subtitle: 'إشعار فوري عند حلول وقت الجرعة',
                        value: _doseReminders,
                        onChanged: (val) => setState(() => _doseReminders = val),
                        isDark: isDark,
                      ),
                      const Divider(height: 1, color: AppColors.border),
                      _buildSwitchTile(
                        icon: PhosphorIconsRegular.drop,
                        title: 'تنبيهات فحص السكر',
                        subtitle: 'تذكير دوري بقياس السكر صائم وبعد الأكل',
                        value: _insulinReminders,
                        onChanged: (val) => setState(() => _insulinReminders = val),
                        isDark: isDark,
                      ),
                      const Divider(height: 1, color: AppColors.border),
                      _buildSwitchTile(
                        icon: PhosphorIconsRegular.speakerHigh,
                        title: 'أصوات التنبيه والنغمات',
                        subtitle: 'تشغيل نغمة طبية مميزة عند التنبيه',
                        value: _soundEnabled,
                        onChanged: (val) => setState(() => _soundEnabled = val),
                        isDark: isDark,
                      ),
                      const Divider(height: 1, color: AppColors.border),
                      _buildSwitchTile(
                        icon: PhosphorIconsRegular.shieldWarning,
                        title: 'تنبيهات الجرعات الحرجة',
                        subtitle: 'تكرار التنبيه حتى يتم تسجيل تناول الجرعة',
                        value: _criticalAlerts,
                        onChanged: (val) => setState(() => _criticalAlerts = val),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // General Preferences Section
                Text(
                  'التفضيلات العامة',
                  style: AppTextStyles.h3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(PhosphorIconsRegular.moon, color: AppColors.primary),
                        title: Text('المظهر (الثيم)', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                        trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                          builder: (context, mode) => Text(
                            mode == ThemeMode.dark ? 'الوضع الليلي' : 'الوضع الفاتح',
                            style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (_) => const ThemeBottomSheet(),
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.border),
                      ListTile(
                        leading: const Icon(PhosphorIconsRegular.globe, color: AppColors.primary),
                        title: Text('اللغة', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                        trailing: BlocBuilder<LocaleCubit, Locale>(
                          builder: (context, locale) => Text(
                            locale.languageCode == 'ar' ? 'العربية' : 'English',
                            style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (_) => const LanguageBottomSheet(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      DialogUtils.showConfirmationDialog(
                        context: context,
                        title: l10n.logout,
                        content: l10n.confirmLogout,
                        confirmText: l10n.logout,
                        cancelText: l10n.cancel,
                        confirmColor: AppColors.danger,
                        onConfirm: () => context.read<AuthCubit>().logout(),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: const BorderSide(color: AppColors.danger, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(PhosphorIconsRegular.signOut, size: 20),
                    label: Text(
                      l10n.logout,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.danger,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: isDark ? AppColors.darkText : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.caption.copyWith(
          fontSize: 11,
          color: AppColors.textSecondary,
        ),
      ),
      value: value,
      activeColor: AppColors.primary,
      onChanged: onChanged,
    );
  }
}
