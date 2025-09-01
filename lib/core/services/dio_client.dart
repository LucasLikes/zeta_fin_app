import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  // Criação do Dio com as opções de configuração
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://localhost:32769', // Altere para a URL correta da sua API
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
    headers: {'Accept': 'application/json'}, // Cabeçalho de aceitação
  ));

  // Adicionando interceptors para logging das requisições/respostas
  DioClient() {
    dio.interceptors.add(LogInterceptor(responseBody: true));

    // Adiciona o token JWT ao cabeçalho em todas as requisições
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Carrega o token armazenado no SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token'); // A chave 'token' é a mesma que você usou ao salvar o token

        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token'; // Adiciona o token ao cabeçalho
        }

        return handler.next(options); // Prossegue com a requisição
      },
    ));
  }

  // Função POST genérica
  Future<Response> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.post(endpoint, data: data);
      return response; // Retorna a resposta da requisição
    } on DioError catch (e) {
      // Trata erros de requisição
      throw Exception('Erro na requisição: ${e.response?.statusCode}, ${e.message}');
    }
  }

  // Função GET genérica
  Future<Response> get(String endpoint) async {
    try {
      final response = await dio.get(endpoint);
      return response; // Retorna a resposta da requisição
    } on DioError catch (e) {
      // Trata erros de requisição
      throw Exception('Erro na requisição: ${e.response?.statusCode}, ${e.message}');
    }
  }
}
