import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/portfolio/presentation/sections/hero/hero_section.dart';
import 'package:portfolio/portfolio/presentation/sections/hero/portrait_container.dart';
import 'package:portfolio/portfolio/presentation/widgets/portfolio_image.dart';
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

  group('Hero Portrait Presentation & Focus Tests', () {
    testWidgets(
      'renders close-up portrait with BoxFit.cover, semantics, and bottom caption',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: HeroSection(onViewProjectsTap: () {}),
              ),
            ),
          ),
        );
        await tester.pump();

        // Verify PortraitContainer exists
        expect(find.byType(PortraitContainer), findsOneWidget);

        // Verify PortfolioImage uses BoxFit.cover and upper-focused alignment
        final imageFinder = find.byType(PortfolioImage);
        expect(imageFinder, findsWidgets);

        final profileImageWidget = tester.widget<PortfolioImage>(
          imageFinder.first,
        );
        expect(profileImageWidget.fit, equals(BoxFit.cover));
        expect(
          profileImageWidget.alignment,
          equals(const Alignment(0.0, -0.6)),
        );

        // Verify Semantics label
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label ==
                  'Portrait of Yahya Mohamed, Flutter Developer',
        );
        expect(semanticsFinder, findsOneWidget);

        // Verify caption under the portrait
        expect(
          find.text('Flutter Developer • Available for Opportunities'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'confirms floating tech badges and technical grid are completely removed',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: HeroSection(onViewProjectsTap: () {}),
              ),
            ),
          ),
        );
        await tester.pump();

        // "Mobile Developer" badge is completely removed
        expect(find.text('Mobile Developer'), findsNothing);

        // Grid painter and double container frame are removed
        expect(
          find.byWidgetPredicate(
            (w) => w.runtimeType.toString().contains('Grid'),
          ),
          findsNothing,
        );
      },
    );
  });

  group('Hero Portrait Hover & Reduced-Motion Tests', () {
    testWidgets('hover interaction works cleanly on desktop', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: HeroSection(onViewProjectsTap: () {}),
            ),
          ),
        ),
      );
      await tester.pump();

      final portraitFinder = find.byType(PortraitContainer);
      expect(portraitFinder, findsOneWidget);

      // Create mouse pointer and hover over the portrait
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(portraitFinder));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);

      // Mouse exit
      await gesture.moveTo(const Offset(10, 10));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await gesture.removePointer();
    });

    testWidgets('respects reduced-motion preferences with disableAnimations', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: HeroSection(onViewProjectsTap: () {}),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(PortraitContainer), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Hero Section Responsive No-Overflow Tests across Viewports', () {
    for (final size in testViewports) {
      testWidgets(
        'renders hero cleanly at ${size.width.toInt()}px without overflow',
        (WidgetTester tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(
                  child: HeroSection(onViewProjectsTap: () {}),
                ),
              ),
            ),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));

          expect(tester.takeException(), isNull);
        },
      );
    }
  });
}
