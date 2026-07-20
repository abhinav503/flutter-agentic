import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:gravia/enums/recent_search_type.dart';

import '../../domain/entities/recent_search_entity.dart';

part 'recent_search_model.freezed.dart';
part 'recent_search_model.g.dart';

@freezed
abstract class RecentSearchModel with _$RecentSearchModel {
  const RecentSearchModel._();

  const factory RecentSearchModel({
    required String id,
    required String name,
    // Raw wire string ('product' / 'category') — parsed to RecentSearchType
    // only in toEntity(), per the data-layer-parses-wire-strings convention.
    required String type,
  }) = _RecentSearchModel;

  factory RecentSearchModel.fromJson(Map<String, dynamic> json) =>
      _$RecentSearchModelFromJson(json);

  factory RecentSearchModel.fromEntity(RecentSearchEntity e) =>
      RecentSearchModel(id: e.id, name: e.name, type: e.type.wireValue);

  RecentSearchEntity toEntity() => RecentSearchEntity(
    id: id,
    name: name,
    type: type.toRecentSearchType(),
  );
}
