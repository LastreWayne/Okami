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
        fontSize: 32,
        fontWeight: FontWeight.w300,
        letterSpacing: 8,
        color: AppColors.ink,
      ),
      headlineLarge: GoogleFonts.shipporiMincho(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: AppColors.ink,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.inkMuted,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12.5,
        fontWeight: FontWeight.w500,
        color: AppColors.inkFaint,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
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
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: AppColors.ink,
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
    );
  }
}
