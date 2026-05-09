import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final base = ThemeData(brightness: brightness, useMaterial3: true);

  // ─── Dark-tech palette (Agenai-inspired) ─────────────────────────
  const dBg = Color(0xFF080810);
  const dSurface = Color(0xFF0E0E1A);
  const dSurfaceHigh = Color(0xFF161625);
  const dBorder = Color(0xFF1C1C32);
  const dText = Color(0xFFF0F0F8);
  const dTextMuted = Color(0xFF6E6E88);

  const lBg = Color(0xFFF5F5FA);
  const lSurface = Color(0xFFFFFFFF);
  const lSurfaceHigh = Color(0xFFEEEEF4);
  const lText = Color(0xFF12121A);
  const lTextMuted = Color(0xFF6B6B80);

  const indigo = Color(0xFF6366F1);
  const cyan = Color(0xFF22D3EE);
  const purple = Color(0xFFA855F7);

  final primary = isDark ? indigo : const Color(0xFF4F46E5);
  final onPrimary = Colors.white;
  final textMain = isDark ? dText : lText;
  final textSub = isDark ? dTextMuted : lTextMuted;

  final scheme = ColorScheme(
    brightness: brightness,
    primary: primary,
    onPrimary: onPrimary,
    secondary: isDark ? cyan : const Color(0xFF0891B2),
    onSecondary: isDark ? dBg : Colors.white,
    tertiary: isDark ? purple : const Color(0xFF7C3AED),
    onTertiary: Colors.white,
    error: const Color(0xFFEF4444),
    onError: Colors.white,
    surface: isDark ? dSurface : lSurface,
    onSurface: textMain,
    surfaceContainerHighest: isDark ? dSurfaceHigh : lSurfaceHigh,
    onSurfaceVariant: textSub,
    outline: isDark ? dBorder : const Color(0xFFDDDDE6),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: isDark ? lSurface : dSurface,
    onInverseSurface: isDark ? lText : dText,
    inversePrimary: isDark ? const Color(0xFF4F46E5) : indigo,
  );

  // ─── Typography — Urbanist ────────────────────────────────────────
  final urbanist = GoogleFonts.urbanist(color: textMain);

  final textTheme = GoogleFonts.urbanistTextTheme(base.textTheme).copyWith(
    displayLarge: urbanist.copyWith(
      fontSize: 80,
      height: 0.95,
      letterSpacing: -3.0,
      fontWeight: FontWeight.w800,
    ),
    displayMedium: urbanist.copyWith(
      fontSize: 52,
      height: 0.98,
      letterSpacing: -1.8,
      fontWeight: FontWeight.w700,
    ),
    displaySmall: urbanist.copyWith(
      fontSize: 40,
      height: 1.0,
      letterSpacing: -1.0,
      fontWeight: FontWeight.w700,
    ),
    headlineLarge: urbanist.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.6,
    ),
    headlineMedium: urbanist.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.4,
    ),
    headlineSmall: urbanist.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    bodyLarge: urbanist.copyWith(
      fontSize: 16,
      height: 1.75,
      fontWeight: FontWeight.w400,
      color: textSub,
    ),
    bodyMedium: urbanist.copyWith(
      fontSize: 14,
      height: 1.65,
      fontWeight: FontWeight.w400,
      color: textSub,
    ),
    bodySmall: urbanist.copyWith(
      fontSize: 12,
      height: 1.5,
      color: textSub,
    ),
    labelLarge: urbanist.copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w800,
      letterSpacing: 2.2,
      color: primary,
    ),
    labelMedium: urbanist.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.4,
    ),
  );

  // ─── Components ───────────────────────────────────────────────────
  return base.copyWith(
    colorScheme: scheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: isDark ? dBg : lBg,
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: scheme.surface,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: urbanist.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
          color: onPrimary,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textMain,
        side: BorderSide(color: isDark ? dBorder : const Color(0xFFCCCCD8), width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: urbanist.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
          color: textMain,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        textStyle: urbanist.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: isDark ? dSurfaceHigh : lSurfaceHigh,
      labelStyle: TextStyle(
          color: textMain, fontWeight: FontWeight.w600, fontSize: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      side: BorderSide.none,
    ),
    dividerColor: scheme.outline.withValues(alpha: 0.12),
    appBarTheme: AppBarTheme(
      backgroundColor: (isDark ? dBg : lBg).withValues(alpha: 0.75),
      foregroundColor: textMain,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? dSurface : lSurface.withValues(alpha: 0.8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.15)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.error),
      ),
      labelStyle: TextStyle(color: textSub, fontWeight: FontWeight.w500),
    ),
  );
}
