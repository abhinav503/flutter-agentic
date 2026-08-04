// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => _ReviewModel(
  uid: json['uid'] as String,
  productId: json['product_id'] as String,
  rating: (json['rating'] as num).toInt(),
  text: json['text'] as String,
  userName: json['user_name'] as String,
  userAvatarUrl: json['user_avatar_url'] as String? ?? '',
  verifiedPurchase: json['verified_purchase'] as bool? ?? false,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$ReviewModelToJson(_ReviewModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'product_id': instance.productId,
      'rating': instance.rating,
      'text': instance.text,
      'user_name': instance.userName,
      'user_avatar_url': instance.userAvatarUrl,
      'verified_purchase': instance.verifiedPurchase,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
