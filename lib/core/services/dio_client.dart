import 'package:dio/dio.dart';

class DioClient {
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:5179/api/', // Altere para o seu IP ou URL da API
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
  ));

  DioClient() {
    dio.interceptors.add(LogInterceptor(responseBody: true));
  }
}