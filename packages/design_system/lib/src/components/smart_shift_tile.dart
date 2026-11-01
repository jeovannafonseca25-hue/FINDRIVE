import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';
import 'gap.dart';
import 'money_text.dart';

/// Tile do Smart Shift (Mapa de calor de horários de pico).
class SmartShiftTile extends StatelessWidget {
  const SmartShiftTile({
    required this.timeRange,
    required this.demandLevel,
    required this.score,
    required this.expectedNetHourlyRate,
    super.key,
    this.isRecommended = false,
  });

  final String timeRange;
  final String demandLevel;
  final int score;
  final double expectedNetHourlyRate;
  final bool isRecommended;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final semantics = context.semanticColors;

    final (scoreBg, scoreFg) = score >= 90
        ? (colorScheme.primary, colorScheme.onPrimary)
        : score >= 70
            ? (colorScheme.primaryContainer, colorScheme.onPrimaryContainer)
            : (colorScheme.surfaceContainerHighest, colorScheme.onSurfaceVariant);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppRadius.mdAll,
        border: Border.all(
          color: isRecommended ? colorScheme.primary : colorScheme.outline,
          width: isRecommended ? 1.8 : 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scoreBg,
                  borderRadius: AppRadius.smAll,
                ),
                child: Text(
                  '$score',
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scoreFg,
                  ),
                ),
              ),
              const Gap.md(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        timeRange,
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (isRecommended) ...[
                        const Gap.xs(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: AppRadius.pillAll,
                          ),
                          child: Text(
                            'PICO',
                            style: AppTypography.labelSmall.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    'Demanda: $demandLevel',
                    style: AppTypography.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Estimativa líq.',
                style: AppTypography.labelSmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
              Row(
                children: [
                  MoneyText.amount(
                    expectedNetHourlyRate,
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w800,
                      color: semantics.income,
                    ),
                  ),
                  Text(
                    '/h',
                    style: AppTypography.labelSmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
