import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'app_typography.dart';

/// Dark theme configuration for Yahya Mohamed's portfolio.
abstract final class AppTheme {
  static ThemeData get darkTheme {
    final textTheme = TextTheme(
      displayLarge: AppTypography.heading(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryText,
        letterSpacing: -0.5,
      ),
      displayMedium: AppTypography.heading(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryText,
        letterSpacing: -0.5,
      ),
      displaySmall: AppTypography.heading(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
      ),
      headlineMedium: AppTypography.heading(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
      ),
      headlineSmall: AppTypography.heading(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
      ),
      titleLarge: AppTypography.heading(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
      ),
      bodyLarge: AppTypography.body(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.secondaryText,
        height: 1.6,
      ),
      bodyMedium: AppTypography.body(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.secondaryText,
        height: 1.5,
      ),
      labelLarge: AppTypography.heading(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
        letterSpacing: 0.2,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryCyan,
        secondary: AppColors.secondaryViolet,
        surface: AppColors.card,
      ),
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }
}
