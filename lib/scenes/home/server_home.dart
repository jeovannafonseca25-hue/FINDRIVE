import '../../core/models/goal_model.dart';
import '../../core/models/maintenance_model.dart';
import '../../core/models/shift_model.dart';
import '../../core/models/smart_alert_model.dart';
import '../../core/models/vehicle_model.dart';
import 'package:carteira_design_system/carteira_design_system.dart';

abstract interface class ServerHome {
  Future<GoalModel> fetchTodayGoal();
  Future<ShiftModel> fetchActiveShift();
  Future<VehicleModel> fetchActiveVehicle();
  Future<MaintenanceModel> fetchMaintenanceVault();
  Future<List<SmartAlertModel>> fetchSmartAlerts();
  Future<ShiftModel> toggleShiftStatus(bool start);
}

class DefaultServerHome implements ServerHome {
  const DefaultServerHome();

  @override
  Future<GoalModel> fetchTodayGoal() async {
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
  Future<ShiftModel> fetchActiveShift() async {
    return ShiftModel(
      shiftId: 'shf_99410',
      isOnline: true,
      startedAt: DateTime.now().subtract(const Duration(hours: 5, minutes: 24)),
      onlineDurationSeconds: (5 * 3600) + (24 * 60),
      grossEarned: 315.00,
      fuelSpent: 75.00,
      kmDriven: 180,
      ridesCompleted: 11,
      cpkRate: 0.16,
    );
  }

  @override
  Future<VehicleModel> fetchActiveVehicle() async {
    return const VehicleModel(
      id: 'veh_0921',
      model: 'Chevrolet Onix 1.0 Flex',
      plate: 'BRA2E19',
      year: 2024,
      regime: VehicleRegime.rented,
      currentOdometerKm: 48430,
      periodicCost: 680.00,
      rentalCompany: 'Localiza Meoo',
      breakEvenRides: 28,
      breakEvenDay: 'Quarta-feira',
    );
  }

  @override
  Future<MaintenanceModel> fetchMaintenanceVault() async {
    return const MaintenanceModel(
      vaultBalance: 1240.00,
      retentionPercent: 10.0,
      cpkAmount: 0.16,
      items: [
        MaintenanceItemStatus(
          name: 'Troca de Óleo e Filtro',
          remainingKm: 1570,
          estimatedCost: 190.00,
          isWarning: true,
        ),
        MaintenanceItemStatus(
          name: 'Pastilhas de Freio Dianteiras',
          remainingKm: 11570,
          estimatedCost: 220.00,
          isWarning: false,
        ),
        MaintenanceItemStatus(
          name: 'Pneus (4 unidades)',
          remainingKm: 16570,
          estimatedCost: 1200.00,
          isWarning: false,
        ),
      ],
    );
  }

  @override
  Future<List<SmartAlertModel>> fetchSmartAlerts() async {
    return const [
      SmartAlertModel(
        id: 'notif_9102',
        title: 'Conta de Energia Vence Amanhã!',
        message:
            'Sua conta de luz de R\$ 180,00 vence amanhã. No seu ritmo atual, faltam apenas 2 corridas médias para cobrir.',
        billAmount: 180.00,
        ridesEquivalent: 2,
        priority: SmartNotificationPriority.high,
      ),
    ];
  }

  @override
  Future<ShiftModel> toggleShiftStatus(bool start) async {
    return ShiftModel(
      shiftId: 'shf_99410',
      isOnline: start,
      startedAt: DateTime.now(),
      onlineDurationSeconds: start ? 3600 : 0,
      grossEarned: start ? 55.0 : 0.0,
      fuelSpent: start ? 15.0 : 0.0,
      kmDriven: start ? 25 : 0,
      ridesCompleted: start ? 2 : 0,
    );
  }
}
