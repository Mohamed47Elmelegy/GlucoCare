import 'package:flutter/material.dart';

class AppColors {
  // Brand / Primary Palette
  static const Color primary = Color(0xFF3B82F6); // Blue
  static const Color primaryContainer = Color(0xFF2170E4);
  static const Color onPrimary = Colors.white;
  static const Color primaryFixed = Color(0xFFD8E2FF);

  // Secondary Palette
  static const Color secondary = Color(0xFF10B981); // Green
  static const Color secondaryContainer = Color(0xFF6CF8BB);
  static const Color onSecondary = Colors.white;

  // Background and Surfaces
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color surfaceDim = Color(0xFFD8D9E3);
  static const Color surfaceBright = Color(0xFFF9F9FF);
  static const Color surfaceContainerLow = Color(0xFFF2F3FD);
  static const Color surfaceContainer = Color(0xFFECEDF7);
  static const Color surfaceVariant = Color(0xFFE2E8F0);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);

  // Border & Outline
  static const Color border = Color(0xFFE2E8F0);
  static const Color outline = Color(0xFF727785);
  static const Color outlineVariant = Color(0xFFC2C6D6);

  // Status & Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color danger = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Status Chip Colors
  static const Color statusTakenBg = Color(0xFFD1FAE5);
  static const Color statusTakenText = Color(0xFF065F46);
  static const Color statusMissedBg = Color(0xFFFEE2E2);
  static const Color statusMissedText = Color(0xFF991B1B);
  static const Color statusUpcomingBg = Color(0xFFDBEAFE);
  static const Color statusUpcomingText = Color(0xFF1E40AF);

  // Dark Mode
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkText = Color(0xFFF1F5F9);
  static const Color darkBorder = Color(0xFF334155);

  // Legacy / Compatibility
  static const Color premiumDarkBackground = Color(0xFF0F172A);
  static const Color premiumCardGrey = Color(0xFF1E293B);
  static const Color premiumMint = Color(0xFF10B981);
  static const Color premiumMintLight = Color(0xFFD1FAE5);
  static const Color premiumAqua = Color(0xFF3B82F6);

  // Basic Colors
  static const Color textWhite = Colors.white;
  static const Color textWhite60 = Colors.white60;
  static const Color textWhite38 = Colors.white38;
  static const Color textWhite24 = Colors.white24;
  static const Color textBlack = Colors.black;
  static const Color textBlack87 = Colors.black87;
  static const Color textBlack54 = Colors.black54;
  static const Color transparent = Colors.transparent;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFFEBF3FF), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
