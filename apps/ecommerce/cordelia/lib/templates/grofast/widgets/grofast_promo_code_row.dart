import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/loading_dots.dart';

import 'package:cordelia/feature/storefront/cart/presentation/cubit/coupon_cubit.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';

import 'grofast_primary_button.dart';

/// The Bag's promo-code row (kit frames `129:1144` / `119:819`): a **dashed**
/// outlined row with the field on the left and the pack's one ink pill on
/// the right. Live: the typed code is validated by the backend
/// ([CouponCubit]); once applied the pill flips to Remove, and a rejection
/// prints the server's reason under the dashes with the code kept in place
/// for a retry.
class GrofastPromoCodeRow extends StatefulWidget {
  final CouponState couponState;
  final ValueChanged<String> onApply;
  final VoidCallback onRemove;

  const GrofastPromoCodeRow({
    super.key,
    required this.couponState,
    required this.onApply,
    required this.onRemove,
  });

  @override
  State<GrofastPromoCodeRow> createState() => _GrofastPromoCodeRowState();
}

class _GrofastPromoCodeRowState extends State<GrofastPromoCodeRow> {
  final TextEditingController _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(context.appShapes.cardRadius);

    final applied = switch (widget.couponState) {
      CouponApplied(:final coupon) => coupon,
      _ => null,
    };
    final errorMessage = switch (widget.couponState) {
      CouponFailed(:final message) => message,
      _ => null,
    };
    final applying = widget.couponState is CouponApplying;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          // Fills like a card and outlines like a voucher: the kit's raised
          // neutral behind the dashes, not the page.
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: radius,
          ),
          child: CustomPaint(
            painter: _DashedBorderPainter(
              // The kit's own stroke — the ink at 20%, which no neutral
              // outline role reproduces on this pack's green-cast palette.
              color: cs.onSurface.withValues(
                alpha: GrofastDimenConst.couponBorderOpacity,
              ),
              radius: radius,
            ),
            child: SizedBox(
              height: GrofastDimenConst.couponRowHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: applied != null
                          ? Text(
                              GrofastValueConst.promoAppliedLabel(applied.code),
                              style: GrofastTextStyleConst.bodyMedium(
                                tt,
                              ).copyWith(color: cs.onSurface),
                            )
                          // The dashed voucher IS the field chrome — every
                          // border is stripped explicitly, because the
                          // theme's inputDecorationTheme injects the pack's
                          // input border even into a collapsed decoration.
                          : TextField(
                              controller: _code,
                              enabled: !applying,
                              textCapitalization: TextCapitalization.characters,
                              style: GrofastTextStyleConst.bodyMedium(
                                tt,
                              ).copyWith(color: cs.onSurface),
                              decoration: InputDecoration(
                                isCollapsed: true,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: GrofastValueConst.promoCodeHint,
                                hintStyle: GrofastTextStyleConst.bodyMedium(
                                  tt,
                                ).copyWith(color: cs.onSurfaceVariant),
                              ),
                              onSubmitted: widget.onApply,
                              // Same dismissal rule AppTextField bakes in — tapping
                              // outside drops focus and the keyboard.
                              onTapOutside: (_) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                            ),
                    ),
                    if (applying)
                      const LoadingDots()
                    else
                      GrofastInkButton(
                        label: applied != null
                            ? GrofastValueConst.promoRemoveLabel
                            : GrofastValueConst.promoApplyLabel,
                        onTap: applied != null
                            ? () {
                                _code.clear();
                                widget.onRemove();
                              }
                            : () => widget.onApply(_code.text),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              errorMessage,
              style: GrofastTextStyleConst.meta(tt).copyWith(color: cs.error),
            ),
          ),
        ],
      ],
    );
  }
}

/// Flutter has no dashed `BoxBorder`, and the dash is the whole point of the
/// kit's promo row — so the outline is painted rather than approximated with
/// a solid one.
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final BorderRadius radius;

  static const _dash = 6.0;
  static const _gap = 4.0;

  const _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path()
      ..addRRect(radius.toRRect(Offset.zero & size).deflate(0.5));

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + _dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance = end + _gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
