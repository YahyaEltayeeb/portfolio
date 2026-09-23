import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/portfolio/presentation/screens/portfolio_main_screen.dart';
import 'package:portfolio/portfolio/presentation/screens/project_details_screen.dart';
import 'package:portfolio/portfolio/presentation/sections/projects/project_grid_card.dart';
import 'package:portfolio/portfolio/presentation/sections/projects/projects_section.dart';
import 'package:portfolio/portfolio/presentation/widgets/full_screen_image_viewer.dart';
import 'package:portfolio/portfolio/presentation/widgets/portfolio_image.dart';
import 'package:portfolio/portfolio/repositories/projects_repository.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  const testViewports = [
    Size(1440, 900),
    Size(1024, 768),
    Size(768, 1024),
    Size(390, 844),
  ];

  final projects = const ProjectsRepository().getProjects();

  group('ProjectGridCard Responsive & Image Safe Behavior Tests', () {
    for (final size in testViewports) {
      testWidgets(
        'renders cleanly at ${size.width.toInt()}px without overflow',
        (WidgetTester tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          final project = projects.first;
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(
                  child: ProjectGridCard(project: project),
                ),
              ),
            ),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));

          // Verify card rendered without throwing overflow exception
          expect(tester.takeException(), isNull);

          // Verify cover image uses AspectRatio and BoxFit.contain
          final imageFinder = find.byType(PortfolioImage);
          expect(imageFinder, findsWidgets);

          final portfolioImage = tester.widget<PortfolioImage>(
            imageFinder.first,
          );
          expect(portfolioImage.fit, equals(BoxFit.contain));

          final aspectRatioFinder = find.byType(AspectRatio);
          expect(aspectRatioFinder, findsWidgets);
        },
      );
    }
  });

  group('ProjectsSection Responsive Grid Tests', () {
    for (final size in testViewports) {
      testWidgets(
        'renders all 6 project cards at ${size.width.toInt()}px without overflow',
        (WidgetTester tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(child: ProjectsSection()),
              ),
            ),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));

          expect(tester.takeException(), isNull);
          expect(find.byType(ProjectGridCard), findsNWidgets(6));
        },
      );
    }
  });

  group('ProjectDetailsScreen Responsive & Image Safe Behavior Tests', () {
    for (final size in testViewports) {
      testWidgets(
        'renders details view at ${size.width.toInt()}px without overflow',
        (WidgetTester tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          // Test with Zadna Groceries (portrait screenshots)
          final project = projects.first;
          await tester.pumpWidget(
            MaterialApp(home: ProjectDetailsScreen(project: project)),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));

          expect(tester.takeException(), isNull);

          // Verify cover image uses BoxFit.contain and AspectRatio
          final imageFinder = find.byType(PortfolioImage);
          expect(imageFinder, findsWidgets);

          final firstImage = tester.widget<PortfolioImage>(imageFinder.first);
          expect(firstImage.fit, equals(BoxFit.contain));
        },
      );
    }
  });

  group('FullScreenImageViewer Responsive & Image Safe Behavior Tests', () {
    for (final size in testViewports) {
      testWidgets(
        'renders image viewer cleanly at ${size.width.toInt()}px without overflow',
        (WidgetTester tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          final project = projects.first;
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: FullScreenImageViewer(
                  images: project.screenshotAssets,
                  title: project.title,
                ),
              ),
            ),
          );
          await tester.pump();

          expect(tester.takeException(), isNull);

          final imageFinder = find.byType(PortfolioImage);
          expect(imageFinder, findsOneWidget);

          final viewerImage = tester.widget<PortfolioImage>(imageFinder);
          expect(viewerImage.fit, equals(BoxFit.contain));
          expect(viewerImage.alignment, equals(Alignment.center));
        },
      );
    }
  });

  group('PortfolioMainScreen Full Page Responsive Tests', () {
    for (final size in testViewports) {
      testWidgets(
        'renders full page at ${size.width.toInt()}px without overflow',
        (WidgetTester tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          await tester.pumpWidget(
            const MaterialApp(home: PortfolioMainScreen()),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));

          expect(tester.takeException(), isNull);
        },
      );
    }
  });
}
