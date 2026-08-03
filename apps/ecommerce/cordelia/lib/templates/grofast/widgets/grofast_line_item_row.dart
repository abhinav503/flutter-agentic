import 'package:flutter/material.dart';

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
/// favourite heart, nothing) and [trailing] (a stepper, a quantity,
/// nothing). Removing a line is the Bag's swipe, never a control in the row.
class GrofastLineItemRow extends StatelessWidget {
  final String imageUrl;
  final String name;

  /// The pack size line under the name ("3 kg").
  final String? subtitle;
  final double price;

  /// The per-unit suffix on the price. Omit on rows whose price is already a
  /// line total (Checkout, Track Order).
  final String? unit;

  /// Top-right slot — the favourite heart, on the rows that toggle one.
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
    final radius = BorderRadius.circular(GrofastDimenConst.tileRadius);

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

/// The `−  n  +` stepper (spec sheet §13): two rounded squares around the
/// count, sized below the touch floor on purpose — they sit on a row that is
/// itself the large target.
///
/// The kit draws it at two sizes, and the two invert each other's colours: on
/// a Bag row the keys are white squares on the row's tinted card, while
/// Product Details' larger [GrofastQuantityStepper.large] puts tinted keys on
/// the plain white page.
class GrofastQuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;

  /// Null disables the minus (the pack floors quantity at 1 rather than
  /// letting a stepper delete the row).
  final VoidCallback? onDecrement;

  final double buttonSize;
  final double buttonRadius;
  final double glyphSize;

  /// True on a tinted row, where the keys invert to white.
  final bool keysOnTint;

  const GrofastQuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    this.onDecrement,
  }) : buttonSize = GrofastDimenConst.stepperButtonSize,
       buttonRadius = GrofastDimenConst.stepperButtonRadius,
       glyphSize = AppSpacing.base,
       keysOnTint = true;

  const GrofastQuantityStepper.large({
    super.key,
    required this.quantity,
    required this.onIncrement,
    this.onDecrement,
  }) : buttonSize = GrofastDimenConst.detailStepperButtonSize,
       buttonRadius = GrofastDimenConst.detailStepperButtonRadius,
       // The kit insets the larger key's glyph by 25% a side.
       glyphSize = AppSpacing.xl2,
       keysOnTint = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepperButton(
          asset: GrofastImageConst.minus,
          onTap: onDecrement,
          semanticLabel: GrofastValueConst.decreaseQuantityLabel,
          size: buttonSize,
          radius: buttonRadius,
          glyphSize: glyphSize,
          onTint: keysOnTint,
        ),
        SizedBox(
          width: AppSpacing.xl6,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: keysOnTint
                ? GrofastTextStyleConst.rowTitleBold(tt)
                : GrofastTextStyleConst.price(
                    tt,
                  ).copyWith(color: cs.onSurfaceVariant),
          ),
        ),
        _StepperButton(
          asset: GrofastImageConst.plus,
          onTap: onIncrement,
          semanticLabel: GrofastValueConst.increaseQuantityLabel,
          size: buttonSize,
          radius: buttonRadius,
          glyphSize: glyphSize,
          onTint: keysOnTint,
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  final String asset;
  final VoidCallback? onTap;
  final String semanticLabel;
  final double size;
  final double radius;
  final double glyphSize;
  final bool onTint;

  const _StepperButton({
    required this.asset,
    required this.onTap,
    required this.semanticLabel,
    required this.size,
    required this.radius,
    required this.glyphSize,
    required this.onTint,
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
          width: size,
          height: size,
          decoration: BoxDecoration(
            // The kit's stepper reads as two keys either side of the count,
            // not two dots — so the key always takes the opposite fill to
            // whatever it stands on.
            color: onTint ? cs.surface : cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(radius),
          ),
          alignment: Alignment.center,
          child: AppSvgImage.asset(
            asset,
            width: glyphSize,
            height: glyphSize,
            color: enabled
                ? cs.onSurface
                : cs.onSurfaceVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}
