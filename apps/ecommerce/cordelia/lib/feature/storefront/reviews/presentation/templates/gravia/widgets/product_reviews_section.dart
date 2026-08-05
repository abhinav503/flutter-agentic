import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/rating_stars.dart';
import 'package:core/core/ui/molecules/empty_state.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_action_pair.dart';

import '../../../../domain/entities/product_rating_entity.dart';
import '../../../../domain/entities/product_reviews_entity.dart';
import '../../../../domain/entities/review_entity.dart';
import '../../../reviewer_avatar.dart';

/// Gravia's Ratings & Reviews block on Product Details — the same
/// heading/divider rhythm as the Key Info and Similar Products sections
/// above and below it.
///
/// The Gravia kit predates reviews and draws no frame for them (recorded as
/// a deviation in the spec sheet), so this is composed entirely from recipes
/// the pack already owns: the section heading's textLgBold, the hairline
/// divider between rows, and a [GraviaActionButton] for the CTA.
class GraviaProductReviewsSection extends StatelessWidget {
  final ProductReviewsEntity reviews;

  /// Null while a write is in flight — the CTA stops taking taps rather than
  /// letting a second submit stack on the first.
  final VoidCallback? onWriteReview;
  final VoidCallback? onDeleteReview;

  /// The signed-in shopper, so their own review offers edit/delete.
  final String? currentUid;

  const GraviaProductReviewsSection({
    super.key,
    required this.reviews,
    required this.onWriteReview,
    required this.onDeleteReview,
    required this.currentUid,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final hairline = context.appColors.dockedHairline;
    final mine = reviews.mine(currentUid);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ValueConst.reviewsSectionTitle,
          style: GraviaTextStyleConst.textLgBold(
            tt,
          ).copyWith(color: cs.onSurface),
        ),
        const SizedBox(height: AppSpacing.base),
        if (reviews.rating.hasReviews)
          _Summary(rating: reviews.rating)
        else
          EmptyState(
            iconData: Icons.reviews_outlined,
            title: ValueConst.reviewsEmptyTitle,
            subtitle: ValueConst.reviewsEmptySubtitle,
          ),
        const SizedBox(height: AppSpacing.lg),
        GraviaActionButton(
          action: GraviaAction(
            label: mine == null
                ? ValueConst.writeReviewLabel
                : ValueConst.editReviewLabel,
            kind: GraviaActionKind.secondary,
            onTap: onWriteReview,
          ),
        ),
        for (final review in reviews.reviews) ...[
          const SizedBox(height: AppSpacing.lg),
          Divider(color: hairline, height: 1, thickness: 1),
          const SizedBox(height: AppSpacing.lg),
          _ReviewRow(
            review: review,
            // Only the shopper's own row carries a delete — everyone else's
            // is moderated from the admin console, not from here.
            onDelete: review.uid == currentUid ? onDeleteReview : null,
          ),
        ],
      ],
    );
  }
}

/// The average, big, beside the per-star histogram — the shape a shopper
/// scans before reading a single review.
class _Summary extends StatelessWidget {
  final ProductRatingEntity rating;

  const _Summary({required this.rating});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rating.average.toStringAsFixed(1),
              style: GraviaTextStyleConst.displayXsBold(
                tt,
              ).copyWith(color: cs.onSurface),
            ),
            const SizedBox(height: AppSpacing.xs2),
            RatingStars(rating: rating.average),
            const SizedBox(height: AppSpacing.xs2),
            Text(
              ValueConst.reviewCountLabel(rating.count),
              style: GraviaTextStyleConst.textXsRegular(
                tt,
              ).copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(width: AppSpacing.xl2),
        Expanded(
          child: Column(
            children: [
              for (var star = 5; star >= 1; star--) ...[
                if (star < 5) const SizedBox(height: AppSpacing.xs2),
                _StarBar(star: star, share: rating.starShare(star)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StarBar extends StatelessWidget {
  final int star;
  final double share;

  static const double _height = 6;

  const _StarBar({required this.star, required this.share});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        Text(
          '$star',
          style: GraviaTextStyleConst.textXsRegular(
            tt,
          ).copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(width: AppSpacing.xs2),
        Expanded(
          // The track is width-driven, so the fill is a fraction of it
          // rather than a fixed pixel width — the row has to survive both
          // phone widths and the histogram sitting beside a long average.
          child: ClipRRect(
            borderRadius: AppRadius.full,
            child: LinearProgressIndicator(
              value: share,
              minHeight: _height,
              backgroundColor: cs.surfaceContainerHighest,
              // The same amber the stars above it use — a rating histogram
              // in the brand colour would read as a progress bar.
              valueColor: const AlwaysStoppedAnimation(
                RatingStars.defaultStarColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final ReviewEntity review;
  final VoidCallback? onDelete;

  static const double _avatarSize = 40;

  const _ReviewRow({required this.review, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReviewerAvatar(avatarUrl: review.userAvatarUrl, size: _avatarSize),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.userName,
                    style: GraviaTextStyleConst.textSmMedium(
                      tt,
                    ).copyWith(color: cs.onSurface),
                  ),
                  const SizedBox(height: AppSpacing.xs4),
                  Row(
                    children: [
                      RatingStars(
                        rating: review.rating.toDouble(),
                        size: AppSpacing.base,
                      ),
                      const SizedBox(width: AppSpacing.xs2),
                      Text(
                        ValueConst.reviewAgeLabel(review.createdAt),
                        style: GraviaTextStyleConst.textXsRegular(
                          tt,
                        ).copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (onDelete != null)
              GestureDetector(
                onTap: onDelete,
                child: Text(
                  ValueConst.deleteReviewLabel,
                  style: GraviaTextStyleConst.textXsRegular(
                    tt,
                  ).copyWith(color: cs.error),
                ),
              ),
          ],
        ),
        if (review.verifiedPurchase) ...[
          const SizedBox(height: AppSpacing.xs2),
          Text(
            ValueConst.verifiedPurchaseLabel,
            style: GraviaTextStyleConst.textXsRegular(
              tt,
            ).copyWith(color: cs.primary),
          ),
        ],
        if (review.text.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs2),
          Text(
            review.text,
            style: GraviaTextStyleConst.textSmRegular(
              tt,
            ).copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}
