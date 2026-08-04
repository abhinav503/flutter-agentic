import 'package:flutter/material.dart';

import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/network_image.dart';

import 'package:cordelia/enums/order_status.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_pill.dart';

import '../../../../domain/entities/order_entity.dart';

/// One order in My Orders (kit frame `35`) — a tinted radius-16 card: an
/// 88px thumbnail beside the order's name, size and total, with an inline
/// Track Order action.
///
/// The kit draws a *product* here — image, name, **category**, price — but
/// an order is a basket, not a product. It's rendered as its first line
/// item's photo and name (the only image an order has) with the category
/// slot carrying the basket's size instead, which is the piece of
/// information a shopper actually needs to tell two orders apart. The price
/// is the order total, not that one line's.
///
/// My Orders only. The kit repeats this card atop Track Order, where
/// standing for the order by its first line item hides the rest of the
/// basket — that screen itemises the order instead (see `TrackOrderScreen`).
class DailyMartOrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onTrack;

  /// Draws the status pill beside the name. True only while the screen's
  /// chip row is on **All**, where the list mixes every status and a card
  /// otherwise can't say which one it is. Under Active / Completed /
  /// Cancelled the chip above the list already answers that, and repeating
  /// it on every card is noise that costs the name its width.
  final bool showStatus;

  const DailyMartOrderCard({
    super.key,
    required this.order,
    required this.onTrack,
    this.showStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    // Orders always have at least one line item (the server rejects an empty
    // cart at checkout), but a legacy/partial doc shouldn't crash the list.
    final first = order.items.isEmpty ? null : order.items.first;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: cs.surfaceContainer.withValues(alpha: 0.8),
        borderRadius: AppRadius.xl,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: AppRadius.lg,
            child: ColoredBox(
              color: cs.surface,
              child: SizedBox.square(
                dimension: DailyMartDimenConst.orderThumbSize,
                child: first == null
                    ? null
                    : AppNetworkImage(
                        url: first.imageUrl,
                        width: DailyMartDimenConst.orderThumbSize,
                        height: DailyMartDimenConst.orderThumbSize,
                      ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        first?.productName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DailyMartTextStyleConst.bodyMdSemibold(
                          tt,
                        ).copyWith(color: cs.onSurface),
                      ),
                    ),
                    if (showStatus) ...[
                      const SizedBox(width: AppSpacing.xs),
                      _StatusPill(status: order.status),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.xs4),
                Text(
                  DailyMartValueConst.orderSummaryLabel(
                    order.items.length,
                    order.placedAt,
                  ),
                  // Two facts joined on one line — clip rather than wrap, or
                  // a narrow phone would push the price row past the
                  // thumbnail and break the card's silhouette.
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DailyMartTextStyleConst.bodySmMedium(
                    tt,
                  ).copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.xs2),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        order.totalPrice.asPrice,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DailyMartTextStyleConst.bodyMdSemibold(
                          tt,
                        ).copyWith(color: cs.onSurface),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    _TrackButton(onTap: onTrack),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Which stage the order is at, as the pack's static label pill.
///
/// Three fills off the preset's own roles rather than a new colour each:
/// green ([AppColorsExtension.tintedPrimaryFill], the pack's one tint) for
/// the settled-well case, red (`errorContainer`) for cancelled, and the
/// kit's reserved blue Action ramp (`tertiaryContainer`) for an order still
/// moving — the preset keeps that ramp precisely so an accent this pack
/// eventually needs comes from the kit instead of a seed-derived tone.
class _StatusPill extends StatelessWidget {
  final OrderStatus status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final (background, foreground) = switch (status) {
      OrderStatus.pending ||
      OrderStatus.inProcess => (cs.tertiaryContainer, cs.tertiary),
      OrderStatus.delivered => (
        context.appColors.tintedPrimaryFill,
        cs.primary,
      ),
      OrderStatus.cancelled => (cs.errorContainer, cs.error),
    };

    return DailyMartPill(
      label: DailyMartValueConst.orderStatusLabel(status),
      color: background,
      style: DailyMartTextStyleConst.bodyXsSemibold(
        tt,
      ).copyWith(color: foreground),
    );
  }
}

/// The card's own compact CTA — not [DailyMartOutlineButton], which is the
/// pack's full-width 56px pill: this one rides inside a card at 32px and
/// radius 8 (the kit's 6 rounded to the pack's nearest token), the same
/// "secondary action on top of a larger target" call the card's overlay
/// controls make.
///
/// Filled with `surface` rather than left transparent: this card's own fill
/// is `surfaceContainer @ .8`, so a transparent button took the card's tint
/// and all but vanished into it. `surface` is the canvas colour — white in
/// light, the near-black canvas in dark — which is a step away from the
/// card's fill in both modes, so the button reads as a raised control on it
/// either way. Not a literal white: that would invert on dark, leaving a
/// white slab in the middle of a dark card.
class _TrackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _TrackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(color: cs.surface, borderRadius: AppRadius.md),
      child: AppButton(
        label: DailyMartValueConst.trackOrderAction,
        onTap: onTap,
        variant: AppButtonVariant.secondary,
        size: AppButtonSize.small,
        height: DailyMartDimenConst.orderTrackButtonHeight,
        borderRadius: AppRadius.md,
        borderColor: cs.primary,
        labelStyle: DailyMartTextStyleConst.bodyXsSemibold(
          tt,
        ).copyWith(color: cs.primary),
      ),
    );
  }
}
