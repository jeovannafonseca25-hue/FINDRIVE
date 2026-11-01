import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:carteira_digital/core/models/goal_model.dart';
import 'package:carteira_digital/core/models/maintenance_model.dart';
import 'package:carteira_digital/core/models/shift_model.dart';
import 'package:carteira_digital/core/models/smart_alert_model.dart';
import 'package:carteira_digital/core/models/vehicle_model.dart';
import 'package:carteira_digital/scenes/home/home_coordinator.dart';
import 'package:carteira_digital/scenes/home/home_factory.dart';
import 'package:carteira_digital/scenes/home/home_view.dart';
import 'package:carteira_digital/scenes/home/home_view_model.dart';
import 'package:carteira_digital/scenes/home/server_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeServerHome implements ServerHome {
  @override
  Future<GoalModel> fetchTodayGoal() async {
    return const GoalModel(
      targetMonthlyNetIncome: 4500.0,
      householdFixedCosts: 2100.0,
      vehicleFixedCosts: 2720.0,
      workingDaysPerMonth: 22,
      maintenanceRetentionRate: 0.10,
      fuelExpenseRate: 0.24,
    );
  }

  @override
  Future<ShiftModel> fetchActiveShift() async {
    return ShiftModel(
      shiftId: 'shf_1',
      isOnline: true,
      startedAt: DateTime.now(),
      onlineDurationSeconds: 3600,
      grossEarned: 100.0,
      fuelSpent: 20.0,
      kmDriven: 30,
      ridesCompleted: 3,
    );
  }

  @override
  Future<VehicleModel> fetchActiveVehicle() async {
    return const VehicleModel(
      id: 'veh_1',
      model: 'Chevrolet Onix',
      plate: 'BRA2E19',
      year: 2024,
      regime: VehicleRegime.rented,
      currentOdometerKm: 48000,
      periodicCost: 680.0,
    );
  }

  @override
  Future<MaintenanceModel> fetchMaintenanceVault() async {
    return const MaintenanceModel(
      vaultBalance: 1200.0,
      retentionPercent: 10.0,
      cpkAmount: 0.16,
      items: [],
    );
  }

  @override
  Future<List<SmartAlertModel>> fetchSmartAlerts() async {
    return const [
      SmartAlertModel(
        id: '1',
        title: 'Alerta Teste',
        message: 'Mensagem teste',
        billAmount: 180.0,
        ridesEquivalent: 2,
      ),
    ];
  }

  @override
  Future<ShiftModel> toggleShiftStatus(bool start) async {
    return ShiftModel(
      shiftId: 'shf_1',
      isOnline: start,
      startedAt: DateTime.now(),
      onlineDurationSeconds: start ? 3600 : 0,
      grossEarned: 100.0,
      fuelSpent: 20.0,
      kmDriven: 30,
      ridesCompleted: 3,
    );
  }
}

class _FakeHomeCoordinator implements HomeCoordinator {
  @override
  void navigateToGoalCalculator(BuildContext context) {}

  @override
  void navigateToSmartShift(BuildContext context) {}

  @override
  void navigateToMaintenanceVault(BuildContext context) {}

  @override
  void navigateToVehicleSetup(BuildContext context) {}

  @override
  void navigateToOverlay(BuildContext context) {}
}

Widget _app(Widget home) => MaterialApp(theme: AppTheme.dark(), home: home);

void main() {
  testWidgets('HomeFactory.make builds HomeView and loads data', (tester) async {
    await tester.pumpWidget(_app(HomeFactory.make(
      server: _FakeServerHome(),
      coordinator: _FakeHomeCoordinator(),
    )));
    await tester.pumpAndSettle();

    expect(find.byType(HomeView), findsOneWidget);
    expect(find.text('Olá, Carlos Eduardo'), findsOneWidget);
    expect(find.byType(GoalProgressCard), findsOneWidget);
    expect(find.byType(NetRateCard), findsOneWidget);
  });

  testWidgets('HomeViewModel toggles shift status', (tester) async {
    final server = _FakeServerHome();
    final coordinator = _FakeHomeCoordinator();
    final viewModel = HomeViewModel(
      serverHome: server,
      coordinator: coordinator,
    );

    await tester.pumpWidget(_app(HomeView(viewModel: viewModel)));
    await tester.pumpAndSettle();

    expect(viewModel.shift?.isOnline, isTrue);
    await viewModel.toggleShift();
    expect(viewModel.shift?.isOnline, isFalse);
  });
}
