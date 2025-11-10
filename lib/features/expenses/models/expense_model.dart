class Expense {
  final String id;
  final String userId;
  final String name;
  final double value;
  final String category;
  final DateTime date;
  final DateTime? dueDate;

  Expense({
    required this.id,
    required this.userId,
    required this.name,
    required this.value,
    required this.category,
    required this.date,
    this.dueDate,
  });

  // ===== GETTERS AUXILIARES =====
  bool get isOverdue {
    if (dueDate == null) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  int get daysUntilDue {
    if (dueDate == null) return 0;
    return dueDate!.difference(DateTime.now()).inDays;
  }

  String get statusLabel {
    if (dueDate == null) return 'Sem vencimento';
    if (isOverdue) return 'Vencida';
    if (daysUntilDue == 0) return 'Vence hoje';
    if (daysUntilDue <= 3) return 'Vence em breve';
    return 'Em dia';
  }

  // ===== FACTORY =====
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      date: json['date'] != null 
          ? DateTime.parse(json['date']) 
          : DateTime.now(),
      dueDate: json['dueDate'] != null 
          ? DateTime.parse(json['dueDate']) 
          : null,
    );
  }

  // ===== SERIALIZAÇÃO =====
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'value': value,
      'category': category,
      'date': date.toIso8601String(),
      if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
    };
  }

  // ===== COPY =====
  Expense copyWith({
    String? id,
    String? userId,
    String? name,
    double? value,
    String? category,
    DateTime? date,
    DateTime? dueDate,
  }) {
    return Expense(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      value: value ?? this.value,
      category: category ?? this.category,
      date: date ?? this.date,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  String toString() => 'Expense($id - $name: R\$ $value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Expense &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}