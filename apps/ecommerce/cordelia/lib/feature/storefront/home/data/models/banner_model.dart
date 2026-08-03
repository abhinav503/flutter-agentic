import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/extensions/string_extensions.dart';

import 'package:cordelia/enums/banner_target_type.dart';

import '../../domain/entities/banner_entity.dart';

part 'banner_model.freezed.dart';
part 'banner_model.g.dart';

@freezed
abstract class BannerModel with _$BannerModel {
  const BannerModel._();

  const factory BannerModel({
    required String id,
    required String image,
    required String title,
    @Default('') String subtitle,
    // Raw wire string ('none' / 'product' / 'category') — parsed to
    // BannerTargetType only in toEntity(), per the data-layer-parses-wire-
    // strings convention.
    @JsonKey(name: 'target_type') @Default('none') String targetType,
    @JsonKey(name: 'target_id') @Default('') String targetId,
    // Raw '#RRGGBB' from the admin's colour picker, empty when unset — parsed
    // in toEntity() for the same reason the target type is.
    @JsonKey(name: 'background_color') @Default('') String backgroundColor,
  }) = _BannerModel;

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  factory BannerModel.fromEntity(BannerEntity e) => BannerModel(
    id: e.id,
    image: e.imageUrl,
    title: e.title,
    subtitle: e.subtitle,
    targetType: e.targetType.wireValue,
    targetId: e.targetId,
    backgroundColor: e.backgroundArgb?.asHexColor ?? '',
  );

  BannerEntity toEntity() => BannerEntity(
    id: id,
    imageUrl: image,
    title: title,
    subtitle: subtitle,
    targetType: targetType.toBannerTargetType(),
    targetId: targetId,
    backgroundArgb: backgroundColor.hexColorArgb,
  );
}
