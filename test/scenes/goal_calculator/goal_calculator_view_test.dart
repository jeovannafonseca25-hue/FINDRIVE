import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:carteira_digital/core/models/goal_model.dart';
import 'package:carteira_digital/scenes/goal_calculator/goal_calculator_coordinator.dart';
import 'package:carteira_digital/scenes/goal_calculator/goal_calculator_factory.dart';
import 'package:carteira_digital/scenes/goal_calculator/goal_calculator_view.dart';
import 'package:carteira_digital/scenes/goal_calculator/goal_calculator_view_model.dart';
import 'package:carteira_digital/scenes/goal_calculator/server_goal_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeServerGoalCalculator implements ServerGoalCalculator {
  GoalModel settings = const GoalModel(
    targetMonthlyNetIncome: 4500.0,
    householdFixedCosts: 2100.0,
    vehicleFixedCosts: 2720.0,
    workingDaysPerMonth: 22,
    maintenanceRetentionRate: 0.10,
    fuelExpenseRate: 0.24,
    daysOffWeeklyCount: 2,
  );

  @override
  Future<GoalModel> fetchCurrentSettings() async => settings;

  @override
  Future<void> saveSettings(GoalModel settings) async {
    this.settings = settings;
  }
}

class _FakeGoalCoordinator implements GoalCalculatorCoordinator {
  int popCalls = 0;
  @override
  void pop(BuildContext context) {
    popCalls++;
  }
}

Widget _app(Widget home) => MaterialApp(theme: AppTheme.dark(), home: home);

void main() {
  testWidgets('GoalCalculatorFactory.make builds GoalCalculatorView', (tester) async {
    final server = _FakeServerGoalCalculator();
    final coordinator = _FakeGoalCoordinator();

    await tester.pumpWidget(_app(GoalCalculatorFactory.make(
      server: server,
      coordinator: coordinator,
    )));
    await tester.pumpAndSettle();

    expect(find.byType(GoalCalculatorView), findsOneWidget);
    expect(find.text('META BRUTA REVERSA DIÁRIA'), findsOneWidget);
    expect(find.text('MODO FOLGA GARANTIDA'), findsOneWidget);
  });

  testWidgets('recalculates goal when days off are updated', (tester) async {
    final server = _FakeServerGoalCalculator();
    final coordinator = _FakeGoalCoordinator();
    final viewModel = GoalCalculatorViewModel(
      server: server,
      coordinator: coordinator,
    );

    await tester.pumpWidget(_app(GoalCalculatorView(viewModel: viewModel)));
    await tester.pumpAndSettle();

    expect(viewModel.daysOffPerWeek, 2);
    final initialTarget = viewModel.computedGoal.dailyGrossTarget;

    // Altera para 1 dia de folga (mais dias trabalhados -> menor meta diária)
    viewModel.updateDaysOff(1);
    await tester.pumpAndSettle();

    expect(viewModel.daysOffPerWeek, 1);
    expect(viewModel.computedGoal.dailyGrossTarget, lessThan(initialTarget));
  });
}
