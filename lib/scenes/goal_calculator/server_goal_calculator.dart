import '../../core/models/goal_model.dart';

abstract interface class ServerGoalCalculator {
  Future<GoalModel> fetchCurrentSettings();
  Future<void> saveSettings(GoalModel settings);
}

class DefaultServerGoalCalculator implements ServerGoalCalculator {
  const DefaultServerGoalCalculator();

  @override
  Future<GoalModel> fetchCurrentSettings() async {
    return const GoalModel(
      targetMonthlyNetIncome: 4500.0,
      householdFixedCosts: 2100.0,
      vehicleFixedCosts: 2720.0,
      workingDaysPerMonth: 22,
      maintenanceRetentionRate: 0.10,
      fuelExpenseRate: 0.24,
      daysOffWeeklyCount: 2,
    );
  }

  @override
  Future<void> saveSettings(GoalModel settings) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }
}
