import 'package:flutter/material.dart';

/// Centralized Responsive System supporting continuous scaling from 320px to 1920px+.
/// Provides breakpoints, fluid padding, max-width wrappers, and adaptive grid calculations.
class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;
  final Widget? wideDesktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
    this.wideDesktop,
  });

  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;
  static const double maxContentWidth = 1280;

  static bool isSmallMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 375;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= tabletBreakpoint && width < desktopBreakpoint;
  }

  static bool isWideDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktopBreakpoint;

  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    required T desktop,
    T? wideDesktop,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= desktopBreakpoint && wideDesktop != null) return wideDesktop;
    if (width >= tabletBreakpoint) return desktop;
    if (width >= mobileBreakpoint && tablet != null) return tablet;
    return mobile;
  }

  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 375) return 16;
    if (width < 600) return 20;
    if (width < 1024) return 32;
    if (width < 1440) return 64;
    return 80;
  }

  static int gridColumns(
    BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
    int wideDesktop = 4,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= desktopBreakpoint) return wideDesktop;
    if (width >= tabletBreakpoint) return desktop;
    if (width >= mobileBreakpoint) return tablet;
    return mobile;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth >= desktopBreakpoint && wideDesktop != null) {
      return wideDesktop!;
    }
    if (screenWidth >= tabletBreakpoint) {
      return desktop;
    }
    if (screenWidth >= mobileBreakpoint && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

/// Max-width constrained content container centered horizontally
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = Responsive.maxContentWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPadding = EdgeInsets.symmetric(
      horizontal: Responsive.horizontalPadding(context),
    );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ?? defaultPadding,
          child: child,
        ),
      ),
    );
  }
}
