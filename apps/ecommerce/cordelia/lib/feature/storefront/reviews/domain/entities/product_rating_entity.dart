/// A product's rolled-up rating: the average, how many reviews produced it,
/// and the per-star histogram. Comes off the product doc's denormalized
/// aggregates, so a grid can print a rating without loading any reviews.
class ProductRatingEntity {
  final double average;
  final int count;

  /// Per-star counts in fixed 1★→5★ order, so index `star - 1` is that
  /// star's tally. A plain average can't draw the five-bar histogram a
  /// reviews summary shows, which is why the buckets travel too.
  final List<int> buckets;

  const ProductRatingEntity({
    required this.average,
    required this.count,
    required this.buckets,
  });

  /// A product nobody has reviewed. Screens branch on [count] being zero and
  /// render an empty state — never 0.0 stars, which reads as a bad product
  /// rather than an unrated one.
  static const empty = ProductRatingEntity(
    average: 0,
    count: 0,
    buckets: [0, 0, 0, 0, 0],
  );
}

extension ProductRatingEntityX on ProductRatingEntity {
  bool get hasReviews => count > 0;

  int starCount(int star) =>
      star >= 1 && star <= buckets.length ? buckets[star - 1] : 0;

  /// That star's share of all reviews, 0–1 — what a histogram bar fills to.
  /// Relative to the total (not to the tallest bar) so the bars read as
  /// proportions of the reviews, which is what the number beside them means.
  double starShare(int star) => count <= 0 ? 0 : starCount(star) / count;
}
