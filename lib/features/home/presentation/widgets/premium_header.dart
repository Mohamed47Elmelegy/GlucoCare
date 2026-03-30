import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/extensions/context_extension.dart';

class PremiumHeader extends StatelessWidget {
  final String name;
  final String date;

  const PremiumHeader({super.key, required this.name, required this.date});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: colorScheme.onSurface,
                ),
                children: [
                  ..._buildGreetingSpans(l10n.hey(name), name, colorScheme),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            PhosphorIcons.squaresFour(PhosphorIconsStyle.bold),
            color: colorScheme.onSurface,
            size: 24,
          ),
        ),
      ],
    );
  }

  List<TextSpan> _buildGreetingSpans(
    String fullText,
    String name,
    ColorScheme colorScheme,
  ) {
    final parts = fullText.split(name);
    if (parts.length < 2) return [TextSpan(text: fullText)];

    return [
      TextSpan(text: parts[0]),
      TextSpan(
        text: name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
      ),
      TextSpan(text: parts[1]),
    ];
  }
}
