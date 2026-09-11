import 'package:flutter/material.dart';

abstract final class DisqamColors {
  static const primary = Color(0xFF0D7B8E);
  static const navy = Color(0xFF0B2354);
  static const background = Color(0xFFF5F9F8);
  static const surfaceAlt = Color(0xFFE4F1F0);
  static const text = Color(0xFF18323B);
  static const muted = Color(0xFF5D747B);
  static const border = Color(0xFFD9E6E9);
  static const accentSoft = Color(0xFFFFF2D5);
}

ThemeData buildDisqamTheme() {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: DisqamColors.primary,
        brightness: Brightness.light,
      ).copyWith(
        primary: DisqamColors.primary,
        onPrimary: Colors.white,
        surface: Colors.white,
        onSurface: DisqamColors.text,
        onSurfaceVariant: DisqamColors.muted,
        outline: DisqamColors.border,
        error: const Color(0xFFB84B4B),
      );
  const textTheme = TextTheme(
    displaySmall: TextStyle(
      fontSize: 36,
      height: 1.12,
      letterSpacing: -1,
      fontWeight: FontWeight.w700,
      color: DisqamColors.navy,
    ),
    headlineLarge: TextStyle(
      fontSize: 30,
      height: 1.25,
      fontWeight: FontWeight.w700,
      color: DisqamColors.navy,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      height: 1.3,
      fontWeight: FontWeight.w700,
      color: DisqamColors.navy,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      height: 1.3,
      fontWeight: FontWeight.w700,
      color: DisqamColors.navy,
    ),
    titleMedium: TextStyle(
      fontSize: 20,
      height: 1.35,
      fontWeight: FontWeight.w600,
      color: DisqamColors.navy,
    ),
    titleSmall: TextStyle(
      fontSize: 18,
      height: 1.4,
      fontWeight: FontWeight.w600,
      color: DisqamColors.navy,
    ),
    bodyLarge: TextStyle(fontSize: 17, height: 1.65, color: DisqamColors.text),
    bodyMedium: TextStyle(fontSize: 17, height: 1.5, color: DisqamColors.text),
    bodySmall: TextStyle(fontSize: 16, height: 1.5, color: DisqamColors.muted),
    labelLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontSize: 16),
  );
  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: DisqamColors.background,
    textTheme: textTheme,
    visualDensity: VisualDensity.standard,
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 56),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: shape,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 56),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: shape,
        side: const BorderSide(color: DisqamColors.border),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: DisqamColors.border),
      ),
    ),
  );
}
