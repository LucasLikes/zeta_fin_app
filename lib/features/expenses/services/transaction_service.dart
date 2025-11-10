import 'package:dio/dio.dart';
import '../../../core/services/dio_client.dart';
import '../models/transaction_model.dart';

class TransactionService {
  final DioClient _client;

  TransactionService(this._client);

  Dio get dio => _client.dio;

  static const String _endpoint = '/Transactions';

  // ==============================================================
  // 📦 CRIA UMA NOVA TRANSAÇÃO
  // ==============================================================
  Future<Transaction> createTransaction({
    required String type, // 'income' | 'expense'
    required double value,
    required String description,
    required String category,
    required DateTime date,
    String? expenseType, // 'fixas' | 'variaveis' | 'desnecessarios'
    bool hasReceipt = false,
  }) async {
    try {
      // Mapeia os valores para os enums corretos do backend
      int typeEnum = type.toLowerCase() == 'income' ? 0 : 1;
      
      int? expenseTypeEnum;
      if (expenseType != null) {
        if (expenseType == 'fixas') {
          expenseTypeEnum = 0; // Fixas
        } else if (expenseType == 'variaveis') {
          expenseTypeEnum = 1; // Variaveis
        } else if (expenseType == 'desnecessarios') {
          expenseTypeEnum = 2; // Desnecessarios
        }
      }

      final body = {
        'type': typeEnum,
        'value': value,
        'description': description,
        'category': category,
        'expenseType': expenseTypeEnum,
        'date': date.toIso8601String(),
        'hasReceipt': hasReceipt,
      };

      print('📤 Enviando transação: $body'); // Debug

      final response = await dio.post(_endpoint, data: body);

      print('✅ Resposta recebida: ${response.data}'); // Debug

      // Caso o backend retorne a transação dentro de 'data'
      if (response.data['data'] != null) {
        return Transaction.fromJson(response.data['data']);
      }
      
      return Transaction.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ Erro ao criar transação: ${e.response?.data}'); // Debug
      throw _handleError(e);
    }
  }

  // ==============================================================
  // 📋 LISTA TODAS AS TRANSAÇÕES
  // ==============================================================
  Future<List<Transaction>> getTransactions({
  String? type,
  String? startDate,
  String? endDate,
  String? category,
  String? expenseType,
  int page = 1,
  int limit = 20,
  String? orderBy = 'date',
  String? sort = 'desc',
}) async {
  try {
    // Converte tipo para enum se necessário
    int? typeEnum;
    if (type != null) {
      typeEnum = type.toLowerCase() == 'income' ? 0 : 1;
    }

    int? expenseTypeEnum;
    if (expenseType != null) {
      switch (expenseType.toLowerCase()) {
        case 'fixas':
          expenseTypeEnum = 0;
          break;
        case 'variaveis':
          expenseTypeEnum = 1;
          break;
        case 'desnecessarios':
          expenseTypeEnum = 2;
          break;
      }
    }

    // Adiciona os parâmetros de ordenação na query
    final query = {
      'Page': page,
      'Limit': limit,
      if (typeEnum != null) 'Type': typeEnum,
      if (startDate != null) 'StartDate': startDate,
      if (endDate != null) 'EndDate': endDate,
      if (category != null) 'Category': category,
      if (expenseTypeEnum != null) 'ExpenseType': expenseTypeEnum,
      if (orderBy != null) 'OrderBy': orderBy,  // Passa a ordenação
      if (sort != null) 'Sort': sort,          // Passa a direção da ordenação
    };

    print('📤 Buscando transações com filtros: $query');

    final response = await dio.get(_endpoint, queryParameters: query);

    print('✅ Resposta: ${response.data}');

    // CORREÇÃO: Backend retorna dentro de data.transactions
    if (response.data['success'] == true && 
        response.data['data'] != null &&
        response.data['data']['transactions'] != null) {
      final list = response.data['data']['transactions'] as List<dynamic>;
      return list.map((t) => Transaction.fromJson(t)).toList();
    }

    return [];
  } on DioException catch (e) {
    print('❌ Erro ao buscar transações: ${e.response?.data}');
    throw _handleError(e);
  }
}

  // ==============================================================
  // 🔍 OBTÉM UMA TRANSAÇÃO POR ID
  // ==============================================================
  Future<Transaction> getTransactionById(String id) async {
    try {
      final response = await dio.get('$_endpoint/$id');
      
      if (response.data['success'] == true && response.data['data'] != null) {
        return Transaction.fromJson(response.data['data']);
      }
      
      throw Exception('Transação não encontrada');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==============================================================
  // ✏️ ATUALIZA UMA TRANSAÇÃO
  // ==============================================================
  Future<Transaction> updateTransaction({
    required String id,
    double? value,
    String? description,
    String? category,
    DateTime? date,
  }) async {
    try {
      final body = {
        if (value != null) 'value': value,
        if (description != null) 'description': description,
        if (category != null) 'category': category,
        if (date != null) 'date': date.toIso8601String(),
      };

      final response = await dio.put('$_endpoint/$id', data: body);

      if (response.data['success'] == true && response.data['data'] != null) {
        return Transaction.fromJson(response.data['data']);
      }
      
      throw Exception('Erro ao atualizar transação');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==============================================================
  // 🗑️ DELETA UMA TRANSAÇÃO
  // ==============================================================
  Future<void> deleteTransaction(String id) async {
    try {
      await dio.delete('$_endpoint/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==============================================================
  // 💰 OBTÉM RESUMO FINANCEIRO
  // ==============================================================
  Future<Map<String, dynamic>> getFinancialSummary({
    String? startDate,
    String? endDate,
    String? month,
  }) async {
    try {
      final query = {
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
        if (month != null) 'month': month,
      };

      print('📤 Buscando resumo com filtros: $query');

      final response = await dio.get(
        '$_endpoint/summary',
        queryParameters: query,
      );

      print('✅ Resumo recebido: ${response.data}');
      
      // CORREÇÃO: Backend retorna dentro de 'data'
      if (response.data['success'] == true && response.data['data'] != null) {
        return response.data['data'] as Map<String, dynamic>;
      }
      
      throw Exception('Erro ao buscar resumo');
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
      
      // Tenta extrair mensagem do formato ApiResponse ou ProblemDetails
      String message = 'Erro desconhecido';
      
      if (data is Map) {
        message = data['message'] ?? 
                  data['error']?['message'] ?? 
                  data['detail'] ?? 
                  data['title'] ?? 
                  'Erro desconhecido';
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