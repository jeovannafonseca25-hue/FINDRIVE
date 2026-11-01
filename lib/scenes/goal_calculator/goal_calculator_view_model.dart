import 'package:flutter/widgets.dart';

import '../../core/models/goal_model.dart';
import 'goal_calculator_coordinator.dart';
import 'server_goal_calculator.dart';

/// ViewModel da Calculadora de Meta Reversa & Modo Folga Garantida.
class GoalCalculatorViewModel extends ChangeNotifier {
  GoalCalculatorViewModel({
    required ServerGoalCalculator server,
    required GoalCalculatorCoordinator coordinator,
  })  : _server = server,
        _coordinator = coordinator {
    _load();
  }

  final ServerGoalCalculator _server;
  final GoalCalculatorCoordinator _coordinator;

  bool _isLoading = true;
  double _netIncomeTarget = 4500.0;
  double _householdCosts = 2100.0;
  double _vehicleCosts = 2720.0;
  int _daysOffPerWeek = 2;
  double _retentionRate = 0.10;
  double _fuelRate = 0.24;

  bool get isLoading => _isLoading;
  double get netIncomeTarget => _netIncomeTarget;
  double get householdCosts => _householdCosts;
  double get vehicleCosts => _vehicleCosts;
  int get daysOffPerWeek => _daysOffPerWeek;
  double get retentionPercent => _retentionRate * 100;
  double get fuelPercent => _fuelRate * 100;

  int get workingDaysPerMonth {
    final workDaysPerWeek = (7 - _daysOffPerWeek).clamp(1, 7);
    return (workDaysPerWeek * 4.33).round();
  }

  GoalModel get computedGoal => GoalModel(
        targetMonthlyNetIncome: _netIncomeTarget,
        householdFixedCosts: _householdCosts,
        vehicleFixedCosts: _vehicleCosts,
        workingDaysPerMonth: workingDaysPerMonth,
        maintenanceRetentionRate: _retentionRate,
        fuelExpenseRate: _fuelRate,
        daysOffWeeklyCount: _daysOffPerWeek,
      );

  Future<void> _load() async {
    final settings = await _server.fetchCurrentSettings();
    _netIncomeTarget = settings.targetMonthlyNetIncome;
    _householdCosts = settings.householdFixedCosts;
    _vehicleCosts = settings.vehicleFixedCosts;
    _daysOffPerWeek = settings.daysOffWeeklyCount;
    _retentionRate = settings.maintenanceRetentionRate;
    _fuelRate = settings.fuelExpenseRate;
    _isLoading = false;
    notifyListeners();
  }

  void updateNetIncome(double val) {
    _netIncomeTarget = val;
    notifyListeners();
  }

  void updateHouseholdCosts(double val) {
    _householdCosts = val;
    notifyListeners();
  }

  void updateVehicleCosts(double val) {
    _vehicleCosts = val;
    notifyListeners();
  }

  void updateDaysOff(int days) {
    _daysOffPerWeek = days;
    notifyListeners();
  }

  void updateRetentionRate(double rate) {
    _retentionRate = rate;
    notifyListeners();
  }

  void updateFuelRate(double rate) {
    _fuelRate = rate;
    notifyListeners();
  }

  Future<void> save(BuildContext context) async {
    await _server.saveSettings(computedGoal);
    if (context.mounted) {
      _coordinator.pop(context);
    }
  }
}
