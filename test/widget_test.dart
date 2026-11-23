import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lms/app/app.dart';

void main() {
  testWidgets('LMS app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const LMSApp(initialThemeMode: ThemeMode.light));

    // Initial splash screen
    expect(find.text('Flutter LMS'), findsOneWidget);

    // Complete splash screen timer
    await tester.pump(const Duration(seconds: 3));

    // Allow navigation animation to complete
    await tester.pumpAndSettle();
  });
}
