import 'package:flutter/material.dart';

import '../main_nav/main_nav_scaffold.dart';
import 'login_coordinator.dart';
import 'login_view.dart';
import 'login_view_model.dart';
import 'server_login.dart';

/// Assembles the FINDRIVE login scene, injecting its dependencies into the ViewModel.
abstract final class LoginFactory {
  static Widget make({LoginCoordinator? coordinator, ServerLogin? server}) {
    final serverLogin = server ?? const DefaultServerLogin();
    final loginCoordinator = coordinator ??
        DefaultLoginCoordinator(
          onLoginSuccess: (context) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => const MainNavScaffold(),
              ),
            );
          },
        );
    final viewModel = LoginViewModel(
      serverLogin: serverLogin,
      coordinator: loginCoordinator,
    );
    return LoginView(viewModel: viewModel);
  }
}
