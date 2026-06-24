import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:okami/models/task_model.dart';
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

  testWidgets('InkCard renders its child and reacts to tap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_host(
      InkCard(onTap: () => tapped = true, child: const Text('hi')),
    ));
    expect(find.text('hi'), findsOneWidget);
    await tester.tap(find.text('hi'));
    expect(tapped, isTrue);
  });

  testWidgets('ActionTile shows icon + label', (tester) async {
    await tester.pumpWidget(_host(
      ActionTile(icon: Icons.lock_outline, label: 'Lock in', onTap: () {}),
    ));
    expect(find.text('Lock in'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
  });

  testWidgets('GradientButton fires onPressed', (tester) async {
    var pressed = false;
    await tester.pumpWidget(_host(
      GradientButton(label: 'Create Task', onPressed: () => pressed = true),
    ));
    await tester.tap(find.text('Create Task'));
    expect(pressed, isTrue);
  });

  testWidgets('TaskRow shows title and formatted meta', (tester) async {
    final task = Task(
      id: '1',
      title: 'Deep work',
      description: '',
      dateTime: DateTime(2026, 6, 24, 8, 5),
      durationMinutes: 90,
      priority: TaskPriority.a,
      category: TaskCategory.neuroplasticity,
      repeatsWeekly: false,
    );
    await tester.pumpWidget(_host(TaskRow(task: task, onTap: () {})));
    expect(find.text('Deep work'), findsOneWidget);
    expect(find.text('08:05 · 90 min · Neuroplasticity'), findsOneWidget);
  });
}
