import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/constants/app_strings.dart';
import 'package:portfolio/portfolio/presentation/sections/contact/contact_section.dart';
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

  group('ContactSection Content & Interaction Tests', () {
    testWidgets('renders all 4 compact contact cards with visible text', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ContactSection()),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // 4 cards titles
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone & WhatsApp'), findsOneWidget);
      expect(find.text('LinkedIn'), findsOneWidget);
      expect(find.text('GitHub'), findsOneWidget);

      // Visible readable text values
      expect(find.text(AppStrings.email), findsOneWidget);
      expect(find.text(AppStrings.phone), findsOneWidget);
      expect(find.text(AppStrings.linkedInHandle), findsOneWidget);
      expect(find.text(AppStrings.gitHubHandle), findsOneWidget);

      // Copy buttons exist for Email and Phone
      expect(find.byIcon(Icons.copy_rounded), findsNWidgets(2));
    });

    testWidgets('Tapping copy icon copies email to clipboard', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      String? copiedClipboardText;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (
            MethodCall methodCall,
          ) async {
            if (methodCall.method == 'Clipboard.setData') {
              final Map? args = methodCall.arguments as Map?;
              copiedClipboardText = args?['text'] as String?;
            }
            return null;
          });

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ContactSection()),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Tap email copy icon (first copy icon)
      final copyIcons = find.byIcon(Icons.copy_rounded);
      await tester.tap(copyIcons.first);
      await tester.pump();

      expect(copiedClipboardText, equals(AppStrings.email));
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);

      // Advance the 2-second reset timer
      await tester.pump(const Duration(seconds: 2));
    });
  });

  group('ContactSection Responsive No-Overflow Tests', () {
    for (final size in testViewports) {
      testWidgets('renders cleanly at ${size.width.toInt()}px without overflow', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(child: ContactSection()),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        expect(find.text(AppStrings.email), findsOneWidget);
        expect(find.text(AppStrings.phone), findsOneWidget);
      });
    }
  });
}
