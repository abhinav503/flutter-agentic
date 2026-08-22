import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/rating_stars.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/blocks/ecommerce/price_breakdown.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/support/presentation/support_order_link.dart';
import 'package:cordelia/enums/order_status.dart';
import 'package:cordelia/feature/storefront/address/domain/entities/address_entity.dart';
import 'package:cordelia/templates/gravia/constants/gravia_color_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_dimen_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/extensions/gravia_order_labels.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_action_pair.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_hero_header.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_otp_digits.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_sheet.dart';

import '../../../../../reviews/presentation/templates/gravia/widgets/write_review_sheet_content.dart';
import '../../../../domain/entities/order_entity.dart';
import '../../../bloc/orders_bloc.dart';
import '../../../order_review_actions.dart';
import '../widgets/order_line_item_row.dart';
import '../widgets/order_status_timeline.dart';

/// `gravia` template's Track Order — the one screen dedicated to a single
/// order: its dated status timeline, the delivery OTP while it's out, what
/// it contains, what was paid, and where it's going.
///
/// The Gravia kit draws no Track Order frame (recorded in the spec sheet),
/// so this is composed from recipes the pack already owns: the collapsing
/// hero header every routed screen uses, `OrderLineItemRow` from the order
/// card, the `PriceBreakdown` block the Cart totals use, and the pack's
/// hairline-divided section rhythm.
///
/// The order arrives whole through `extra` from My Orders, so the screen
/// paints without fetching; it then reads the bloc's copy
/// (`OrdersState.freshest`) so a rating saved here shows immediately.
///
/// **Cancel** reports back by popping the order id instead of dispatching —
/// it applies optimistically and reconciles against the list, which belongs
/// to the bloc `OrdersScreen` owns; two instances racing that would let them
/// disagree. Rating has nothing optimistic to reconcile, so it goes straight
/// through this page's own bloc. Same split both other packs make.
class TrackOrderScreen extends BaseScreen {
  final OrderEntity order;

