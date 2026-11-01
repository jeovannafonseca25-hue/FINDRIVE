import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:carteira_digital/scenes/smart_shift/server_smart_shift.dart';
import 'package:carteira_digital/scenes/smart_shift/smart_shift_coordinator.dart';
import 'package:carteira_digital/scenes/smart_shift/smart_shift_factory.dart';
import 'package:carteira_digital/scenes/smart_shift/smart_shift_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeServerSmartShift implements ServerSmartShift {
  @override
  Future<SmartShiftData> fetchHeatmap(String dayOfWeek) async {
    return const SmartShiftData(
      dayOfWeek: 'Sexta-feira',
      recommendedWindow: '17:00 às 23:00',
      reason: 'Pico Corporativo',
      averageRatePerHour: 48.0,
      blocks: [
        SmartShiftBlock(
          timeRange: '17:00 - 20:30',
          demandLevel: 'Pico',
          score: 98,
          expectedNetRate: 50.0,
          isRecommended: true,
        ),
      ],
    );
  }
}

class _FakeSmartShiftCoordinator implements SmartShiftCoordinator {
  @override
  void pop(BuildContext context) {}
}

Widget _app(Widget home) => MaterialApp(theme: AppTheme.dark(), home: home);

void main() {
  testWidgets('SmartShiftFactory.make builds SmartShiftView', (tester) async {
    await tester.pumpWidget(_app(SmartShiftFactory.make(
      server: _FakeServerSmartShift(),
      coordinator: _FakeSmartShiftCoordinator(),
    )));
    await tester.pumpAndSettle();

    expect(find.byType(SmartShiftView), findsOneWidget);
    expect(find.text('RECOMENDAÇÃO INTELIGENTE'), findsOneWidget);
    expect(find.text('Melhor Janela: 17:00 às 23:00'), findsOneWidget);
    expect(find.byType(SmartShiftTile), findsOneWidget);
  });
}
