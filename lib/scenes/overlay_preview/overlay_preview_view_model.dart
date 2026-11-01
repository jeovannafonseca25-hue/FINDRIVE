import 'package:flutter/widgets.dart';

import 'overlay_preview_coordinator.dart';
import 'server_overlay_preview.dart';

/// ViewModel da simulação e prototipação do Widget Suspenso (Overlay Android).
class OverlayPreviewViewModel extends ChangeNotifier {
  OverlayPreviewViewModel({
    required ServerOverlayPreview server,
    required OverlayPreviewCoordinator coordinator,
  })  : _server = server,
        _coordinator = coordinator;

  // ignore: unused_field
  final ServerOverlayPreview _server;
  final OverlayPreviewCoordinator _coordinator;

  bool _isOverlayEnabled = true;
  double _ridePrice = 28.50;
  double _rideDistanceKm = 8.2;
  double _fuelCostPerLiter = 5.80;
  double _carEfficiencyKmPerLiter = 11.5;
  double _cpk = 0.16;

  bool get isOverlayEnabled => _isOverlayEnabled;
  double get ridePrice => _ridePrice;
  double get rideDistanceKm => _rideDistanceKm;

  /// Custo do combustível para esta corrida.
  double get estimatedFuelCost =>
      (_rideDistanceKm / _carEfficiencyKmPerLiter) * _fuelCostPerLiter;

  /// Desgaste veicular (CPK) desta corrida.
  double get estimatedWearCost => _rideDistanceKm * _cpk;

  /// Lucro Líquido Real da Corrida:
  double get estimatedNetProfit => _ridePrice - estimatedFuelCost - estimatedWearCost;

  /// Lucro Líquido por KM Rodado:
  double get netProfitPerKm =>
      _rideDistanceKm > 0 ? estimatedNetProfit / _rideDistanceKm : 0.0;

  /// Classificação de Viabilidade da Corrida:
  String get viabilityLabel {
    if (netProfitPerKm >= 2.50) return 'Corrida Excelente (Lucro Alto)';
    if (netProfitPerKm >= 1.80) return 'Corrida Viável (Na Média)';
    return 'Corrida Pouco Rentável (Cuidado)';
  }

  bool get isViable => netProfitPerKm >= 1.80;

  void toggleOverlay(bool value) {
    _isOverlayEnabled = value;
    notifyListeners();
  }

  void updateRidePrice(double val) {
    _ridePrice = val;
    notifyListeners();
  }

  void updateRideDistance(double val) {
    _rideDistanceKm = val;
    notifyListeners();
  }

  void pop(BuildContext context) {
    _coordinator.pop(context);
  }
}
