# Ōkami Visual Design Polish — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Re-skin the existing Ōkami screens (splash, NeuPlas, task form, bottom nav) into an elegant oriental-iOS sumi-e look, driven by a centralized theme and reusable components.

**Architecture:** Theme-first. All color/gradient/type tokens and component defaults live in `app_theme.dart`; reusable visual widgets live in `app_widgets.dart`. Screens are refactored to consume tokens + components so no styling is hard-coded. No new dependencies (`google_fonts` already present).

**Tech Stack:** Flutter (Material 3, dark), `google_fonts` (Shippori Mincho + Inter), `provider`.

## Global Constraints

- Flutter SDK is NOT on PATH. Invoke it as `C:\Users\aljls\Flutter.native\flutter\bin\flutter.bat`. Commands below write `flutter` for brevity — substitute the full path (or `alias flutter="C:/Users/aljls/Flutter.native/flutter/bin/flutter.bat"` for the shell session).
- Project root: `C:\dev\okami`. Run all `flutter` commands from there.
- `flutter analyze` MUST report **No issues found** at the end of every task.
- Color tokens (verbatim): sumi `#16140F`, surface `#1F1C16`, hairline `#2E2A22`, ink `#F2ECE0`, inkMuted `#9A9286`, inkFaint `#6B6459`, ultramarineDeep `#1E2A7A`, ultramarine `#3A4ED6`, ultramarineBright `#5A78FF`.
- Accent gradient: linear `#1E2A7A → #5A78FF`, topLeft → bottomRight.
- Fonts: Shippori Mincho (headers/wordmark), Inter (body/UI). Priority colors: A=ultramarineBright, B=ultramarine, C=inkFaint.
- `google_fonts` fetches fonts over the network on first render. In tests, disable runtime fetching (`GoogleFonts.config.allowRuntimeFetching = false`) so text falls back silently instead of hitting the network.
- Flutter version here uses `WidgetState`/`WidgetStateProperty` and `CardThemeData` (not the deprecated `MaterialState`/`CardTheme`).
- Visual verification target: emulator `emulator-5554` (`flutter run`). Visual checks are noted per screen; they are confirmation steps, not blockers for analyze.

---

### Task 1: Color/gradient tokens + typography

**Files:**
- Modify: `lib/theme/app_theme.dart` (full rewrite of `AppColors`, add `AppGradients`, rebuild text theme)
- Test: `test/theme_test.dart` (create)

**Interfaces:**
- Produces: `AppColors` (static `Color` fields per Global Constraints), `AppGradients.accent` (`LinearGradient`), `AppTheme.darkTheme` (`ThemeData`) with the Shippori Mincho + Inter `TextTheme`.

- [ ] **Step 1: Write the failing test**

```dart
// test/theme_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:okami/theme/app_theme.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  test('palette tokens match the spec', () {
    expect(AppColors.sumi, const Color(0xFF16140F));
    expect(AppColors.surface, const Color(0xFF1F1C16));
    expect(AppColors.hairline, const Color(0xFF2E2A22));
    expect(AppColors.ink, const Color(0xFFF2ECE0));
    expect(AppColors.inkMuted, const Color(0xFF9A9286));
    expect(AppColors.inkFaint, const Color(0xFF6B6459));
    expect(AppColors.ultramarineDeep, const Color(0xFF1E2A7A));
    expect(AppColors.ultramarine, const Color(0xFF3A4ED6));
    expect(AppColors.ultramarineBright, const Color(0xFF5A78FF));
  });

  test('accent gradient runs deep -> bright', () {
    expect(AppGradients.accent.colors.first, AppColors.ultramarineDeep);
    expect(AppGradients.accent.colors.last, AppColors.ultramarineBright);
  });

  testWidgets('darkTheme uses sumi background', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.darkTheme, home: const Scaffold()),
    );
    final ctx = tester.element(find.byType(Scaffold));
    expect(Theme.of(ctx).scaffoldBackgroundColor, AppColors.sumi);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/theme_test.dart`
