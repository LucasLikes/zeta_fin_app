import 'package:flutter/material.dart';
import 'package:zeta_fin_app/core/services/transaction_service.dart' hide Transaction;
import 'package:zeta_fin_app/features/expenses/models/transaction_model.dart';
import 'dart:typed_data';

class TransactionController extends ChangeNotifier {
  final TransactionService _transactionService;

  TransactionController({required TransactionService transactionService})
      : _transactionService = transactionService;

  // Estado
  bool _isLoading = false;
  List<Transaction> _transactions = [];
  Map<String, dynamic>? _summary;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  List<Transaction> get transactions => _transactions;
  Map<String, dynamic>? get summary => _summary;
  String? get errorMessage => _errorMessage;

  // Transações por tipo
  List<Transaction> get incomes =>
      _transactions.where((t) => t.isIncome).toList();
  List<Transaction> get expenses =>
      _transactions.where((t) => t.isExpense).toList();

  // Transações por tipo de despesa
  List<Transaction> get fixedExpenses =>
      _transactions.where((t) => t.expenseType == 'fixas').toList();
  List<Transaction> get variableExpenses =>
      _transactions.where((t) => t.expenseType == 'variaveis').toList();
  List<Transaction> get unnecessaryExpenses =>
      _transactions.where((t) => t.expenseType == 'desnecessarios').toList();

  // ==================== MÉTODOS ====================

  /// Carrega todas as transações
  Future<void> loadTransactions({
    String? type,
    String? startDate,
    String? endDate,
    String? category,
    String? expenseType,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await _transactionService.getTransactions(
        type: type,
        startDate: startDate,
        endDate: endDate,
        category: category,
        expenseType: expenseType,
        limit: 100,
      );

      _transactions = (response['data']['transactions'] as List)
          .map((json) => Transaction.fromJson(json))
          .toList();

      _setLoading(false);
    } catch (e) {
      _errorMessage = 'Erro ao carregar transações: $e';
      _setLoading(false);
      rethrow;
    }
  }

  /// Carrega resumo financeiro
  Future<void> loadSummary({String? month}) async {
    try {
      final response = await _transactionService.getFinancialSummary(
        month: month,
      );

      _summary = response['data'];
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erro ao carregar resumo: $e';
      rethrow;
    }
  }

  /// Carrega transações e resumo juntos
  Future<void> loadAll({String? month}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final now = DateTime.now();
      final monthStr = month ??
          '${now.year}-${now.month.toString().padLeft(2, '0')}';

      await Future.wait([
        loadTransactions(
          startDate: '$monthStr-01',
          endDate: DateTime(now.year, now.month + 1, 0)
              .toString()
              .split(' ')[0],
        ),
        loadSummary(month: monthStr),
      ]);

      _setLoading(false);
    } catch (e) {
      _errorMessage = 'Erro ao carregar dados: $e';
      _setLoading(false);
      rethrow;
    }
  }

  /// Cria uma nova transação
  Future<Transaction> createTransaction({
    required String type,
    required double value,
    required String description,
    required String category,
    required String date,
    String? expenseType,
    bool hasReceipt = false,
  }) async {
    try {
      final response = await _transactionService.createTransaction(
        type: type,
        value: value,
        description: description,
        category: category,
        date: date,
        expenseType: expenseType,
        hasReceipt: hasReceipt,
      );

      final transaction = Transaction.fromJson(response['data']);
      
      // Adiciona à lista local
      _transactions.insert(0, transaction);
      notifyListeners();

      // Recarrega o resumo
      await loadSummary();

      return transaction;
    } catch (e) {
      _errorMessage = 'Erro ao criar transação: $e';
      rethrow;
    }
  }

  /// Cria transação com upload de recibo
  Future<Transaction> createTransactionWithReceipt({
    required Uint8List fileBytes,
    required String fileName,
    required String category,
    required String expenseType,
    String? description,
  }) async {
    try {
      final response =
          await _transactionService.uploadReceiptAndCreateTransaction(
        fileBytes: fileBytes,
        fileName: fileName,
        category: category,
        expenseType: expenseType,
        description: description,
      );

      final transaction = Transaction.fromJson(
        response['data']['transaction'],
      );

      // Adiciona à lista local
      _transactions.insert(0, transaction);
      notifyListeners();

      // Recarrega o resumo
      await loadSummary();

      return transaction;
    } catch (e) {
      _errorMessage = 'Erro ao criar transação com recibo: $e';
      rethrow;
    }
  }

  /// Atualiza uma transação
  Future<Transaction> updateTransaction({
    required String id,
    double? value,
    String? description,
    String? category,
    String? date,
    String? expenseType,
  }) async {
    try {
      final response = await _transactionService.updateTransaction(
        id: id,
        value: value,
        description: description,
        category: category,
        date: date,
        expenseType: expenseType,
      );

      final updatedTransaction = Transaction.fromJson(response['data']);

      // Atualiza na lista local
      final index = _transactions.indexWhere((t) => t.id == id);
      if (index != -1) {
        _transactions[index] = updatedTransaction;
        notifyListeners();
      }

      // Recarrega o resumo
      await loadSummary();

      return updatedTransaction;
    } catch (e) {
      _errorMessage = 'Erro ao atualizar transação: $e';
      rethrow;
    }
  }

  /// Deleta uma transação
  Future<void> deleteTransaction(String id) async {
    try {
      await _transactionService.deleteTransaction(id);

      // Remove da lista local
      _transactions.removeWhere((t) => t.id == id);
      notifyListeners();

      // Recarrega o resumo
      await loadSummary();
    } catch (e) {
      _errorMessage = 'Erro ao deletar transação: $e';
      rethrow;
    }
  }

  /// Filtra transações localmente
  List<Transaction> filterTransactions({
    String? type,
    String? category,
    String? expenseType,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _transactions.where((transaction) {
      if (type != null && transaction.type != type) return false;
      if (category != null && transaction.category != category) return false;
      if (expenseType != null && transaction.expenseType != expenseType) {
        return false;
      }
      if (startDate != null && transaction.date.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && transaction.date.isAfter(endDate)) {
        return false;
      }
      return true;
    }).toList();
  }

  /// Obtém total de receitas
  double get totalIncome {
    return incomes.fold(0, (sum, transaction) => sum + transaction.value);
  }

  /// Obtém total de despesas
  double get totalExpense {
    return expenses.fold(0, (sum, transaction) => sum + transaction.value);
  }

  /// Obtém saldo
  double get balance => totalIncome - totalExpense;

  /// Limpa o erro
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Atualiza estado de loading
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Limpa todos os dados
  void clear() {
    _transactions = [];
    _summary = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}