import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/molecules/swipe_to_delete_row.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_icon_disc.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_sheet.dart';

import '../../../../domain/entities/address_entity.dart';

/// One saved address (kit frame `30 Checkout - Shipping Address`) — a
/// radius-16 card holding the kit's pin, the address tag, the composed
/// address line, an edit pencil and a trailing selection disc, swiped left
/// to reveal delete.
///
/// The card body is the tap target and selecting *is* confirming: the kit
/// gives this screen a single CTA ("Add New Address") and no confirm button,
/// so a two-step select-then-commit would leave the commit with nowhere to
/// live. Selected lifts to `surfaceContainerLow` behind a 1px primary
/// border — the same "this control is live" treatment the search field's
/// active state uses, and this pack's only other green border.
///
/// The kit's frame draws neither edit nor delete, so both are composed from
/// recipes the pack already owns rather than invented: the pencil is a
/// [DailyMartIconDisc] (Edit Profile's avatar-badge glyph at row scale), and
/// the swipe is core's [SwipeToDeleteRow] — the Cart row's reveal, so a
/// shopper who has removed a cart line already knows this gesture. Three
/// actions on one row, each with its own affordance: body taps select, the
/// pencil edits, a left swipe deletes.
class AddressCard extends StatelessWidget {
  final AddressEntity address;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AddressCard({
    super.key,
    required this.address,
    required this.selected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  /// Gates the swipe behind the pack's destructive-confirm sheet, then always
  /// answers `false`.
  ///
  /// The delete is a server round-trip the bloc awaits, so the row has to
  /// leave when the new list lands, not when the finger lifts: answering
  /// `true` would drop it optimistically, and a *failed* delete re-emits the
  /// same list — rebuilding a `Dismissible` the framework believes it already
  /// dismissed, which throws. Giving up the fling animation is what buys the
  /// row surviving a failed delete.
  Future<bool> _confirmDelete(BuildContext context) async {
    var confirmed = false;
    await showDailyMartConfirmSheet(
      context: context,
      title: DailyMartValueConst.deleteAddressTitle,
      message: DailyMartValueConst.deleteAddressMessage,
      confirmLabel: DailyMartValueConst.deleteLabel,
      onConfirm: () => confirmed = true,
    );
    if (confirmed) onDelete();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SwipeToDeleteRow(
      itemKey: address.id,
      confirmDismiss: () => _confirmDelete(context),
      borderRadius: AppRadius.xl,
      icon: AppSvgImage.asset(DailyMartImageConst.delete),
      child: _AddressCardBody(
        address: address,
        selected: selected,
        onTap: onTap,
        onEdit: onEdit,
      ),
    );
  }
}

/// The card face itself, split out so the [Dismissible] above wraps a widget
/// that owns no gesture of its own beyond its two taps.
class _AddressCardBody extends StatelessWidget {
  final AddressEntity address;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const _AddressCardBody({
    required this.address,
    required this.selected,
    required this.onTap,
    required this.onEdit,
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
          // Centred, not top-aligned as before the pencil landed: two
          // trailing controls of different diameters read as crooked when
          // hung from the top of a two-line text block.
          child: Row(
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
              Tooltip(
                message: DailyMartValueConst.editAddressTooltip,
                child: DailyMartIconDisc(
                  asset: DailyMartImageConst.pencil,
                  // Smaller than the pack's 48px back disc, for the same
                  // reason the product card's overlay controls are: this is
                  // a secondary action riding a row whose whole body is
                  // already the primary target.
                  size: DailyMartDimenConst.addressActionSize,
                  iconSize: AppSpacing.base,
                  // A step lighter than the card it sits on, so the disc
                  // reads as a control rather than dissolving into the card.
                  backgroundColor: cs.surface,
                  foregroundColor: cs.onSurfaceVariant,
                  onTap: onEdit,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
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
