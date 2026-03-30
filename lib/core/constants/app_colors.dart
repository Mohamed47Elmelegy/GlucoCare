import 'package:flutter/material.dart';

class AppColors {
  // Primary Seed
  static const Color primary = Colors.teal;
  static const Color onPrimary = Colors.white;

  // Background and Surfaces
  static const Color background = Color(0xFFF8FAFC); // Very soft grey-blue
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFE2E8F0);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Premium Smart Home Style Colors
  static const Color premiumDarkBackground = Color(0xFF0F111A);
  static const Color premiumCardGrey = Color(0xFF1D212E);
  static const Color premiumMint = Color(0xFF6FE8D1);
  static const Color premiumMintLight = Color(0xFFACF7E7);
  static const Color premiumAqua = Color(0xFF4AC7FA);

  // Semantic Colors
  static const Color textWhite = Colors.white;
  static const Color textWhite60 = Colors.white60;
  static const Color textWhite38 = Colors.white38;
  static const Color textWhite24 = Colors.white24;
  static const Color textBlack = Colors.black;
  static const Color textBlack87 = Colors.black87;
  static const Color textBlack54 = Colors.black54;
  static const Color transparent = Colors.transparent;

  // Gradients
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [premiumAqua, premiumMint],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
