import 'package:dio/dio.dart';
import 'dart:typed_data';

class TransactionService {
  final Dio _dio;
  static const String baseUrl = 'https://api.zetafin.com/v1';

  TransactionService({required Dio dio}) : _dio = dio;

  // ==================== TRANSAÇÕES ====================

  /// Cria uma nova transação (receita ou despesa)
  Future<Map<String, dynamic>> createTransaction({
    required String type, // 'income' ou 'expense'
    required double value,
    required String description,
    required String category,
    required String date, // formato: 'YYYY-MM-DD'
    String? expenseType, // 'fixas', 'variaveis', 'desnecessarios' (obrigatório se type='expense')
    bool hasReceipt = false,
  }) async {
    try {
      final body = {
        'type': type,
        'value': value,
        'description': description,
        'category': category,
        'date': date,
        'hasReceipt': hasReceipt,
      };

      // Adiciona expenseType apenas se for despesa
      if (type == 'expense' && expenseType != null) {
        body['expenseType'] = expenseType;
      }

      final response = await _dio.post(
        '$baseUrl/transactions',
        data: body,
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Lista transações do usuário
  Future<Map<String, dynamic>> getTransactions({
    String? type,
    String? startDate,
    String? endDate,
    String? category,
    String? expenseType,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (type != null) queryParameters['type'] = type;
      if (startDate != null) queryParameters['startDate'] = startDate;
      if (endDate != null) queryParameters['endDate'] = endDate;
      if (category != null) queryParameters['category'] = category;
      if (expenseType != null) queryParameters['expenseType'] = expenseType;

      final response = await _dio.get(
        '$baseUrl/transactions',
        queryParameters: queryParameters,
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Obtém uma transação específica por ID
  Future<Map<String, dynamic>> getTransactionById(String id) async {
    try {
      final response = await _dio.get('$baseUrl/transactions/$id');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Atualiza uma transação
  Future<Map<String, dynamic>> updateTransaction({
    required String id,
    double? value,
    String? description,
    String? category,
    String? date,
    String? expenseType,
  }) async {
    try {
      final body = <String, dynamic>{};

      if (value != null) body['value'] = value;
      if (description != null) body['description'] = description;
      if (category != null) body['category'] = category;
      if (date != null) body['date'] = date;
      if (expenseType != null) body['expenseType'] = expenseType;

      final response = await _dio.put(
        '$baseUrl/transactions/$id',
        data: body,
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Deleta uma transação
  Future<void> deleteTransaction(String id) async {
    try {
      await _dio.delete('$baseUrl/transactions/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Obtém resumo financeiro
  Future<Map<String, dynamic>> getFinancialSummary({
    String? startDate,
    String? endDate,
    String? month, // formato: 'YYYY-MM'
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (startDate != null) queryParameters['startDate'] = startDate;
      if (endDate != null) queryParameters['endDate'] = endDate;
      if (month != null) queryParameters['month'] = month;

      final response = await _dio.get(
        '$baseUrl/transactions/summary',
        queryParameters: queryParameters,
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== OCR / RECIBOS ====================

  /// Faz upload de um recibo e processa via OCR
  Future<Map<String, dynamic>> uploadReceipt({
    required Uint8List fileBytes,
    required String fileName,
    String? transactionId,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
        ),
        if (transactionId != null) 'transactionId': transactionId,
      });

      final response = await _dio.post(
        '$baseUrl/receipts/upload',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Processa OCR manualmente de um recibo
  Future<Map<String, dynamic>> processOCR(String receiptId) async {
    try {
      final response = await _dio.post(
        '$baseUrl/receipts/$receiptId/process-ocr',
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Cria transação a partir dos dados do OCR
  Future<Map<String, dynamic>> createTransactionFromReceipt({
    required String receiptId,
    String? category,
    String? expenseType,
    String? description,
  }) async {
    try {
      final body = <String, dynamic>{};

      if (category != null) body['category'] = category;
      if (expenseType != null) body['expenseType'] = expenseType;
      if (description != null) body['description'] = description;

      final response = await _dio.post(
        '$baseUrl/receipts/$receiptId/create-transaction',
        data: body,
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Upload e criação de transação em uma única operação
  Future<Map<String, dynamic>> uploadReceiptAndCreateTransaction({
    required Uint8List fileBytes,
    required String fileName,
    required String category,
    required String expenseType,
    String? description,
  }) async {
    try {
      // 1. Upload do recibo
      final uploadResult = await uploadReceipt(
        fileBytes: fileBytes,
        fileName: fileName,
      );

      final receiptId = uploadResult['data']['id'] as String;

      // 2. Criar transação a partir do recibo
      final transactionResult = await createTransactionFromReceipt(
        receiptId: receiptId,
        category: category,
        expenseType: expenseType,
        description: description,
      );

      return transactionResult;
    } catch (e) {
      rethrow;
    }
  }

  // ==================== TRATAMENTO DE ERROS ====================

  Exception _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      final errorMessage = data['error']?['message'] ?? 'Erro desconhecido';
      final errorCode = data['error']?['code'] ?? 'UNKNOWN_ERROR';

      switch (error.response!.statusCode) {
        case 400:
          return BadRequestException(errorMessage, errorCode);
        case 401:
          return UnauthorizedException(errorMessage);
        case 403:
          return ForbiddenException(errorMessage);
        case 404:
          return NotFoundException(errorMessage);
        case 422:
          return ValidationException(
            errorMessage,
            data['error']?['details'] ?? [],
          );
        case 500:
          return ServerException(errorMessage);
        default:
          return ApiException(errorMessage, errorCode);
      }
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return TimeoutException('Tempo de conexão esgotado');
    } else if (error.type == DioExceptionType.connectionError) {
      return NetworkException('Erro de conexão. Verifique sua internet.');
    } else {
      return ApiException('Erro inesperado', 'UNKNOWN_ERROR');
    }
  }
}

// ==================== EXCEÇÕES CUSTOMIZADAS ====================

class ApiException implements Exception {
  final String message;
  final String code;

  ApiException(this.message, this.code);

  @override
  String toString() => message;
}

class BadRequestException extends ApiException {
  BadRequestException(String message, String code) : super(message, code);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message)
      : super(message, 'AUTHENTICATION_ERROR');
}

class ForbiddenException extends ApiException {
  ForbiddenException(String message)
      : super(message, 'AUTHORIZATION_ERROR');
}

class NotFoundException extends ApiException {
  NotFoundException(String message)
      : super(message, 'RESOURCE_NOT_FOUND');
}

class ValidationException extends ApiException {
  final List<dynamic> details;

  ValidationException(String message, this.details)
      : super(message, 'VALIDATION_ERROR');

  String getFieldError(String fieldName) {
    final fieldError = details.firstWhere(
      (error) => error['field'] == fieldName,
      orElse: () => null,
    );
    return fieldError?['message'] ?? '';
  }
}

class ServerException extends ApiException {
  ServerException(String message) : super(message, 'SERVER_ERROR');
}

class TimeoutException extends ApiException {
  TimeoutException(String message) : super(message, 'TIMEOUT_ERROR');
}

class NetworkException extends ApiException {
  NetworkException(String message) : super(message, 'NETWORK_ERROR');
}

// ==================== MODELOS DE DADOS ====================

class Transaction {
  final String id;
  final String userId;
  final String type; // 'income' ou 'expense'
  final double value;
  final String description;
  final String category;
  final String? expenseType;
  final DateTime date;
  final bool hasReceipt;
  final String? receiptUrl;
  final Map<String, dynamic>? receiptOcrData;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.value,
    required this.description,
    required this.category,
    this.expenseType,
    required this.date,
    required this.hasReceipt,
    this.receiptUrl,
    this.receiptOcrData,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['userId'],
      type: json['type'],
      value: (json['value'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      expenseType: json['expenseType'],
      date: DateTime.parse(json['date']),
      hasReceipt: json['hasReceipt'],
      receiptUrl: json['receiptUrl'],
      receiptOcrData: json['receiptOcrData'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'value': value,
      'description': description,
      'category': category,
      'expenseType': expenseType,
      'date': date.toIso8601String().split('T')[0],
      'hasReceipt': hasReceipt,
      'receiptUrl': receiptUrl,
      'receiptOcrData': receiptOcrData,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Receipt {
  final String id;
  final String? transactionId;
  final String fileName;
  final String fileUrl;
  final int fileSize;
  final String mimeType;
  final bool ocrProcessed;
  final OcrData? ocrData;
  final DateTime createdAt;

  Receipt({
    required this.id,
    this.transactionId,
    required this.fileName,
    required this.fileUrl,
    required this.fileSize,
    required this.mimeType,
    required this.ocrProcessed,
    this.ocrData,
    required this.createdAt,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['id'],
      transactionId: json['transactionId'],
      fileName: json['fileName'],
      fileUrl: json['fileUrl'],
      fileSize: json['fileSize'],
      mimeType: json['mimeType'],
      ocrProcessed: json['ocrProcessed'],
      ocrData: json['ocrData'] != null
          ? OcrData.fromJson(json['ocrData'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class OcrData {
  final double? extractedValue;
  final String? extractedDate;
  final String? merchantName;
  final List<ReceiptItem>? items;
  final double confidence;

  OcrData({
    this.extractedValue,
    this.extractedDate,
    this.merchantName,
    this.items,
    required this.confidence,
  });

  factory OcrData.fromJson(Map<String, dynamic> json) {
    return OcrData(
      extractedValue: json['extractedValue']?.toDouble(),
      extractedDate: json['extractedDate'],
      merchantName: json['merchantName'],
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => ReceiptItem.fromJson(item))
              .toList()
          : null,
      confidence: (json['confidence'] as num).toDouble(),
    );
  }
}

class ReceiptItem {
  final String name;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  ReceiptItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory ReceiptItem.fromJson(Map<String, dynamic> json) {
    return ReceiptItem(
      name: json['name'],
      quantity: json['quantity'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }
}