import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/portfolio/presentation/screens/project_details_screen.dart';
import 'package:portfolio/portfolio/presentation/sections/projects/project_grid_card.dart';
import 'package:portfolio/portfolio/presentation/sections/projects/projects_section.dart';
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
    Size(430, 932),
    Size(390, 844),
  ];

  final projects = const ProjectsRepository().getProjects();

  group('ProjectsSection Grid & Content Tests', () {
    testWidgets('renders all 6 project cards with correct types and badges', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: ProjectsSection())),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.byType(ProjectGridCard), findsNWidgets(6));

      // Verify all 6 project titles
      expect(find.text('Zadna Groceries'), findsOneWidget);
      expect(find.text('Zadna Delivery'), findsOneWidget);
      expect(find.text('Super Fitness'), findsOneWidget);
      expect(find.text('Flowery E-Commerce'), findsOneWidget);
      expect(find.text('Flowery Tracking'), findsOneWidget);
      expect(find.text('Exam App'), findsOneWidget);

      // Verify all 6 short project types
      expect(find.text('Grocery Delivery Application'), findsOneWidget);
      expect(find.text('Driver Delivery Application'), findsOneWidget);
      expect(find.text('Fitness & Smart Coaching Application'), findsOneWidget);
      expect(find.text('Flower Shopping Application'), findsOneWidget);
      expect(find.text('Delivery Tracking Application'), findsOneWidget);
      expect(find.text('Quiz & Examination Application'), findsOneWidget);

      // Status badge: Only 2 live production apps have the "Live App" badge
      expect(find.text('Live App'), findsNWidgets(2));
      expect(find.text('App Store'), findsNWidgets(2));
      expect(find.text('GitHub'), findsNWidgets(4));

      // Every card has a "View Project" button
      expect(find.text('View Project'), findsNWidgets(6));
    });

    testWidgets('ProjectGridCard uses 16:9 AspectRatio and BoxFit.contain', (
      WidgetTester tester,
    ) async {
      final project = projects.first;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                width: 380,
                child: ProjectGridCard(project: project),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // Cover uses AspectRatio
      final aspectRatioFinder = find.byType(AspectRatio);
      expect(aspectRatioFinder, findsWidgets);

      final aspectRatio = tester.widget<AspectRatio>(aspectRatioFinder.first);
      expect(aspectRatio.aspectRatio, equals(16 / 9));

      // Cover uses BoxFit.contain
      final imageFinder = find.byType(PortfolioImage);
      expect(imageFinder, findsWidgets);

      final image = tester.widget<PortfolioImage>(imageFinder.first);
      expect(image.fit, equals(BoxFit.contain));
      expect(image.alignment, equals(Alignment.center));
    });
  });

  group('3/2/1 Responsive Column Behavior Tests', () {
    testWidgets('Desktop (1440px) renders 3 cards per row', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: ProjectsSection())),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      final cards = tester
          .widgetList<ProjectGridCard>(find.byType(ProjectGridCard))
          .toList();
      expect(cards.length, equals(6));

      // In 3-column layout, the first 3 cards have the same top offset
      final top0 = tester.getTopLeft(find.byType(ProjectGridCard).at(0)).dy;
      final top1 = tester.getTopLeft(find.byType(ProjectGridCard).at(1)).dy;
      final top2 = tester.getTopLeft(find.byType(ProjectGridCard).at(2)).dy;
      final top3 = tester.getTopLeft(find.byType(ProjectGridCard).at(3)).dy;

      expect(top0, equals(top1));
      expect(top1, equals(top2));
      expect(top3, greaterThan(top0)); // 4th card is on the 2nd row
    });

    testWidgets('Tablet (1024px and 768px) renders 2 cards per row', (
      WidgetTester tester,
    ) async {
      for (final width in [1024.0, 768.0]) {
        tester.view.physicalSize = Size(width, 1200);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(child: ProjectsSection()),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));

        // In 2-column layout, card 0 and 1 share the same top offset, card 2 is below
        final top0 = tester.getTopLeft(find.byType(ProjectGridCard).at(0)).dy;
        final top1 = tester.getTopLeft(find.byType(ProjectGridCard).at(1)).dy;
        final top2 = tester.getTopLeft(find.byType(ProjectGridCard).at(2)).dy;

        expect(top0, equals(top1));
        expect(top2, greaterThan(top0));
      }
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('Mobile (430px and 390px) renders 1 card per row', (
      WidgetTester tester,
    ) async {
      for (final width in [430.0, 390.0]) {
        tester.view.physicalSize = Size(width, 1200);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(child: ProjectsSection()),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));

        // In 1-column layout, card 0, 1, 2 each have strictly increasing top offsets
        final top0 = tester.getTopLeft(find.byType(ProjectGridCard).at(0)).dy;
        final top1 = tester.getTopLeft(find.byType(ProjectGridCard).at(1)).dy;
        final top2 = tester.getTopLeft(find.byType(ProjectGridCard).at(2)).dy;

        expect(top1, greaterThan(top0));
        expect(top2, greaterThan(top1));
      }
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });

  group('Card Interaction & Navigation Tests', () {
    testWidgets('Tapping the card navigates to ProjectDetailsScreen', (
      WidgetTester tester,
    ) async {
      final project = projects.first;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                width: 380,
                child: ProjectGridCard(project: project),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // Tap card
      await tester.tap(find.byType(ProjectGridCard));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(ProjectDetailsScreen), findsOneWidget);
    });

    testWidgets('Tapping "View Project" navigates to ProjectDetailsScreen', (
      WidgetTester tester,
    ) async {
      final project = projects.first;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                width: 380,
                child: ProjectGridCard(project: project),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      await tester.tap(find.text('View Project'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(ProjectDetailsScreen), findsOneWidget);
    });

    testWidgets(
      'External action button renders label and outward arrow',
      (WidgetTester tester) async {
        // Zadna Groceries has App Store action
        final prodProject = projects.first;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: SizedBox(
                  width: 380,
                  child: ProjectGridCard(project: prodProject),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));

        expect(find.text('App Store'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_outward_rounded), findsOneWidget);
      },
    );
  });

  group('Responsive No-Overflow Tests across Viewports', () {
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

          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(child: ProjectsSection()),
              ),
            ),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 600));

          expect(tester.takeException(), isNull);
        },
      );
    }
  });

  group('Reduced-Motion Accessibility Tests', () {
    testWidgets('renders static cards cleanly when disableAnimations is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(child: ProjectsSection()),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(ProjectGridCard), findsNWidgets(6));
    });
  });
}
