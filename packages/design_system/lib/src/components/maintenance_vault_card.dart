import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';
import 'gap.dart';
import 'money_text.dart';

class MaintenanceItemStatus {
  const MaintenanceItemStatus({
    required this.name,
    required this.remainingKm,
    required this.estimatedCost,
    required this.isWarning,
  });

  final String name;
  final int remainingKm;
  final double estimatedCost;
  final bool isWarning;
}

/// Card de exibição da Carteira de Manutenção (Fundo Preventivo) e CPK.
class MaintenanceVaultCard extends StatelessWidget {
  const MaintenanceVaultCard({
    required this.vaultBalance,
    required this.retentionPercent,
    required this.cpkAmount,
    required this.items,
    super.key,
    this.onTapManage,
  });

  final double vaultBalance;
  final double retentionPercent;
  final double cpkAmount;
  final List<MaintenanceItemStatus> items;
  final VoidCallback? onTapManage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final semantics = context.semanticColors;

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
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: semantics.vault.withValues(alpha: 0.15),
                      borderRadius: AppRadius.smAll,
                    ),
                    child: Icon(
                      Icons.shield_outlined,
                      color: semantics.vault,
                      size: 18,
                    ),
                  ),
                  const Gap.sm(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CARTEIRA DE MANUTENÇÃO',
                        style: AppTypography.labelSmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Proteção automática de ${retentionPercent.toStringAsFixed(0)}% por dia',
                        style: AppTypography.bodySmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (onTapManage != null)
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onPressed: onTapManage,
                ),
            ],
          ),
          const Gap.md(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saldo Reservado',
                    style: AppTypography.labelSmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Gap.xxs(),
                  MoneyText.amount(
                    vaultBalance,
                    style: AppTypography.headlineMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Custo p/ KM (CPK)',
                    style: AppTypography.labelSmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Gap.xxs(),
                  Text(
                    'R\$ ${cpkAmount.toStringAsFixed(2)} / km',
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Gap.md(),
          Divider(color: colorScheme.outline, height: 1),
          const Gap.md(),
          Text(
            'Próximas Manutenções Programadas:',
            style: AppTypography.labelSmall.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap.sm(),
          ...items.map((item) {
            final statusColor = item.isWarning ? semantics.warning : semantics.income;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Gap.sm(),
                      Text(
                        item.name,
                        style: AppTypography.bodySmall.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'em ${item.remainingKm} km',
                        style: AppTypography.bodySmall.copyWith(
                          color: item.isWarning ? statusColor : colorScheme.onSurfaceVariant,
                          fontWeight: item.isWarning ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      const Gap.sm(),
                      MoneyText.amount(
                        item.estimatedCost,
                        style: AppTypography.bodySmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
