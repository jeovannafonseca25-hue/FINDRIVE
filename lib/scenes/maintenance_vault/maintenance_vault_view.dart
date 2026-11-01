import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:flutter/material.dart';

import 'maintenance_vault_view_model.dart';

class MaintenanceVaultView extends StatelessWidget {
  const MaintenanceVaultView({required this.viewModel, super.key});

  final MaintenanceVaultViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final semantics = context.semanticColors;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) {
          return const AppScaffold(
            title: 'Fundo Preventivo',
            body: Center(child: StateView.loading(message: 'Calculando desgaste e saldo...')),
          );
        }

        final vault = viewModel.vault;

        return AppScaffold(
          title: 'Carteira de Manutenção (CPK)',
          body: ListView(
            children: [
              // Card do Saldo do Fundo Preventivo
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: AppRadius.lgAll,
                  border: Border.all(color: semantics.vault, width: 1.5),
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
                                size: 20,
                              ),
                            ),
                            const Gap.sm(),
                            Text(
                              'SALDO PROTEGIDO (EMERGÊNCIAS)',
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
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: semantics.vault.withValues(alpha: 0.15),
                            borderRadius: AppRadius.pillAll,
                          ),
                          child: Text(
                            'Retenção: ${vault?.retentionPercent.toStringAsFixed(0)}%',
                            style: AppTypography.labelSmall.copyWith(
                              color: semantics.vault,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap.md(),
                    MoneyText.amount(
                      vault?.vaultBalance ?? 0.0,
                      style: AppTypography.displayLarge.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const Gap.xs(),
                    Text(
                      'Este valor é segregado virtualmente das suas metas para você nunca ser pego de surpresa por pneus, óleo ou panes mecânicas.',
                      style: AppTypography.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap.lg(),

              // Resumo do CPK
              const SectionHeader(title: 'Custo por Quilômetro Rodado (CPK)'),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: AppRadius.lgAll,
                  border: Border.all(color: colorScheme.outline),
                ),
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CPK Total Estimado',
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Desgaste de peças + fluidos por km',
                          style: AppTypography.bodySmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'R\$ ${(vault?.cpkAmount ?? 0.16).toStringAsFixed(2)} / km',
                      style: AppTypography.titleLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap.lg(),

              // Desgaste de Peças Críticas
              const SectionHeader(title: 'Monitoramento de Peças e Revisões'),
              if (vault != null)
                for (final item in vault.items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: AppRadius.mdAll,
                        border: Border.all(
                          color: item.isWarning ? semantics.warning : colorScheme.outline,
                          width: item.isWarning ? 1.4 : 1.0,
                        ),
                      ),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    item.isWarning
                                        ? Icons.warning_amber_rounded
                                        : Icons.check_circle_outline_rounded,
                                    color: item.isWarning ? semantics.warning : semantics.income,
                                    size: 18,
                                  ),
                                  const Gap.sm(),
                                  Text(
                                    item.name,
                                    style: AppTypography.titleSmall.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              MoneyText.amount(
                                item.estimatedCost,
                                style: AppTypography.titleSmall.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const Gap.xs(),
                          Text(
                            item.isWarning
                                ? 'Atenção: Troca necessária nos próximos ${item.remainingKm} km!'
                                : 'Em bom estado. Próxima intervenção em ~${item.remainingKm} km.',
                            style: AppTypography.bodySmall.copyWith(
                              color: item.isWarning ? semantics.warning : colorScheme.onSurfaceVariant,
                              fontWeight: item.isWarning ? FontWeight.w700 : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              const Gap.lg(),

              AppButton(
                label: 'Simular Depósito Diário (+ R\$ 38,00)',
                icon: Icons.add_moderator_rounded,
                onPressed: () => viewModel.addSimulatedDeposit(38.0),
              ),
              const Gap.xl(),
            ],
          ),
        );
      },
    );
  }
}
