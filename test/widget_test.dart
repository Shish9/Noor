// Smoke test for QuranApp.

import 'package:flutter_test/flutter_test.dart';

import 'package:quran_app/app/app.dart';

void main() {
  testWidgets('QuranApp builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const QuranApp());
    expect(find.byType(QuranApp), findsOneWidget);
  });
}
