import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Design System Typography (Cairo)
  // H1: 28px Bold
  static final TextStyle h1 = GoogleFonts.cairo(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  // H2: 22px SemiBold
  static final TextStyle h2 = GoogleFonts.cairo(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  // H3: 18px SemiBold
  static final TextStyle h3 = GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // Body: 16px Regular
  static final TextStyle body = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  // Caption: 13px Regular
  static final TextStyle caption = GoogleFonts.cairo(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  // Existing API (kept for compatibility, mapped to design system)
  static final TextStyle displayLarge = h1;

  static final TextStyle titleLarge = h2;

  static final TextStyle titleMedium = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.15,
  );

  static final TextStyle bodyLarge = body;

  static final TextStyle bodyMedium = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 0.25,
  );

  static final TextStyle labelLarge = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );
}
