/// One shopper's review of one product. [uid] is the review's identity (it
/// is the backing doc's id too), which is how a screen tells the signed-in
/// shopper's own review apart from everyone else's — the difference between
/// a "Write a review" and an "Edit your review" CTA.
class ReviewEntity {
  final String uid;
  final String productId;

  /// Whole stars, 1–5.
  final int rating;

  /// May be empty — a shopper can rate without writing anything.
  final String text;
  final String userName;

  /// Empty when the shopper never set a profile photo; screens fall back to
  /// a glyph rather than a broken image.
  final String userAvatarUrl;

  /// True when the reviewer has a delivered order containing this product.
  /// A badge only — anyone signed in may review.
  final bool verifiedPurchase;

  /// When the review was first posted. An edit does not move it, so a list
  /// ordered by this stays stable while shoppers fix typos.
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReviewEntity({
    required this.uid,
    required this.productId,
    required this.rating,
    required this.text,
    required this.userName,
    required this.userAvatarUrl,
    required this.verifiedPurchase,
    required this.createdAt,
    required this.updatedAt,
  });
}
