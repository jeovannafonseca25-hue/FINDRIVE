import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:flutter/material.dart';

import 'home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({required this.viewModel, super.key});

  final HomeViewModel viewModel;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final semantics = context.semanticColors;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) {
          return const AppScaffold(
            title: 'FINDRIVE',
            body: Center(child: StateView.loading(message: 'Calculando metas e turnos...')),
          );
        }

        final shift = viewModel.shift;
        final vehicle = viewModel.vehicle;
        final isOnline = shift?.isOnline ?? false;

        return AppScaffold(
          title: 'FINDRIVE',
          actions: [
            IconButton(
              icon: const Icon(Icons.layers_outlined),
              tooltip: 'Widget Suspenso',
              onPressed: () => viewModel.openOverlay(context),
            ),
          ],
          body: RefreshIndicator(
            onRefresh: viewModel.loadData,
            color: colorScheme.primary,
            child: ListView(
              children: [
                // Driver Header & Shift Status Pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olá, Carlos Eduardo',
                          style: AppTypography.titleLarge.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '${vehicle?.model ?? "Veículo"} • ${vehicle?.plate ?? ""}',
                          style: AppTypography.bodySmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: viewModel.toggleShift,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: isOnline
                              ? semantics.income.withValues(alpha: 0.18)
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: AppRadius.pillAll,
                          border: Border.all(
                            color: isOnline ? semantics.income : colorScheme.outline,
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isOnline ? semantics.income : colorScheme.onSurfaceVariant,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Gap.xs(),
                            Text(
                              isOnline ? 'TURNO ATIVO' : 'OFFLINE',
                              style: AppTypography.labelSmall.copyWith(
                                color: isOnline ? semantics.income : colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap.lg(),

                // Card Principal: Meta Reversa Diária
                GoalProgressCard(
                  dailyGoal: viewModel.dailyGoalAmount,
                  earnedSoFar: viewModel.earnedSoFar,
                  remainingHours: viewModel.remainingHours,
                  onTapDetails: () => viewModel.openGoalCalculator(context),
                ),
                const Gap.md(),

                // Card Secundário: Hora Líquida Real
                if (shift != null)
                  NetRateCard(
                    netHourlyRate: shift.netHourlyRate,
                    onlineHoursFormatted: shift.onlineDurationFormatted,
                    grossEarned: shift.grossEarned,
                    netProfit: shift.netProfit,
                    performance: shift.performance,
                    isShiftActive: isOnline,
                  ),
                const Gap.md(),

                // Barra de Ações Rápidas
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: isOnline ? 'Pausar Turno' : 'Iniciar Turno',
                        icon: isOnline ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        onPressed: viewModel.toggleShift,
                      ),
                    ),
                    const Gap.sm(),
                    Expanded(
                      child: AppButton.secondary(
                        label: '+ Corrida (R\$ 35)',
                        icon: Icons.add_circle_outline,
                        onPressed: () => viewModel.addSimulatedRide(35.0),
                      ),
                    ),
                  ],
                ),
                const Gap.lg(),

                // Notificações Inteligentes
                if (viewModel.alerts.isNotEmpty) ...[
                  const SectionHeader(title: 'Alertas Inteligentes'),
                  for (final alert in viewModel.alerts)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: SmartNotificationCard(
                        title: alert.title,
                        message: alert.message,
                        billAmount: alert.billAmount,
                        ridesEquivalent: alert.ridesEquivalent,
                        priority: alert.priority,
                      ),
                    ),
                  const Gap.sm(),
                ],

                // Fundo Preventivo / Carteira de Manutenção
                if (viewModel.maintenance != null) ...[
                  SectionHeader(
                    title: 'Fundo Preventivo & CPK',
                    actionLabel: 'Ver Detalhes',
                    onAction: () => viewModel.openMaintenanceVault(context),
                  ),
                  MaintenanceVaultCard(
                    vaultBalance: viewModel.maintenance!.vaultBalance,
                    retentionPercent: viewModel.maintenance!.retentionPercent,
                    cpkAmount: viewModel.maintenance!.cpkAmount,
                    items: viewModel.maintenance!.items,
                    onTapManage: () => viewModel.openMaintenanceVault(context),
                  ),
                  const Gap.md(),
                ],

                // Perfil do Veículo & Break-Even
                if (vehicle != null) ...[
                  SectionHeader(
                    title: 'Veículo & Ponto de Equilíbrio',
                    actionLabel: 'Configurar',
                    onAction: () => viewModel.openVehicleSetup(context),
                  ),
                  VehicleProfileCard(
                    model: vehicle.model,
                    plate: vehicle.plate,
                    regime: vehicle.regime,
                    periodicCost: vehicle.periodicCost,
                    breakEvenRides: vehicle.breakEvenRides,
                    breakEvenDay: vehicle.breakEvenDay,
                    depreciationPerKm: vehicle.depreciationPerKm,
                    onTapEdit: () => viewModel.openVehicleSetup(context),
                  ),
                ],
                const Gap.xl(),
              ],
            ),
          ),
        );
      },
    );
  }
}
