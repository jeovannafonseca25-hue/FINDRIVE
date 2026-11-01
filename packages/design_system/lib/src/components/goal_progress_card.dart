import 'package:flutter/material.dart';

import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';
import 'gap.dart';
import 'money_text.dart';

/// Card principal do FINDRIVE para exibição da Meta Reversa Diária.
/// Combina o minimalismo do design Uber (cartão escuro, bordas finas)
/// com a energia do Amarelo 99 na barra de progresso.
class GoalProgressCard extends StatelessWidget {
  const GoalProgressCard({
    required this.dailyGoal,
    required this.earnedSoFar,
    required this.remainingHours,
    super.key,
    this.title = 'Meta Reversa de Hoje',
    this.onTapDetails,
  });

  final double dailyGoal;
  final double earnedSoFar;
  final double remainingHours;
  final String title;
  final VoidCallback? onTapDetails;

  double get _progress => dailyGoal > 0 ? (earnedSoFar / dailyGoal).clamp(0.0, 1.0) : 0.0;
  double get _remainingAmount => (dailyGoal - earnedSoFar).clamp(0.0, double.infinity);
  int get _progressPercent => (_progress * 100).round();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTapDetails,
      borderRadius: AppRadius.lgAll,
      child: Container(
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
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Gap.sm(),
                    Text(
                      title.toUpperCase(),
                      style: AppTypography.labelSmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        letterSpacing: 1.0,
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
                    color: colorScheme.primaryContainer,
                    borderRadius: AppRadius.pillAll,
                  ),
                  child: Text(
                    '$_progressPercent%',
                    style: AppTypography.labelSmall.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w800,
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
                  earnedSoFar,
                  style: AppTypography.displayLarge.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Gap.xs(),
                Text(
                  '/ ',
                  style: AppTypography.titleMedium.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                MoneyText.amount(
                  dailyGoal,
                  style: AppTypography.titleMedium.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Gap.md(),
            ClipRRect(
              borderRadius: AppRadius.pillAll,
              child: SizedBox(
                height: 8,
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: isDark
                      ? const Color(0xFF262626)
                      : const Color(0xFFE5E5EA),
                  valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                ),
              ),
            ),
            const Gap.md(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.flag_outlined,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const Gap.xs(),
                    Text(
                      'Faltam ',
                      style: AppTypography.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    MoneyText.amount(
                      _remainingAmount,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const Gap.xs(),
                    Text(
                      '~${remainingHours.toStringAsFixed(1)}h restantes',
                      style: AppTypography.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
