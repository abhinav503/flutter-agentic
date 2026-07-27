// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryDetailsModel _$CategoryDetailsModelFromJson(
  Map<String, dynamic> json,
) => _CategoryDetailsModel(
  products: (json['products'] as List<dynamic>)
      .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CategoryDetailsModelToJson(
  _CategoryDetailsModel instance,
) => <String, dynamic>{'products': instance.products};
