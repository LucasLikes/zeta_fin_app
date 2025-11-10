import 'package:flutter/material.dart';
import 'package:zeta_fin_app/core/services/transaction_service.dart';
import 'package:zeta_fin_app/features/expenses/models/transaction_model.dart';

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
      _transactions.where((t) => t.type == 'income').toList();
  List<Transaction> get expenses =>
      _transactions.where((t) => t.type == 'expense').toList();

  List<Transaction> get fixedExpenses =>
      _transactions.where((t) => t.expenseType == 'fixas').toList();
  List<Transaction> get variableExpenses =>
      _transactions.where((t) => t.expenseType == 'variaveis').toList();
  List<Transaction> get unnecessaryExpenses =>
      _transactions.where((t) => t.expenseType == 'desnecessarios').toList();

  // ==============================================================
  // 📋 Carrega todas as transações
  // ==============================================================
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
      final transactions = await _transactionService.getTransactions(
        type: type,
        startDate: startDate,
        endDate: endDate,
        category: category,
        expenseType: expenseType,
        limit: 100,
      );

      _transactions = transactions;
      _setLoading(false);
    } catch (e) {
      _errorMessage = 'Erro ao carregar transações: $e';
      _setLoading(false);
    }
  }

  // ==============================================================
  // 💰 Carrega resumo financeiro
  // ==============================================================
  Future<void> loadSummary({String? month}) async {
    try {
      final summary = await _transactionService.getFinancialSummary(month: month);
      _summary = summary;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erro ao carregar resumo: $e';
      notifyListeners();
    }
  }

  // ==============================================================
  // 🔄 Carrega tudo
  // ==============================================================
  Future<void> loadAll({String? month}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final now = DateTime.now();
      final monthStr = month ?? '${now.year}-${now.month.toString().padLeft(2, '0')}';

      await Future.wait([
        loadTransactions(
          startDate: '$monthStr-01',
          endDate: DateTime(now.year, now.month + 1, 0).toIso8601String(),
        ),
        loadSummary(month: monthStr),
      ]);

      _setLoading(false);
    } catch (e) {
      _errorMessage = 'Erro ao carregar dados: $e';
      _setLoading(false);
    }
  }

  // ==============================================================
  // ➕ Cria uma nova transação
  // ==============================================================
  Future<Transaction?> createTransaction({
    required String type,
    required double value,
    required String description,
    required String category,
    required DateTime date,
    String? expenseType,
    bool hasReceipt = false,
  }) async {
    try {
      final transaction = await _transactionService.createTransaction(
        type: type,
        value: value,
        description: description,
        category: category,
        date: date,
        expenseType: expenseType,
        hasReceipt: hasReceipt,
      );

      _transactions.insert(0, transaction);
      notifyListeners();

      await loadSummary();
      return transaction;
    } catch (e) {
      _errorMessage = 'Erro ao criar transação: $e';
      notifyListeners();
      return null;
    }
  }

  // ==============================================================
  // ✏️ Atualiza uma transação
  // ==============================================================
  Future<Transaction?> updateTransaction({
    required String id,
    double? value,
    String? description,
    String? category,
    DateTime? date,
  }) async {
    try {
      final updated = await _transactionService.updateTransaction(
        id: id,
        value: value,
        description: description,
        category: category,
        date: date,
      );

      final index = _transactions.indexWhere((t) => t.id == id);
      if (index != -1) {
        _transactions[index] = updated;
        notifyListeners();
      }

      await loadSummary();
      return updated;
    } catch (e) {
      _errorMessage = 'Erro ao atualizar transação: $e';
      notifyListeners();
      return null;
    }
  }

  // ==============================================================
  // 🗑️ Deleta uma transação
  // ==============================================================
  Future<void> deleteTransaction(String id) async {
    try {
      await _transactionService.deleteTransaction(id);
      _transactions.removeWhere((t) => t.id == id);
      notifyListeners();
      await loadSummary();
    } catch (e) {
      _errorMessage = 'Erro ao deletar transação: $e';
      notifyListeners();
    }
  }

  // ==============================================================
  // 📊 Filtros locais
  // ==============================================================
  List<Transaction> filterTransactions({
    String? type,
    String? category,
    String? expenseType,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _transactions.where((t) {
      if (type != null && t.type != type) return false;
      if (category != null && t.category != category) return false;
      if (expenseType != null && t.expenseType != expenseType) return false;
      if (startDate != null && t.date.isBefore(startDate)) return false;
      if (endDate != null && t.date.isAfter(endDate)) return false;
      return true;
    }).toList();
  }

  // ==============================================================
  // 💵 Totais
  // ==============================================================
  double get totalIncome => incomes.fold(0, (s, t) => s + t.value);
  double get totalExpense => expenses.fold(0, (s, t) => s + t.value);
  double get balance => totalIncome - totalExpense;

  // ==============================================================
  // 🔧 Utilidades
  // ==============================================================
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clear() {
    _transactions = [];
    _summary = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
