import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appTheme(Brightness brightness) {
  final base = ThemeData(brightness: brightness, useMaterial3: true);

  return base.copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF007AFF), // Apple Blue
      brightness: brightness,
    ),
    textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: brightness == Brightness.dark ? Colors.white : const Color(0xFF1D1D1F),
      displayColor: brightness == Brightness.dark ? Colors.white : const Color(0xFF1D1D1F),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: brightness == Brightness.dark 
        ? const Color(0xFF1E2A3A) // Dark blue-gray for cards
        : const Color(0xFFFFFFFF), // Crispy white for cards
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007AFF),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF007AFF),
        side: const BorderSide(color: Color(0xFF007AFF), width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: brightness == Brightness.dark 
        ? const Color(0xFF2A3A4A) // Darker blue-gray for chips
        : const Color(0xFFF8F9FA), // Light gray for chips on white
      labelStyle: TextStyle(
        color: brightness == Brightness.dark 
          ? Colors.white 
          : const Color(0xFF1D1D1F),
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    scaffoldBackgroundColor: brightness == Brightness.dark 
      ? const Color(0xFF0A1428) // Rich dark blue background
      : const Color(0xFFFFFFFF), // Crispy white background
  );
}
