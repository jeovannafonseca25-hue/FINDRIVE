import 'package:flutter/material.dart';

/// Raw color palette of the FINDRIVE design system.
///
/// Combines the iconic 99 Yellow with the sleek, high-contrast
/// minimalist aesthetic of Uber. Two palettes, one per brightness,
/// with consistent fields consumed via [ThemeData] and [AppSemanticColors].
class AppColorPalette {
  const AppColorPalette({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.outline,
    required this.income,
    required this.expense,
    required this.transfer,
    required this.warning,
    required this.error,
    required this.onError,
    required this.brandYellow,
    required this.uberBlack,
    required this.vault,
  });

  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color outline;
  final Color income;
  final Color expense;
  final Color transfer;
  final Color warning;
  final Color error;
  final Color onError;
  final Color brandYellow;
  final Color uberBlack;
  final Color vault;
}

/// The official 99 + Uber Minimalist palettes.
abstract final class AppColors {
  /// 99 Yellow signature brand color.
  static const Color yellow99 = Color(0xFFFFC700);

  /// Uber deep minimalist jet black.
  static const Color uberJetBlack = Color(0xFF121212);

  /// Light palette: crisp white & light grey grounds, bold black text and 99 yellow primary.
  static const AppColorPalette light = AppColorPalette(
    primary: Color(0xFFFFC700),
    onPrimary: Color(0xFF000000),
    primaryContainer: Color(0xFFFFF4CC),
    onPrimaryContainer: Color(0xFF261C00),
    background: Color(0xFFF7F7F8),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFEEEEF0),
    onSurface: Color(0xFF121212),
    onSurfaceMuted: Color(0xFF6E6E73),
    outline: Color(0xFFE5E5EA),
    income: Color(0xFF008736),
    expense: Color(0xFFD32F2F),
    transfer: Color(0xFF757575),
    warning: Color(0xFFE65100),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
    brandYellow: Color(0xFFFFC700),
    uberBlack: Color(0xFF121212),
    vault: Color(0xFF0D47A1),
  );

  /// Dark palette: Uber OLED/deep black grounds, high contrast white text and electric 99 yellow.
  static const AppColorPalette dark = AppColorPalette(
    primary: Color(0xFFFFC700),
    onPrimary: Color(0xFF000000),
    primaryContainer: Color(0xFF2F2600),
    onPrimaryContainer: Color(0xFFFFE082),
    background: Color(0xFF000000),
    surface: Color(0xFF141414),
    surfaceVariant: Color(0xFF1F1F1F),
    onSurface: Color(0xFFFFFFFF),
    onSurfaceMuted: Color(0xFF8E8E93),
    outline: Color(0xFF2C2C2E),
    income: Color(0xFF00C853),
    expense: Color(0xFFFF5252),
    transfer: Color(0xFFAAAAAA),
    warning: Color(0xFFFFB300),
    error: Color(0xFFFF5252),
    onError: Color(0xFF000000),
    brandYellow: Color(0xFFFFC700),
    uberBlack: Color(0xFF121212),
    vault: Color(0xFF2979FF),
  );
}
