import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/bloc/theme_cubit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/extensions/context_extension.dart';

class ThemeBottomSheet extends StatelessWidget {
  const ThemeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = context.theme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.selectTheme,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _ThemeOption(
            icon: Icons.brightness_auto,
            title: l10n.systemDefault,
            onTap: () {
              context.read<ThemeCubit>().updateTheme(ThemeMode.system);
              Navigator.pop(context);
            },
          ),
          _ThemeOption(
            icon: Icons.light_mode,
            title: l10n.light,
            onTap: () {
              context.read<ThemeCubit>().updateTheme(ThemeMode.light);
              Navigator.pop(context);
            },
          ),
          _ThemeOption(
            icon: Icons.dark_mode,
            title: l10n.dark,
            onTap: () {
              context.read<ThemeCubit>().updateTheme(ThemeMode.dark);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }
}
