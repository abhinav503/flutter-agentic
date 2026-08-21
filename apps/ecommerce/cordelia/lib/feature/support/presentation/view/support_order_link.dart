import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/constants/value_const.dart';

import 'support_channels.dart';
import 'support_glyphs.dart';

/// "Need help with this order?" — the entry that carries the order number
/// into the support message, so a shopper never has to find and retype it.
///
/// Styled from theme roles alone, no pack constants: the theme is already
/// swapped per template, and this is one quiet line rather than a surface
/// with a kit opinion behind it. One widget rather than three also keeps it
/// from drifting into three different-looking affordances for the same tap
/// — the trap the three-template sweep kept finding.
///
/// It sits at the end of a Track Order body rather than in the docked slot
/// below: that slot already carries Cancel while an order is coming and Rate
/// once it has arrived, and asking for help is not an alternative to either.
/// Inside the body it is also reachable on a **cancelled** order, which has
/// no CTA at all and is exactly when a shopper most often needs someone.
class SupportOrderLink extends StatelessWidget {
  final String orderId;

  const SupportOrderLink({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => context.push(AppRoutes.support, extra: orderId),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.base),
        child: Row(
          children: [
            Icon(
              supportChannelGlyph(SupportChannelKind.email),
              size: supportGlyphSize,
              color: cs.primary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                ValueConst.supportOrderCtaLabel,
                style: tt.bodyMedium!.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: AppSpacing.xl3,
              color: cs.primary,
            ),
          ],
        ),
      ),
    );
  }
}
