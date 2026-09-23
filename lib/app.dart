import 'package:flutter/material.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'portfolio/presentation/screens/splash_screen.dart';

/// The root widget of Yahya Mohamed's portfolio web application.
class YahyaPortfolioApp extends StatelessWidget {
  const YahyaPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '${AppStrings.name} | ${AppStrings.title}',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
