import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';
import 'gap.dart';
import 'money_text.dart';

enum NetRatePerformance { high, normal, low }

/// Card de monitoramento em tempo real da Hora Líquida Real do motorista ($/hora).
class NetRateCard extends StatelessWidget {
  const NetRateCard({
    required this.netHourlyRate,
    required this.onlineHoursFormatted,
    required this.grossEarned,
    required this.netProfit,
    super.key,
    this.performance = NetRatePerformance.high,
    this.isShiftActive = true,
  });

  final double netHourlyRate;
  final String onlineHoursFormatted;
  final double grossEarned;
  final double netProfit;
  final NetRatePerformance performance;
  final bool isShiftActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final semantics = context.semanticColors;

    final (badgeText, badgeBg, badgeFg) = switch (performance) {
      NetRatePerformance.high => (
        'Alta Rentabilidade',
        semantics.income.withValues(alpha: 0.15),
        semantics.income,
      ),
      NetRatePerformance.normal => (
        'Na Média',
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
      ),
      NetRatePerformance.low => (
        'Abaixo da Meta',
        semantics.expense.withValues(alpha: 0.15),
        semantics.expense,
      ),
    };

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: colorScheme.outline, width: 1.2),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isShiftActive ? semantics.income : colorScheme.onSurfaceVariant,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap.sm(),
                  Text(
                    'HORA LÍQUIDA REAL',
                    style: AppTypography.labelSmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: AppRadius.pillAll,
                ),
                child: Text(
                  badgeText,
                  style: AppTypography.labelSmall.copyWith(
                    color: badgeFg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const Gap.md(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              MoneyText.amount(
                netHourlyRate,
                style: AppTypography.displayLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: semantics.income,
                ),
              ),
              const Gap.xs(),
              Text(
                '/ hora limpa',
                style: AppTypography.titleSmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Gap.md(),
          Divider(color: colorScheme.outline, height: 1),
          const Gap.md(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MetricMini(
                label: 'Tempo Online',
                valueText: onlineHoursFormatted,
                icon: Icons.timer_outlined,
              ),
              _MetricMini(
                label: 'Bruto Recebido',
                moneyValue: grossEarned,
                icon: Icons.arrow_upward_rounded,
              ),
              _MetricMini(
                label: 'Lucro Líquido',
                moneyValue: netProfit,
                icon: Icons.account_balance_wallet_outlined,
                highlightColor: semantics.income,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricMini extends StatelessWidget {
  const _MetricMini({
    required this.label,
    required this.icon,
    this.valueText,
    this.moneyValue,
    this.highlightColor,
  });

  final String label;
  final IconData icon;
  final String? valueText;
  final double? moneyValue;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        if (moneyValue != null)
          MoneyText.amount(
            moneyValue!,
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: highlightColor ?? colorScheme.onSurface,
            ),
          )
        else
          Text(
            valueText ?? '-',
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: highlightColor ?? colorScheme.onSurface,
            ),
          ),
      ],
    );
  }
}
