import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get light => _make(false);
  static ThemeData get dark => _make(true);
  static ThemeData _make(bool dark) {
    final ink = dark ? const Color(0xFFF0F4FC) : const Color(0xFF0C2D76);
    final muted = dark ? const Color(0xFFA9B9CE) : const Color(0xFF6B7F9D);
    final primary = dark ? const Color(0xFF3278FA) : const Color(0xFF0755E9);
    final border = dark ? const Color(0xFF253D54) : const Color(0xFFDCE6F2);
    final field = dark ? const Color(0xFF142439) : Colors.white;
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      visualDensity: VisualDensity.standard,
      brightness: dark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: dark
          ? const Color(0xFF091523)
          : const Color(0xFFF7FAFD),
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: primary,
            brightness: dark ? Brightness.dark : Brightness.light,
          ).copyWith(
            primary: primary,
            onSurface: ink,
            surface: field,
            outline: border,
          ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          letterSpacing: 0,
          fontSize: 29,
          height: 1.4,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
        titleLarge: TextStyle(
          letterSpacing: 0,
          fontSize: 22,
          height: 1.4,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        bodyMedium: TextStyle(
          letterSpacing: 0,
          fontSize: 14,
          height: 1.45,
          color: muted,
        ),
        bodySmall: TextStyle(
          letterSpacing: 0,
          fontSize: 12,
          height: 1.45,
          color: muted,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: field,
        hintStyle: TextStyle(letterSpacing: 0, color: muted, fontSize: 14),
        prefixIconColor: muted,
        suffixIconColor: muted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primary),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            letterSpacing: 0,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          backgroundColor: field,
          minimumSize: const Size.fromHeight(56),
          side: BorderSide(color: border),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            letterSpacing: 0,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            letterSpacing: 0,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(48, 36),
        ),
      ),
    );
  }
}
