import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/portfolio/presentation/sections/experience/experience_card.dart';
import 'package:portfolio/portfolio/presentation/sections/experience/experience_section.dart';
import 'package:portfolio/portfolio/repositories/experience_repository.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  const testViewports = [
    Size(320, 600),
    Size(390, 844),
    Size(430, 932),
    Size(768, 1024),
    Size(1024, 768),
    Size(1440, 900),
  ];

  final experiences = const ExperienceRepository().getExperiences();

  group('ExperienceCard Narrow Width (<560px) Layout Tests', () {
    testWidgets(
      'renders date first, then job title, then company on narrow width',
      (WidgetTester tester) async {
        // Test with Black Horse Courses
        final experience = experiences.firstWhere(
          (e) => e.id == 'black-horse-courses',
        );

        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ExperienceCard(experience: experience, isLast: false),
              ),
            ),
          ),
        );
        await tester.pump();

        // Find the date text
        final dateFinder = find.text(experience.period.toUpperCase());
        expect(dateFinder, findsOneWidget);

        // Find the title text
        final titleFinder = find.text(experience.title);
        expect(titleFinder, findsOneWidget);

        // Find the company text
        final companyFinder = find.text(experience.company);
        expect(companyFinder, findsOneWidget);

        // Verify exact vertical visual order: Date Y < Title Y < Company Y
        final datePos = tester.getTopLeft(dateFinder);
        final titlePos = tester.getTopLeft(titleFinder);
        final companyPos = tester.getTopLeft(companyFinder);

        expect(
          datePos.dy,
          lessThan(titlePos.dy),
          reason: 'Date must be displayed above job title',
        );
        expect(
          titlePos.dy,
          lessThan(companyPos.dy),
          reason: 'Job title must be displayed above company name',
        );

        // Verify all are left-aligned (similar X coordinate within card padding)
        expect((datePos.dx - titlePos.dx).abs(), lessThan(2.0));
        expect((titlePos.dx - companyPos.dx).abs(), lessThan(2.0));

        // Verify date does NOT have a badge/container decoration on narrow width
        // The desktop container badge uses BoxDecoration with alpha 0.12
        final dateWidget = tester.widget<Text>(dateFinder);
        expect(dateWidget.style?.fontSize, equals(12.0));
        expect(dateWidget.style?.fontWeight, equals(FontWeight.w500));
        expect(dateWidget.style?.letterSpacing, equals(0.8));

        // Responsibilities and technologies are preserved
        expect(find.text(experience.responsibilities.first), findsOneWidget);
        expect(find.text(experience.technologies.first), findsOneWidget);
      },
    );

    testWidgets(
      'applies narrow visual order consistently across all experiences',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        for (final exp in experiences) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(
                  child: ExperienceCard(experience: exp, isLast: false),
                ),
              ),
            ),
          );
          await tester.pump();

          final dateFinder = find.text(exp.period.toUpperCase());
          final titleFinder = find.text(exp.title);
          final companyFinder = find.text(exp.company);

          expect(dateFinder, findsOneWidget);
          expect(titleFinder, findsOneWidget);
          expect(companyFinder, findsOneWidget);

          final dateY = tester.getTopLeft(dateFinder).dy;
          final titleY = tester.getTopLeft(titleFinder).dy;
          final companyY = tester.getTopLeft(companyFinder).dy;

          expect(
            dateY,
            lessThan(titleY),
            reason: '${exp.company}: Date above title',
          );
          expect(
            titleY,
            lessThan(companyY),
            reason: '${exp.company}: Title above company',
          );
        }
      },
    );
  });

  group('ExperienceCard Desktop (>=560px) Layout Tests', () {
    testWidgets('preserves desktop Row layout with period badge on the right', (
      WidgetTester tester,
    ) async {
      final experience = experiences.first;

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
              child: ExperienceCard(experience: experience, isLast: false),
            ),
          ),
        ),
      );
      await tester.pump();

      // On desktop, the period is displayed with original casing in the badge
      final dateFinder = find.text(experience.period);
      expect(dateFinder, findsOneWidget);

      final titleFinder = find.text(experience.title);
      expect(titleFinder, findsOneWidget);

      // Verify date badge is to the right of the title
      final dateX = tester.getTopLeft(dateFinder).dx;
      final titleX = tester.getTopLeft(titleFinder).dx;
      expect(dateX, greaterThan(titleX));
    });
  });

  group('Experience Responsive No-Overflow Tests across All Viewports', () {
    for (final size in testViewports) {
      testWidgets(
        'renders ExperienceSection at ${size.width.toInt()}px without overflow',
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
                body: SingleChildScrollView(child: ExperienceSection()),
              ),
            ),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));

          expect(tester.takeException(), isNull);
          expect(find.byType(ExperienceCard), findsNWidgets(3));
        },
      );
    }

    testWidgets(
      'Black Falcons card does not overflow when tags wrap to multiple lines',
      (WidgetTester tester) async {
        final experience = experiences.firstWhere(
          (e) => e.id == 'black-falcons',
        );
        final originalOnError = FlutterError.onError;
        final errors = <FlutterErrorDetails>[];
        FlutterError.onError = (details) {
          errors.add(details);
        };

        addTearDown(() {
          FlutterError.onError = originalOnError;
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        for (double width = 600; width <= 1300; width += 20) {
          tester.view.physicalSize = Size(width, 900);
          tester.view.devicePixelRatio = 1.0;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(
                  child: SizedBox(
                    width: width,
                    child: ExperienceCard(
                      experience: experience,
                      isLast: false,
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pump();
        }

        final overflowErrors = errors
            .where((e) => e.toString().contains('overflowed'))
            .toList();
        expect(
          overflowErrors,
          isEmpty,
          reason:
              'Found overflow errors: ${overflowErrors.map((e) => e.summary.toString()).toList()}',
        );
      },
    );
  });
}
