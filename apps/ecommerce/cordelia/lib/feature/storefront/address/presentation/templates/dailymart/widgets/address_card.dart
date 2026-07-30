import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';

import '../../../../domain/entities/address_entity.dart';

/// One saved address (kit frame `30 Checkout - Shipping Address`) — a
/// radius-16 card holding the kit's pin, the address tag, the composed
/// address line, and a trailing selection disc.
///
/// The whole card is the tap target and selecting *is* confirming: the kit
/// gives this screen a single CTA ("Add New Address") and no confirm button,
/// so a two-step select-then-commit would leave the commit with nowhere to
/// live. Selected lifts to `surfaceContainerLow` behind a 1px primary
/// border — the same "this control is live" treatment the search field's
/// active state uses, and this pack's only other green border.
///
/// Edit and delete actions aren't drawn here: the kit's frame has none yet.
class AddressCard extends StatelessWidget {
  final AddressEntity address;
  final bool selected;
  final VoidCallback onTap;

  const AddressCard({
    super.key,
    required this.address,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: selected ? cs.surfaceContainerLow : cs.surfaceContainer,
      borderRadius: AppRadius.xl,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.xl,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: AppRadius.xl,
            border: Border.all(
              color: selected ? cs.primary : Colors.transparent,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSvgImage.asset(
                DailyMartImageConst.location,
                color: cs.onSurfaceVariant,
                width: AppSpacing.xl4,
                height: AppSpacing.xl4,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.tag,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DailyMartTextStyleConst.bodyMdSemibold(
                        tt,
                      ).copyWith(color: cs.onSurface),
                    ),
                    const SizedBox(height: AppSpacing.xs3),
                    Text(
                      address.displayLine,
                      style: DailyMartTextStyleConst.bodySmRegular(
                        tt,
                      ).copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              _SelectionDisc(selected: selected),
            ],
          ),
        ),
      ),
    );
  }
}

/// The kit draws two unrelated silhouettes here rather than one control in
/// two states: a filled green disc with a white tick when selected, a bare
/// `outline` ring when not — so this is a switch on the state, not a
/// [Checkbox] with overridden colours.
class _SelectionDisc extends StatelessWidget {
  final bool selected;

  const _SelectionDisc({required this.selected});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: DailyMartDimenConst.addressCheckSize,
      height: DailyMartDimenConst.addressCheckSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? cs.primary : Colors.transparent,
        border: selected ? null : Border.all(color: cs.outline),
      ),
      child: selected
          ? AppSvgImage.asset(
              DailyMartImageConst.check,
              color: cs.onPrimary,
              width: 11,
              height: 9,
            )
          : null,
    );
  }
}
