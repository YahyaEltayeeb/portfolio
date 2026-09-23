import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/core/constants/app_strings.dart';

void main() {
  testWidgets('Portfolio app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const YahyaPortfolioApp());
    expect(find.text(AppStrings.name), findsOneWidget);
  });
}
