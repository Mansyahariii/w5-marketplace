import 'package:flutter/material.dart';

// ─── Design Tokens dari Stitch: "Home Decor Marketplace" ────────────────────
// Primary: Terracotta | Secondary: Sage | Font: Noto Serif + Manrope
class AppColors {
  // Primary (Terracotta)
  static const Color primary          = Color(0xFF9A4029);
  static const Color primaryContainer = Color(0xFFB9583E);
  static const Color primaryFixed     = Color(0xFFFFDBD2);
  static const Color onPrimary        = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFFFFBFF);

  // Secondary (Sage)
  static const Color secondary          = Color(0xFF54624E);
  static const Color secondaryContainer = Color(0xFFD5E5CB);
  static const Color onSecondary        = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF586752);

  // Tertiary (Warm sand)
  static const Color tertiary          = Color(0xFF68594A);
  static const Color tertiaryContainer = Color(0xFF827261);
  static const Color onTertiary        = Color(0xFFFFFFFF);

  // Surface hierarchy
  static const Color background             = Color(0xFFFEF8F4);
  static const Color surface               = Color(0xFFFEF8F4);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow    = Color(0xFFF8F3EF);
  static const Color surfaceContainer      = Color(0xFFF2EDE9);
  static const Color surfaceContainerHigh  = Color(0xFFECE7E3);
  static const Color surfaceContainerHighest = Color(0xFFE6E2DE);
  static const Color surfaceDim            = Color(0xFFDED9D5);
  static const Color surfaceBright         = Color(0xFFFEF8F4);

  // On-surface
  static const Color onBackground    = Color(0xFF1D1B19);
  static const Color onSurface       = Color(0xFF1D1B19);
  static const Color onSurfaceVariant = Color(0xFF56423D);

  // Outline
  static const Color outline        = Color(0xFF89726C);
  static const Color outlineVariant  = Color(0xFFDCC1BA);

  // Error
  static const Color error          = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError        = Color(0xFFFFFFFF);

  // ─── Alias (kompatibilitas file lain) ─────────────────────────────────────
  static const Color primaryLight   = Color(0xFFB9583E); // = primaryContainer
  static const Color primaryDark    = Color(0xFF6B2A15);
  static const Color accent         = Color(0xFFD5E5CB); // = secondaryContainer
  static const Color textPrimary    = onSurface;
  static const Color textSecondary  = onSurfaceVariant;
  static const Color textHint       = Color(0xFF9E9E9E);
  static const Color border         = outlineVariant;
  static const Color divider        = outlineVariant;
}