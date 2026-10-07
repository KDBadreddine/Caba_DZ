import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Color Palette — matched to CabaDZ mockup ────────────────────────────────
class AppColors {
  AppColors._();

  static const Color primary        = Color(0xFF0C3D2A);
  static const Color primaryDark    = Color(0xFF082818);
  static const Color primaryLight   = Color(0xFFE8F2EC);
  static const Color primaryMid     = Color(0xFF1A5C3E);

  static const Color accent         = Color(0xFFFFFFFF);
  static const Color background     = Color(0xFFFFFFFF);
  static const Color cardBg         = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF4F5F7);

  static const Color textPrimary    = Color(0xFF111111);
  static const Color textSecondary  = Color(0xFF8A8A8A);
  static const Color textHint       = Color(0xFFB4B4B4);

  static const Color error          = Color(0xFFE53935);
  static const Color success        = Color(0xFF22C55E);
  static const Color warning        = Color(0xFFF59E0B);
  static const Color info           = Color(0xFF3B82F6);

  static const Color border         = Color(0xFFEEEEEE);
  static const Color divider        = Color(0xFFF3F4F6);
  static const Color shadow         = Color(0x0F000000);

  static const Color starYellow     = Color(0xFFFFB800);
  static const Color skyTop         = Color(0xFFD6E8F5);
  static const Color skyBottom      = Color(0xFFFFFFFF);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A5C3E), Color(0xFF0C3D2A)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFD6E8F5), Color(0xFFFFFFFF)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0C3D2A), Color(0xFF1A5C3E)],
  );
}

// ─── Text Styles ─────────────────────────────────────────────────────────────
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get displayLarge => GoogleFonts.cairo(
    fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
  );

  static TextStyle get displayMedium => GoogleFonts.cairo(
    fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
  );

  static TextStyle get headlineLarge => GoogleFonts.cairo(
    fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
  );

  static TextStyle get headlineMedium => GoogleFonts.cairo(
    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
  );

  static TextStyle get titleLarge => GoogleFonts.cairo(
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.cairo(
    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  static TextStyle get bodyLarge => GoogleFonts.cairo(
    fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.cairo(
    fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
  );

  static TextStyle get bodySmall => GoogleFonts.cairo(
    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
  );

  static TextStyle get labelLarge => GoogleFonts.cairo(
    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary,
  );

  static TextStyle get buttonText => GoogleFonts.cairo(
    fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.accent,
  );
}

// ─── App Theme ───────────────────────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.primaryMid,
        surface: AppColors.cardBg,
        error: AppColors.error,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: GoogleFonts.cairo().fontFamily,
      textTheme: TextTheme(
        displayLarge:  AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        titleLarge:    AppTextStyles.titleLarge,
        titleMedium:   AppTextStyles.titleMedium,
        bodyLarge:     AppTextStyles.bodyLarge,
        bodyMedium:    AppTextStyles.bodyMedium,
        bodySmall:     AppTextStyles.bodySmall,
        labelLarge:    AppTextStyles.labelLarge,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cardBg,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: AppTextStyles.headlineMedium,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
        labelStyle: AppTextStyles.bodyMedium,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.accent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: AppTextStyles.buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.border, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: AppTextStyles.buttonText.copyWith(color: AppColors.primary),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: const BorderSide(color: AppColors.textHint, width: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.primaryLight,
        thumbColor: AppColors.primary,
        overlayColor: Color(0x220C3D2A),
        trackHeight: 4,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primaryLight,
        labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }
}
