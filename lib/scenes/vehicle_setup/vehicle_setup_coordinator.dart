import 'package:flutter/material.dart';

abstract interface class VehicleSetupCoordinator {
  void pop(BuildContext context);
}

class DefaultVehicleSetupCoordinator implements VehicleSetupCoordinator {
  @override
  void pop(BuildContext context) {
    Navigator.of(context).maybePop();
  }
}
