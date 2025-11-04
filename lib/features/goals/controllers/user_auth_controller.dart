import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeta_fin_app/core/state/auth_state.dart';
import '../../repositories/user_auth_repository.dart';
import 'dart:convert';

class AuthController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  // Método de login
  Future<void> login(String email, String password, AuthState authState) async {
  try {
    final user = await authRepository.login(email, password);

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', user.token);
    prefs.setString('name', user.name);
    prefs.setString('email', user.email);

    authState.setUser(name: user.name, email: user.email); // atualiza o estado
    authState.login(); // ⬅️ atualiza o GoRouter
  } catch (e) {
    print('Erro de login: $e');
    rethrow;
  }
}

  // Método para verificar se o token está presente e válido
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && _isTokenValid(token)) {
      return true; // O token é válido
    }

    return false; // O token não está presente ou é inválido
  }

  // Função para validar o token localmente (verificando data de expiração, etc.)
  bool _isTokenValid(String token) {
    // Simples verificação da validade do token (pode ser estendido para checar a expiração)
    try {
      final parts = token.split('.');
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final payloadMap = json.decode(payload);

      final exp = payloadMap['exp'];
      final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);

      // Verifica se o token está expirado
      if (expirationDate.isBefore(DateTime.now())) {
        return false;
      }

      return true;
    } catch (e) {
      // Caso ocorra algum erro na validação, tratamos como inválido
      return false;
    }
  }

  // Método para logout
  Future<void> logout(AuthState authState) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    authState
        .logout(); // ⬅️ GoRouter vai redirecionar para /login automaticamente
  }

  Future<void> cadastrar(String name, String email, String password) async {
    try {
      // Chama o repositório para fazer o cadastro
      await authRepository.cadastrar(name, email, password);
    } catch (e) {
      throw Exception("Erro ao cadastrar: $e");
    }
  }
}
