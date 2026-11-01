import 'package:flutter/widgets.dart';

import 'server_smart_shift.dart';
import 'smart_shift_coordinator.dart';

/// ViewModel de Inteligência de Turno (Smart Shift e Mapa de Calor).
class SmartShiftViewModel extends ChangeNotifier {
  SmartShiftViewModel({
    required ServerSmartShift server,
    required SmartShiftCoordinator coordinator,
  })  : _server = server,
        _coordinator = coordinator {
    load();
  }

  final ServerSmartShift _server;
  final SmartShiftCoordinator _coordinator;

  bool _isLoading = true;
  String _selectedDay = 'Sexta-feira';
  SmartShiftData? _data;

  bool get isLoading => _isLoading;
  String get selectedDay => _selectedDay;
  SmartShiftData? get data => _data;

  static const List<String> daysOfWeek = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo',
  ];

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _data = await _server.fetchHeatmap(_selectedDay);
    _isLoading = false;
    notifyListeners();
  }

  void selectDay(String day) {
    if (_selectedDay == day) return;
    _selectedDay = day;
    load();
  }

  void pop(BuildContext context) {
    _coordinator.pop(context);
  }
}
