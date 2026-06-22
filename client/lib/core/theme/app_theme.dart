import 'package:flutter/material.dart';

// ── Tokens de color (ThemeExtension = "CSS variables" de Flutter) ─────────────
//
// Define los colores semánticos UNA vez. Hay dos instancias: dark y light.
// Flutter resuelve automáticamente cuál usar vía Theme.of(context).extension<>().
// Para leer en un widget: context.appColors.bgPrimary   (o el shorthand context.colorBgPrimary)
// Para cambiar la paleta: edita solo AppColorTokens.dark o AppColorTokens.light.
//
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  const AppColorTokens({
    required this.bgPrimary,
    required this.bgSecondary,
    required this.bgTertiary,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
  });

  final Color bgPrimary;    // fondo scaffold
  final Color bgSecondary;  // cards, appbar, bottom sheet
  final Color bgTertiary;   // inputs, hover, chips
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;

  // ── Paleta oscura ─────────────────────────────────────────────────────────
  static const dark = AppColorTokens(
    bgPrimary:     Color(0xFF0A0A0F),
    bgSecondary:   Color(0xFF12121A),
    bgTertiary:    Color(0xFF1A1A24),
    textPrimary:   Color(0xFFFFFFFF),
    textSecondary: Color(0xFF8B8B9E),
    textMuted:     Color(0xFF4A4A5E),
    border:        Color(0x14FFFFFF), // rgba(255,255,255,0.08)
  );

  // ── Paleta clara ──────────────────────────────────────────────────────────
  // Tonos lavanda suave que espejean la "personalidad" del modo oscuro.
  // Edita aquí y todo se propaga automáticamente.
  static const light = AppColorTokens(
    bgPrimary:     Color(0xFFECECF5), // scaffold: gris-lavanda
    bgSecondary:   Color(0xFFF5F5FD), // cards: blanco-lavanda
    bgTertiary:    Color(0xFFE2E2EE), // inputs/hover: lavanda visible
    textPrimary:   Color(0xFF1A1A2E),
    textSecondary: Color(0xFF555566),
    textMuted:     Color(0xFF9999AA),
    border:        Color(0x1A000000), // rgba(0,0,0,0.10)
  );

  // ── ThemeExtension overrides ──────────────────────────────────────────────
  @override
  AppColorTokens copyWith({
    Color? bgPrimary,
    Color? bgSecondary,
    Color? bgTertiary,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? border,
  }) => AppColorTokens(
    bgPrimary:     bgPrimary     ?? this.bgPrimary,
    bgSecondary:   bgSecondary   ?? this.bgSecondary,
    bgTertiary:    bgTertiary    ?? this.bgTertiary,
    textPrimary:   textPrimary   ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    textMuted:     textMuted     ?? this.textMuted,
    border:        border        ?? this.border,
  );

  @override
  AppColorTokens lerp(ThemeExtension<AppColorTokens>? other, double t) {
    if (other is! AppColorTokens) return this;
    return AppColorTokens(
      bgPrimary:     Color.lerp(bgPrimary,     other.bgPrimary,     t)!,
      bgSecondary:   Color.lerp(bgSecondary,   other.bgSecondary,   t)!,
      bgTertiary:    Color.lerp(bgTertiary,    other.bgTertiary,    t)!,
      textPrimary:   Color.lerp(textPrimary,   other.textPrimary,   t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted:     Color.lerp(textMuted,     other.textMuted,     t)!,
      border:        Color.lerp(border,        other.border,        t)!,
    );
  }
}

// ── Colores globales (independientes del tema) ────────────────────────────────
class AppColors {
  AppColors._();

  // Acento (igual en oscuro y claro)
  static const Color accentPrimary   = Color(0xFF5B4FE8);
  static const Color accentSecondary = Color(0xFFFF6B6B);
  static const Color accentGreen     = Color(0xFF00C9A7);

  // Institucionales
  static const Color ubbBlue   = Color(0xFF014898);
  static const Color ubbYellow = Color(0xFFF9B214);
  static const Color ubbRed    = Color(0xFFE41B1A);
  static const Color orange    = Color(0xFFFF8C42);
  static const Color pink      = Color(0xFFFF6B9D);

