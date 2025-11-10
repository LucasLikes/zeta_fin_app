
class Transaction {
  final String id;
  final String userId;
  final String type; // 'income' ou 'expense'
  final double value;
  final String description;
  final String category;
  final String? expenseType; // 'fixed', 'variable', 'unnecessary'
  final DateTime date;
  final bool hasReceipt;
  final String? receiptUrl;
  final String? receiptOcrData;
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
    this.hasReceipt = false,
    this.receiptUrl,
    this.receiptOcrData,
    required this.createdAt,
    required this.updatedAt,
  });

  // ===== GETTERS AUXILIARES =====
  bool get isIncome => type.toLowerCase() == 'income';
  bool get isExpense => type.toLowerCase() == 'expense';

  bool get isFixedExpense => expenseType?.toLowerCase() == 'fixed';
  bool get isVariableExpense => expenseType?.toLowerCase() == 'variable';
  bool get isUnnecessaryExpense => expenseType?.toLowerCase() == 'unnecessary';

  // ===== FACTORY =====
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      type: json['type'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      expenseType: json['expenseType'],
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      hasReceipt: json['hasReceipt'] ?? false,
      receiptUrl: json['receiptUrl'],
      receiptOcrData: json['receiptOcrData'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  // ===== SERIALIZAÇÃO =====
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'value': value,
      'description': description,
      'category': category,
      'expenseType': expenseType,
      'date': date.toIso8601String(),
      'hasReceipt': hasReceipt,
      'receiptUrl': receiptUrl,
      'receiptOcrData': receiptOcrData,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // ===== COPY =====
  Transaction copyWith({
    String? id,
    String? userId,
    String? type,
    double? value,
    String? description,
    String? category,
    String? expenseType,
    DateTime? date,
    bool? hasReceipt,
    String? receiptUrl,
    String? receiptOcrData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      value: value ?? this.value,
      description: description ?? this.description,
      category: category ?? this.category,
      expenseType: expenseType ?? this.expenseType,
      date: date ?? this.date,
      hasReceipt: hasReceipt ?? this.hasReceipt,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      receiptOcrData: receiptOcrData ?? this.receiptOcrData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Transaction($id - $description: $value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transaction &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
