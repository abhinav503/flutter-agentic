import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/badge.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/radio_dot.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';

import '../../domain/entities/address_entity.dart';

/// One saved address row: radio + name + tag badge, address line + phone,
/// and Edit/Delete pill actions. The radio/identity block is the only part
/// wrapped for [onSelect] — Edit/Delete sit outside it as sibling widgets so
/// a tap on either action never also re-triggers selection (nested
/// `GestureDetector`s along the same hit path both fire otherwise).
class AddressCard extends StatelessWidget {
  final AddressEntity address;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AddressCard({
    super.key,
    required this.address,
    required this.selected,
    required this.onSelect,
    required this.onEdit,
    required this.onDelete,
  });

  // Radio width (AppRadioDot's default `size`) + the gap after it — reused so
  // the address/phone lines and the Edit/Delete row indent to sit under the
  // name, not under the radio.
  static const _identityInset = 16 + AppSpacing.base;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    // Kit spec calls for pure white/black here, not the warm near-black/
    // near-white `onSurface` pair the rest of the app reads — shared by the
    // phone row and the Edit button's icon+label.
    final blackOrWhite =
        Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onSelect,
          behavior: HitTestBehavior.opaque,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // Center, not start: aligns the radio against this row's
                // own line (name + badge) instead of the top of the whole
                // multi-line block below, which pulled it visually high.
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppRadioDot(selected: selected),
                  const SizedBox(width: AppSpacing.base),
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            address.name,
                            style: TextStyleConst.textMdBold(tt)
                                .copyWith(color: cs.onSurface),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs2),
                        // Same AppBadge call as ProductCard's quantity badge
                        // (badgeLabelStyle/badgeBackgroundColor at every
                        // ProductCard call site) — kept identical so the two
                        // surfaces don't drift apart.
                        AppBadge(
                          text: address.tag,
                          intent: AppBadgeIntent.info,
                          textStyle: TextStyleConst.badgeLabel(tt).copyWith(color: cs.primary),
                          backgroundColor: cs.tintedPrimaryFill,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs2),
              Padding(
                padding: const EdgeInsets.only(left: _identityInset),
                child: Text(
                  address.addressLine,
                  style: TextStyleConst.textSmRegular(tt)
                      .copyWith(color: ColorConst.gray500),
                ),
              ),
              const SizedBox(height: AppSpacing.xs2),
              Padding(
                padding: const EdgeInsets.only(left: _identityInset),
                child: Row(
                  children: [
                    AppSvgImage.asset(
                      ImageConst.calling,
                      color: blackOrWhite,
                      width: 14,
                      height: 14,
                    ),
                    const SizedBox(width: AppSpacing.xs3),
                    Text(
                      address.phone,
                      style: TextStyleConst.textSmRegular(tt).copyWith(color: blackOrWhite),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        Padding(
          padding: const EdgeInsets.only(left: _identityInset),
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  label: ValueConst.editLabel,
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.small,
                  fullWidth: true,
                  // Matches the 45px action-control height used by the glass
                  // icon buttons in every header and the docked bottom CTAs.
                  height: 45,
                  labelStyle: TextStyleConst.textSmMedium(tt).copyWith(color: blackOrWhite),
                  leadingIcon: AppSvgImage.asset(
                    ImageConst.editRectangle,
                    color: blackOrWhite,
                    width: 20,
                    height: 20,
                  ),
                  onTap: onEdit,
                ),
              ),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: _DeleteButton(onTap: onDelete),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// No `AppButton` variant renders a filled error-tinted pill (its Fill/
/// Outline/Text set is deliberately generic, per `AppButton`'s own doc
/// comment) — a one-off local widget instead of forking the shared atom for
/// a look only this screen's Delete action uses.
class _DeleteButton extends StatelessWidget {
  final VoidCallback onTap;

  const _DeleteButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final shapes = Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;

    return SizedBox(
      // Matches the 45px action-control height used by the glass icon
      // buttons in every header and the docked bottom CTAs — same reasoning
      // as the Edit button's `height: 45` beside it.
      height: 45,
      child: Material(
        // Error/50 light, Error/500-20%-alpha dark — see tintedErrorFill.
        color: cs.tintedErrorFill,
        borderRadius: BorderRadius.circular(shapes.buttonRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(shapes.buttonRadius),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppSvgImage.asset(
                  ImageConst.trash,
                  color: ColorConst.error500,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  ValueConst.deleteLabel,
                  style: TextStyleConst.textSmMedium(tt)
                      .copyWith(color: ColorConst.error500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
