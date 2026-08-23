import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/app_update_requirement_entity.dart';

part 'app_config_model.freezed.dart';
part 'app_config_model.g.dart';

/// GET /api/app-config — per-platform maps; the repository picks this
/// platform's pair when turning it into the entity.
@freezed
abstract class AppConfigModel with _$AppConfigModel {
  const AppConfigModel._();

  const factory AppConfigModel({
    @JsonKey(name: 'min_version')
    @Default(<String, String>{})
    Map<String, String> minVersion,
    @JsonKey(name: 'update_url')
    @Default(<String, String>{})
    Map<String, String> updateUrl,
  }) = _AppConfigModel;

  factory AppConfigModel.fromJson(Map<String, dynamic> json) =>
      _$AppConfigModelFromJson(json);

  factory AppConfigModel.fromEntity(
    AppUpdateRequirementEntity e, {
    required String platform,
  }) => AppConfigModel(
    minVersion: {platform: e.minVersion},
    updateUrl: {platform: e.updateUrl},
  );

  AppUpdateRequirementEntity toEntity({required String platform}) =>
      AppUpdateRequirementEntity(
        minVersion: minVersion[platform] ?? '',
        updateUrl: updateUrl[platform] ?? '',
      );
}
