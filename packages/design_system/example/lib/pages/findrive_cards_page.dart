import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class FindriveCardsPage extends StatefulWidget {
  const FindriveCardsPage({super.key});

  @override
  State<FindriveCardsPage> createState() => _FindriveCardsPageState();
}

class _FindriveCardsPageState extends State<FindriveCardsPage> {
  bool _overlayActive = true;
  double _earned = 315.0;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Componentes FINDRIVE',
      actions: const [ThemeModeButton()],
      body: ListView(
        children: [
          const SectionHeader(title: 'Meta Reversa Diária'),
          GoalProgressCard(
            dailyGoal: 450.0,
            earnedSoFar: _earned,
            remainingHours: 2.1,
            onTapDetails: () {
              setState(() {
                _earned = (_earned + 45.0) > 450.0 ? 120.0 : _earned + 45.0;
              });
            },
          ),
          const Gap.lg(),
          const SectionHeader(title: 'Hora Líquida Real (Tempo Real)'),
          const NetRateCard(
            netHourlyRate: 38.74,
            onlineHoursFormatted: '5h 24m',
            grossEarned: 315.00,
            netProfit: 209.20,
            performance: NetRatePerformance.high,
          ),
          const Gap.lg(),
          const SectionHeader(title: 'Carteira de Manutenção (Fundo Preventivo)'),
          const MaintenanceVaultCard(
            vaultBalance: 1240.00,
            retentionPercent: 10.0,
            cpkAmount: 0.16,
            items: [
              MaintenanceItemStatus(
                name: 'Troca de Óleo e Filtro',
                remainingKm: 1570,
                estimatedCost: 190.00,
                isWarning: true,
              ),
              MaintenanceItemStatus(
                name: 'Pastilhas de Freio Dianteiras',
                remainingKm: 11570,
                estimatedCost: 220.00,
                isWarning: false,
              ),
              MaintenanceItemStatus(
                name: 'Pneus (4 unidades)',
                remainingKm: 16570,
                estimatedCost: 1200.00,
                isWarning: false,
              ),
            ],
          ),
          const Gap.lg(),
          const SectionHeader(title: 'Perfil do Veículo & Ponto de Equilíbrio'),
          const VehicleProfileCard(
            model: 'Chevrolet Onix 1.0 Flex',
            plate: 'BRA2E19',
            regime: VehicleRegime.rented,
            periodicCost: 680.00,
            breakEvenRides: 28,
            breakEvenDay: 'Quarta-feira',
          ),
          const Gap.sm(),
          const VehicleProfileCard(
            model: 'Renault Kwid Zen',
            plate: 'RNT4G88',
            regime: VehicleRegime.owned,
            periodicCost: 1180.00,
            depreciationPerKm: 0.14,
          ),
          const Gap.lg(),
          const SectionHeader(title: 'Notificações Inteligentes Contextualizadas'),
          const SmartNotificationCard(
            title: 'Conta de Energia Vence Amanhã!',
            message:
                'Sua conta de luz de R\$ 180,00 vence amanhã. No seu ritmo atual, faltam apenas 2 corridas médias para cobrir.',
            billAmount: 180.00,
            ridesEquivalent: 2,
          ),
          const Gap.lg(),
          const SectionHeader(title: 'Smart Shift (Melhores Horários)'),
          const SmartShiftTile(
            timeRange: '17:00 - 20:30',
            demandLevel: 'Pico Extremo (Dinâmica)',
            score: 98,
            expectedNetHourlyRate: 51.20,
            isRecommended: true,
          ),
          const Gap.xs(),
          const SmartShiftTile(
            timeRange: '06:00 - 09:00',
            demandLevel: 'Alta Demanda',
            score: 92,
            expectedNetHourlyRate: 42.00,
          ),
          const Gap.xs(),
          const SmartShiftTile(
            timeRange: '09:00 - 12:00',
            demandLevel: 'Baixa Demanda',
            score: 45,
            expectedNetHourlyRate: 24.00,
          ),
          const Gap.lg(),
          const SectionHeader(title: 'Widget Flutuante Suspenso (Overlay Android)'),
          OverlayWidgetCard(
            isOverlayActive: _overlayActive,
            onToggleOverlay: (val) => setState(() => _overlayActive = val),
            remainingGoal: 135.00,
            currentNetRate: 38.74,
          ),
          const Gap.xl(),
        ],
      ),
    );
  }
}
