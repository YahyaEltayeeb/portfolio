import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/core/constants/app_strings.dart';
import 'package:portfolio/portfolio/presentation/screens/portfolio_main_screen.dart';
import 'package:portfolio/portfolio/presentation/screens/splash_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  testWidgets('Portfolio app launches with SplashScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const YahyaPortfolioApp());
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text(AppStrings.name.toUpperCase()), findsOneWidget);
  });

  testWidgets('PortfolioMainScreen renders major section headers', (
    WidgetTester tester,
  ) async {
    // Provide a desktop size viewport for the test
    tester.view.physicalSize = const Size(1440, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MaterialApp(home: PortfolioMainScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text(AppStrings.name), findsWidgets);
    expect(find.text(AppStrings.title), findsWidgets);
    expect(find.text(AppStrings.skillsTitle), findsOneWidget);
    expect(find.text(AppStrings.projectsTitle), findsOneWidget);
  });
}
