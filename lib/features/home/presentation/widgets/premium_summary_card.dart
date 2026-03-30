import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/context_extension.dart';

class PremiumSummaryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String mainValue;
  final List<SummaryMetric> metrics;

  const PremiumSummaryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.mainValue,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.premiumMintLight.withValues(alpha: 0.9),
            AppColors.premiumMint.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.premiumMint.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        PhosphorIconsFill.drop,
                        color: Colors.black87,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        title,
                        style: textTheme.titleLarge?.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                mainValue,
                style: textTheme.displayLarge?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w300,
                  fontSize: 48,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: metrics.map((metric) => _buildMetric(context, metric)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(BuildContext context, SummaryMetric metric) {
    final textTheme = context.textTheme;
    return Column(
      children: [
        Text(
          metric.value,
          style: textTheme.titleMedium?.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          metric.label,
          style: textTheme.labelSmall?.copyWith(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class SummaryMetric {
  final String label;
  final String value;

  SummaryMetric({required this.label, required this.value});
}
