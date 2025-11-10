import 'package:dio/dio.dart';
import 'package:zeta_fin_app/core/services/dio_client.dart';
import 'package:zeta_fin_app/features/expenses/models/expense_model.dart';

class ExpenseService {
  final DioClient _client;

  ExpenseService(this._client);

  Dio get dio => _client.dio;

  static const String _endpoint = '/Expenses';

  // ==============================================================
  // 📋 LISTA TODAS AS DESPESAS DE UM USUÁRIO
  // ==============================================================
  Future<List<Expense>> getExpensesByUser(String userId) async {
    try {
      print('📤 Buscando despesas do usuário: $userId');

      final response = await dio.get('$_endpoint/user/$userId');

      print('✅ Resposta recebida: ${response.data}');

      // Backend retorna array direto (não tem wrapper)
      if (response.data is List) {
        final list = response.data as List<dynamic>;
        return list.map((e) => Expense.fromJson(e)).toList();
      }

      return [];
    } on DioException catch (e) {
      print('❌ Erro ao buscar despesas: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // ==============================================================
  // 🔍 OBTÉM UMA DESPESA POR ID
  // ==============================================================
  Future<Expense?> getExpenseById(String id) async {
    try {
      final response = await dio.get('$_endpoint/$id');
      
      if (response.data != null) {
        return Expense.fromJson(response.data);
      }
      
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw _handleError(e);
    }
  }

  // ==============================================================
  // 📦 CRIA UMA NOVA DESPESA
  // ==============================================================
  Future<Expense> createExpense({
    required String userId,
    required String name,
    required double value,
    required String category,
    DateTime? dueDate,
  }) async {
    try {
      final body = {
        'userId': userId,
        'name': name,
        'value': value,
        'category': category,
        if (dueDate != null) 'dueDate': dueDate.toIso8601String(),
      };

      print('📤 Criando despesa: $body');

      final response = await dio.post(_endpoint, data: body);

      print('✅ Despesa criada: ${response.data}');

      return Expense.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ Erro ao criar despesa: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // ==============================================================
  // ✏️ ATUALIZA UMA DESPESA
  // ==============================================================
  Future<Expense> updateExpense({
    required String id,
    String? name,
    double? value,
    String? category,
    DateTime? dueDate,
  }) async {
    try {
      final body = {
        if (name != null) 'name': name,
        if (value != null) 'value': value,
        if (category != null) 'category': category,
        if (dueDate != null) 'dueDate': dueDate.toIso8601String(),
      };

      final response = await dio.put('$_endpoint/$id', data: body);

      return Expense.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==============================================================
  // 🗑️ DELETA UMA DESPESA
  // ==============================================================
  Future<void> deleteExpense(String id) async {
    try {
      await dio.delete('$_endpoint/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==============================================================
  // 💰 OBTÉM RESUMO POR CATEGORIA
  // ==============================================================
  Future<Map<String, double>> getSummaryByCategory(String userId) async {
    try {
      print('📤 Buscando resumo por categoria para: $userId');

      final response = await dio.get('$_endpoint/summary/$userId');

      print('✅ Resumo recebido: ${response.data}');

      // Backend retorna Map<string, decimal> direto
      if (response.data is Map) {
        final map = Map<String, dynamic>.from(response.data);
        return map.map((key, value) => MapEntry(key, (value as num).toDouble()));
      }

      return {};
    } on DioException catch (e) {
      print('❌ Erro ao buscar resumo: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // ==============================================================
  // ⚠️ TRATAMENTO CENTRALIZADO DE ERROS
  // ==============================================================
  Exception _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      
      String message = 'Erro desconhecido';
      
      if (data is Map) {
        message = data['message'] ?? 
                  data['error']?['message'] ?? 
                  data['detail'] ?? 
                  data['title'] ?? 
                  'Erro desconhecido';
      } else if (data is String) {
        message = data;
      }
      
      final code = error.response!.statusCode?.toString() ?? 'UNKNOWN';

      switch (error.response!.statusCode) {
        case 400:
          return ApiException('Requisição inválida: $message', code);
        case 401:
          return ApiException('Não autorizado. Faça login novamente.', 'UNAUTHORIZED');
        case 403:
          return ApiException('Acesso negado: $message', 'FORBIDDEN');
        case 404:
          return ApiException('Não encontrado: $message', 'NOT_FOUND');
        case 500:
          return ApiException('Erro interno do servidor', 'SERVER_ERROR');
        default:
          return ApiException(message, code);
      }
    } else {
      return ApiException('Erro de conexão com o servidor', 'NETWORK_ERROR');
    }
  }
}

// ==============================================================
class ApiException implements Exception {
  final String message;
  final String code;
  ApiException(this.message, this.code);

  @override
  String toString() => '$message (code: $code)';
}