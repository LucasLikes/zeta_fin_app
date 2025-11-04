import 'ocr_data_model.dart';

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
      id: json['id'] as String,
      transactionId: json['transactionId'] as String?,
      fileName: json['fileName'] as String,
      fileUrl: json['fileUrl'] as String,
      fileSize: json['fileSize'] as int,
      mimeType: json['mimeType'] as String,
      ocrProcessed: json['ocrProcessed'] as bool,
      ocrData: json['ocrData'] != null
          ? OcrData.fromJson(json['ocrData'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionId': transactionId,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'fileSize': fileSize,
      'mimeType': mimeType,
      'ocrProcessed': ocrProcessed,
      'ocrData': ocrData?.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Receipt copyWith({
    String? id,
    String? transactionId,
    String? fileName,
    String? fileUrl,
    int? fileSize,
    String? mimeType,
    bool? ocrProcessed,
    OcrData? ocrData,
    DateTime? createdAt,
  }) {
    return Receipt(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      ocrProcessed: ocrProcessed ?? this.ocrProcessed,
      ocrData: ocrData ?? this.ocrData,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}