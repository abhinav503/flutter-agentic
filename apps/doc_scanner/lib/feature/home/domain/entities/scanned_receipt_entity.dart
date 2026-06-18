import 'package:doc_scanner/enums/extraction_status.dart';

class ScannedReceiptEntity {
  final String id;
  final String imagePath;
  final String? restaurantName;
  final String? date;
  final double? amount;
  final String? currency;
  final ExtractionStatus status;
  final String? errorMessage;

  const ScannedReceiptEntity({
    required this.id,
    required this.imagePath,
    required this.status,
    this.restaurantName,
    this.date,
    this.amount,
    this.currency,
    this.errorMessage,
  });

  ScannedReceiptEntity copyWith({
    String? imagePath,
    String? restaurantName,
    String? date,
    double? amount,
    String? currency,
    ExtractionStatus? status,
    String? errorMessage,
  }) =>
      ScannedReceiptEntity(
        id: id,
        imagePath: imagePath ?? this.imagePath,
        restaurantName: restaurantName ?? this.restaurantName,
        date: date ?? this.date,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  String get formattedAmount {
    if (amount == null) return '—';
    final sym = currency ?? '';
    return '$sym${amount!.toStringAsFixed(2)}';
  }
}
