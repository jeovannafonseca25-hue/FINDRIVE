import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';

/// Semantic colors for financial, status and brand elements in FINDRIVE:
/// income, expense, transfer, warning, maintenance vault, and brand colors.
///
/// Registered as a [ThemeExtension] so widgets can read them via
/// `context.semanticColors`.
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.income,
    required this.expense,
    required this.transfer,
    required this.warning,
    required this.muted,
    required this.vault,
    required this.brandYellow,
    required this.uberBlack,
  });

  factory AppSemanticColors.fromPalette(AppColorPalette palette) {
    return AppSemanticColors(
      income: palette.income,
      expense: palette.expense,
      transfer: palette.transfer,
      warning: palette.warning,
      muted: palette.onSurfaceMuted,
      vault: palette.vault,
      brandYellow: palette.brandYellow,
      uberBlack: palette.uberBlack,
    );
  }

  final Color income;
  final Color expense;
  final Color transfer;
  final Color warning;
  final Color muted;
  final Color vault;
  final Color brandYellow;
  final Color uberBlack;

  @override
  AppSemanticColors copyWith({
    Color? income,
    Color? expense,
    Color? transfer,
    Color? warning,
    Color? muted,
    Color? vault,
    Color? brandYellow,
    Color? uberBlack,
  }) {
    return AppSemanticColors(
      income: income ?? this.income,
      expense: expense ?? this.expense,
      transfer: transfer ?? this.transfer,
      warning: warning ?? this.warning,
      muted: muted ?? this.muted,
      vault: vault ?? this.vault,
      brandYellow: brandYellow ?? this.brandYellow,
      uberBlack: uberBlack ?? this.uberBlack,
    );
  }

  @override
  AppSemanticColors lerp(AppSemanticColors? other, double t) {
    if (other == null) return this;
    return AppSemanticColors(
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
      transfer: Color.lerp(transfer, other.transfer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      vault: Color.lerp(vault, other.vault, t)!,
      brandYellow: Color.lerp(brandYellow, other.brandYellow, t)!,
      uberBlack: Color.lerp(uberBlack, other.uberBlack, t)!,
    );
  }
}

/// Shortcut extension: `context.semanticColors.income`.
extension SemanticColorsContext on BuildContext {
  AppSemanticColors get semanticColors {
    final colors = Theme.of(this).extension<AppSemanticColors>();
    assert(
      colors != null,
      'AppSemanticColors is missing. Use AppTheme.light() or AppTheme.dark().',
    );
    return colors!;
  }
}
