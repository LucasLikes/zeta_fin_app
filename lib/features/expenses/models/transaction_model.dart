class Transaction {
  final String id;
  final String type; // 'income' ou 'expense'
  final double value;
  final String description;
  final String category;
  final DateTime date;
  final String? expenseType; // 'fixas', 'variaveis', 'desnecessarios'
  final bool hasReceipt;
  final String? receiptUrl;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.type,
    required this.value,
    required this.description,
    required this.category,
    required this.date,
    this.expenseType,
    this.hasReceipt = false,
    this.receiptUrl,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  // ===== GETTERS ADICIONAIS =====
  
  /// Verifica se é uma receita
  bool get isIncome => type == 'income';

  /// Verifica se é uma despesa
  bool get isExpense => type == 'expense';

  /// Verifica se é uma despesa fixa
  bool get isFixedExpense => expenseType == 'fixas';

  /// Verifica se é uma despesa variável
  bool get isVariableExpense => expenseType == 'variaveis';

  /// Verifica se é uma despesa desnecessária
  bool get isUnnecessaryExpense => expenseType == 'desnecessarios';

  // ===== FACTORY CONSTRUCTORS =====

  /// Cria uma transação a partir de um JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'] ?? json['id'] ?? '',
      type: json['type'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      date: json['date'] != null 
          ? DateTime.parse(json['date']) 
          : DateTime.now(),
      expenseType: json['expenseType'],
      hasReceipt: json['hasReceipt'] ?? false,
      receiptUrl: json['receiptUrl'],
      userId: json['userId'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  /// Converte a transação para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'value': value,
      'description': description,
      'category': category,
      'date': date.toIso8601String(),
      'expenseType': expenseType,
      'hasReceipt': hasReceipt,
      'receiptUrl': receiptUrl,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Cria uma cópia da transação com campos atualizados
  Transaction copyWith({
    String? id,
    String? type,
    double? value,
    String? description,
    String? category,
    DateTime? date,
    String? expenseType,
    bool? hasReceipt,
    String? receiptUrl,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      type: type ?? this.type,
      value: value ?? this.value,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      expenseType: expenseType ?? this.expenseType,
      hasReceipt: hasReceipt ?? this.hasReceipt,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Transaction(id: $id, type: $type, value: $value, description: $description, category: $category, date: $date, expenseType: $expenseType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Transaction &&
      other.id == id &&
      other.type == type &&
      other.value == value &&
      other.description == description &&
      other.category == category &&
      other.date == date &&
      other.expenseType == expenseType &&
      other.hasReceipt == hasReceipt &&
      other.receiptUrl == receiptUrl &&
      other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      type.hashCode ^
      value.hashCode ^
      description.hashCode ^
      category.hashCode ^
      date.hashCode ^
      expenseType.hashCode ^
      hasReceipt.hashCode ^
      receiptUrl.hashCode ^
      userId.hashCode;
  }
}