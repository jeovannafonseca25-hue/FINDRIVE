import 'package:flutter/material.dart';

abstract interface class SmartShiftCoordinator {
  void pop(BuildContext context);
}

class DefaultSmartShiftCoordinator implements SmartShiftCoordinator {
  @override
  void pop(BuildContext context) {
    Navigator.of(context).maybePop();
  }
}
