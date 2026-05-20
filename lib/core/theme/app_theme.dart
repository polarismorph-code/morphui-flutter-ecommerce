import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          brightness: Brightness.light,
          surface: AppColors.surface,
          primary: AppColors.primary,
          onPrimary: AppColors.textInverted,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.text,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleTextStyle: TextStyle(
            color: AppColors.text,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textInverted,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.border),
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          hintStyle: const TextStyle(
            color: AppColors.textTertiary,
            fontSize: 15,
          ),
          labelStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w700,
            letterSpacing: -1,
          ),
          headlineLarge: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          headlineMedium: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          headlineSmall: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
          titleLarge: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
          titleMedium: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          bodyLarge: TextStyle(
            color: AppColors.text,
            fontSize: 16,
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      );

  // Fallback — Morph generates the live dark palette at runtime via the
  // backend. This theme is only shown when the backend is unreachable
  // (no wifi, local dev, etc.). Keep it soft — no pure black.
  //
  // Reference: Apple dark UI palette
  //   Background  #1C1C1E  — dark but not black
  //   Surface     #2C2C2E  — elevated surface
  //   Text        #F2F2F7  — off-white
  //   Subtle      #AEAEB2  — secondary label
  //   Faint       #636366  — tertiary label
  //   Border      #3A3A3C  — separator
  static const Color _bg     = Color(0xFF1C1C1E);
  static const Color _surface= Color(0xFF2C2C2E);
  static const Color _text   = Color(0xFFF2F2F7);
  static const Color _subtle = Color(0xFFAEAEB2);
  static const Color _faint  = Color(0xFF636366);
  static const Color _border = Color(0xFF3A3A3C);

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          brightness: Brightness.dark,
        ).copyWith(
          surface: _surface,
          onSurface: _text,
          onSurfaceVariant: _subtle,
          outline: _border,
          outlineVariant: _border,
          // Primary = white in dark mode (buttons, active states)
          primary: _text,
          onPrimary: _bg,
          // Secondary = indigo stays constant — it's a brand anchor
          secondary: AppColors.accent,
          onSecondary: _text,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: _bg,
          foregroundColor: _text,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: TextStyle(
            color: _text,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        cardTheme: CardThemeData(
          color: _surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: _border, width: 1),
          ),
        ),
        dividerTheme: DividerThemeData(
          color: _border,
          thickness: 1,
          space: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _text,
            foregroundColor: _bg,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: _border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: _border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: _text, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          hintStyle: TextStyle(color: _faint, fontSize: 15),
          labelStyle: TextStyle(color: _subtle, fontSize: 15),
        ),
        textTheme: TextTheme(
          displayLarge:  TextStyle(color: _text, fontWeight: FontWeight.w700, letterSpacing: -1),
          headlineLarge: TextStyle(color: _text, fontWeight: FontWeight.w700, letterSpacing: -0.5),
          headlineMedium:TextStyle(color: _text, fontWeight: FontWeight.w700, letterSpacing: -0.5),
          headlineSmall: TextStyle(color: _text, fontWeight: FontWeight.w600, letterSpacing: -0.3),
          titleLarge:    TextStyle(color: _text, fontWeight: FontWeight.w600, letterSpacing: -0.3),
          titleMedium:   TextStyle(color: _text, fontWeight: FontWeight.w600, letterSpacing: -0.2),
          bodyLarge:     TextStyle(color: _text,   fontSize: 16, height: 1.5),
          bodyMedium:    TextStyle(color: _subtle, fontSize: 14, height: 1.5),
        ),
      );
}
