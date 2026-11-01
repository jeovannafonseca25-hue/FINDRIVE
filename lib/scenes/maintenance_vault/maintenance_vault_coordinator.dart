import 'package:flutter/material.dart';

abstract interface class MaintenanceVaultCoordinator {
  void pop(BuildContext context);
}

class DefaultMaintenanceVaultCoordinator implements MaintenanceVaultCoordinator {
  @override
  void pop(BuildContext context) {
    Navigator.of(context).maybePop();
  }
}
