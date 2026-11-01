import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FINDRIVE Components', () {
    testWidgets('GoalProgressCard renders daily goal and progress', (tester) async {
      await tester.pumpWidget(
        wrap(
          const GoalProgressCard(
            dailyGoal: 450.0,
            earnedSoFar: 315.0,
            remainingHours: 2.1,
          ),
        ),
      );

      expect(find.text('META REVERSA DE HOJE'), findsOneWidget);
      expect(find.text('70%'), findsOneWidget);
      expect(find.text('~2.1h restantes'), findsOneWidget);
    });

    testWidgets('NetRateCard renders net hourly rate and metrics', (tester) async {
      await tester.pumpWidget(
        wrap(
          const NetRateCard(
            netHourlyRate: 38.74,
            onlineHoursFormatted: '5h 24m',
            grossEarned: 315.00,
            netProfit: 209.20,
            performance: NetRatePerformance.high,
          ),
        ),
      );

      expect(find.text('HORA LÍQUIDA REAL'), findsOneWidget);
      expect(find.text('Alta Rentabilidade'), findsOneWidget);
      expect(find.text('5h 24m'), findsOneWidget);
    });

    testWidgets('MaintenanceVaultCard renders vault balance and status', (tester) async {
      await tester.pumpWidget(
        wrap(
          const MaintenanceVaultCard(
            vaultBalance: 1240.00,
            retentionPercent: 10.0,
            cpkAmount: 0.16,
            items: [
              MaintenanceItemStatus(
                name: 'Troca de Óleo',
                remainingKm: 1570,
                estimatedCost: 190.00,
                isWarning: true,
              ),
            ],
          ),
        ),
      );

      expect(find.text('CARTEIRA DE MANUTENÇÃO'), findsOneWidget);
      expect(find.text('Proteção automática de 10% por dia'), findsOneWidget);
      expect(find.text('R\$ 0.16 / km'), findsOneWidget);
      expect(find.text('Troca de Óleo'), findsOneWidget);
    });

    testWidgets('SmartNotificationCard renders alert and rides equivalent', (tester) async {
      await tester.pumpWidget(
        wrap(
          const SmartNotificationCard(
            title: 'Conta de Energia Vence Amanhã!',
            message: 'Faltam 2 corridas médias.',
            billAmount: 180.00,
            ridesEquivalent: 2,
          ),
        ),
      );

      expect(find.text('Conta de Energia Vence Amanhã!'), findsOneWidget);
      expect(find.text('2 corridas'), findsOneWidget);
    });

    testWidgets('VehicleProfileCard renders rented break-even info', (tester) async {
      await tester.pumpWidget(
        wrap(
          const VehicleProfileCard(
            model: 'Chevrolet Onix 1.0',
            plate: 'BRA2E19',
            regime: VehicleRegime.rented,
            periodicCost: 680.00,
            breakEvenRides: 28,
            breakEvenDay: 'Quarta-feira',
          ),
        ),
      );

      expect(find.text('Chevrolet Onix 1.0'), findsOneWidget);
      expect(find.text('28 corridas (~Quarta-feira)'), findsOneWidget);
    });

    testWidgets('SmartShiftTile renders score and peak recommendation', (tester) async {
      await tester.pumpWidget(
        wrap(
          const SmartShiftTile(
            timeRange: '17:00 - 20:30',
            demandLevel: 'Pico Extremo',
            score: 98,
            expectedNetHourlyRate: 51.20,
            isRecommended: true,
          ),
        ),
      );

      expect(find.text('17:00 - 20:30'), findsOneWidget);
      expect(find.text('98'), findsOneWidget);
      expect(find.text('PICO'), findsOneWidget);
    });

    testWidgets('OverlayWidgetCard renders switch and triggers toggle', (tester) async {
      bool toggled = false;
      await tester.pumpWidget(
        wrap(
          OverlayWidgetCard(
            isOverlayActive: false,
            onToggleOverlay: (v) => toggled = v,
          ),
        ),
      );

      expect(find.text('WIDGET FLUTUANTE (OVERLAY)'), findsOneWidget);
      await tester.tap(find.byType(Switch));
      expect(toggled, isTrue);
    });
  });
}
