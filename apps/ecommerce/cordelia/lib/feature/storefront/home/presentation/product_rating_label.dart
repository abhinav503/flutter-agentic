import 'package:cordelia/constants/value_const.dart';

import '../domain/entities/product_entity.dart';

/// What a product's rating reads as beside its stars.
///
/// Presentation, not the entity: the entity answers *whether* a product has
/// been rated ([ProductEntity.hasRating]), and `domain` may not reach the
/// localizations to say "Not rated yet" in words. Shared because all three
/// packs print the same two answers — the average with its count, or the
/// unrated line — and each was re-deriving the choice beside its own stars.
extension ProductRatingLabelX on ProductEntity {
  String get ratingLabel => hasRating
      ? ValueConst.ratingLabel(ratingAverage, reviewCount)
      : ValueConst.unratedLabel;
}
