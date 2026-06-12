import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/extraction_status.dart';
import '../../domain/entities/scanned_receipt_entity.dart';

part 'scanned_receipt_model.freezed.dart';
part 'scanned_receipt_model.g.dart';

@freezed
abstract class ScannedReceiptModel with _$ScannedReceiptModel {
  const ScannedReceiptModel._();

  const factory ScannedReceiptModel({
    required String id,
    required String imagePath,
    String? restaurantName,
    String? date,
    double? amount,
    String? currency,
    @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
    required ExtractionStatus status,
    String? errorMessage,
  }) = _ScannedReceiptModel;

  factory ScannedReceiptModel.fromJson(Map<String, dynamic> json) =>
      _$ScannedReceiptModelFromJson(json);

  factory ScannedReceiptModel.fromEntity(ScannedReceiptEntity e) =>
      ScannedReceiptModel(
        id: e.id,
        imagePath: e.imagePath,
        restaurantName: e.restaurantName,
        date: e.date,
        amount: e.amount,
        currency: e.currency,
        status: e.status,
        errorMessage: e.errorMessage,
      );

  ScannedReceiptEntity toEntity() => ScannedReceiptEntity(
        id: id,
        imagePath: imagePath,
        restaurantName: restaurantName,
        date: date,
        amount: amount,
        currency: currency,
        status: status,
        errorMessage: errorMessage,
      );
}

ExtractionStatus _statusFromJson(dynamic s) => ExtractionStatus.values
    .firstWhere((e) => e.name == s, orElse: () => ExtractionStatus.pending);

String _statusToJson(ExtractionStatus s) => s.name;