  const TrackOrderScreen({super.key, required this.order});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends BaseScreenState<TrackOrderScreen>
    with OrderReviewActions {
  @override
  Future<void> showRateOrderSheet({
    required int initialRating,
    required String initialText,
    required Future<String?> Function(int rating, String text) onSubmit,
  }) => showGraviaSheet<void>(
    title: ValueConst.rateOrderSheetTitle,
    child: GraviaWriteReviewSheetContent(
      initialRating: initialRating,
      initialText: initialText,
      textLabel: ValueConst.rateOrderTextLabel,
      textHint: ValueConst.rateOrderTextHint,
      onSubmit: onSubmit,
    ),
  );

  void _confirmCancel() => showGraviaConfirmSheet(
    context: context,
    title: GraviaValueConst.cancelOrderConfirmTitle,
    message: GraviaValueConst.cancelOrderConfirmBody,
    confirmLabel: GraviaValueConst.cancelOrderConfirmCta,
    onConfirm: () => context.pop(widget.order.id),
  );

  Future<void> _copy(String value) =>
      copyToClipboard(value, GraviaValueConst.copiedMessage);

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.lightStatusIcons;

  @override
  Widget body(BuildContext context) => BlocConsumer<OrdersBloc, OrdersState>(
    listener: (context, state) {
      if (state case OrdersLoaded(rateFailed: true)) {
        showSnackBar(ValueConst.orderRatingFailedMessage);
      }
    },
    // The routed order is a snapshot; once the list has loaded, its copy is
    // the one carrying a rating saved from this screen.
    builder: (context, state) =>
        _content(context, state.freshest(widget.order)),
  );

  Widget _content(BuildContext context, OrderEntity order) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final hairline = context.appColors.dockedHairline;
    // Only meaningful while the order is out for delivery — a delivered or
    // cancelled order has nothing left to hand over.
    final showOtp =
        order.status == OrderStatus.inProcess && order.deliveryOtp.isNotEmpty;
    final refundNote = order.refundStatus.label;

    Widget divider() => Column(
      children: [
        const SizedBox(height: AppSpacing.xl2),
        Divider(color: hairline, height: 1, thickness: 1),
        const SizedBox(height: AppSpacing.xl2),
      ],
    );

    return Column(
      children: [
        Expanded(
          child: CollapsingHeaderSheet(
            initialHeaderHeight: GraviaDimenConst.headerHeightRegular,
            header: GraviaHeroHeader(
              title: GraviaValueConst.trackOrderTitle,
              onBack: () => context.pop(),
            ),
            body: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(GraviaValueConst.orderStatusTitle),
                  const SizedBox(height: AppSpacing.base),
                  GraviaOrderStatusTimeline(order: order),
                  if (refundNote != null) ...[
                    const SizedBox(height: AppSpacing.base),
                    Text(
                      refundNote,
                      style: GraviaTextStyleConst.textSmRegular(tt).copyWith(
                        color: order.refundStatus == RefundStatus.failed
                            ? cs.error
                            : GraviaColorConst.gray500,
                      ),
                    ),
                  ],
                  if (showOtp) ...[
                    divider(),
                    Row(
                      children: [
                        Text(
                          GraviaValueConst.deliveryOtpLabel,
                          style: GraviaTextStyleConst.textMdBold(
                            tt,
                          ).copyWith(color: cs.onSurface),
                        ),
                        const Spacer(),
                        GraviaOtpDigits(otp: order.deliveryOtp),
                      ],
                    ),
                  ],
                  divider(),
                  _SectionTitle(GraviaValueConst.orderItemsTitle),
                  const SizedBox(height: AppSpacing.base),
                  for (var i = 0; i < order.items.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.base),
                    OrderLineItemRow(item: order.items[i]),
                  ],
                  divider(),
                  _SectionTitle(GraviaValueConst.orderSummaryTitle),
                  const SizedBox(height: AppSpacing.base),
                  PriceBreakdown(
                    lines: [
                      PriceLine(
                        label: GraviaValueConst.itemTotalLabel,
                        value: order.totalPrice.asPrice,
                        labelStyle: GraviaTextStyleConst.textSmRegular(
                          tt,
                        ).copyWith(color: cs.onSurfaceVariant),
                        valueStyle: GraviaTextStyleConst.textSmMedium(
                          tt,
                        ).copyWith(color: cs.onSurface),
                      ),
                      if (order.couponCode.isNotEmpty)
                        PriceLine(
                          label: GraviaValueConst.couponLineLabel(
                            order.couponCode,
                          ),
                          value: '- ${order.couponDiscount.asPrice}',
                          labelStyle: GraviaTextStyleConst.textSmRegular(
                            tt,
                          ).copyWith(color: cs.onSurfaceVariant),
                          valueStyle: GraviaTextStyleConst.textSmMedium(
                            tt,
                          ).copyWith(color: cs.primary),
                        ),
                      // Only when the order actually carried a fee: an order
                      // delivered free has nothing to account for between
                      // the items and the total.
                      if (order.deliveryFee > 0)
                        PriceLine(
                          label: GraviaValueConst.deliveryLabel,
                          value: order.deliveryFee.asPrice,
                          labelStyle: GraviaTextStyleConst.textSmRegular(
                            tt,
                          ).copyWith(color: cs.onSurfaceVariant),
                          valueStyle: GraviaTextStyleConst.textSmMedium(
                            tt,
                          ).copyWith(color: cs.onSurface),
                        ),
                    ],
                    total: PriceLine(
                      label: GraviaValueConst.orderTotalLabel,
                      // Net of the coupon and inclusive of delivery — the
                      // figure the server charged.
                      value: order.payableTotal.asPrice,
                      labelStyle: GraviaTextStyleConst.textMdBold(
                        tt,
                      ).copyWith(color: cs.onSurface),
                      valueStyle: GraviaTextStyleConst.textMdBold(
                        tt,
                      ).copyWith(color: cs.onSurface),
                    ),
                    dividerColor: hairline,
                  ),
                  divider(),
                  _SectionTitle(GraviaValueConst.orderDetailsTitle),
                  const SizedBox(height: AppSpacing.base),
                  _DetailRow(
                    label: GraviaValueConst.orderIdLabel,
                    value: order.id,
                    onCopy: () => _copy(order.id),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _DetailRow(
                    label: GraviaValueConst.orderPlacedOnLabel,
                    value: order.placedAt.orderPlacedLabel,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _DetailRow(
                    label: GraviaValueConst.paymentIdLabel,
                    // A payment-less (test-mode) order has no reference to
                    // quote — say so rather than leave the row empty.
                    value: order.paymentId.isEmpty
                        ? GraviaValueConst.noOnlinePaymentLabel
                        : order.paymentId,
                    onCopy: order.paymentId.isEmpty
                        ? null
                        : () => _copy(order.paymentId),
                  ),
                  if (order.isRated) ...[
                    const SizedBox(height: AppSpacing.xs),
                    _RatingRow(order: order),
                  ],
                  if (order.deliveryAddress case final address?) ...[
                    divider(),
                    _SectionTitle(GraviaValueConst.deliveryAddressTitle),
                    const SizedBox(height: AppSpacing.base),
                    Text(
                      address.name,
                      style: GraviaTextStyleConst.textSmMedium(
                        tt,
                      ).copyWith(color: cs.onSurface),
                    ),
                    const SizedBox(height: AppSpacing.xs4),
                    Text(
                      address.displayLine,
                      style: GraviaTextStyleConst.textSmRegular(
                        tt,
                      ).copyWith(color: GraviaColorConst.gray500),
                    ),
                  ],
                  divider(),
                  SupportOrderLink(orderId: order.id),
                ],
              ),
            ),
          ),
        ),
        // Cancel while it's still coming; once it has arrived the same slot
        // asks how the delivery went. A cancelled order gets neither —
        // nothing left to stop, and no delivery to rate.
        if (order.status.isUpcoming || order.canBeRated)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.base,
                AppSpacing.lg,
                AppSpacing.base,
              ),
              child: GraviaActionButton(
                action: order.canBeRated
                    ? GraviaAction(
                        label: order.isRated
                            ? ValueConst.editOrderRatingLabel
                            : ValueConst.rateOrderLabel,
                        kind: GraviaActionKind.primary,
                        onTap: () => rateOrder(order),
                      )
                    : GraviaAction(
                        label: GraviaValueConst.cancelOrderLabel,
                        kind: GraviaActionKind.tintedError,
                        onTap: _confirmCancel,
                      ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: GraviaTextStyleConst.textLgBold(
      Theme.of(context).textTheme,
    ).copyWith(color: Theme.of(context).colorScheme.onSurface),
  );
}

/// One label/value line of the details block — muted label left, ink value
/// right. [onCopy] adds a tap-to-copy glyph for the rows carrying an id a
/// shopper would hand to support (a Material symbol; the kit exports none).
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onCopy;

