import 'package:flutter/widgets.dart';

import '../../core/models/maintenance_model.dart';
import 'maintenance_vault_coordinator.dart';
import 'server_maintenance_vault.dart';

/// ViewModel da Carteira de Manutenção e Fundo Preventivo.
class MaintenanceVaultViewModel extends ChangeNotifier {
  MaintenanceVaultViewModel({
    required ServerMaintenanceVault server,
    required MaintenanceVaultCoordinator coordinator,
  })  : _server = server,
        _coordinator = coordinator {
    load();
  }

  final ServerMaintenanceVault _server;
  final MaintenanceVaultCoordinator _coordinator;

  bool _isLoading = true;
  MaintenanceModel? _vault;

  bool get isLoading => _isLoading;
  MaintenanceModel? get vault => _vault;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _vault = await _server.fetchVault();
    _isLoading = false;
    notifyListeners();
  }

  void addSimulatedDeposit(double amount) {
    if (_vault == null) return;
    _vault = _vault!.copyWith(vaultBalance: _vault!.vaultBalance + amount);
    notifyListeners();
  }

  void updateRetention(double percent) {
    if (_vault == null) return;
    _vault = _vault!.copyWith(retentionPercent: percent);
    _server.updateRetention(percent);
    notifyListeners();
  }

  void pop(BuildContext context) {
    _coordinator.pop(context);
  }
}
