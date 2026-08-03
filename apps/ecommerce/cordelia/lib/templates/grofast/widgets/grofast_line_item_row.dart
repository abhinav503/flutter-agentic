import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_image_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';

import 'grofast_price.dart';

/// The pack's horizontal product row (spec sheet §10) — one silhouette shared
/// by the Bag, Checkout's item list and Track Order's items: a 100px card at
/// radius 28 with the photo in a well on the left, name over pack size over
/// price in the middle, and up to two controls stacked on the right.
///
/// Every screen that lists a purchased line renders THIS, so the three can't
/// drift; what varies between them is only what goes in [topTrailing] (a
/// heart, a remove disc, nothing) and [trailing] (a stepper, a quantity,
/// nothing).
class GrofastLineItemRow extends StatelessWidget {
  final String imageUrl;
  final String name;

  /// The pack size line under the name ("3 kg").
  final String? subtitle;
  final double price;

  /// The per-unit suffix on the price. Omit on rows whose price is already a
  /// line total (Checkout, Track Order).
  final String? unit;

  /// Top-right slot — a favourite heart, or the Bag's remove disc.
  final Widget? topTrailing;

  /// Bottom-right slot — the Bag's quantity stepper, or a `× 2` count.
  final Widget? trailing;

  final VoidCallback? onTap;

  const GrofastLineItemRow({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    this.subtitle,
    this.unit,
    this.topTrailing,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(context.appShapes.cardRadius);

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: GrofastDimenConst.lineItemRowHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                SizedBox.square(
                  dimension: GrofastDimenConst.lineItemThumbSize,
                  child: AppNetworkImage(url: imageUrl, fit: BoxFit.contain),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GrofastTextStyleConst.rowTitleBold(tt),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacing.xs4),
                        Text(
                          subtitle!,
                          style: GrofastTextStyleConst.meta(
                            tt,
                          ).copyWith(color: cs.onSurfaceVariant),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xs3),
                      GrofastPrice(value: price, unit: unit),
                    ],
                  ),
                ),
                if (topTrailing != null || trailing != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: AppSpacing.lg),
                      ?topTrailing,
                      const Spacer(),
                      ?trailing,
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The `−  n  +` stepper on a Bag row and on Product Details (spec sheet
/// §13): two bare circular buttons around the count, sized below the touch
/// floor on purpose — they sit on a row that is itself the large target.
class GrofastQuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;

  /// Null disables the minus (the pack floors quantity at 1 rather than
  /// letting a stepper delete the row).
  final VoidCallback? onDecrement;

  const GrofastQuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepperButton(
          asset: GrofastImageConst.minus,
          onTap: onDecrement,
          semanticLabel: GrofastValueConst.decreaseQuantityLabel,
        ),
        SizedBox(
          width: AppSpacing.xl6,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: GrofastTextStyleConst.rowTitleBold(tt),
          ),
        ),
        _StepperButton(
          asset: GrofastImageConst.plus,
          onTap: onIncrement,
          semanticLabel: GrofastValueConst.increaseQuantityLabel,
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  final String asset;
  final VoidCallback? onTap;
  final String semanticLabel;

  const _StepperButton({
    required this.asset,
    required this.onTap,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final enabled = onTap != null;

    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: GrofastDimenConst.stepperButtonSize,
          height: GrofastDimenConst.stepperButtonSize,
          decoration: BoxDecoration(
            color: cs.surfaceContainer,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: AppSvgImage.asset(
            asset,
            width: AppSpacing.base,
            height: AppSpacing.base,
            color: enabled
                ? cs.onSurface
                : cs.onSurfaceVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}

/// The small circular remove control on a Bag row — `cs.error`-filled, with
/// the kit's trash glyph.
class GrofastRemoveDisc extends StatelessWidget {
  final VoidCallback onTap;
  final String tooltip;

  const GrofastRemoveDisc({
    super.key,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: GrofastDimenConst.productHeartSize,
          height: GrofastDimenConst.productHeartSize,
          decoration: BoxDecoration(color: cs.error, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: AppSvgImage.asset(
            GrofastImageConst.delete,
            width: AppSpacing.base,
            height: AppSpacing.base,
            color: cs.onError,
          ),
        ),
      ),
    );
  }
}
