// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scanned_receipt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScannedReceiptModel _$ScannedReceiptModelFromJson(Map<String, dynamic> json) =>
    _ScannedReceiptModel(
      id: json['id'] as String,
      imagePath: json['imagePath'] as String,
      restaurantName: json['restaurantName'] as String?,
      date: json['date'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      status: _statusFromJson(json['status']),
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$ScannedReceiptModelToJson(
  _ScannedReceiptModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'imagePath': instance.imagePath,
  'restaurantName': instance.restaurantName,
  'date': instance.date,
  'amount': instance.amount,
  'currency': instance.currency,
  'status': _statusToJson(instance.status),
  'errorMessage': instance.errorMessage,
};
