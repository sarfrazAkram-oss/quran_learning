// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:quran_learning/main.dart';

void main() {
  testWidgets('Language Selection Screen loads correctly', (
    WidgetTester tester,
  ) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the main heading is displayed.
    expect(find.text('As-salamu alaykum'), findsOneWidget);

    // Verify that the language buttons are displayed.
    expect(find.text('English'), findsOneWidget);
    expect(find.text('اردو'), findsOneWidget);

    // Verify that the Get Started button is displayed.
    expect(find.text('Get Started'), findsOneWidget);
  });
}
