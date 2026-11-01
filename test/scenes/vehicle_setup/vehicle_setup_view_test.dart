import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:carteira_digital/core/models/vehicle_model.dart';
import 'package:carteira_digital/scenes/vehicle_setup/server_vehicle_setup.dart';
import 'package:carteira_digital/scenes/vehicle_setup/vehicle_setup_coordinator.dart';
import 'package:carteira_digital/scenes/vehicle_setup/vehicle_setup_factory.dart';
import 'package:carteira_digital/scenes/vehicle_setup/vehicle_setup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeServerVehicleSetup implements ServerVehicleSetup {
  VehicleModel vehicle = const VehicleModel(
    id: 'veh_1',
    model: 'Renault Kwid',
    plate: 'ABC1D23',
    year: 2023,
    regime: VehicleRegime.rented,
    currentOdometerKm: 50000,
    periodicCost: 680.0,
  );

  @override
  Future<VehicleModel> fetchVehicle() async => vehicle;

  @override
  Future<void> saveVehicle(VehicleModel vehicle) async {
    this.vehicle = vehicle;
  }
}

class _FakeVehicleCoordinator implements VehicleSetupCoordinator {
  int popCount = 0;
  @override
  void pop(BuildContext context) {
    popCount++;
  }
}

Widget _app(Widget home) => MaterialApp(theme: AppTheme.dark(), home: home);

void main() {
  testWidgets('VehicleSetupFactory.make builds VehicleSetupView', (tester) async {
    final server = _FakeServerVehicleSetup();
    final coordinator = _FakeVehicleCoordinator();

    await tester.pumpWidget(_app(VehicleSetupFactory.make(
      server: server,
      coordinator: coordinator,
    )));
    await tester.pumpAndSettle();

    expect(find.byType(VehicleSetupView), findsOneWidget);
    expect(find.text('PONTO DE EQUILÍBRIO (BREAK-EVEN)'), findsOneWidget);
    expect(find.text('Carro Alugado'), findsOneWidget);
    expect(find.text('Carro Próprio'), findsOneWidget);
  });
}
