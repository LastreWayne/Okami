import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:okami/theme/app_theme.dart';
import 'package:okami/widgets/app_widgets.dart';

Widget _host(Widget child) =>
    MaterialApp(theme: AppTheme.darkTheme, home: Scaffold(body: child));

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('SectionTitle shows title, subtitle and a brush stroke', (tester) async {
    await tester.pumpWidget(_host(
      const SectionTitle(title: 'Task Manager', subtitle: 'Today'),
    ));
    expect(find.text('Task Manager'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.byType(BrushStroke), findsOneWidget);
  });

  testWidgets('KanjiWatermark renders the wolf glyph', (tester) async {
    await tester.pumpWidget(_host(const KanjiWatermark()));
    expect(find.text('狼'), findsOneWidget);
  });
}