Expected: FAIL — `AppGradients` undefined / token values differ.

- [ ] **Step 3: Write the implementation** (replace the entire file)

```dart
// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Base — warm sumi
  static const Color sumi = Color(0xFF16140F);
  static const Color surface = Color(0xFF1F1C16);
  static const Color hairline = Color(0xFF2E2A22);
  // Ink
  static const Color ink = Color(0xFFF2ECE0);
  static const Color inkMuted = Color(0xFF9A9286);
  static const Color inkFaint = Color(0xFF6B6459);
  // Accent — ultramarine gradient family
  static const Color ultramarineDeep = Color(0xFF1E2A7A);
  static const Color ultramarine = Color(0xFF3A4ED6);
  static const Color ultramarineBright = Color(0xFF5A78FF);
  // Priority markers
  static const Color priorityA = ultramarineBright;
  static const Color priorityB = ultramarine;
  static const Color priorityC = inkFaint;
}

class AppGradients {
  static const LinearGradient accent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.ultramarineDeep, AppColors.ultramarineBright],
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    final base = ThemeData(brightness: Brightness.dark);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme).copyWith(
      displayLarge: GoogleFonts.shipporiMincho(
        fontSize: 32, fontWeight: FontWeight.w300,
        letterSpacing: 8, color: AppColors.ink,
      ),
      headlineLarge: GoogleFonts.shipporiMincho(
        fontSize: 28, fontWeight: FontWeight.w500, color: AppColors.ink,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.ink,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.inkMuted,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12.5, fontWeight: FontWeight.w500, color: AppColors.inkFaint,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.sumi,
      canvasColor: AppColors.sumi,
      textTheme: textTheme,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.ultramarine,
        onPrimary: AppColors.ink,
        secondary: AppColors.ultramarineBright,
        surface: AppColors.surface,
        onSurface: AppColors.ink,
        error: Color(0xFFC0564B),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/theme_test.dart`
Expected: PASS (3 tests). Then `flutter analyze` → No issues found.

- [ ] **Step 5: Commit**

```bash
git add lib/theme/app_theme.dart test/theme_test.dart
git commit -m "feat(theme): sumi palette, ultramarine gradient, mincho+inter type"
```

---

### Task 2: Component themes

**Files:**
- Modify: `lib/theme/app_theme.dart` (extend the returned `ThemeData` with component themes)
- Test: `test/theme_test.dart` (add cases)

**Interfaces:**
- Consumes: `AppColors`, `AppGradients` (Task 1).
- Produces: themed `CardThemeData`, `InputDecorationTheme`, `SegmentedButtonThemeData`, `ChipThemeData`, `SwitchThemeData`, `NavigationBarThemeData`, `FilledButtonThemeData`, `AppBarTheme` on `AppTheme.darkTheme`.

- [ ] **Step 1: Write the failing test** (append inside `main()` in `test/theme_test.dart`)

```dart
  test('card theme is flat with hairline border', () {
    final card = AppTheme.darkTheme.cardTheme;
    expect(card.color, AppColors.surface);
    expect(card.elevation, 0);
  });

  test('navigation bar theme uses sumi background', () {
    expect(AppTheme.darkTheme.navigationBarTheme.backgroundColor, AppColors.sumi);
  });
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/theme_test.dart`
Expected: FAIL — `card.color` null / elevation null (no card theme yet).

- [ ] **Step 3: Write the implementation** — in `lib/theme/app_theme.dart`, add these properties to the `ThemeData(...)` returned by `darkTheme` (place them after `colorScheme:`):

