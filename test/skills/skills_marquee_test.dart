import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/constants/app_strings.dart';
import 'package:portfolio/portfolio/presentation/sections/skills/skills_section.dart';
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

  group('SkillsSection Header & Labels Tests', () {
    testWidgets('renders approved title, subtitle, and both marquee rows', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SkillsSection())),
      );
      await tester.pump();

      // Section title & subtitle
      expect(find.text(AppStrings.skillsTitle), findsOneWidget);
      expect(find.text(AppStrings.skillsSubtitle), findsOneWidget);

      // Verify two InfiniteMarqueeRow widgets
      final marqueeFinder = find.byType(InfiniteMarqueeRow);
      expect(marqueeFinder, findsNWidgets(2));
    });

    testWidgets('contains all Row 1 Core Development skill labels', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SkillsSection())),
      );
      await tester.pump();

      const expectedRow1Skills = [
        'Flutter',
        'Dart',
        'Clean Architecture',
        'BLoC',
        'Cubit',
        'Dependency Injection',
        'RESTful APIs',
        'SOLID Principles',
      ];

      for (final skill in expectedRow1Skills) {
        expect(
          find.text(skill),
          findsWidgets,
          reason: 'Skill $skill should exist in Row 1',
        );
      }
    });

    testWidgets('contains all Row 2 Production & Tools skill labels', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SkillsSection())),
      );
      await tester.pump();

      const expectedRow2Skills = [
        'Firebase',
        'OneSignal',
        'Google Maps',
        'Real-time Tracking',
        'Background Location',
        'Payment Integration',
        'Unit Testing',
        'Widget Testing',
        'Git & GitHub',
        'Agile / Scrum',
      ];

      for (final skill in expectedRow2Skills) {
        expect(
          find.text(skill),
          findsWidgets,
          reason: 'Skill $skill should exist in Row 2',
        );
      }
    });
  });

  group('Opposite Movement Directions Tests', () {
    testWidgets('Row 1 and Row 2 have opposite MarqueeDirections', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SkillsSection())),
      );
      await tester.pump();

      final marqueeFinder = find.byType(InfiniteMarqueeRow);
      expect(marqueeFinder, findsNWidgets(2));

      final row1 = tester.widget<InfiniteMarqueeRow>(marqueeFinder.at(0));
      final row2 = tester.widget<InfiniteMarqueeRow>(marqueeFinder.at(1));

      expect(row1.direction, equals(MarqueeDirection.rightToLeft));
      expect(row2.direction, equals(MarqueeDirection.leftToRight));
    });

    testWidgets('Row 1 and Row 2 translate in opposite directions', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SkillsSection())),
      );
      await tester.pump();

      final marqueeFinder = find.byType(InfiniteMarqueeRow);
      final state1 = tester.state<InfiniteMarqueeRowState>(marqueeFinder.at(0));
      final state2 = tester.state<InfiniteMarqueeRowState>(marqueeFinder.at(1));

      // Set controller to 0.0
      state1.controller.value = 0.0;
      state2.controller.value = 0.0;
      final initialOffset1 = state1.currentOffset;
      final initialOffset2 = state2.currentOffset;

      // Advance controller by 0.1
      state1.controller.value = 0.1;
      state2.controller.value = 0.1;
      final movedOffset1 = state1.currentOffset;
      final movedOffset2 = state2.currentOffset;

      // Row 1 (rightToLeft) moves negative: offset decreases
      expect(
        movedOffset1,
        lessThan(initialOffset1),
        reason: 'Row 1 moves leftwards (negative translation)',
      );

      // Row 2 (leftToRight) moves positive: offset increases
      expect(
        movedOffset2,
        greaterThan(initialOffset2),
        reason: 'Row 2 moves rightwards (positive translation)',
      );
    });
  });

  group('Pause and Resume Behavior Tests', () {
    testWidgets('Hovering Row 1 pauses only Row 1 and exiting resumes it', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SkillsSection())),
      );
      await tester.pump();

      final marqueeFinder = find.byType(InfiniteMarqueeRow);
      final state1 = tester.state<InfiniteMarqueeRowState>(marqueeFinder.at(0));
      final state2 = tester.state<InfiniteMarqueeRowState>(marqueeFinder.at(1));

      // Initially both are animating
      expect(state1.isPaused, isFalse);
      expect(state2.isPaused, isFalse);

      // Create mouse pointer and hover Row 1
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(marqueeFinder.at(0)));
      await tester.pump();

      // Row 1 is paused, Row 2 is unaffected
      expect(state1.isPaused, isTrue);
      expect(state2.isPaused, isFalse);

      // Pointer exits Row 1 to top-left
      await gesture.moveTo(const Offset(10, 10));
      await tester.pump();

      // Row 1 resumes
      expect(state1.isPaused, isFalse);
      expect(state2.isPaused, isFalse);

      await gesture.removePointer();
    });

    testWidgets(
      'Touch press-and-hold pauses touched row and release resumes it',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: SkillsSection())),
        );
        await tester.pump();

        final marqueeFinder = find.byType(InfiniteMarqueeRow);
        final state2 = tester.state<InfiniteMarqueeRowState>(
          marqueeFinder.at(1),
        );

        expect(state2.isPaused, isFalse);

        // Press and hold on Row 2
        final touchGesture = await tester.startGesture(
          tester.getCenter(marqueeFinder.at(1)),
        );
        await tester.pump();

        // Row 2 pauses
        expect(state2.isPaused, isTrue);

        // Release touch
        await touchGesture.up();
        await tester.pump();

        // Row 2 resumes
        expect(state2.isPaused, isFalse);
      },
    );
  });

  group('Reduced-Motion Accessibility Fallback Tests', () {
    testWidgets(
      'Displays static wrapped chips when disableAnimations is true',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: MaterialApp(home: Scaffold(body: SkillsSection())),
          ),
        );
        await tester.pump();

        // No marquee rows rendered when animations are disabled
        expect(find.byType(InfiniteMarqueeRow), findsNothing);

        // Wrap layout renders static chips with all labels present
        expect(find.byType(Wrap), findsWidgets);
        expect(find.text('Flutter'), findsOneWidget);
        expect(find.text('Dart'), findsOneWidget);
        expect(find.text('Firebase'), findsOneWidget);
        expect(find.text('Git & GitHub'), findsOneWidget);
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
                body: SingleChildScrollView(child: SkillsSection()),
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
