import 'package:flutter/material.dart';

import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';
import 'gap.dart';
import 'money_text.dart';

/// Card interativo do Widget Suspenso (Overlay Android).
class OverlayWidgetCard extends StatelessWidget {
  const OverlayWidgetCard({
    required this.isOverlayActive,
    required this.onToggleOverlay,
    super.key,
    this.remainingGoal = 135.0,
    this.currentNetRate = 38.5,
  });

  final bool isOverlayActive;
  final ValueChanged<bool> onToggleOverlay;
  final double remainingGoal;
  final double currentNetRate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                  Icon(
                    Icons.layers_outlined,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const Gap.sm(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WIDGET FLUTUANTE (OVERLAY)',
                        style: AppTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurfaceVariant,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Text(
                        'Sobreposição rápida sobre Uber e 99',
                        style: AppTypography.bodySmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Switch(
                value: isOverlayActive,
                onChanged: onToggleOverlay,
              ),
            ],
          ),
          const Gap.md(),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: AppRadius.pillAll,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: colorScheme.primary,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.speed_rounded,
                      size: 14,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  const Gap.sm(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Falta faturar:',
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                      ),
                      MoneyText.amount(
                        remainingGoal,
                        style: AppTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Gap.md(),
                  Container(width: 1, height: 20, color: Colors.white24),
                  const Gap.md(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ritmo líquido:',
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        'R\$ ${currentNetRate.toStringAsFixed(2)}/h',
                        style: AppTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
