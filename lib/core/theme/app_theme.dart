import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

// Design System: "The Curated Home" / "Home Decor Marketplace" (Stitch)
// Headlines: Noto Serif | Body/Labels: Manrope
class AppTheme {
  static ThemeData get light {
    // Merge: headline uses Noto Serif, body/label uses Manrope
    final textTheme = GoogleFonts.manropeTextTheme().copyWith(
      displayLarge: GoogleFonts.notoSerif(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.02,
        color: AppColors.onBackground,
      ),
      displayMedium: GoogleFonts.notoSerif(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.02,
        color: AppColors.onBackground,
      ),
      displaySmall: GoogleFonts.notoSerif(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.02,
        color: AppColors.onBackground,
      ),
      headlineLarge: GoogleFonts.notoSerif(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.02,
        color: AppColors.onBackground,
      ),
      headlineMedium: GoogleFonts.notoSerif(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.02,
        color: AppColors.onBackground,
      ),
      headlineSmall: GoogleFonts.notoSerif(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.02,
        color: AppColors.onBackground,
      ),
      titleLarge: GoogleFonts.manrope(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      ),
      titleMedium: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
      ),
      titleSmall: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
      ),
      bodyLarge: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
      ),
      bodySmall: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurfaceVariant,
      ),
      labelLarge: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      ),
      labelMedium: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurfaceVariant,
      ),
      labelSmall: GoogleFonts.manrope(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurfaceVariant,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: Colors.white,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: const Color(0xFF93000A),
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,

      // AppBar — terracotta
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.notoSerif(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: -0.01,
        ),
      ),

      // Elevated Button — Terracotta gradient via decoration
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999), // full pill
          ),
          elevation: 0,
          textStyle: GoogleFonts.manrope(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input — "The Soft Entry": no box, bottom-only focus
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceVariant,
        ),
        hintStyle: GoogleFonts.manrope(
          fontSize: 14,
          color: AppColors.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Card — "Frameless Look" on surfaceContainerLowest
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
    );
  }
}
