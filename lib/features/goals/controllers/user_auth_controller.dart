import 'package:shared_preferences/shared_preferences.dart';
import '../../repositories/user_auth_repository.dart';

class AuthController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  // Método de login
  Future<void> login(String email, String password) async {
    try {
      final user = await authRepository.login(email, password);
      
      // Salvar o token no SharedPreferences após login bem-sucedido
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', user.token); // Armazenar o token JWT

      // Aqui você pode seguir com outras ações, como navegar para outra tela ou atualizar o estado.

    } catch (e) {
      // Tratar erro de login
      print('Erro de login: $e');
      rethrow; // Re-throw para capturar no UI se necessário
    }
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