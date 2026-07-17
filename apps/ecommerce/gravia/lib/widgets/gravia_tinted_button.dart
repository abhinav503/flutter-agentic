import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/dimen_const.dart';
import 'package:gravia/constants/text_style_const.dart';

/// Gravia's tinted-error pill — no `AppButton` variant renders a filled
/// error-tinted pill (its Fill/Outline/Text set is deliberately generic, per
/// `AppButton`'s own doc comment), so this is a small dedicated preset
/// instead of forking the shared atom. Started as `AddressCard`'s private
/// `_DeleteButton`; the Orders screen's "Cancel" action is its second
/// caller, which is what moved it here.
///
/// Sized (45px tall) but not full-width by itself — wrap in `Expanded` (or a
/// fixed-width parent) the same way both callers do, since it always sits
/// beside another action.
class GraviaTintedButton extends StatelessWidget {
  static const double height = DimenConst.controlHeight;

  final String label;
  final VoidCallback? onTap;
  final Widget? leadingIcon;

  const GraviaTintedButton({
    super.key,
    required this.label,
    this.onTap,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final shapes =
        Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;
    final radius = BorderRadius.circular(shapes.buttonRadius);

    return SizedBox(
      height: height,
      child: Material(
        // Error/50 light, Error/500-20%-alpha dark — see tintedErrorFill.
        color: cs.tintedErrorFill,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIcon != null) ...[
                  leadingIcon!,
                  const SizedBox(width: AppSpacing.xs),
                ],
                Text(
                  label,
                  style: TextStyleConst.textSmMedium(
                    tt,
                  ).copyWith(color: ColorConst.error500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