  // Grupos musculares
  static const Color musclePecho    = Color(0xFF3b82f6);
  static const Color muscleEspalda  = Color(0xFF8b5cf6);
  static const Color musclePiernas  = Color(0xFF22c55e);
  static const Color muscleHombros  = Color(0xFFf97316);
  static const Color muscleBrazos   = Color(0xFFec4899);
  static const Color muscleCore     = Color(0xFFeab308);
  static const Color muscleGluteos  = Color(0xFFef4444);

  // Dificultad
  static const Color diffPrincipiante = Color(0xFF4ECDC4);
  static const Color diffIntermedio   = Color(0xFFFFB347);
  static const Color diffAvanzado     = Color(0xFFFF6B6B);

  // ── Aliases backward-compat ──────────────────────────────────────────────
  // Los widgets que aún usan AppColors.bgPrimary etc. siguen compilando.
  // Preferir siempre context.colorBgPrimary (resuelve según modo activo).
  // Modo oscuro
  static const Color bgPrimary    = Color(0xFF0A0A0F);
  static const Color bgSecondary  = Color(0xFF12121A);
  static const Color bgTertiary   = Color(0xFF1A1A24);
  static const Color textPrimary  = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8B8B9E);
  static const Color textMuted    = Color(0xFF4A4A5E);
  static const Color border       = Color(0x14FFFFFF);
  // Modo claro
  static const Color bgPrimaryLight    = Color(0xFFECECF5);
  static const Color bgSecondaryLight  = Color(0xFFF5F5FD);
  static const Color bgTertiaryLight   = Color(0xFFE2E2EE);
  static const Color textPrimaryLight  = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF555566);
  static const Color textMutedLight    = Color(0xFF9999AA);
  static const Color borderLight       = Color(0x1A000000);
}

// ── Extensión de contexto ─────────────────────────────────────────────────────
//
// Acceso: context.appColors.bgPrimary       — objeto completo (útil en cascada)
//         context.colorBgPrimary            — shorthand directo (más común)
//
extension AppColorsX on BuildContext {
  AppColorTokens get appColors =>
      Theme.of(this).extension<AppColorTokens>() ?? AppColorTokens.dark;

  Color get colorBgPrimary     => appColors.bgPrimary;
  Color get colorBgSecondary   => appColors.bgSecondary;
  Color get colorBgTertiary    => appColors.bgTertiary;
  Color get colorTextPrimary   => appColors.textPrimary;
  Color get colorTextSecondary => appColors.textSecondary;
  Color get colorTextMuted     => appColors.textMuted;
  Color get colorBorder        => appColors.border;
  bool  get isDarkMode         => Theme.of(this).brightness == Brightness.dark;
}

