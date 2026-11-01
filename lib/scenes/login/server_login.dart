/// Backend de autenticação para motoristas do FINDRIVE.
abstract interface class ServerLogin {
  Future<void> fetchLogin({required String email, required String password});
}

/// Implementação padrão com simulação assíncrona para desenvolvimento.
class DefaultServerLogin implements ServerLogin {
  const DefaultServerLogin();

  @override
  Future<void> fetchLogin({
    required String email,
    required String password,
  }) async {
    // Simula latência de rede de 600ms
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }
}

/// Implementação de produção conectando à API RESTful do FINDRIVE.
class ServerLoginImpl implements ServerLogin {
  const ServerLoginImpl();

  @override
  Future<void> fetchLogin({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }
}
