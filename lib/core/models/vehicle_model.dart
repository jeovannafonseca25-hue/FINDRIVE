import 'package:carteira_design_system/carteira_design_system.dart';

/// Modelo de domínio para o Veículo do motorista no FINDRIVE.
class VehicleModel {
  const VehicleModel({
    required this.id,
    required this.model,
    required this.plate,
    required this.year,
    required this.regime,
    required this.currentOdometerKm,
    required this.periodicCost,
    this.rentalCompany,
    this.breakEvenRides = 28,
    this.breakEvenDay = 'Quarta-feira',
    this.depreciationPerKm = 0.14,
    this.cpkEstimated = 0.16,
    this.fuelEfficiencyKmPerLiter = 11.5,
  });

  final String id;
  final String model;
  final String plate;
  final int year;
  final VehicleRegime regime;
  final int currentOdometerKm;

  /// Custo semanal se alugado, ou custo mensal fixo se próprio.
  final double periodicCost;

  final String? rentalCompany;
  final int breakEvenRides;
  final String breakEvenDay;
  final double depreciationPerKm;
  final double cpkEstimated;
  final double fuelEfficiencyKmPerLiter;

  bool get isRented => regime == VehicleRegime.rented;

  VehicleModel copyWith({
    String? id,
    String? model,
    String? plate,
    int? year,
    VehicleRegime? regime,
    int? currentOdometerKm,
    double? periodicCost,
    String? rentalCompany,
    int? breakEvenRides,
    String? breakEvenDay,
    double? depreciationPerKm,
    double? cpkEstimated,
    double? fuelEfficiencyKmPerLiter,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      model: model ?? this.model,
      plate: plate ?? this.plate,
      year: year ?? this.year,
      regime: regime ?? this.regime,
      currentOdometerKm: currentOdometerKm ?? this.currentOdometerKm,
      periodicCost: periodicCost ?? this.periodicCost,
      rentalCompany: rentalCompany ?? this.rentalCompany,
      breakEvenRides: breakEvenRides ?? this.breakEvenRides,
      breakEvenDay: breakEvenDay ?? this.breakEvenDay,
      depreciationPerKm: depreciationPerKm ?? this.depreciationPerKm,
      cpkEstimated: cpkEstimated ?? this.cpkEstimated,
      fuelEfficiencyKmPerLiter:
          fuelEfficiencyKmPerLiter ?? this.fuelEfficiencyKmPerLiter,
    );
  }
}
