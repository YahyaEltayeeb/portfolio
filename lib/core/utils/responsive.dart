import 'package:flutter/material.dart';

/// Screen breakpoint helpers for responsive layouts.
abstract final class Responsive {
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1100.0;
  static const double maxContentWidth = 1200.0;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width <= mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width > mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  /// Returns responsive value based on current breakpoint.
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= tabletBreakpoint) return desktop;
    if (width > mobileBreakpoint && tablet != null) return tablet;
    return mobile;
  }
}
