import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/receipt_extraction_entity.dart';

part 'receipt_extraction_model.freezed.dart';
part 'receipt_extraction_model.g.dart';

@freezed
abstract class ReceiptExtractionModel with _$ReceiptExtractionModel {
  const ReceiptExtractionModel._();

  const factory ReceiptExtractionModel({
    @JsonKey(name: 'restaurant_name') String? restaurantName,
    String? date,
    @JsonKey(name: 'total_amount') num? totalAmount,
    String? currency,
  }) = _ReceiptExtractionModel;

  factory ReceiptExtractionModel.fromJson(Map<String, dynamic> json) =>
      _$ReceiptExtractionModelFromJson(json);

  factory ReceiptExtractionModel.fromEntity(ReceiptExtractionEntity e) =>
      ReceiptExtractionModel(
        restaurantName: e.restaurantName,
        date: e.date,
        totalAmount: e.amount,
        currency: e.currency,
      );

  ReceiptExtractionEntity toEntity() => ReceiptExtractionEntity(
        restaurantName: restaurantName,
        date: date,
        amount: totalAmount?.toDouble(),
        currency: currency,
      );
}
