import 'package:flutter/material.dart';

/// Contrato de navegação a partir do Dashboard Principal (Home).
abstract interface class HomeCoordinator {
  void navigateToGoalCalculator(BuildContext context);
  void navigateToSmartShift(BuildContext context);
  void navigateToMaintenanceVault(BuildContext context);
  void navigateToVehicleSetup(BuildContext context);
  void navigateToOverlay(BuildContext context);
}

class DefaultHomeCoordinator implements HomeCoordinator {
  DefaultHomeCoordinator({
    this.onOpenGoalCalculator,
    this.onOpenSmartShift,
    this.onOpenMaintenanceVault,
    this.onOpenVehicleSetup,
    this.onOpenOverlay,
  });

  final void Function(BuildContext context)? onOpenGoalCalculator;
  final void Function(BuildContext context)? onOpenSmartShift;
  final void Function(BuildContext context)? onOpenMaintenanceVault;
  final void Function(BuildContext context)? onOpenVehicleSetup;
  final void Function(BuildContext context)? onOpenOverlay;

  @override
  void navigateToGoalCalculator(BuildContext context) {
    onOpenGoalCalculator?.call(context);
  }

  @override
  void navigateToSmartShift(BuildContext context) {
    onOpenSmartShift?.call(context);
  }

  @override
  void navigateToMaintenanceVault(BuildContext context) {
    onOpenMaintenanceVault?.call(context);
  }

  @override
  void navigateToVehicleSetup(BuildContext context) {
    onOpenVehicleSetup?.call(context);
  }

  @override
  void navigateToOverlay(BuildContext context) {
    onOpenOverlay?.call(context);
  }
}
