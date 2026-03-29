import 'package:flutter/material.dart';

// ── Paleta de colores (extraída del mockup) ───────────────────────────────────
class AppColors {
  AppColors._();

  // Fondos
  static const Color bgPrimary = Color(0xFF0A0A0F);
  static const Color bgSecondary = Color(0xFF12121A);
  static const Color bgTertiary = Color(0xFF1A1A24);

  // Acento
  static const Color accentPrimary = Color(0xFF6C63FF);
  static const Color accentSecondary = Color(0xFFFF6B6B);
  static const Color accentGreen = Color(0xFF4ECDC4);

  // Texto
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8B8B9E);
  static const Color textMuted = Color(0xFF4A4A5E);

  // Borde
  static const Color border = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
}

// ── Tema principal ────────────────────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bgPrimary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accentPrimary,
          secondary: AppColors.accentGreen,
          error: AppColors.accentSecondary,
          surface: AppColors.bgSecondary,
          onPrimary: AppColors.textPrimary,
          onSecondary: AppColors.textPrimary,
          onSurface: AppColors.textPrimary,
          onError: AppColors.textPrimary,
        ),
        cardTheme: CardThemeData(
          color: AppColors.bgSecondary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.bgTertiary,
          hintStyle: const TextStyle(color: AppColors.textMuted),
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.accentPrimary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.accentSecondary),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.accentSecondary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentPrimary,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.accentPrimary,
            textStyle: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
          titleLarge: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
          bodySmall: TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.border,
          space: 1,
          thickness: 1,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bgSecondary,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.bgSecondary,
          selectedItemColor: AppColors.accentPrimary,
          unselectedItemColor: AppColors.textMuted,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
      );
}
