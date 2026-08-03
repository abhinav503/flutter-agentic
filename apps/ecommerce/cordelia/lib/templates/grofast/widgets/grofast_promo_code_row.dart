import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';

import 'grofast_primary_button.dart';

/// The Bag's and Checkout's promo-code row (kit frames `129:1144` /
/// `119:819`): a **dashed** outlined row with the field on the left and the
/// pack's one ink pill on the right.
///
/// There is no coupon backend, so Apply reports the same "coming soon" as the
/// other two templates' equivalents rather than pretending to work — the row
/// is drawn because removing it would leave a hole in the kit's Bag layout
/// (recorded in spec sheet §11).
class GrofastPromoCodeRow extends StatelessWidget {
  final VoidCallback onApply;

  const GrofastPromoCodeRow({super.key, required this.onApply});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(context.appShapes.cardRadius);

    return CustomPaint(
      painter: _DashedBorderPainter(color: cs.outline, radius: radius),
      child: SizedBox(
        height: GrofastDimenConst.couponRowHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  GrofastValueConst.promoCodeHint,
                  style: GrofastTextStyleConst.bodyMedium(
                    tt,
                  ).copyWith(color: cs.onSurfaceVariant),
                ),
              ),
              GrofastInkButton(
                label: GrofastValueConst.promoApplyLabel,
                onTap: onApply,
              ),
            ],
          ),
        ),
      ),
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
