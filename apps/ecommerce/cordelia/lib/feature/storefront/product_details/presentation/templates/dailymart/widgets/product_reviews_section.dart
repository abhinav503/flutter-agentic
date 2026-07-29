import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/icon_circle.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_color_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_pill.dart';

/// The Reviews tab — **entirely static** (kit frame `23 Review product`
/// verbatim): the backend collects no reviews yet, so the summary card, the
/// star bars, and the single review row all render the kit's own copy, the
/// same placeholder policy as the product card's rating row
/// ([DailyMartValueConst.staticRatingLabel]). When reviews land, this whole
/// widget takes entities and the geometry stays.
class DailyMartProductReviewsSection extends StatelessWidget {
  const DailyMartProductReviewsSection({super.key});

  /// The kit's five bar fills, 5★ down to 1★.
  static const _barFills = [1.0, 0.82, 0.73, 0.65, 0.48];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final shapes =
        Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;
    final hairline =
        context.appColors.dockedHairline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                      DailyMartValueConst.staticReviewScore,
                      style: DailyMartTextStyleConst.headingH5(
                        tt,
                      ).copyWith(color: cs.onSurface),
                    ),
                    const SizedBox(height: AppSpacing.xs4),
                    Text(
                      DailyMartValueConst.staticReviewCount,
                      style: DailyMartTextStyleConst.bodySmRegular(
                        tt,
                      ).copyWith(color: cs.onSurface),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        for (var i = 0; i < 5; i++) ...[
                          if (i > 0) const SizedBox(width: AppSpacing.xs4),
                          AppSvgImage.asset(
                            DailyMartImageConst.star,
                            width: AppSpacing.xl2,
                            height: AppSpacing.xl2,
                            color: DailyMartColorConst.reviewAmber,
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
                  for (var i = 0; i < _barFills.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.base),
                    _StarBarRow(stars: 5 - i, fill: _barFills[i]),
                  ],
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: hairline)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _ReviewerRow(),
                const SizedBox(height: AppSpacing.base),
                Text(
                  DailyMartValueConst.staticReviewText,
                  style: DailyMartTextStyleConst.bodySmRegular(
                    tt,
                  ).copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.base),
                const Row(
                  children: [
                    _VoteCount(
                      count: DailyMartValueConst.staticReviewLikes,
                      down: false,
                    ),
                    SizedBox(width: AppSpacing.base),
                    _VoteCount(
                      count: DailyMartValueConst.staticReviewDislikes,
                      down: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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

class _ReviewerRow extends StatelessWidget {
  const _ReviewerRow();

  static const double _avatarSize = 48;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        // The kit's avatar photo isn't redistributable and the review is
        // placeholder copy anyway — the pack's documented person fallback
        // (spec sheet §5) stands in.
        AppIconCircle(
          size: _avatarSize,
          color: cs.surfaceContainer,
          child: Icon(
            Icons.person_rounded,
            size: AppSpacing.xl5,
            color: cs.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: AppSpacing.base),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DailyMartValueConst.staticReviewerName,
                style: DailyMartTextStyleConst.bodyMdSemibold(
                  tt,
                ).copyWith(color: cs.onSurface),
              ),
              const SizedBox(height: AppSpacing.xs4),
              Text(
                DailyMartValueConst.staticReviewAge,
                style: DailyMartTextStyleConst.bodySmRegular(
                  tt,
                ).copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.base),
        DailyMartPill(
          label: DailyMartValueConst.staticRatingLabel,
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
    );
  }
}

class _VoteCount extends StatelessWidget {
  final String count;
  final bool down;

  const _VoteCount({required this.count, required this.down});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final glyph = AppSvgImage.asset(
      DailyMartImageConst.like,
      width: AppSpacing.xl,
      height: AppSpacing.xl,
      color: cs.onSurface,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The kit draws the thumbs-down as the same glyph rotated, so the
        // asset stays single (see DailyMartImageConst.like).
        if (down) Transform.rotate(angle: math.pi, child: glyph) else glyph,
        const SizedBox(width: AppSpacing.xs3),
        Text(
          count,
          style: DailyMartTextStyleConst.bodyMdMedium(
            tt,
          ).copyWith(color: cs.onSurface),
        ),
      ],
    );
  }
}