// ── Temas Material 3 ──────────────────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    const t = AppColorTokens.light;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      extensions: const [t],
      scaffoldBackgroundColor: t.bgPrimary,
      colorScheme: ColorScheme.light(
        primary: AppColors.accentPrimary,
        secondary: AppColors.accentGreen,
        error: AppColors.accentSecondary,
        surface: t.bgSecondary,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: t.textPrimary,
        onError: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: t.bgSecondary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: t.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: t.bgTertiary,
        hintStyle: TextStyle(color: t.textMuted),
        labelStyle: TextStyle(color: t.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: t.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: t.border),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColors.accentPrimary, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColors.accentSecondary),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColors.accentSecondary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accentPrimary,
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge:  TextStyle(color: t.textPrimary, fontSize: 28, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(color: t.textPrimary, fontSize: 22, fontWeight: FontWeight.w700),
        titleLarge:     TextStyle(color: t.textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        titleMedium:    TextStyle(color: t.textPrimary, fontSize: 16, fontWeight: FontWeight.w500),
        bodyLarge:      TextStyle(color: t.textPrimary, fontSize: 16),
        bodyMedium:     TextStyle(color: t.textSecondary, fontSize: 14),
        bodySmall:      TextStyle(color: t.textMuted, fontSize: 12),
      ),
      dividerTheme: DividerThemeData(color: t.border, space: 1, thickness: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: t.bgSecondary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(color: t.textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        iconTheme: IconThemeData(color: t.textPrimary),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: t.bgSecondary,
        indicatorColor: AppColors.accentPrimary.withValues(alpha: 0.15),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: AppColors.accentPrimary, fontSize: 11, fontWeight: FontWeight.w600);
          }
          return TextStyle(color: t.textMuted, fontSize: 11, fontWeight: FontWeight.w400);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.accentPrimary, size: 22);
          }
          return IconThemeData(color: t.textMuted, size: 22);
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: t.bgTertiary,
        selectedColor: AppColors.accentPrimary.withValues(alpha: 0.15),
        labelStyle: TextStyle(color: t.textPrimary, fontSize: 12),
        secondaryLabelStyle: const TextStyle(color: AppColors.accentPrimary, fontSize: 12),
        side: BorderSide(color: t.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: t.bgSecondary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(color: t.textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        contentTextStyle: TextStyle(color: t.textSecondary, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: t.textPrimary, // texto blanco en claro, negro en oscuro — invertido
        contentTextStyle: TextStyle(color: t.bgPrimary, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: t.bgSecondary,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accentPrimary,
      ),
    );
  }

  static ThemeData get dark {
    const t = AppColorTokens.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      extensions: const [t],
      scaffoldBackgroundColor: t.bgPrimary,
      colorScheme: ColorScheme.dark(
        primary: AppColors.accentPrimary,
        secondary: AppColors.accentGreen,
        error: AppColors.accentSecondary,
        surface: t.bgSecondary,
        onPrimary: t.textPrimary,
        onSecondary: t.textPrimary,
        onSurface: t.textPrimary,
        onError: t.textPrimary,
      ),
      cardTheme: CardThemeData(
        color: t.bgSecondary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: t.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: t.bgTertiary,
        hintStyle: TextStyle(color: t.textMuted),
        labelStyle: TextStyle(color: t.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: t.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: t.border),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColors.accentPrimary, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColors.accentSecondary),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColors.accentSecondary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentPrimary,
          foregroundColor: t.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.3),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accentPrimary,
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge:  TextStyle(color: t.textPrimary, fontSize: 28, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(color: t.textPrimary, fontSize: 22, fontWeight: FontWeight.w700),
        titleLarge:     TextStyle(color: t.textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        titleMedium:    TextStyle(color: t.textPrimary, fontSize: 16, fontWeight: FontWeight.w500),
        bodyLarge:      TextStyle(color: t.textPrimary, fontSize: 16),
        bodyMedium:     TextStyle(color: t.textSecondary, fontSize: 14),
        bodySmall:      TextStyle(color: t.textMuted, fontSize: 12),
      ),
      dividerTheme: DividerThemeData(color: t.border, space: 1, thickness: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: t.bgSecondary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(color: t.textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        iconTheme: IconThemeData(color: t.textPrimary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: t.bgSecondary,
        selectedItemColor: AppColors.accentPrimary,
        unselectedItemColor: t.textMuted,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: t.bgSecondary,
        indicatorColor: AppColors.accentPrimary.withValues(alpha: 0.18),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: AppColors.accentPrimary, fontSize: 11, fontWeight: FontWeight.w600);
          }
          return TextStyle(color: t.textSecondary, fontSize: 11, fontWeight: FontWeight.w400);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.accentPrimary, size: 22);
          }
          return IconThemeData(color: t.textSecondary, size: 22);
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: t.bgTertiary,
        selectedColor: AppColors.accentPrimary.withValues(alpha: 0.20),
        labelStyle: TextStyle(color: t.textPrimary, fontSize: 12),
        secondaryLabelStyle: const TextStyle(color: AppColors.accentPrimary, fontSize: 12),
        side: BorderSide(color: t.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: t.bgSecondary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(color: t.textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        contentTextStyle: TextStyle(color: t.textSecondary, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: t.bgTertiary,
        contentTextStyle: TextStyle(color: t.textPrimary, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: t.bgSecondary,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accentPrimary,
      ),
    );
  }
}
