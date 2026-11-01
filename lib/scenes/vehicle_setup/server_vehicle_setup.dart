import '../../core/models/vehicle_model.dart';
import 'package:carteira_design_system/carteira_design_system.dart';

abstract interface class ServerVehicleSetup {
  Future<VehicleModel> fetchVehicle();
  Future<void> saveVehicle(VehicleModel vehicle);
}

class DefaultServerVehicleSetup implements ServerVehicleSetup {
  const DefaultServerVehicleSetup();

  @override
  Future<VehicleModel> fetchVehicle() async {
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
      depreciationPerKm: 0.14,
    );
  }

  @override
  Future<void> saveVehicle(VehicleModel vehicle) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }
}
