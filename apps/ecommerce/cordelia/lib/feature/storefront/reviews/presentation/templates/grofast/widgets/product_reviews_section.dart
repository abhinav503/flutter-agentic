import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/rating_stars.dart';
import 'package:core/core/ui/molecules/empty_state.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_color_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_chip.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_primary_button.dart';

import '../../../../domain/entities/product_rating_entity.dart';
import '../../../../domain/entities/product_reviews_entity.dart';
import '../../../../domain/entities/review_entity.dart';
import '../../../reviewer_avatar.dart';

/// Grofast's Reviews block on Product Details — the pack's section heading
/// over the average, the per-star histogram, and the reviews themselves.
///
/// The GROFAST kit draws no reviews frame (recorded as a deviation in the
/// spec sheet), so this is composed from recipes the pack already owns: the
/// `sectionBold` heading the Description above it uses, the outlined badge
/// that already carries this product's rating in the title row, and the
/// pack's gradient CTA.
class GrofastProductReviewsSection extends StatelessWidget {
  final ProductReviewsEntity reviews;

  /// Null while a write is in flight — the CTA stops taking taps rather than
  /// letting a second submit stack on the first.
  final VoidCallback? onWriteReview;
  final VoidCallback? onDeleteReview;

  /// The signed-in shopper, so their own review offers edit/delete.
  final String? currentUid;

  const GrofastProductReviewsSection({
    super.key,
    required this.reviews,
    required this.onWriteReview,
    required this.onDeleteReview,
    required this.currentUid,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final hairline = context.appColors.dockedHairline;
    final mine = reviews.mine(currentUid);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ValueConst.reviewsSectionTitle,
          style: GrofastTextStyleConst.sectionBold(tt),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (reviews.rating.hasReviews)
          _Summary(rating: reviews.rating)
        else
          const EmptyState(
            iconData: Icons.reviews_outlined,
            title: ValueConst.reviewsEmptyTitle,
            subtitle: ValueConst.reviewsEmptySubtitle,
          ),
        const SizedBox(height: AppSpacing.lg),
        GrofastPrimaryButton(
          label: mine == null
              ? ValueConst.writeReviewLabel
              : ValueConst.editReviewLabel,
          onTap: onWriteReview,
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
              style: GrofastTextStyleConst.displayBold(tt),
            ),
            const SizedBox(height: AppSpacing.xs2),
            RatingStars(
              rating: rating.average,
              color: GrofastColorConst.ratingStar,
            ),
            const SizedBox(height: AppSpacing.xs2),
            Text(
              ValueConst.reviewCountLabel(rating.count),
              style: GrofastTextStyleConst.bodySmall(
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
          style: GrofastTextStyleConst.bodySmall(
            tt,
          ).copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(width: AppSpacing.xs2),
        Expanded(
          // Width-driven, so the fill is a fraction of the track rather than
          // a fixed pixel width — the row has to survive both phone widths
          // and the histogram sitting beside a long average.
          child: ClipRRect(
            borderRadius: AppRadius.full,
            child: LinearProgressIndicator(
              value: share,
              minHeight: _height,
              backgroundColor: cs.surfaceContainerHighest,
              valueColor: const AlwaysStoppedAnimation(
                GrofastColorConst.ratingStar,
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
                    style: GrofastTextStyleConst.bodyMedium(tt),
                  ),
                  const SizedBox(height: AppSpacing.xs4),
                  Text(
                    ValueConst.reviewAgeLabel(review.createdAt),
                    style: GrofastTextStyleConst.bodySmall(
                      tt,
                    ).copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            // The same outlined star badge the title row uses for the
            // product's own rating — one rating shape per pack.
            GrofastBadge.outlined(
              label: review.rating.toStringAsFixed(1),
              leading: const Icon(
                Icons.star_rounded,
                size: AppSpacing.base,
                color: GrofastColorConst.ratingStar,
              ),
            ),
          ],
        ),
        if (review.text.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            review.text,
            style: GrofastTextStyleConst.bodyRelaxed(
              tt,
            ).copyWith(color: cs.onSurfaceVariant),
          ),
        ],
        if (review.verifiedPurchase || onDelete != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              if (review.verifiedPurchase)
                Text(
                  ValueConst.verifiedPurchaseLabel,
                  style: GrofastTextStyleConst.bodySmall(
                    tt,
                  ).copyWith(color: cs.primary),
                ),
              const Spacer(),
              if (onDelete != null)
                GestureDetector(
                  onTap: onDelete,
                  child: Text(
                    ValueConst.deleteReviewLabel,
                    style: GrofastTextStyleConst.bodySmall(
                      tt,
                    ).copyWith(color: cs.error),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
