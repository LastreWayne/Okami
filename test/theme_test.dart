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
