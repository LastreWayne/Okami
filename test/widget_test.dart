// Smoke test: the app boots to the splash screen wordmark.

import 'package:flutter_test/flutter_test.dart';

import 'package:okami/main.dart';

void main() {
  testWidgets('OkamiApp boots to the splash wordmark', (WidgetTester tester) async {
    await tester.pumpWidget(const OkamiApp());

    // Splash shows the mincho ŌKAMI wordmark.
    expect(find.text('ŌKAMI'), findsOneWidget);

    // Let the 3s splash timer + navigation complete so no timers stay pending.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
