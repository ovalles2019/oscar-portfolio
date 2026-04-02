import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final base = ThemeData(brightness: brightness, useMaterial3: true);
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF6D5EF7),
    brightness: brightness,
  ).copyWith(
    primary: const Color(0xFF6D5EF7),
    secondary: const Color(0xFF19B8A5),
    surface: isDark ? const Color(0xFF111827) : const Color(0xFFFFFFFF),
    surfaceContainerHighest:
        isDark ? const Color(0xFF1B2434) : const Color(0xFFF4F7FB),
    outline: isDark ? const Color(0xFF344054) : const Color(0xFFD7DEEA),
  );

  final textTheme = GoogleFonts.interTextTheme(base.textTheme).copyWith(
    displayLarge: GoogleFonts.inter(
      fontSize: 64,
      fontWeight: FontWeight.w700,
      height: 1.02,
      letterSpacing: -2.8,
      color: isDark ? Colors.white : const Color(0xFF0F172A),
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 42,
      fontWeight: FontWeight.w700,
      height: 1.08,
      letterSpacing: -1.6,
      color: isDark ? Colors.white : const Color(0xFF0F172A),
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.15,
      letterSpacing: -0.9,
      color: isDark ? Colors.white : const Color(0xFF0F172A),
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: -0.6,
      color: isDark ? Colors.white : const Color(0xFF0F172A),
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.25,
      letterSpacing: -0.3,
      color: isDark ? Colors.white : const Color(0xFF0F172A),
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.7,
      letterSpacing: -0.1,
      color: isDark ? const Color(0xFFD7DEEA) : const Color(0xFF334155),
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.6,
      letterSpacing: 0,
      color: isDark ? const Color(0xFFB8C1D1) : const Color(0xFF475569),
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: isDark ? Colors.white : const Color(0xFF0F172A),
    ),
  );

  return base.copyWith(
    colorScheme: colorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor:
        isDark ? const Color(0xFF060B16) : const Color(0xFFF6F8FC),
    canvasColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: textTheme.titleLarge?.color,
      centerTitle: false,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    dividerColor: colorScheme.outline.withOpacity(0.45),
    cardTheme: CardThemeData(
      elevation: 0,
      color: colorScheme.surface.withOpacity(isDark ? 0.9 : 0.96),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: textTheme.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textTheme.labelLarge?.color,
        side: BorderSide(color: colorScheme.outline.withOpacity(0.7)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: textTheme.labelLarge,
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: colorScheme.surfaceContainerHighest.withOpacity(0.9),
      selectedColor: colorScheme.primary.withOpacity(0.15),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      side: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      labelStyle: textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : const Color(0xFF0F172A),
      ),
    ),
    iconTheme: IconThemeData(color: textTheme.bodyLarge?.color),
  );
}
