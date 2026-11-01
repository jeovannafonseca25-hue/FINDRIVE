import 'package:flutter/widgets.dart';

import 'login_coordinator.dart';
import 'server_login.dart';

/// Estado e ações da cena de Login do FINDRIVE.
class LoginViewModel extends ChangeNotifier {
  LoginViewModel({
    required ServerLogin serverLogin,
    required LoginCoordinator coordinator,
  })  : _serverLogin = serverLogin,
        _coordinator = coordinator;

  final ServerLogin _serverLogin;
  final LoginCoordinator _coordinator;

  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;

  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get canSubmit => _email.trim().isNotEmpty && _password.trim().isNotEmpty && !_isLoading;

  void onEmailChanged(String value) {
    _email = value;
    _errorMessage = null;
    notifyListeners();
  }

  void onPasswordChanged(String value) {
    _password = value;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> submit(BuildContext context) async {
    if (!canSubmit) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _serverLogin.fetchLogin(email: _email, password: _password);
      if (context.mounted) {
        _coordinator.navigateToHome(context);
      }
    } catch (e) {
      _errorMessage = 'Falha ao autenticar. Verifique seus dados.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
