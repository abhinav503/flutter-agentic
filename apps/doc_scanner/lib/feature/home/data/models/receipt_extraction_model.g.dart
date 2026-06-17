// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_extraction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReceiptExtractionModel _$ReceiptExtractionModelFromJson(
  Map<String, dynamic> json,
) => _ReceiptExtractionModel(
  restaurantName: json['restaurant_name'] as String?,
  date: json['date'] as String?,
  totalAmount: json['total_amount'] as num?,
  currency: json['currency'] as String?,
);

Map<String, dynamic> _$ReceiptExtractionModelToJson(
  _ReceiptExtractionModel instance,
) => <String, dynamic>{
  'restaurant_name': instance.restaurantName,
  'date': instance.date,
  'total_amount': instance.totalAmount,
  'currency': instance.currency,
};
