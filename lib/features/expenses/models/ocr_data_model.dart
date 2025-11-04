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
      extractedDate: json['extractedDate'] as String?,
      merchantName: json['merchantName'] as String?,
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => ReceiptItem.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'extractedValue': extractedValue,
      'extractedDate': extractedDate,
      'merchantName': merchantName,
      'items': items?.map((item) => item.toJson()).toList(),
      'confidence': confidence,
    };
  }

  bool get isHighConfidence => confidence >= 0.8;
  bool get isMediumConfidence => confidence >= 0.5 && confidence < 0.8;
  bool get isLowConfidence => confidence < 0.5;

  String get confidenceLabel {
    if (isHighConfidence) return 'Alta';
    if (isMediumConfidence) return 'Média';
    return 'Baixa';
  }

  OcrData copyWith({
    double? extractedValue,
    String? extractedDate,
    String? merchantName,
    List<ReceiptItem>? items,
    double? confidence,
  }) {
    return OcrData(
      extractedValue: extractedValue ?? this.extractedValue,
      extractedDate: extractedDate ?? this.extractedDate,
      merchantName: merchantName ?? this.merchantName,
      items: items ?? this.items,
      confidence: confidence ?? this.confidence,
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
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }

  ReceiptItem copyWith({
    String? name,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
  }) {
    return ReceiptItem(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}