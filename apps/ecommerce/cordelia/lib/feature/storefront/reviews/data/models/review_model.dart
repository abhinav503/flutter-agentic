import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/review_entity.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
abstract class ReviewModel with _$ReviewModel {
  const ReviewModel._();

  const factory ReviewModel({
    required String uid,
    @JsonKey(name: 'product_id') required String productId,
    required int rating,
    required String text,
    @JsonKey(name: 'user_name') required String userName,
    @JsonKey(name: 'user_avatar_url') @Default('') String userAvatarUrl,
    @JsonKey(name: 'verified_purchase') @Default(false) bool verifiedPurchase,
    // ISO-8601 wire strings, parsed to DateTime only in toEntity() — the
    // data layer parses wire values, per the layer convention.
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  factory ReviewModel.fromEntity(ReviewEntity e) => ReviewModel(
    uid: e.uid,
    productId: e.productId,
    rating: e.rating,
    text: e.text,
    userName: e.userName,
    userAvatarUrl: e.userAvatarUrl,
    verifiedPurchase: e.verifiedPurchase,
    createdAt: e.createdAt.toIso8601String(),
    updatedAt: e.updatedAt.toIso8601String(),
  );

  ReviewEntity toEntity() => ReviewEntity(
    uid: uid,
    productId: productId,
    rating: rating,
    text: text,
    userName: userName,
    userAvatarUrl: userAvatarUrl,
    verifiedPurchase: verifiedPurchase,
    // A malformed or missing timestamp degrades to the epoch rather than
    // throwing — one bad row must not blank out a product's whole list.
    createdAt:
        DateTime.tryParse(createdAt) ?? DateTime.fromMillisecondsSinceEpoch(0),
    updatedAt:
        DateTime.tryParse(updatedAt) ??
        DateTime.tryParse(createdAt) ??
        DateTime.fromMillisecondsSinceEpoch(0),
  );
}
