import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../../core/theme/bloc/theme_cubit.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/profile_section.dart';
import '../widgets/settings_list_item.dart';
import '../widgets/theme_bottom_sheet.dart';

import '../widgets/language_bottom_sheet.dart';
import '../../../../core/localization/bloc/locale_cubit.dart';
import '../../../../core/routes/route_constants.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/widgets/premium_app_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: PremiumAppBar(
        title: l10n.settings,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) {
          return current is AuthSuccess || current is AuthUnauthenticated;
        },
        builder: (context, authState) {
          String userName = 'User';
          String? email;
          if (authState is AuthSuccess) {
            userName = authState.user.name;
            email = authState.user.email;
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
            children: [
              ProfileSection(email: email, userName: userName),
              const SizedBox(height: 40),
              SettingsListItem(
                assetPath: AppAssets.profile,
                title: l10n.accountInformation,
                onTap: () {
                  context.push(RouteConstants.editProfile);
                },
              ),
              SettingsListItem(
                icon: Icons.notifications_none,
                title: l10n.notifications,
                onTap: () {},
              ),
              SettingsListItem(
                icon: Icons.lock_outline,
                title: l10n.privacySecurity,
                onTap: () {},
              ),
              SettingsListItem(
                icon: Icons.brightness_6_outlined,
                title: l10n.theme,
                trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, themeMode) {
                    return Text(
                      _getThemeName(context, themeMode),
                      style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    );
                  },
                ),
                onTap: () => _showThemeBottomSheet(context),
              ),
              SettingsListItem(
                icon: Icons.language,
                title: l10n.language,
                trailing: BlocBuilder<LocaleCubit, Locale>(
                  builder: (context, locale) {
                    return Text(
                      locale.languageCode == 'ar' ? l10n.arabic : l10n.english,
                      style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    );
                  },
                ),
                onTap: () => _showLanguageBottomSheet(context),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              SettingsListItem(
                icon: Icons.logout,
                title: l10n.logout,
                titleColor: colorScheme.error,
                onTap: () => _showLogoutDialog(context, l10n),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const ThemeBottomSheet(),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const LanguageBottomSheet(),
    );
  }

  String _getThemeName(BuildContext context, ThemeMode mode) {
    final l10n = AppLocalizations.of(context)!;
    switch (mode) {
      case ThemeMode.light:
        return l10n.light;
      case ThemeMode.dark:
        return l10n.dark;
      case ThemeMode.system:
        return l10n.systemDefault;
    }
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    DialogUtils.showConfirmationDialog(
      context: context,
      title: l10n.logout,
      content: l10n.confirmLogout,
      confirmText: l10n.logout,
      cancelText: l10n.cancel,
      confirmColor: context.colorScheme.error,
      onConfirm: () {
        context.read<AuthBloc>().add(LogoutRequested());
      },
    );
  }
}
