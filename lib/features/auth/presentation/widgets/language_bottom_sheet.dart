import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/bloc/locale_cubit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/extensions/context_extension.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

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
            l10n.language,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _LanguageOption(
            title: l10n.english,
            onTap: () {
              context.read<LocaleCubit>().updateLocale('en');
              Navigator.pop(context);
            },
            isSelected: Localizations.localeOf(context).languageCode == 'en',
          ),
          _LanguageOption(
            title: l10n.arabic,
            onTap: () {
              context.read<LocaleCubit>().updateLocale('ar');
              Navigator.pop(context);
            },
            isSelected: Localizations.localeOf(context).languageCode == 'ar',
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  const _LanguageOption({
    required this.title,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: isSelected
          ? Icon(Icons.check, color: context.colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }
}
