import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../tokens/app_typography.dart';

/// Which semantic color a money figure takes.
enum MoneyTone { neutral, income, expense }

/// Size of a [MoneyText].
enum MoneySize { small, medium, large, display }

/// Money figure formatted for financial display.
class MoneyText extends StatelessWidget {
  const MoneyText(
    this.value, {
    super.key,
    this.tone = MoneyTone.neutral,
    this.size = MoneySize.medium,
    this.signed = false,
    this.style,
  });

  MoneyText.amount(
    double amount, {
    super.key,
    this.tone = MoneyTone.neutral,
    this.size = MoneySize.medium,
    this.signed = false,
    this.style,
  }) : value = formatCurrency(amount);

  final String value;
  final MoneyTone tone;
  final MoneySize size;

  /// Prefix "+" for income and "−" for expense.
  final bool signed;

  /// Optional custom style override.
  final TextStyle? style;

  static String formatCurrency(double amount) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    final fixed = absAmount.toStringAsFixed(2);
    final parts = fixed.split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];

    final buffer = StringBuffer();
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(integerPart[i]);
    }
    final prefix = isNegative ? '-' : '';
    return 'R\$ $prefix${buffer.toString()},$decimalPart';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final color = switch (tone) {
      MoneyTone.neutral => theme.colorScheme.onSurface,
      MoneyTone.income => semantic.income,
      MoneyTone.expense => semantic.expense,
    };
    final base = style ??
        switch (size) {
          MoneySize.small => AppTypography.bodySmall,
          MoneySize.medium => AppTypography.titleMedium,
          MoneySize.large => AppTypography.titleLarge,
          MoneySize.display => AppTypography.displayLarge,
        };
    final prefix = switch ((signed, tone)) {
      (true, MoneyTone.income) => '+',
      (true, MoneyTone.expense) => '−',
      _ => '',
    };
    return Text(
      '$prefix$value',
      style: base.copyWith(
        color: style?.color ?? color,
        fontFeatures: AppTypography.tabularFigures,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
