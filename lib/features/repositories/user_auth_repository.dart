import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/dio_client.dart';
import '../goals/models/user_model.dart';

class AuthRepository {
  final DioClient dioClient;

  // Injeção de dependência do DioClient
  AuthRepository({required this.dioClient});

  // Função de login que interage com a API
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dioClient.post(
        '/api/Auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        // Salva o token no SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', response.data['token']); // Salva o token

        return UserModel.fromJson(
          response.data,
        ); // Retorna o modelo de usuário com o token JWT
      } else {
        throw Exception('Falha na autenticação');
      }
    } catch (e) {
      throw Exception('Erro ao tentar fazer login: $e');
    }
  }

  Future<void> cadastrar(String name, String email, String password) async {
    try {
      final response = await dioClient.post('/api/Users', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 201) {
        // Sucesso, usuário cadastrado
      } else {
        throw Exception('Falha ao cadastrar');
      }
    } catch (e) {
      throw Exception('Erro ao tentar cadastrar: $e');
    }
  }
}
