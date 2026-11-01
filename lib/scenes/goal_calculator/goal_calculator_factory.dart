import 'package:flutter/widgets.dart';

import 'goal_calculator_coordinator.dart';
import 'goal_calculator_view.dart';
import 'goal_calculator_view_model.dart';
import 'server_goal_calculator.dart';

/// Montador da cena da Calculadora de Meta Reversa.
abstract final class GoalCalculatorFactory {
  static Widget make({
    GoalCalculatorCoordinator? coordinator,
    ServerGoalCalculator? server,
  }) {
    final serverGoal = server ?? const DefaultServerGoalCalculator();
    final goalCoordinator = coordinator ?? DefaultGoalCalculatorCoordinator();
    final viewModel = GoalCalculatorViewModel(
      server: serverGoal,
      coordinator: goalCoordinator,
    );
    return GoalCalculatorView(viewModel: viewModel);
  }
}
