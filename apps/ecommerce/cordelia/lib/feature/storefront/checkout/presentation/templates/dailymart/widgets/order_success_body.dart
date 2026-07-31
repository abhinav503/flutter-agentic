import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_primary_button.dart';

/// Checkout's terminal state (kit frame `34 Order Successfully`) — the
/// success mark centred over the message, with the CTA pinned to the bottom.
///
/// Rendered in place of the form rather than as its own route: the kit gives
/// it the same header row, and swapping the body keeps the placed order off
/// the back stack, so there's no way to navigate back into a checkout that
/// already succeeded.
class OrderSuccessBody extends StatelessWidget {
  final VoidCallback onTrackOrder;

  const OrderSuccessBody({super.key, required this.onTrackOrder});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      // The screen's SafeArea is `bottom: false` so the form's fade can run to
      // the device edge — which means this body owns its own bottom inset, or
      // the CTA would sit under the iOS home indicator and Android's gesture
      // bar. Same pattern the floating CTAs elsewhere in this pack use.
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
      ),
      child: Column(
        children: [
          const Spacer(),
          const _SuccessMark(),
          const SizedBox(height: AppSpacing.xl),
          Text(
            DailyMartValueConst.orderPlacedTitle,
            textAlign: TextAlign.center,
            style: DailyMartTextStyleConst.successTitle(
              tt,
            ).copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            DailyMartValueConst.orderPlacedMessage,
            textAlign: TextAlign.center,
            style: DailyMartTextStyleConst.bodySmRegular(
              tt,
            ).copyWith(color: cs.onSurface),
          ),
          const Spacer(flex: 2),
          DailyMartPrimaryButton(
            label: DailyMartValueConst.trackOrderLabel,
            onTap: onTrackOrder,
          ),
        ],
      ),
    );
  }
}

/// The kit's success illustration is a green disc with a white tick, ringed
/// by loose sparkles. The disc and its size come from Flutter and the tick is
/// the kit's own `check` export — the same "bare glyph, container drawn in
/// code" convention this pack already uses for the selected-address tick and
/// the stepper's +/−. The sparkles are not reproduced: they're decorative
/// one-offs with no export, and inventing vector art would be worse than
/// leaving the mark clean.
class _SuccessMark extends StatelessWidget {
  const _SuccessMark();

  static const _size = 112.0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: SizedBox.square(
        dimension: AppSpacing.xl8,
        child: AppSvgImage.asset(
          DailyMartImageConst.check,
          color: cs.onPrimary,
        ),
      ),
    );
  }
}