```dart
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.hairline),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.sumi,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.shipporiMincho(
          fontSize: 22, fontWeight: FontWeight.w500, color: AppColors.ink,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: const TextStyle(color: AppColors.inkFaint),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.ultramarineBright, width: 1.5),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((s) =>
              s.contains(WidgetState.selected) ? AppColors.ultramarine : Colors.transparent),
          foregroundColor: WidgetStateProperty.resolveWith((s) =>
              s.contains(WidgetState.selected) ? AppColors.ink : AppColors.inkMuted),
          side: const WidgetStatePropertyAll(BorderSide(color: AppColors.hairline)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.ultramarine,
        side: const BorderSide(color: AppColors.hairline),
        labelStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.ink),
        secondaryLabelStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.ink),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        showCheckmark: false,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? AppColors.ink : AppColors.inkMuted),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? AppColors.ultramarine : AppColors.surface),
        trackOutlineColor: const WidgetStatePropertyAll(AppColors.hairline),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.sumi,
        elevation: 0,
        indicatorColor: AppColors.ultramarine.withValues(alpha: 0.18),
        iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
              color: s.contains(WidgetState.selected) ? AppColors.ink : AppColors.inkFaint,
            )),
        labelTextStyle: WidgetStatePropertyAll(
          GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.inkMuted),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.ultramarine,
          foregroundColor: AppColors.ink,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
```

Note: the segmented control uses a solid `ultramarine` fill (theme cannot apply a gradient to a segment); the accent gradient is reserved for the hero button and brush stroke.

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/theme_test.dart`
Expected: PASS (5 tests). Then `flutter analyze` → No issues found.

- [ ] **Step 5: Commit**

```bash
git add lib/theme/app_theme.dart test/theme_test.dart
git commit -m "feat(theme): card/input/segmented/chip/switch/nav/button component themes"
```

---

### Task 3: Ink primitives (BrushStroke, SectionTitle, KanjiWatermark)

**Files:**
- Modify: `lib/widgets/app_widgets.dart` (currently empty)
- Test: `test/app_widgets_test.dart` (create)

**Interfaces:**
- Consumes: `AppColors`, `AppGradients`.
- Produces: `BrushStroke({double width, double height})`, `SectionTitle({required String title, String? subtitle})`, `KanjiWatermark({double size})`.

- [ ] **Step 1: Write the failing test**

```dart
// test/app_widgets_test.dart
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/app_widgets_test.dart`
Expected: FAIL — `BrushStroke`/`SectionTitle`/`KanjiWatermark` undefined.

- [ ] **Step 3: Write the implementation** (replace the contents of `lib/widgets/app_widgets.dart`)

```dart
// lib/widgets/app_widgets.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:okami/theme/app_theme.dart';

/// A short, tapered ink brush stroke filled with the accent gradient.
class BrushStroke extends StatelessWidget {
  final double width;
  final double height;
  const BrushStroke({super.key, this.width = 64, this.height = 6});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(width, height), painter: _BrushPainter());
}

class _BrushPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = AppGradients.accent.createShader(rect)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.25, 0, size.width * 0.6, size.height * 0.35)
      ..quadraticBezierTo(size.width * 0.85, size.height * 0.7, size.width, size.height * 0.25)
      ..quadraticBezierTo(size.width * 0.85, size.height, size.width * 0.55, size.height * 0.78)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.55, 0, size.height * 0.5)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A mincho screen title with a gradient brush underline and optional subtitle.
class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const SectionTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: t.headlineLarge),
        const SizedBox(height: 8),
        const BrushStroke(),
        if (subtitle != null) ...[
          const SizedBox(height: 10),
          Text(subtitle!, style: t.bodyMedium),
        ],
      ],
    );
  }
}

/// A faint 狼 (ōkami / wolf) watermark for backgrounds and empty states.
class KanjiWatermark extends StatelessWidget {
  final double size;
  const KanjiWatermark({super.key, this.size = 160});

