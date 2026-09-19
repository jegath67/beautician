import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized Typography using Playfair Display (Serif Elegance) for headings
/// and Plus Jakarta Sans (Clean Modern Sans-Serif) for legible body text.
class AppTypography {
  AppTypography._();

  // Heading Styles (Playfair Display)
  static TextStyle displayLarge(BuildContext context, {Color? color}) {
    return GoogleFonts.playfairDisplay(
      fontSize: _getResponsiveSize(context, desktop: 48, tablet: 38, mobile: 30),
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      height: 1.15,
      color: color,
    );
  }

  static TextStyle displayMedium(BuildContext context, {Color? color}) {
    return GoogleFonts.playfairDisplay(
      fontSize: _getResponsiveSize(context, desktop: 36, tablet: 30, mobile: 24),
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      height: 1.2,
      color: color,
    );
  }

  static TextStyle displaySmall(BuildContext context, {Color? color}) {
    return GoogleFonts.playfairDisplay(
      fontSize: _getResponsiveSize(context, desktop: 28, tablet: 24, mobile: 20),
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.25,
      color: color,
    );
  }

  static TextStyle titleLarge(BuildContext context, {Color? color}) {
    return GoogleFonts.playfairDisplay(
      fontSize: _getResponsiveSize(context, desktop: 22, tablet: 20, mobile: 18),
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: color,
    );
  }

  // Body & UI Styles (Plus Jakarta Sans)
  static TextStyle titleMedium(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 16,
      fontWeight: fontWeight ?? FontWeight.w600,
      letterSpacing: 0.1,
      color: color,
    );
  }

  static TextStyle titleSmall(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: fontWeight ?? FontWeight.w600,
      letterSpacing: 0.1,
      color: color,
    );
  }

  static TextStyle bodyLarge(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 16,
      fontWeight: fontWeight ?? FontWeight.w400,
      height: 1.6,
      color: color,
    );
  }

  static TextStyle bodyMedium(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: fontWeight ?? FontWeight.w400,
      height: 1.5,
      color: color,
    );
  }

  static TextStyle bodySmall(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 12,
      fontWeight: fontWeight ?? FontWeight.w400,
      height: 1.4,
      color: color,
    );
  }

  static TextStyle labelLarge(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: fontWeight ?? FontWeight.w600,
      letterSpacing: 0.5,
      color: color,
    );
  }

  static TextStyle labelSmall(BuildContext context, {Color? color}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: color,
    );
  }

  static double _getResponsiveSize(
    BuildContext context, {
    required double desktop,
    required double tablet,
    required double mobile,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1024) return desktop;
    if (width >= 600) return tablet;
    return mobile;
  }
}
