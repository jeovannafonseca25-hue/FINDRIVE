import 'package:flutter/widgets.dart';

import 'maintenance_vault_coordinator.dart';
import 'maintenance_vault_view.dart';
import 'maintenance_vault_view_model.dart';
import 'server_maintenance_vault.dart';

/// Montador da cena da Carteira de Manutenção (Fundo Preventivo).
abstract final class MaintenanceVaultFactory {
  static Widget make({
    MaintenanceVaultCoordinator? coordinator,
    ServerMaintenanceVault? server,
  }) {
    final serverVault = server ?? const DefaultServerMaintenanceVault();
    final vaultCoordinator = coordinator ?? DefaultMaintenanceVaultCoordinator();
    final viewModel = MaintenanceVaultViewModel(
      server: serverVault,
      coordinator: vaultCoordinator,
    );
    return MaintenanceVaultView(viewModel: viewModel);
  }
}