  @override
  Widget build(BuildContext context) {
    return Text(
      '狼',
      style: GoogleFonts.shipporiMincho(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: AppColors.ink.withValues(alpha: 0.05),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/app_widgets_test.dart`
Expected: PASS (2 tests). Then `flutter analyze` → No issues found.

- [ ] **Step 5: Commit**

```bash
git add lib/widgets/app_widgets.dart test/app_widgets_test.dart
git commit -m "feat(widgets): BrushStroke, SectionTitle, KanjiWatermark ink primitives"
```

---

### Task 4: Surface components (InkCard, ActionTile, GradientButton)

**Files:**
- Modify: `lib/widgets/app_widgets.dart` (append)
- Test: `test/app_widgets_test.dart` (add cases)

**Interfaces:**
- Consumes: `AppColors`, `AppGradients`.
- Produces: `InkCard({required Widget child, VoidCallback? onTap, EdgeInsetsGeometry padding})`, `ActionTile({required IconData icon, required String label, required VoidCallback onTap})`, `GradientButton({required String label, required VoidCallback onPressed})`.

- [ ] **Step 1: Write the failing test** (append inside `main()` in `test/app_widgets_test.dart`)

```dart
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/app_widgets_test.dart`
Expected: FAIL — `InkCard`/`ActionTile`/`GradientButton` undefined.

- [ ] **Step 3: Write the implementation** (append to `lib/widgets/app_widgets.dart`)

```dart
/// Flat, hairline-bordered surface card (replaces stock Material Card).
class InkCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  const InkCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              child: InkWell(onTap: onTap, child: content),
            ),
    );
  }
}

