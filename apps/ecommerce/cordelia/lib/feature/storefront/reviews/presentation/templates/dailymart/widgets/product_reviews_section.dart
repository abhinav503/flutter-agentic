import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/molecules/empty_state.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_color_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_outline_button.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_pill.dart';

import '../../../../domain/entities/product_reviews_entity.dart';
import '../../../../domain/entities/product_rating_entity.dart';
import '../../../../domain/entities/review_entity.dart';
import '../../../reviewer_avatar.dart';

/// The Reviews tab — kit frame `23 Review product`, now rendering real
/// reviews. The geometry is the kit's verbatim (summary card with the score
/// beside five star bars, then review rows under a hairline); only the
/// numbers and copy come from the store.
///
/// Two recorded deviations from the frame, both because the backend has no
/// data behind what it draws: the review row's thumbs up/down counters are
/// gone (nothing votes on a review), and the kit's single reviewer is now
/// however many the product actually has — including none, which the frame
/// has no state for and which renders as an empty state here.
class DailyMartProductReviewsSection extends StatelessWidget {
  final ProductReviewsEntity reviews;

  /// Null while a write is in flight — the CTA reads as busy rather than
  /// letting a second submit stack on the first.
  final VoidCallback? onWriteReview;
  final VoidCallback? onDeleteReview;

  /// The signed-in shopper, so their own review can offer edit/delete.
  final String? currentUid;

  const DailyMartProductReviewsSection({
    super.key,
    required this.reviews,
    required this.onWriteReview,
    required this.onDeleteReview,
    required this.currentUid,
  });

  @override
  Widget build(BuildContext context) {
    final hairline = context.appColors.dockedHairline;
    final mine = reviews.mine(currentUid);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (reviews.rating.hasReviews)
          _SummaryCard(rating: reviews.rating)
        else
          EmptyState(
            iconData: Icons.reviews_outlined,
            title: ValueConst.reviewsEmptyTitle,
            subtitle: ValueConst.reviewsEmptySubtitle,
          ),
        const SizedBox(height: AppSpacing.lg),
        DailyMartOutlineButton(
          label: mine == null
              ? ValueConst.writeReviewLabel
              : ValueConst.editReviewLabel,
          onTap: onWriteReview,
        ),
        for (final review in reviews.reviews) ...[
          const SizedBox(height: AppSpacing.lg),
          _ReviewRow(
            review: review,
            hairline: hairline,
            // Only the shopper's own row carries a delete — everyone
            // else's is moderated from the admin console, not from here.
            onDelete: review.uid == currentUid ? onDeleteReview : null,
          ),
        ],
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final ProductRatingEntity rating;

  const _SummaryCard({required this.rating});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final shapes = context.appShapes;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.base,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: cs.outline),
        borderRadius: BorderRadius.circular(shapes.cardRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DailyMartValueConst.reviewScoreLabel(rating.average),
                  style: DailyMartTextStyleConst.headingH5(
                    tt,
                  ).copyWith(color: cs.onSurface),
                ),
                const SizedBox(height: AppSpacing.xs4),
                Text(
                  ValueConst.reviewCountLabel(rating.count),
                  style: DailyMartTextStyleConst.bodySmRegular(
                    tt,
                  ).copyWith(color: cs.onSurface),
                ),
                const SizedBox(height: AppSpacing.sm),
                // The kit draws five filled stars; they now fill to the
                // real average, so a 3.4-star product doesn't advertise five.
                Row(
                  children: [
                    for (var star = 1; star <= 5; star++) ...[
                      if (star > 1) const SizedBox(width: AppSpacing.xs4),
                      AppSvgImage.asset(
                        DailyMartImageConst.star,
                        width: AppSpacing.xl2,
                        height: AppSpacing.xl2,
                        color: rating.average >= star - 0.5
                            ? DailyMartColorConst.reviewAmber
                            : cs.surfaceContainerHighest,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          Column(
            children: [
              // 5★ at the top, counting down — the kit's order.
              for (var star = 5; star >= 1; star--) ...[
                if (star < 5) const SizedBox(height: AppSpacing.base),
                _StarBarRow(stars: star, fill: rating.starShare(star)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StarBarRow extends StatelessWidget {
  final int stars;
  final double fill;

  static const double _barWidth = 120;
  static const double _barHeight = 5;

  const _StarBarRow({required this.stars, required this.fill});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        SizedBox(
          width: AppSpacing.xl8,
          child: Text(
            DailyMartValueConst.starRowLabel(stars),
            style: DailyMartTextStyleConst.bodyXsMedium(
              tt,
            ).copyWith(color: cs.onSurface),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Stack(
          children: [
            Container(
              width: _barWidth,
              height: _barHeight,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: AppRadius.full,
              ),
            ),
            Container(
              width: _barWidth * fill,
              height: _barHeight,
              decoration: const BoxDecoration(
                color: DailyMartColorConst.reviewAmber,
                borderRadius: AppRadius.full,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final ReviewEntity review;
  final Color hairline;
  final VoidCallback? onDelete;

  static const double _avatarSize = 48;

  const _ReviewRow({
    required this.review,
    required this.hairline,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: hairline)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // The kit's avatar photo isn't redistributable, so a reviewer
                // with no profile picture falls back to the pack's documented
                // person glyph (spec sheet §5).
                ReviewerAvatar(
                  avatarUrl: review.userAvatarUrl,
                  size: _avatarSize,
                ),
                const SizedBox(width: AppSpacing.base),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: DailyMartTextStyleConst.bodyMdSemibold(
                          tt,
                        ).copyWith(color: cs.onSurface),
                      ),
                      const SizedBox(height: AppSpacing.xs4),
                      Text(
                        ValueConst.reviewAgeLabel(review.createdAt),
                        style: DailyMartTextStyleConst.bodySmRegular(
                          tt,
                        ).copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.base),
                DailyMartPill(
                  label: review.rating.asDecimal(),
                  color: DailyMartColorConst.reviewAmber,
                  height: DailyMartDimenConst.ratingPillHeight,
                  style: DailyMartTextStyleConst.bodyXsMedium(
                    tt,
                  ).copyWith(color: DailyMartColorConst.onReviewAmber),
                  leading: AppSvgImage.asset(
                    DailyMartImageConst.star,
                    width: AppSpacing.lg,
                    height: AppSpacing.lg,
                    color: DailyMartColorConst.onReviewAmber,
                  ),
                ),
              ],
            ),
            if (review.text.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.base),
              Text(
                review.text,
                style: DailyMartTextStyleConst.bodySmRegular(
                  tt,
                ).copyWith(color: cs.onSurfaceVariant),
              ),
            ],
            if (review.verifiedPurchase || onDelete != null) ...[
              const SizedBox(height: AppSpacing.base),
              Row(
                children: [
                  if (review.verifiedPurchase)
                    Text(
                      ValueConst.verifiedPurchaseLabel,
                      style: DailyMartTextStyleConst.bodyXsMedium(
                        tt,
                      ).copyWith(color: cs.primary),
                    ),
                  const Spacer(),
                  if (onDelete != null)
                    GestureDetector(
                      onTap: onDelete,
                      child: Text(
                        ValueConst.deleteReviewLabel,
                        style: DailyMartTextStyleConst.bodyXsMedium(
                          tt,
                        ).copyWith(color: cs.error),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
