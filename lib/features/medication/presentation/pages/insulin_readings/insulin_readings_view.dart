import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/insulin_reading.dart';

class InsulinReadingsView extends StatefulWidget {
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final List<InsulinReading> readings;
  final VoidCallback onRetry;

  const InsulinReadingsView({
    super.key,
    required this.isLoading,
    required this.hasError,
    this.errorMessage,
    required this.readings,
    required this.onRetry,
  });

  @override
  State<InsulinReadingsView> createState() => _InsulinReadingsViewState();
}

class _InsulinReadingsViewState extends State<InsulinReadingsView> {
  String _selectedSegment = 'عشوائي';
  final List<String> _segments = ['عشوائي', 'صائم', 'تراكمي', 'بعد الأكل'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (widget.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (widget.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(PhosphorIconsFill.warningCircle, color: AppColors.danger, size: 48),
            const SizedBox(height: 12),
            Text(
              widget.errorMessage ?? 'حدث خطأ في تحميل القراءات',
              style: AppTextStyles.body.copyWith(
                color: isDark ? AppColors.darkText : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: widget.onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    final latestReading = widget.readings.isNotEmpty ? widget.readings.first : null;
    final latestValue = latestReading != null ? latestReading.value.toStringAsFixed(0) : '115';

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Last Reading Summary Card
          Container(
            padding: const EdgeInsets.all(20),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'آخر قراءة',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              latestValue,
                              style: AppTextStyles.h1.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'mg/dL',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.statusTakenBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'طبيعي',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.statusTakenText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(PhosphorIconsRegular.clock, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      latestReading != null
                          ? '${DateFormat('h:mm a', 'ar').format(latestReading.timestamp)} • ${_getReadingTypeName(latestReading.readingType)}'
                          : 'منذ ساعتين • عشوائي',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Segmented Reading Type Selector
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: _segments.map((segment) {
                final isSelected = _selectedSegment == segment;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedSegment = segment),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? AppColors.darkBackground : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        segment,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : (isDark ? AppColors.darkText.withValues(alpha: 0.6) : AppColors.textSecondary),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // 3. Line Chart Visualization Card
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
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'مخطط القراءات',
                      style: AppTextStyles.h3.copyWith(
                        color: isDark ? AppColors.darkText : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'القراءة',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'النطاق',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Mock Chart Line Widget
                SizedBox(
                  height: 140,
                  child: CustomPaint(
                    size: const Size(double.infinity, 140),
                    painter: _GlucoseChartPainter(
                      isDark: isDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4. Recent Readings Log
          Text(
            'سجل القراءات الأخير',
            style: AppTextStyles.h3.copyWith(
              color: isDark ? AppColors.darkText : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          if (widget.readings.isEmpty)
            _buildSampleReadingList(isDark)
          else
            ...widget.readings.map((r) => _buildReadingTile(r, isDark)),
        ],
      ),
    );
  }

  String _getReadingTypeName(ReadingType type) {
    switch (type) {
      case ReadingType.fasting:
        return 'صائم';
      case ReadingType.postprandial:
        return 'بعد الأكل';
      case ReadingType.beforeSleep:
        return 'قبل النوم';
      case ReadingType.hba1c:
        return 'تراكمي';
    }
  }

  Widget _buildReadingTile(InsulinReading r, bool isDark) {
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
              color: AppColors.statusUpcomingBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                PhosphorIconsFill.drop,
                color: AppColors.primary,
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
                  '${r.value.toStringAsFixed(0)} mg/dL',
                  style: AppTextStyles.h3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${_getReadingTypeName(r.readingType)} • ${DateFormat('d MMMM، h:mm a', 'ar').format(r.timestamp)}',
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
              'طبيعي',
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

  Widget _buildSampleReadingList(bool isDark) {
    final samples = [
      {'val': '115', 'type': 'عشوائي', 'time': 'اليوم 02:00 م', 'status': 'طبيعي'},
      {'val': '98', 'type': 'صائم', 'time': 'اليوم 08:30 ص', 'status': 'طبيعي'},
      {'val': '142', 'type': 'بعد الأكل', 'time': 'أمس 09:15 م', 'status': 'مرتفع قليلاً'},
    ];

    return Column(
      children: samples.map((s) {
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
                  color: AppColors.statusUpcomingBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    PhosphorIconsFill.drop,
                    color: AppColors.primary,
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
                      '${s['val']} mg/dL',
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${s['type']} • ${s['time']}',
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
                  color: s['status'] == 'طبيعي' ? AppColors.statusTakenBg : AppColors.statusMissedBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  s['status']!,
                  style: AppTextStyles.caption.copyWith(
                    color: s['status'] == 'طبيعي' ? AppColors.statusTakenText : AppColors.statusMissedText,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _GlucoseChartPainter extends CustomPainter {
  final bool isDark;

  _GlucoseChartPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Target Range band (70-140 mg/dL representation)
    final rangePaint = Paint()
      ..color = AppColors.secondary.withValues(alpha: isDark ? 0.15 : 0.08)
      ..style = PaintingStyle.fill;

    final rangeRect = Rect.fromLTRB(0, size.height * 0.35, size.width, size.height * 0.75);
    canvas.drawRRect(RRect.fromRectAndRadius(rangeRect, const Radius.circular(8)), rangePaint);

    // 2. Draw Target Boundary line
    final boundaryPaint = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, size.height * 0.35), Offset(size.width, size.height * 0.35), boundaryPaint);
    canvas.drawLine(Offset(0, size.height * 0.75), Offset(size.width, size.height * 0.75), boundaryPaint);

    // 3. Draw Chart Line Curve
    final linePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final points = [
      Offset(size.width * 0.05, size.height * 0.65),
      Offset(size.width * 0.25, size.height * 0.45),
      Offset(size.width * 0.45, size.height * 0.70),
      Offset(size.width * 0.65, size.height * 0.30),
      Offset(size.width * 0.85, size.height * 0.50),
      Offset(size.width * 0.95, size.height * 0.42),
    ];

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final midX = (p0.dx + p1.dx) / 2;
      path.cubicTo(midX, p0.dy, midX, p1.dy, p1.dx, p1.dy);
    }
    canvas.drawPath(path, linePaint);

    // 4. Draw Point dots
    final dotFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final dotStroke = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (final p in points) {
      canvas.drawCircle(p, 5, dotFill);
      canvas.drawCircle(p, 5, dotStroke);
    }
  }

  @override
  bool shouldRepaint(covariant _GlucoseChartPainter oldDelegate) => oldDelegate.isDark != isDark;
}
