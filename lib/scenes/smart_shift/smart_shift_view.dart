import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:flutter/material.dart';

import 'smart_shift_view_model.dart';

class SmartShiftView extends StatelessWidget {
  const SmartShiftView({required this.viewModel, super.key});

  final SmartShiftViewModel viewModel;

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
            title: 'Smart Shift',
            body: Center(child: StateView.loading(message: 'Mapeando horários de alta demanda...')),
          );
        }

        final data = viewModel.data;

        return AppScaffold(
          title: 'Smart Shift (Melhores Horários)',
          body: ListView(
            children: [
              // Seletor de Dias da Semana
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: SmartShiftViewModel.daysOfWeek.length,
                  separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
                  itemBuilder: (context, index) {
                    final day = SmartShiftViewModel.daysOfWeek[index];
                    final isSelected = day == viewModel.selectedDay;
                    final shortDay = day.substring(0, 3);

                    return InkWell(
                      onTap: () => viewModel.selectDay(day),
                      borderRadius: AppRadius.pillAll,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: AppRadius.pillAll,
                          border: Border.all(
                            color: isSelected ? colorScheme.primary : colorScheme.outline,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          shortDay,
                          style: AppTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Gap.lg(),

              // Card de Recomendação Principal
              if (data != null) ...[
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
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          const Gap.sm(),
                          Text(
                            'RECOMENDAÇÃO INTELIGENTE',
                            style: AppTypography.labelSmall.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const Gap.md(),
                      Text(
                        'Melhor Janela: ${data.recommendedWindow}',
                        style: AppTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.w900,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const Gap.xs(),
                      Row(
                        children: [
                          Text(
                            'Rentabilidade média estimada: ',
                            style: AppTypography.bodySmall.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          MoneyText.amount(
                            data.averageRatePerHour,
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.w800,
                              color: semantics.income,
                            ),
                          ),
                          Text(
                            '/h limpo',
                            style: AppTypography.bodySmall.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const Gap.md(),
                      Text(
                        data.reason,
                        style: AppTypography.bodyMedium.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap.lg(),

                // Mapa de Calor por Bloco de Horas
                const SectionHeader(title: 'Mapa de Calor (Horas do Dia)'),
                for (final block in data.blocks)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: SmartShiftTile(
                      timeRange: block.timeRange,
                      demandLevel: block.demandLevel,
                      score: block.score,
                      expectedNetHourlyRate: block.expectedNetRate,
                      isRecommended: block.isRecommended,
                    ),
                  ),
              ],
              const Gap.xl(),
            ],
          ),
        );
      },
    );
  }
}
