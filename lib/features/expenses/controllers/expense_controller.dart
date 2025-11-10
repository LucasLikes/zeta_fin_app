import 'package:flutter/material.dart';
import 'package:zeta_fin_app/features/expenses/models/expense_model.dart';
import 'package:zeta_fin_app/features/expenses/services/expense_service.dart';

class ExpenseController extends ChangeNotifier {
  final ExpenseService _expenseService;

  ExpenseController({required ExpenseService expenseService})
      : _expenseService = expenseService;

  // Estado
  bool _isLoading = false;
  List<Expense> _expenses = [];
  Map<String, double>? _summary;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  List<Expense> get expenses => _expenses;
  Map<String, double>? get summary => _summary;
  String? get errorMessage => _errorMessage;

  // Despesas filtradas
  List<Expense> get overdueExpenses =>
      _expenses.where((e) => e.isOverdue).toList();
  
  List<Expense> get upcomingExpenses =>
      _expenses.where((e) => !e.isOverdue && e.dueDate != null && e.daysUntilDue <= 7).toList();

  // Totais
  double get totalExpenses => _expenses.fold(0, (sum, e) => sum + e.value);
  
  double get totalOverdue => overdueExpenses.fold(0, (sum, e) => sum + e.value);
  
  double get totalUpcoming => upcomingExpenses.fold(0, (sum, e) => sum + e.value);

  // ==============================================================
  // 📋 Carrega todas as despesas de um usuário
  // ==============================================================
  Future<void> loadExpenses(String userId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _expenses = await _expenseService.getExpensesByUser(userId);
      _setLoading(false);
    } catch (e) {
      _errorMessage = 'Erro ao carregar despesas: $e';
      _setLoading(false);
    }
  }

  // ==============================================================
  // 💰 Carrega resumo por categoria
  // ==============================================================
  Future<void> loadSummary(String userId) async {
    try {
      _summary = await _expenseService.getSummaryByCategory(userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erro ao carregar resumo: $e';
      notifyListeners();
    }
  }

  // ==============================================================
  // 🔄 Carrega tudo
  // ==============================================================
  Future<void> loadAll(String userId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await Future.wait([
        loadExpenses(userId),
        loadSummary(userId),
      ]);
      _setLoading(false);
    } catch (e) {
      _errorMessage = 'Erro ao carregar dados: $e';
      _setLoading(false);
    }
  }

  // ==============================================================
  // ➕ Cria uma nova despesa
  // ==============================================================
  Future<Expense?> createExpense({
    required String userId,
    required String name,
    required double value,
    required String category,
    DateTime? dueDate,
  }) async {
    try {
      final expense = await _expenseService.createExpense(
        userId: userId,
        name: name,
        value: value,
        category: category,
        dueDate: dueDate,
      );

      _expenses.insert(0, expense);
      notifyListeners();

      await loadSummary(userId);
      return expense;
    } catch (e) {
      _errorMessage = 'Erro ao criar despesa: $e';
      notifyListeners();
      return null;
    }
  }

  // ==============================================================
  // ✏️ Atualiza uma despesa
  // ==============================================================
  Future<Expense?> updateExpense({
    required String id,
    required String userId,
    String? name,
    double? value,
    String? category,
    DateTime? dueDate,
  }) async {
    try {
      final updated = await _expenseService.updateExpense(
        id: id,
        name: name,
        value: value,
        category: category,
        dueDate: dueDate,
      );

      final index = _expenses.indexWhere((e) => e.id == id);
      if (index != -1) {
        _expenses[index] = updated;
        notifyListeners();
      }

      await loadSummary(userId);
      return updated;
    } catch (e) {
      _errorMessage = 'Erro ao atualizar despesa: $e';
      notifyListeners();
      return null;
    }
  }

  // ==============================================================
  // 🗑️ Deleta uma despesa
  // ==============================================================
  Future<void> deleteExpense(String id, String userId) async {
    try {
      await _expenseService.deleteExpense(id);
      _expenses.removeWhere((e) => e.id == id);
      notifyListeners();
      await loadSummary(userId);
    } catch (e) {
      _errorMessage = 'Erro ao deletar despesa: $e';
      notifyListeners();
    }
  }

  // ==============================================================
  // 📊 Filtros locais
  // ==============================================================
  List<Expense> filterByCategory(String category) {
    return _expenses.where((e) => e.category == category).toList();
  }

  List<Expense> filterByDateRange(DateTime start, DateTime end) {
    return _expenses.where((e) {
      return e.date.isAfter(start) && e.date.isBefore(end);
    }).toList();
  }

  List<Expense> searchByName(String query) {
    final lowerQuery = query.toLowerCase();
    return _expenses.where((e) {
      return e.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // ==============================================================
  // 📈 Estatísticas
  // ==============================================================
  Map<String, double> getExpensesByCategory() {
    final Map<String, double> categoryTotals = {};
    
    for (var expense in _expenses) {
      categoryTotals[expense.category] = 
          (categoryTotals[expense.category] ?? 0) + expense.value;
    }
    
    return categoryTotals;
  }

  Expense? getMostExpensiveExpense() {
    if (_expenses.isEmpty) return null;
    return _expenses.reduce((a, b) => a.value > b.value ? a : b);
  }

  double getAverageExpenseValue() {
    if (_expenses.isEmpty) return 0;
    return totalExpenses / _expenses.length;
  }

  // ==============================================================
  // 🔧 Utilidades
  // ==============================================================
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clear() {
    _expenses = [];
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