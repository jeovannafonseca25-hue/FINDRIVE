import 'package:flutter/material.dart';

abstract interface class OverlayPreviewCoordinator {
  void pop(BuildContext context);
}

class DefaultOverlayPreviewCoordinator implements OverlayPreviewCoordinator {
  @override
  void pop(BuildContext context) {
    Navigator.of(context).maybePop();
  }
}