/// A square-ish tappable tile with an outline icon over a label.
class ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const ActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      child: Column(
        children: [
          Icon(icon, size: 24, color: AppColors.ink),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}

/// Full-width primary button filled with the accent gradient.
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const GradientButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            gradient: AppGradients.accent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Container(
            height: 52,
            alignment: Alignment.center,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/app_widgets_test.dart`
Expected: PASS (5 tests). Then `flutter analyze` → No issues found.

- [ ] **Step 5: Commit**

```bash
git add lib/widgets/app_widgets.dart test/app_widgets_test.dart
git commit -m "feat(widgets): InkCard, ActionTile, GradientButton surface components"
```

---

### Task 5: TaskRow component

**Files:**
- Modify: `lib/widgets/app_widgets.dart` (append; add `import 'package:okami/models/task_model.dart';` at top)
- Test: `test/app_widgets_test.dart` (add case; add the model import)

**Interfaces:**
- Consumes: `InkCard` (Task 4), `AppColors`, `Task`/`TaskPriority`/`TaskCategory` from `lib/models/task_model.dart` (fields used: `title`, `dateTime`, `durationMinutes`, `priority`, `category`).
- Produces: `TaskRow({required Task task, required VoidCallback onTap})`.

- [ ] **Step 1: Write the failing test** (append inside `main()`; ensure `import 'package:okami/models/task_model.dart';` is at the top of the test file)

```dart
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/app_widgets_test.dart`
Expected: FAIL — `TaskRow` undefined.

- [ ] **Step 3: Write the implementation** (add the model import at the top of `lib/widgets/app_widgets.dart`, then append the class)

```dart
// add near the other imports:
import 'package:okami/models/task_model.dart';
```

```dart
/// A single task as a tappable ink card with a gradient priority bar.
class TaskRow extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  const TaskRow({super.key, required this.task, required this.onTap});

  Color get _priorityColor {
    switch (task.priority) {
      case TaskPriority.a:
        return AppColors.priorityA;
      case TaskPriority.b:
        return AppColors.priorityB;
      case TaskPriority.c:
        return AppColors.priorityC;
    }
  }

  String get _categoryLabel {
    switch (task.category) {
      case TaskCategory.body:
        return 'Body';
      case TaskCategory.neuroplasticity:
        return 'Neuroplasticity';
      case TaskCategory.motion:
        return 'Motion';
    }
  }

  String get _meta {
    final h = task.dateTime.hour.toString().padLeft(2, '0');
    final m = task.dateTime.minute.toString().padLeft(2, '0');
    return '$h:$m · ${task.durationMinutes} min · $_categoryLabel';
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkCard(
        onTap: onTap,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 42,
              decoration: BoxDecoration(
                color: _priorityColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: t.titleMedium),
                  const SizedBox(height: 4),
                  Text(_meta, style: t.labelMedium),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.inkFaint, size: 20),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/app_widgets_test.dart`
Expected: PASS (6 tests). Then `flutter analyze` → No issues found.

- [ ] **Step 5: Commit**

```bash
git add lib/widgets/app_widgets.dart test/app_widgets_test.dart
git commit -m "feat(widgets): TaskRow with gradient priority bar and meta line"
```

---

### Task 6: Restyle shared form widgets

**Files:**
- Modify: `lib/widgets/task_form_widgets.dart`

**Interfaces:**
- Consumes: `AppColors`. Keeps existing public APIs (`FieldLabel(String)`, `PrioritySelector`, `CategorySelector`, `RepeatToggle`) unchanged — only styling changes.

The selectors (`SegmentedButton`, `ChoiceChip`, `SwitchListTile`) now inherit styling from the Task 2 themes. The only edit is making `FieldLabel` use the themed `labelLarge` style so labels read as Inter w600 `ink` instead of a hard-coded `TextStyle`.

- [ ] **Step 1: Edit `FieldLabel`** — replace its `build` body:

```dart
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
```

- [ ] **Step 2: Verify analyze + tests still pass**

Run: `flutter analyze` → No issues found.
Run: `flutter test` → all existing tests PASS (no behavior change).

- [ ] **Step 3: Commit**

```bash
git add lib/widgets/task_form_widgets.dart
git commit -m "style(form): FieldLabel uses themed labelLarge; selectors inherit theme"
```

---

### Task 7: Splash screen re-skin

**Files:**
- Modify: `lib/screens/splash_screen.dart` (`build` method + add import)

**Interfaces:**
- Consumes: `AppColors`, `BrushStroke`, `KanjiWatermark`, `displayLarge` text style.

- [ ] **Step 1: Add imports** at the top of `lib/screens/splash_screen.dart`:

```dart
import 'package:okami/theme/app_theme.dart';
import 'package:okami/widgets/app_widgets.dart';
```

- [ ] **Step 2: Replace the `build` method** with:

```dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sumi,
      body: Stack(
        alignment: Alignment.center,
        children: [
          const KanjiWatermark(size: 300),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/app_logo.png', width: 180),
                const SizedBox(height: 28),
                Text('ŌKAMI', style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 16),
                const BrushStroke(width: 88, height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
```

- [ ] **Step 3: Verify**

Run: `flutter analyze` → No issues found.
Visual check (optional now, batched in Task 10): `flutter run -d emulator-5554` → splash shows faint 狼 watermark, logo, mincho ŌKAMI wordmark, gradient brush underline, then fades to MainScreen after 3s.

- [ ] **Step 4: Commit**

```bash
git add lib/screens/splash_screen.dart
git commit -m "style(splash): sumi canvas, mincho wordmark, kanji watermark, brush"
```

---

### Task 8: NeuPlas screen re-skin

**Files:**
- Modify: `lib/screens/neuroplasticity/np_screen.dart`

**Interfaces:**
- Consumes: `SectionTitle`, `ActionTile`, `TaskRow`, `KanjiWatermark`, `AppColors`. Keeps all existing navigation/provider logic.

- [ ] **Step 1: Update imports** — add to the top of `np_screen.dart`:

```dart
import 'package:okami/theme/app_theme.dart';
import 'package:okami/widgets/app_widgets.dart';
```

- [ ] **Step 2: Replace the title block** (the `Text('Task Manager'...)`, the `SizedBox`, and the `Text('Today'...)` — the first three children of the outer `Column`) with:

```dart
              const SectionTitle(title: 'Task Manager', subtitle: 'Today'),
```

- [ ] **Step 3: Replace the two action buttons** — swap each `_buildActionButton(context, icon: ..., label: ..., onTap: ...)` call for an `ActionTile(icon: ..., label: ..., onTap: ...)` with the same arguments. The first becomes:

```dart
                  Expanded(
                    child: ActionTile(
                      icon: Icons.lock_outline,
                      label: 'Lock in',
                      onTap: () {
                        final task = context.read<TaskProvider>().currentTask();
                        if (task == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No Task planned currently')),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LockingInScreen(task: task),
                            ),
                          );
                        }
                      },
                    ),
                  ),
```

and the second:

```dart
                  Expanded(
                    child: ActionTile(
                      icon: Icons.edit_attributes_outlined,
                      label: 'Organize my week',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WeekOrgScreen(),
                          ),
                        );
                      },
                    ),
                  ),
```

- [ ] **Step 4: Replace `_buildTaskList`** body to use `TaskRow`:

```dart
  Widget _buildTaskList(BuildContext context, List<Task> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, idx) {
        final task = tasks[idx];
        return TaskRow(
          task: task,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditTaskScreen(task: task)),
            );
          },
        );
      },
    );
  }
