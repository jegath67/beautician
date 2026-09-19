import 'package:flutter/material.dart';

/// Centralized color palette for the luxury Beautician & Salon experience.
/// Carefully curated with WCAG AA compliant contrast in both dark and light modes.
class AppColors {
  AppColors._();

  // Primary Brand Gold & Bronze Accents
  static const Color goldPrimary = Color(0xFFC5A880); // Champagne Gold
  static const Color goldLight = Color(0xFFE2CBB0);
  static const Color goldDark = Color(0xFF9E7E56);
  static const Color goldMuted = Color(0x33C5A880);

  static const Color roseGold = Color(0xFFD4AF37);
  static const Color warmBlush = Color(0xFFF7EBE8);
  static const Color softBronze = Color(0xFFB59371);

  // Dark Theme Palette (Velvet Charcoal & Deep Onyx)
  static const Color darkBackground = Color(0xFF0D0D10);
  static const Color darkSurface = Color(0xFF16161B);
  static const Color darkSurfaceVariant = Color(0xFF1E1E26);
  static const Color darkCard = Color(0xFF191921);
  static const Color darkBorder = Color(0xFF2B2B36);
  static const Color darkTextPrimary = Color(0xFFFDFBF7);
  static const Color darkTextSecondary = Color(0xFFA5A5B5);
  static const Color darkTextMuted = Color(0xFF6E6E7E);

  // Light Theme Palette (Warm Cream & Silk Ivory)
  static const Color lightBackground = Color(0xFFFBF9F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF3EFE9);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE5DDD0);
  static const Color lightTextPrimary = Color(0xFF1A1715);
  static const Color lightTextSecondary = Color(0xFF5E5852);
  static const Color lightTextMuted = Color(0xFF948A80);

  // Semantic & Feedback Colors
  static const Color success = Color(0xFF2E7D32);
  static const Color successBg = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFED6C02);
  static const Color warningBg = Color(0xFFFFF3E0);
  static const Color error = Color(0xFFD32F2F);
  static const Color errorBg = Color(0xFFFFEBEE);
  static const Color info = Color(0xFF0288D1);
  static const Color infoBg = Color(0xFFE1F5FE);

  // Focus & Accessibility Ring
  static const Color focusRing = Color(0xFFD4AF37);
}
