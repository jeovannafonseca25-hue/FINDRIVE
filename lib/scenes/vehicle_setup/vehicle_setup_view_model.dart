import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../core/models/vehicle_model.dart';
import 'server_vehicle_setup.dart';
import 'vehicle_setup_coordinator.dart';

/// ViewModel da configuração de Veículo e Ponto de Equilíbrio (Break-Even).
class VehicleSetupViewModel extends ChangeNotifier {
  VehicleSetupViewModel({
    required ServerVehicleSetup server,
    required VehicleSetupCoordinator coordinator,
  })  : _server = server,
        _coordinator = coordinator {
    _load();
  }

  final ServerVehicleSetup _server;
  final VehicleSetupCoordinator _coordinator;

  bool _isLoading = true;
  String _model = 'Chevrolet Onix 1.0';
  String _plate = 'BRA2E19';
  VehicleRegime _regime = VehicleRegime.rented;
  double _periodicCost = 680.00;
  int _currentKm = 48430;
  double _depreciationPerKm = 0.14;

  bool get isLoading => _isLoading;
  String get model => _model;
  String get plate => _plate;
  VehicleRegime get regime => _regime;
  double get periodicCost => _periodicCost;
  int get currentKm => _currentKm;
  double get depreciationPerKm => _depreciationPerKm;

  int get computedBreakEvenRides {
    if (_regime == VehicleRegime.rented) {
      // Custo do aluguel semanal / ~R$ 24,20 líquido por corrida
      return (_periodicCost / 24.20).ceil();
    } else {
      // Custo mensal diluído semanalmente / ~R$ 24,20
      return ((_periodicCost / 4.33) / 24.20).ceil();
    }
  }

  String get computedBreakEvenDay {
    final rides = computedBreakEvenRides;
    if (rides <= 12) return 'Terça-feira';
    if (rides <= 25) return 'Quarta-feira';
    if (rides <= 35) return 'Quinta-feira';
    return 'Sexta-feira';
  }

  Future<void> _load() async {
    final v = await _server.fetchVehicle();
    _model = v.model;
    _plate = v.plate;
    _regime = v.regime;
    _periodicCost = v.periodicCost;
    _currentKm = v.currentOdometerKm;
    _depreciationPerKm = v.depreciationPerKm;
    _isLoading = false;
    notifyListeners();
  }

  void setRegime(VehicleRegime r) {
    _regime = r;
    if (r == VehicleRegime.rented && _periodicCost > 1500) {
      _periodicCost = 680.0;
    } else if (r == VehicleRegime.owned && _periodicCost < 700) {
      _periodicCost = 1180.0;
    }
    notifyListeners();
  }

  void updateModel(String val) {
    _model = val;
    notifyListeners();
  }

  void updatePlate(String val) {
    _plate = val;
    notifyListeners();
  }

  void updatePeriodicCost(double val) {
    _periodicCost = val;
    notifyListeners();
  }

  void updateKm(int val) {
    _currentKm = val;
    notifyListeners();
  }

  Future<void> save(BuildContext context) async {
    final v = VehicleModel(
      id: 'veh_0921',
      model: _model,
      plate: _plate,
      year: 2024,
      regime: _regime,
      currentOdometerKm: _currentKm,
      periodicCost: _periodicCost,
      breakEvenRides: computedBreakEvenRides,
      breakEvenDay: computedBreakEvenDay,
      depreciationPerKm: _depreciationPerKm,
    );
    await _server.saveVehicle(v);
    if (context.mounted) {
      _coordinator.pop(context);
    }
  }
}