```

- [ ] **Step 5: Delete the now-unused helpers** `_buildActionButton` and `_formatHour` (the latter moved into `TaskRow`). Replace `_buildEmptyState` with:

```dart
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const KanjiWatermark(size: 120),
          const SizedBox(height: 8),
          Text(
            'No tasks yet',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 20),
          ),
        ],
      ),
    );
  }
```

- [ ] **Step 6: Verify**

Run: `flutter analyze` → No issues found (confirm no leftover references to `_buildActionButton`/`_formatHour`).
Run: `flutter test` → all PASS.

- [ ] **Step 7: Commit**

```bash
git add lib/screens/neuroplasticity/np_screen.dart
git commit -m "style(neuplas): SectionTitle, ActionTiles, TaskRow list, kanji empty state"
```

---

### Task 9: Task form screens (New + Edit)

**Files:**
- Modify: `lib/screens/neuroplasticity/new_task_screen.dart`
- Modify: `lib/screens/neuroplasticity/edit_task_screen.dart`

**Interfaces:**
- Consumes: `GradientButton`, themed `InputDecorationTheme`/`AppBarTheme`.

- [ ] **Step 1: New task — add import** at top of `new_task_screen.dart`:

```dart
import '../../widgets/app_widgets.dart';
```

- [ ] **Step 2: New task — remove the explicit `border: OutlineInputBorder()`** from all three `TextField` decorations so they inherit the themed input style. Each `decoration` becomes, e.g.:

```dart
              decoration: const InputDecoration(hintText: 'The TASK'),
```

(Apply the same removal to the description field `hintText: 'What is it about?'` and the duration field `hintText: 'How much?'`.)

- [ ] **Step 3: New task — replace the save button** (`SizedBox(width: double.infinity, child: FilledButton(...))`) with:

```dart
            SizedBox(
              width: double.infinity,
              child: GradientButton(label: 'Create Task', onPressed: _saveTask),
            ),
```

- [ ] **Step 4: Edit task — add import** at top of `edit_task_screen.dart`:

```dart
import '../../widgets/app_widgets.dart';
```

- [ ] **Step 5: Edit task — remove `border: OutlineInputBorder()`** from the title, description, and duration `TextField` decorations (same as Step 2).

- [ ] **Step 6: Edit task — replace the save button** (`SizedBox(width: double.infinity, child: FilledButton(onPressed: _saveChanges, ...))`) with:

```dart
            SizedBox(
              width: double.infinity,
              child: GradientButton(label: 'Save changes', onPressed: _saveChanges),
            ),
