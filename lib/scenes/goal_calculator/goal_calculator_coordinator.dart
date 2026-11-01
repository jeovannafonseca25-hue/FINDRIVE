import 'package:flutter/material.dart';

abstract interface class GoalCalculatorCoordinator {
  void pop(BuildContext context);
}

class DefaultGoalCalculatorCoordinator implements GoalCalculatorCoordinator {
  @override
  void pop(BuildContext context) {
    Navigator.of(context).maybePop();
  }
}
