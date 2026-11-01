import 'package:flutter/material.dart';

/// Contrato de navegação para a cena de Login do FINDRIVE.
abstract interface class LoginCoordinator {
  void navigateToHome(BuildContext context);
}

class DefaultLoginCoordinator implements LoginCoordinator {
  DefaultLoginCoordinator({this.onLoginSuccess});

  final void Function(BuildContext context)? onLoginSuccess;

  @override
  void navigateToHome(BuildContext context) {
    if (onLoginSuccess != null) {
      onLoginSuccess!(context);
    }
  }
}
