import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:okami/theme/app_theme.dart';

void main() {
  test('palette tokens match the spec', () {
    expect(AppColors.sumi, const Color(0xFF0E0F13));
    expect(AppColors.surface, const Color(0xFF17191F));
    expect(AppColors.hairline, const Color(0xFF282C34));
    expect(AppColors.ink, const Color(0xFFECEEF2));
    expect(AppColors.inkMuted, const Color(0xFF9DA1A9));
    expect(AppColors.inkFaint, const Color(0xFF686C74));
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

  test('card theme is flat with hairline border', () {
    final card = AppTheme.darkTheme.cardTheme;
    expect(card.color, AppColors.surface);
    expect(card.elevation, 0);
  });

  test('navigation bar theme uses sumi background', () {
    expect(AppTheme.darkTheme.navigationBarTheme.backgroundColor, AppColors.sumi);
  });
}
