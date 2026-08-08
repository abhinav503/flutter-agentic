import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/pincode_info_entity.dart';

part 'pincode_info_model.freezed.dart';
part 'pincode_info_model.g.dart';

@freezed
abstract class PincodeInfoModel with _$PincodeInfoModel {
  const PincodeInfoModel._();

  const factory PincodeInfoModel({
    @Default('') String city,
    @Default('') String state,
    @Default('') String country,
  }) = _PincodeInfoModel;

  factory PincodeInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PincodeInfoModelFromJson(json);

  factory PincodeInfoModel.fromEntity(PincodeInfoEntity e) =>
      PincodeInfoModel(city: e.city, state: e.state, country: e.country);

  PincodeInfoEntity toEntity() =>
      PincodeInfoEntity(city: city, state: state, country: country);
}
