import '../../core/models/maintenance_model.dart';
import 'package:carteira_design_system/carteira_design_system.dart';

abstract interface class ServerMaintenanceVault {
  Future<MaintenanceModel> fetchVault();
  Future<void> updateRetention(double percent);
}

class DefaultServerMaintenanceVault implements ServerMaintenanceVault {
  const DefaultServerMaintenanceVault();

  @override
  Future<MaintenanceModel> fetchVault() async {
    return const MaintenanceModel(
      vaultBalance: 1240.00,
      retentionPercent: 10.0,
      cpkAmount: 0.16,
      items: [
        MaintenanceItemStatus(
          name: 'Troca de Óleo e Filtro (Sintético)',
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
          name: 'Jogo de Pneus (4 unidades)',
          remainingKm: 16570,
          estimatedCost: 1200.00,
          isWarning: false,
        ),
        MaintenanceItemStatus(
          name: 'Alinhamento e Balanceamento 3D',
          remainingKm: 4200,
          estimatedCost: 120.00,
          isWarning: false,
        ),
        MaintenanceItemStatus(
          name: 'Correia Dentada / Tensores',
          remainingKm: 28000,
          estimatedCost: 550.00,
          isWarning: false,
        ),
      ],
    );
  }

  @override
  Future<void> updateRetention(double percent) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}
