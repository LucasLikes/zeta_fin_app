import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:zeta_fin_app/features/goals/models/user_model.dart';
import '../../core/services/dio_client.dart';

class AuthRepository {
  final DioClient dioClient;

  AuthRepository({required this.dioClient});

  // ----------------------------
  // LOGIN
  // ----------------------------
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dioClient.dio.post(
        '/Auth/login',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Authorization': 'zeta-fin-jwt-super-secret-key',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);

        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Falha na autenticação: código ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao tentar fazer login: $e');
    }
  }

  // ----------------------------
  // CADASTRAR
  // ----------------------------
  Future<void> cadastrar(String name, String email, String password) async {
    try {
      final response = await dioClient.dio.post(
        '/Users',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Authorization': 'zeta-fin-jwt-super-secret-key',
            'Content-Type': 'application/json',
          },
        ),
      );

      // O Swagger mostra 200 OK no cadastro, então ajustamos aqui
      if (response.statusCode == 201 || response.statusCode == 200  ) {
        print('Usuário cadastrado com sucesso!');
      } else {
        throw Exception(
            'Falha ao cadastrar: código ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao tentar cadastrar: $e');
    }
  }
}