```

Leave the Delete `OutlinedButton.icon` as-is (it uses `colorScheme.error`, which is themed).

- [ ] **Step 7: Verify**

Run: `flutter analyze` → No issues found.
Run: `flutter test` → all PASS.

- [ ] **Step 8: Commit**

```bash
git add lib/screens/neuroplasticity/new_task_screen.dart lib/screens/neuroplasticity/edit_task_screen.dart
git commit -m "style(task-form): gradient primary button, themed inputs, mincho app bar"
```

---

### Task 10: Bottom nav verification + full visual pass

**Files:**
- Modify (only if needed): `lib/screens/main_screen.dart`

**Interfaces:**
- Consumes: `NavigationBarThemeData` (Task 2). No code change expected — the `NavigationBar` inherits the theme.

- [ ] **Step 1: Confirm nav inherits the theme** — read `main_screen.dart`. The `NavigationBar` should need no edits (background `sumi`, inactive icons `inkFaint`, subtle ultramarine indicator all come from theme). If any hard-coded color exists, remove it so the theme applies.

- [ ] **Step 2: Full analyze + test sweep**

Run: `flutter analyze` → No issues found.
Run: `flutter test` → all PASS.

- [ ] **Step 3: Visual pass on device**

Run: `flutter run -d emulator-5554`. Walk through and confirm:
  - Splash: watermark + mincho wordmark + brush, fades to app.
  - NeuPlas: mincho title with brush underline; two ink action tiles; create a task → it appears as a TaskRow with the correct priority-color bar and `HH:MM · N min · Category` meta; empty state shows 狼 + "No tasks yet".
  - Tap a task → Edit screen: mincho app bar, themed inputs, gradient "Save changes" button, error-red Delete.
  - New task (via the existing entry point): gradient "Create Task" button, themed inputs.
  - Bottom nav: sumi background, ink active icon, faint inactive icons, subtle ultramarine indicator pill.

If a build artifact looks stale, run `flutter clean` then `flutter run` (known OneDrive/incremental-build gotcha — though the project now lives at `C:\dev\okami`, keep this in mind).

- [ ] **Step 4: Commit** (only if Step 1 changed a file)

```bash
git add lib/screens/main_screen.dart
git commit -m "style(nav): rely on themed NavigationBar"
```

---

## Self-Review

**Spec coverage:**
- Color tokens + gradient → Task 1 ✓
- Typography (Shippori Mincho + Inter) → Task 1 ✓
- Component themes (card/input/segmented/chip/switch/nav/button/appbar) → Task 2 ✓
- InkCard, TaskRow, ActionTile, BrushStroke, SectionTitle, KanjiWatermark, GradientButton → Tasks 3–5 ✓
- Restyle PrioritySelector/CategorySelector/RepeatToggle/FieldLabel → Task 6 (selectors via theme, FieldLabel direct) ✓
- Splash → Task 7 ✓ · NeuPlas → Task 8 ✓ · New/Edit form → Task 9 ✓ · Bottom nav → Task 10 ✓
- Out-of-scope (Home/Body/Motion) → untouched ✓
- Verification (analyze green + emulator-5554) → per-task + Task 10 ✓

**Deviations from spec (intentional, noted):** segmented control uses solid `ultramarine` rather than a gradient fill (theme limitation); "iOS large title" is realized as a mincho `AppBarTheme` title rather than a collapsing large-title header (keeps scope tight). Both preserve the intended look.

**Placeholder scan:** none — every code step contains complete code.

**Type consistency:** `InkCard(child/onTap/padding)`, `TaskRow(task/onTap)`, `ActionTile(icon/label/onTap)`, `GradientButton(label/onPressed)`, `SectionTitle(title/subtitle)`, `BrushStroke(width/height)`, `KanjiWatermark(size)` are referenced consistently across Tasks 3–9. `Task` fields (`title`, `dateTime`, `durationMinutes`, `priority`, `category`) match `task_model.dart` usage.