  const _DetailRow({required this.label, required this.value, this.onCopy});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        Text(
          label,
          style: GraviaTextStyleConst.textSmRegular(
            tt,
          ).copyWith(color: GraviaColorConst.gray500),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onCopy != null) ...[
                InkResponse(
                  onTap: onCopy,
                  radius: AppSpacing.xl2,
                  child: Icon(
                    Icons.copy_rounded,
                    size: AppSpacing.lg,
                    color: GraviaColorConst.gray500,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs2),
              ],
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GraviaTextStyleConst.textSmMedium(
                    tt,
                  ).copyWith(color: cs.onSurface),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The rating the shopper gave this delivery, in the details block — the
/// same label/value rhythm, with stars standing in for the value.
class _RatingRow extends StatelessWidget {
  final OrderEntity order;

  const _RatingRow({required this.order});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              ValueConst.yourRatingLabel,
              style: GraviaTextStyleConst.textSmRegular(
                tt,
              ).copyWith(color: GraviaColorConst.gray500),
            ),
            const Spacer(),
            RatingStars(rating: order.rating.toDouble(), size: AppSpacing.base),
          ],
        ),
        if (order.reviewText.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs2),
          Text(
            order.reviewText,
            style: GraviaTextStyleConst.textSmRegular(
              tt,
            ).copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}
