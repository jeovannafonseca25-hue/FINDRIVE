import 'package:flutter/widgets.dart';

import 'server_smart_shift.dart';
import 'smart_shift_coordinator.dart';
import 'smart_shift_view.dart';
import 'smart_shift_view_model.dart';

/// Montador da cena de Inteligência de Turno (Smart Shift).
abstract final class SmartShiftFactory {
  static Widget make({
    SmartShiftCoordinator? coordinator,
    ServerSmartShift? server,
  }) {
    final serverShift = server ?? const DefaultServerSmartShift();
    final shiftCoordinator = coordinator ?? DefaultSmartShiftCoordinator();
    final viewModel = SmartShiftViewModel(
      server: serverShift,
      coordinator: shiftCoordinator,
    );
    return SmartShiftView(viewModel: viewModel);
  }
}
