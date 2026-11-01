import 'package:flutter/material.dart';

import '../../core/models/goal_model.dart';
import '../../core/models/maintenance_model.dart';
import '../../core/models/shift_model.dart';
import '../../core/models/smart_alert_model.dart';
import '../../core/models/vehicle_model.dart';
import 'home_coordinator.dart';
import 'server_home.dart';

/// ViewModel do Dashboard Principal FINDRIVE.
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required ServerHome serverHome,
    required HomeCoordinator coordinator,
  })  : _serverHome = serverHome,
        _coordinator = coordinator {
    loadData();
  }

  final ServerHome _serverHome;
  final HomeCoordinator _coordinator;

  bool _isLoading = true;
  bool _isOverlayActive = true;

  GoalModel? _goal;
  ShiftModel? _shift;
  VehicleModel? _vehicle;
  MaintenanceModel? _maintenance;
  List<SmartAlertModel> _alerts = const [];

  bool get isLoading => _isLoading;
  bool get isOverlayActive => _isOverlayActive;

  GoalModel? get goal => _goal;
  ShiftModel? get shift => _shift;
  VehicleModel? get vehicle => _vehicle;
  MaintenanceModel? get maintenance => _maintenance;
  List<SmartAlertModel> get alerts => _alerts;

  double get dailyGoalAmount => _goal?.dailyGrossTarget ?? 450.0;
  double get earnedSoFar => _shift?.grossEarned ?? 315.0;
  double get remainingHours => _goal != null && _shift != null
      ? ((dailyGoalAmount - earnedSoFar) / 55.0).clamp(0.0, 12.0)
      : 2.1;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _serverHome.fetchTodayGoal(),
        _serverHome.fetchActiveShift(),
        _serverHome.fetchActiveVehicle(),
        _serverHome.fetchMaintenanceVault(),
        _serverHome.fetchSmartAlerts(),
      ]);

      _goal = results[0] as GoalModel;
      _shift = results[1] as ShiftModel;
      _vehicle = results[2] as VehicleModel;
      _maintenance = results[3] as MaintenanceModel;
      _alerts = results[4] as List<SmartAlertModel>;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleShift() async {
    if (_shift == null) return;
    final newStatus = !_shift!.isOnline;
    _shift = await _serverHome.toggleShiftStatus(newStatus);
    notifyListeners();
  }

  void addSimulatedRide(double amount) {
    if (_shift == null) return;
    _shift = _shift!.copyWith(
      grossEarned: _shift!.grossEarned + amount,
      kmDriven: _shift!.kmDriven + 12,
      ridesCompleted: _shift!.ridesCompleted + 1,
      onlineDurationSeconds: _shift!.onlineDurationSeconds + 1200,
    );
    notifyListeners();
  }

  void toggleOverlay(bool value) {
    _isOverlayActive = value;
    notifyListeners();
  }

  void openGoalCalculator(BuildContext context) {
    _coordinator.navigateToGoalCalculator(context);
  }

  void openSmartShift(BuildContext context) {
    _coordinator.navigateToSmartShift(context);
  }

  void openMaintenanceVault(BuildContext context) {
    _coordinator.navigateToMaintenanceVault(context);
  }

  void openVehicleSetup(BuildContext context) {
    _coordinator.navigateToVehicleSetup(context);
  }

  void openOverlay(BuildContext context) {
    _coordinator.navigateToOverlay(context);
  }
}
