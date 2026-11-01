import 'package:flutter/widgets.dart';

import 'server_vehicle_setup.dart';
import 'vehicle_setup_coordinator.dart';
import 'vehicle_setup_view.dart';
import 'vehicle_setup_view_model.dart';

/// Montador da cena de Configuração de Veículo e Break-Even.
abstract final class VehicleSetupFactory {
  static Widget make({
    VehicleSetupCoordinator? coordinator,
    ServerVehicleSetup? server,
  }) {
    final serverVehicle = server ?? const DefaultServerVehicleSetup();
    final vehicleCoordinator = coordinator ?? DefaultVehicleSetupCoordinator();
    final viewModel = VehicleSetupViewModel(
      server: serverVehicle,
      coordinator: vehicleCoordinator,
    );
    return VehicleSetupView(viewModel: viewModel);
  }
}
