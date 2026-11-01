import 'package:flutter/material.dart';

import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';
import 'gap.dart';

enum SmartNotificationPriority { high, medium, normal }

/// Card de notificação inteligente do FINDRIVE.
/// Traduz boletos a vencer e manutenções em esforço de trabalho (corridas médias necessárias).
class SmartNotificationCard extends StatelessWidget {
  const SmartNotificationCard({
    required this.title,
    required this.message,
    required this.billAmount,
    required this.ridesEquivalent,
    super.key,
    this.priority = SmartNotificationPriority.high,
    this.onTapAction,
  });

  final String title;
  final String message;
  final double billAmount;
  final int ridesEquivalent;
  final SmartNotificationPriority priority;
  final VoidCallback? onTapAction;

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
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: AppRadius.mdAll,
            ),
            child: Icon(
              Icons.bolt_rounded,
              color: colorScheme.onPrimary,
              size: 20,
            ),
          ),
          const Gap.md(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: AppRadius.pillAll,
                      ),
                      child: Text(
                        '$ridesEquivalent corridas',
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap.xs(),
                Text(
                  message,
                  style: AppTypography.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
