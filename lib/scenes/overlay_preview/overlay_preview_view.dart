import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:flutter/material.dart';

import 'overlay_preview_view_model.dart';

class OverlayPreviewView extends StatelessWidget {
  const OverlayPreviewView({required this.viewModel, super.key});

  final OverlayPreviewViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final semantics = context.semanticColors;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final isViable = viewModel.isViable;

        return AppScaffold(
          title: 'Widget Suspenso (Overlay Android)',
          body: ListView(
            children: [
              // Switch de ativação
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
                    Row(
                      children: [
                        Icon(
                          Icons.picture_in_picture_alt_rounded,
                          color: colorScheme.primary,
                        ),
                        const Gap.sm(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sobrepor a outros aplicativos',
                              style: AppTypography.titleSmall.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Permite flutuar sobre Uber e 99',
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
                      value: viewModel.isOverlayEnabled,
                      onChanged: viewModel.toggleOverlay,
                    ),
                  ],
                ),
              ),
              const Gap.lg(),

              // Simulação da Tela do Smartphone com Balão Flutuante FINDRIVE
              const SectionHeader(title: 'Pré-Visualização em Tempo Real'),
              Container(
                height: 280,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F141C),
                  borderRadius: AppRadius.lgAll,
                  border: Border.all(color: colorScheme.outline, width: 2),
                ),
                child: Stack(
                  children: [
                    // Fundo simulando mapa de corrida
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map_outlined,
                            size: 64,
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                          const Gap.xs(),
                          Text(
                            '[App Uber / 99 rodando em segundo plano]',
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white38,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Card Flutuante de Viabilidade da Corrida Recebida
                    if (viewModel.isOverlayEnabled)
                      Positioned(
                        top: 24,
                        left: 16,
                        right: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: AppRadius.lgAll,
                            border: Border.all(
                              color: isViable ? semantics.income : semantics.warning,
                              width: 1.8,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black87,
                                blurRadius: 18,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: colorScheme.primary,
                                          borderRadius: AppRadius.smAll,
                                        ),
                                        child: Text(
                                          'FINDRIVE',
                                          style: AppTypography.labelSmall.copyWith(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w900,
                                            color: colorScheme.onPrimary,
                                          ),
                                        ),
                                      ),
                                      const Gap.sm(),
                                      Text(
                                        'Checador de Corrida',
                                        style: AppTypography.labelSmall.copyWith(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isViable
                                          ? semantics.income.withValues(alpha: 0.2)
                                          : semantics.warning.withValues(alpha: 0.2),
                                      borderRadius: AppRadius.pillAll,
                                    ),
                                    child: Text(
                                      isViable ? 'VALE A PENA' : 'AVALIAR',
                                      style: AppTypography.labelSmall.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        color: isViable ? semantics.income : semantics.warning,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Gap.sm(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Lucro Líquido Real:',
                                        style: AppTypography.bodySmall.copyWith(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),
                                      MoneyText.amount(
                                        viewModel.estimatedNetProfit,
                                        style: AppTypography.titleLarge.copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: isViable ? semantics.income : semantics.warning,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'R\$ / km limpo:',
                                        style: AppTypography.bodySmall.copyWith(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        'R\$ ${viewModel.netProfitPerKm.toStringAsFixed(2)} / km',
                                        style: AppTypography.titleMedium.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Gap.xs(),
                              Text(
                                viewModel.viabilityLabel,
                                style: AppTypography.labelSmall.copyWith(
                                  color: isViable ? semantics.income : semantics.warning,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Gap.lg(),

              // Simulador de Parâmetros da Corrida
              const SectionHeader(title: 'Simule uma Chamada de Corrida'),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Valor Bruto da Corrida (R\$)',
                      hint: 'ex: 28,50',
                      initialValue: viewModel.ridePrice.toStringAsFixed(2),
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.attach_money,
                      onChanged: (val) {
                        final parsed = double.tryParse(val);
                        if (parsed != null && parsed > 0) viewModel.updateRidePrice(parsed);
                      },
                    ),
                  ),
                  const Gap.sm(),
                  Expanded(
                    child: AppTextField(
                      label: 'Distância Total (km)',
                      hint: 'ex: 8.2',
                      initialValue: viewModel.rideDistanceKm.toStringAsFixed(1),
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.route_outlined,
                      onChanged: (val) {
                        final parsed = double.tryParse(val);
                        if (parsed != null && parsed > 0) viewModel.updateRideDistance(parsed);
                      },
                    ),
                  ),
                ],
              ),
              const Gap.md(),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: AppRadius.mdAll,
                  border: Border.all(color: colorScheme.outline),
                ),
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custos deduzidos automaticamente:',
                      style: AppTypography.labelSmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap.xs(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Combustível estimado:',
                          style: AppTypography.bodySmall,
                        ),
                        MoneyText.amount(
                          viewModel.estimatedFuelCost,
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const Gap.xxs(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Desgaste Mecânico (CPK R\$ 0,16/km):',
                          style: AppTypography.bodySmall,
                        ),
                        MoneyText.amount(
                          viewModel.estimatedWearCost,
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap.xl(),
            ],
          ),
        );
      },
    );
  }
}
