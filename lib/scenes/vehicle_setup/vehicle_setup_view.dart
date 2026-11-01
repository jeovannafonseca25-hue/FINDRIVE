import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:flutter/material.dart';

import 'vehicle_setup_view_model.dart';

class VehicleSetupView extends StatelessWidget {
  const VehicleSetupView({required this.viewModel, super.key});

  final VehicleSetupViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) {
          return const AppScaffold(
            title: 'Perfil do Veículo',
            body: Center(child: StateView.loading(message: 'Carregando veículo...')),
          );
        }

        final isRented = viewModel.regime == VehicleRegime.rented;

        return AppScaffold(
          title: 'Configurar Veículo & Break-Even',
          body: ListView(
            children: [
              // Seletor de Regime: Alugado vs Próprio
              const SectionHeader(title: 'Regime de Utilização'),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => viewModel.setRegime(VehicleRegime.rented),
                      borderRadius: AppRadius.mdAll,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        decoration: BoxDecoration(
                          color: isRented
                              ? colorScheme.primary
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: AppRadius.mdAll,
                          border: Border.all(
                            color: isRented ? colorScheme.primary : colorScheme.outline,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Carro Alugado',
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isRented ? colorScheme.onPrimary : colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap.sm(),
                  Expanded(
                    child: InkWell(
                      onTap: () => viewModel.setRegime(VehicleRegime.owned),
                      borderRadius: AppRadius.mdAll,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        decoration: BoxDecoration(
                          color: !isRented
                              ? colorScheme.primary
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: AppRadius.mdAll,
                          border: Border.all(
                            color: !isRented ? colorScheme.primary : colorScheme.outline,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Carro Próprio',
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: !isRented ? colorScheme.onPrimary : colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap.lg(),

              // Card Dinâmico de Break-Even
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
                          'PONTO DE EQUILÍBRIO (BREAK-EVEN)',
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
                            color: colorScheme.primaryContainer,
                            borderRadius: AppRadius.pillAll,
                          ),
                          child: Text(
                            '${viewModel.computedBreakEvenRides} corridas / sem',
                            style: AppTypography.labelSmall.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap.md(),
                    Text(
                      isRented
                          ? 'A partir da ${viewModel.computedBreakEvenRides}ª corrida da semana (estimado para ${viewModel.computedBreakEvenDay}), o custo do aluguel estará 100% pago e todo faturamento seguinte é lucro líquido.'
                          : 'Com o custo mensal de financiamento, seguro e IPVA diluído, você atinge o ponto de equilíbrio na ${viewModel.computedBreakEvenRides}ª corrida de cada semana.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: colorScheme.onSurface,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap.lg(),

              // Dados do Veículo
              const SectionHeader(title: 'Dados do Veículo'),
              AppTextField(
                label: 'Modelo do Veículo',
                hint: 'ex: Chevrolet Onix 1.0 Flex',
                initialValue: viewModel.model,
                prefixIcon: Icons.directions_car_outlined,
                onChanged: viewModel.updateModel,
              ),
              const Gap.md(),
              AppTextField(
                label: 'Placa do Veículo',
                hint: 'ex: BRA2E19',
                initialValue: viewModel.plate,
                prefixIcon: Icons.badge_outlined,
                onChanged: viewModel.updatePlate,
              ),
              const Gap.md(),
              AppTextField(
                label: isRented ? 'Valor do Aluguel Semanal (R\$)' : 'Custo Fixo Mensal (Parcela + IPVA + Seguro)',
                hint: isRented ? 'ex: 680,00' : 'ex: 1180,00',
                initialValue: viewModel.periodicCost.toStringAsFixed(0),
                keyboardType: TextInputType.number,
                prefixIcon: Icons.payments_outlined,
                onChanged: (val) {
                  final parsed = double.tryParse(val);
                  if (parsed != null && parsed > 0) viewModel.updatePeriodicCost(parsed);
                },
              ),
              const Gap.md(),
              AppTextField(
                label: 'Quilometragem Atual (Hodômetro)',
                hint: 'ex: 48430',
                initialValue: viewModel.currentKm.toString(),
                keyboardType: TextInputType.number,
                prefixIcon: Icons.speed_outlined,
                onChanged: (val) {
                  final parsed = int.tryParse(val);
                  if (parsed != null && parsed >= 0) viewModel.updateKm(parsed);
                },
              ),
              const Gap.xl(),

              AppButton(
                label: 'Salvar Perfil do Veículo',
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
