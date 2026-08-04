import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';

import 'package:cordelia/feature/storefront/home/domain/entities/banner_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_color_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';

/// Home's promo banner (spec sheet §10): radius 28, split into a copy column
/// and the store's artwork — the admin's headline and offer over a small
/// gradient "claim now" pill on the left, the photo filling the right.
///
/// The kit draws one flat illustration across the whole card with the copy on
/// top of it, which only works because the artwork is drawn around the words.
/// A store uploads a photograph, so the copy takes a column of its own
/// instead — the split is what keeps every store's banner legible, and it
/// lets the copy use the pack's ink rather than white over a wash.
class GrofastPromoCard extends StatelessWidget {
  final BannerEntity banner;
  final VoidCallback? onTap;

  const GrofastPromoCard({super.key, required this.banner, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.appShapes.cardRadius),
        child: SizedBox(
          height: GrofastDimenConst.promoCardHeight,
          child: ColoredBox(
            // The store's own banner colour when its admin picked one — the
            // copy column is a flat surface, so it's the one thing that ties
            // the card to the photograph beside it. Falls back to the pack's
            // raised neutral, which reads as a plain card.
            color: banner.backgroundArgb == null
                ? cs.surfaceContainerLow
                : Color(banner.backgroundArgb!),
            child: Row(
              children: [
                Expanded(
                  flex: GrofastDimenConst.promoCopyFlex,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl2),
                    // The card height is kit-fixed, so the copy column has a
                    // hard budget: one title line + one amount line + the pill
                    // is all that fits. A wrapping title or pill blew that
                    // budget the moment a store wrote real copy.
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          banner.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GrofastTextStyleConst.promoTitle(
                            tt,
                          ).copyWith(color: GrofastColorConst.promoInk),
                        ),
                        if (banner.subtitle.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xs3),
                          _PromoSubtitle(subtitle: banner.subtitle),
                        ],
                        if (banner.hasTarget) ...[
                          const SizedBox(height: AppSpacing.base),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: const BoxDecoration(
                              gradient: GrofastColorConst.brandGradient,
                              borderRadius: AppRadius.full,
                            ),
                            child: Text(
                              GrofastValueConst.claimNow,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              style: GrofastTextStyleConst.pillLabelBold(
                                tt,
                              ).copyWith(color: cs.onPrimary),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: GrofastDimenConst.promoImageFlex,
                  child: AppNetworkImage(
                    url: banner.imageUrl,
                    fit: BoxFit.cover,
                    height: GrofastDimenConst.promoCardHeight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The kit's offer slot ([GrofastTextStyleConst.promoAmount]) assumes a short
/// figure — "40% Off". A store admin writes whatever they like, and a
/// sentence in 28px either truncates to a couple of words or overflows the
/// fixed-height card. So the style adapts to the copy: the amount treatment
/// when the text fits its single line, body-small on two lines when it
/// doesn't — both stay inside the card's height budget.
class _PromoSubtitle extends StatelessWidget {
  final String subtitle;

  const _PromoSubtitle({required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final amountStyle = GrofastTextStyleConst.promoAmount(
      tt,
    ).copyWith(color: GrofastColorConst.promoInk);

    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: subtitle, style: amountStyle),
          maxLines: 1,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout(maxWidth: constraints.maxWidth);
        final fitsAsAmount = !painter.didExceedMaxLines;
        painter.dispose();

        return fitsAsAmount
            ? Text(subtitle, maxLines: 1, style: amountStyle)
            : Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GrofastTextStyleConst.bodySmall(
                  tt,
                ).copyWith(color: GrofastColorConst.promoInk),
              );
      },
    );
  }
}
