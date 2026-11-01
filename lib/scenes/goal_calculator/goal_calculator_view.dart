import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:flutter/material.dart';

import 'goal_calculator_view_model.dart';

class GoalCalculatorView extends StatelessWidget {
  const GoalCalculatorView({required this.viewModel, super.key});

  final GoalCalculatorViewModel viewModel;

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
            title: 'Meta Reversa',
            body: Center(child: StateView.loading(message: 'Carregando parâmetros...')),
          );
        }

        final goal = viewModel.computedGoal;

        return AppScaffold(
          title: 'Calculadora de Meta Reversa',
          body: ListView(
            children: [
              // Card de Resultado em Tempo Real (Design Minimalista Uber com destaque 99)
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: AppRadius.lgAll,
                  border: Border.all(color: colorScheme.primary, width: 1.5),
                ),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'META BRUTA REVERSA DIÁRIA',
                          style: AppTypography.labelSmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: AppRadius.pillAll,
                          ),
                          child: Text(
                            '${viewModel.workingDaysPerMonth} dias úteis',
                            style: AppTypography.labelSmall.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap.sm(),
                    MoneyText.amount(
                      goal.dailyGrossTarget,
                      style: AppTypography.displayLarge.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.primary,
                      ),
                    ),
                    const Gap.xs(),
                    Text(
                      'Faturamento diário para pagar Casa + Carro + Manutenção e sobrar seu Lucro Limpo.',
                      style: AppTypography.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    const Gap.md(),
                    Divider(color: colorScheme.outline, height: 1),
                    const Gap.md(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatItem(
                          label: 'Custo Fixo/Dia',
                          amount: goal.dailyFixedCost,
                        ),
                        _StatItem(
                          label: 'Fundo Preventivo',
                          amount: goal.dailyMaintenanceAllocation,
                          highlightColor: semantics.vault,
                        ),
                        _StatItem(
                          label: 'Lucro Líquido/Dia',
                          amount: goal.dailyNetIncomeTarget,
                          highlightColor: semantics.income,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap.lg(),

              // Seção: Modo Folga Garantida
              const SectionHeader(title: 'Modo Folga Garantida'),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: AppRadius.lgAll,
                  border: Border.all(color: colorScheme.outline),
                ),
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.weekend_outlined,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        const Gap.sm(),
                        Expanded(
                          child: Text(
                            'Quantas folgas você quer por semana?',
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap.sm(),
                    Text(
                      'Os custos fixos dos dias de descanso são redistribuídos automaticamente nos dias que você roda, sem deixar rombo no final do mês.',
                      style: AppTypography.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Gap.md(),
                    Row(
                      children: [0, 1, 2, 3].map((days) {
                        final selected = viewModel.daysOffPerWeek == days;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: InkWell(
                              onTap: () => viewModel.updateDaysOff(days),
                              borderRadius: AppRadius.mdAll,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? colorScheme.primary
                                      : colorScheme.surfaceContainerHighest,
                                  borderRadius: AppRadius.mdAll,
                                  border: Border.all(
                                    color: selected ? colorScheme.primary : colorScheme.outline,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  days == 0 ? 'Sem folga' : '$days folga${days > 1 ? "s" : ""}',
                                  style: AppTypography.labelSmall.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: selected
                                        ? colorScheme.onPrimary
                                        : colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const Gap.lg(),

              // Seção: Custos e Metas
              const SectionHeader(title: 'Custos Fixos & Metas (Mensal)'),
              AppTextField(
                label: 'Lucro Líquido Desejado (R\$ / mês)',
                hint: 'ex: 4500,00',
                initialValue: viewModel.netIncomeTarget.toStringAsFixed(0),
                keyboardType: TextInputType.number,
                prefixIcon: Icons.savings_outlined,
                onChanged: (val) {
                  final parsed = double.tryParse(val);
                  if (parsed != null && parsed > 0) viewModel.updateNetIncome(parsed);
                },
              ),
              const Gap.md(),
              AppTextField(
                label: 'Custos Fixos da Casa (Aluguel, Luz, Comida)',
                hint: 'ex: 2100,00',
                initialValue: viewModel.householdCosts.toStringAsFixed(0),
                keyboardType: TextInputType.number,
                prefixIcon: Icons.home_outlined,
                onChanged: (val) {
                  final parsed = double.tryParse(val);
                  if (parsed != null && parsed >= 0) viewModel.updateHouseholdCosts(parsed);
                },
              ),
              const Gap.md(),
              AppTextField(
                label: 'Custos Fixos do Veículo (Aluguel ou Parcela+IPVA)',
                hint: 'ex: 2720,00',
                initialValue: viewModel.vehicleCosts.toStringAsFixed(0),
                keyboardType: TextInputType.number,
                prefixIcon: Icons.directions_car_outlined,
                onChanged: (val) {
                  final parsed = double.tryParse(val);
                  if (parsed != null && parsed >= 0) viewModel.updateVehicleCosts(parsed);
                },
              ),
              const Gap.lg(),

              // Fundo Preventivo Slider (8% a 12%)
              const SectionHeader(title: 'Percentual do Fundo Preventivo'),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: AppRadius.lgAll,
                  border: Border.all(color: colorScheme.outline),
                ),
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Retenção Automática para Emergências',
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${viewModel.retentionPercent.toStringAsFixed(0)}%',
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w800,
                            color: semantics.vault,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: viewModel.retentionPercent,
                      min: 6,
                      max: 16,
                      divisions: 10,
                      activeColor: semantics.vault,
                      onChanged: (val) => viewModel.updateRetentionRate(val / 100),
                    ),
                  ],
                ),
              ),
              const Gap.xl(),

              AppButton(
                label: 'Salvar e Atualizar Metas',
                onPressed: () => viewModel.save(context),
              ),
              const Gap.xl(),
            ],
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.amount,
    this.highlightColor,
  });

  final String label;
  final double amount;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        MoneyText.amount(
          amount,
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w800,
            color: highlightColor ?? colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
