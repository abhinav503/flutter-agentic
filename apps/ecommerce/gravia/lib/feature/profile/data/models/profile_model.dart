import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/profile_entity.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
abstract class ProfileModel with _$ProfileModel {
  const ProfileModel._();

  const factory ProfileModel({
    required String name,
    required String email,
    // The admin API's users record calls this `mobile`; kept as `phone`
    // here since that's ProfileEntity's existing field name — no reason to
    // rename the domain concept just because the wire key differs.
    @JsonKey(name: 'mobile') required String phone,
    // The admin API doesn't return an avatar (no upload backend yet) —
    // defaults to '' so AppNetworkImage's assetPlaceholder fallback kicks in.
    @JsonKey(name: 'avatar_url', defaultValue: '') required String avatarUrl,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  factory ProfileModel.fromEntity(ProfileEntity e) => ProfileModel(
    name: e.name,
    email: e.email,
    phone: e.phone,
    avatarUrl: e.avatarUrl,
    // avatarBytes never round-trips through the data layer — see its doc.
  );

  ProfileEntity toEntity() => ProfileEntity(
    name: name,
    email: email,
    phone: phone,
    avatarUrl: avatarUrl,
  );
}
