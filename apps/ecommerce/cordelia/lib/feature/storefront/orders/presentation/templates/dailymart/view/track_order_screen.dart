import 'package:flutter/material.dart';

import 'package:core/core/extensions/num_extensions.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/enums/order_status.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_screen_body.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_outline_button.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_section_header.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_sheet.dart';

import 'package:cordelia/feature/support/presentation/view/support_order_link.dart';
import 'package:cordelia/constants/value_const.dart';

import '../../../../../reviews/presentation/templates/dailymart/widgets/write_review_sheet_content.dart';
import '../../../../domain/entities/order_entity.dart';
import '../../../bloc/orders_bloc.dart';
import '../../../order_review_actions.dart';
import '../widgets/order_item_row.dart';
import '../widgets/order_status_timeline.dart';

/// `dailymart` template's Track Order (kit frame `36`) — everything the
/// order contains, its details and payment, and the dated status timeline.
///
/// The kit heads this frame with the same single-product card My Orders
/// lists, which is wrong here: that card stands for a whole order by its
/// *first* line item, so on the one screen dedicated to a single order it
/// hid every other thing the shopper bought. It's replaced by the full
/// Order List — Checkout's row silhouette, read-only — so the basket is
/// itemised where it matters. The order's identity and total have their own
/// blocks below (Order Details, Payment), so nothing the card carried is
/// lost.
///
/// The order arrives whole via `extra` from My Orders, so the screen paints
/// without fetching; it then reads the bloc's copy of that order
/// (`OrdersState.freshest`) so a rating saved here shows immediately.
///
/// **Cancel** still reports back by popping the order id rather than
/// dispatching: it applies optimistically and reconciles against the list,
/// which belongs to the bloc `OrdersScreen` owns — two instances racing that
/// would let them disagree. Rating has nothing optimistic to reconcile, so
/// it goes straight through this page's own bloc into the shared cache.
///
/// Two departures from the frame, both because the data isn't there to back
/// it (see [DailyMartOrderStatusTimeline] for the third, its six steps):
/// - **Expected Delivery** is dropped. No order carries an ETA, and deriving
///   one from `placedAt` would be a promise the store never made.
/// - **Tracking ID** becomes the order id, which is the real identifier a
///   shopper would quote to support; there is no carrier integration behind
///   the kit's `IDX…`. The delivery OTP joins it while the order is out,
///   since that's the number the shopper actually needs at the door.
///
/// The frame's "Trending product" heading above those rows is kit
/// boilerplate copy-pasted from Home — the rows under it are order details,
/// so it's titled as such. The Payment block below them isn't in the frame
/// at all: an order screen that never says what was paid, or where a refund
/// on a cancelled order has got to, sends the shopper to support for
/// something the app already knows.
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
    required void Function(int rating, String text) onSubmit,
  }) => showDailyMartSheet<void>(
    title: ValueConst.rateOrderSheetTitle,
    child: DailyMartWriteReviewSheetContent(
      initialRating: initialRating,
      initialText: initialText,
      textLabel: ValueConst.rateOrderTextLabel,
      textHint: ValueConst.rateOrderTextHint,
      onSubmit: onSubmit,
      onMessage: showSnackBar,
    ),
  );

  void _confirmCancel() => showDailyMartConfirmSheet(
    context: context,
    title: DailyMartValueConst.cancelOrderTitle,
    message: DailyMartValueConst.cancelOrderMessage,
    confirmLabel: DailyMartValueConst.cancelOrderConfirmLabel,
    onConfirm: () => context.pop(widget.order.id),
  );

  Future<void> _copy(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    showSnackBar(DailyMartValueConst.copiedMessage);
  }

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) => BlocConsumer<OrdersBloc, OrdersState>(
    listener: (context, state) {
      if (state case OrdersLoaded(rateFailed: true)) {
        showSnackBar(ValueConst.orderRatingFailedMessage);
      }
    },
    // The routed order is a snapshot; once the list has loaded, its copy
    // is the one that carries a rating saved from this screen.
    builder: (context, state) =>
        _content(context, state.freshest(widget.order)),
  );

  Widget _content(BuildContext context, OrderEntity order) {
    // Only meaningful while the order is out for delivery — a delivered or
    // cancelled order has nothing left to hand over.
    final showOtp =
        order.status == OrderStatus.inProcess && order.deliveryOtp.isNotEmpty;
    final refund = DailyMartValueConst.refundStatusLabel(order.refundStatus);
    final canCancel = order.status.isUpcoming;

    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        // The bottom edge belongs to the shell (its CTA clearance or device
        // inset), so the fade behind the CTA can bleed to the edge.
        bottom: false,
        child: DailyMartScreenBody(
          title: DailyMartValueConst.trackOrderTitle,
          onBack: () => context.pop(),
          gap: AppSpacing.xl2,
          // Not in the kit's frame, which gives this screen no action at
          // all — but the shopper self-cancel is a shipped capability and
          // this pack's order card has no room for it, so dropping it
          // would cost dailymart shoppers a feature rather than reproduce
          // a design decision. Floating over the fade, not a full-width
          // docked bar: this pack has exactly one docked surface (the Cart
          // screen's checkout bar) and this isn't it (spec sheet §8).
          // Cancel while it's coming; once it has arrived the same slot
          // asks how the delivery went. A cancelled order gets neither —
          // nothing left to stop, and no delivery to rate.
          floatingAction: order.canBeRated
              ? DailyMartOutlineButton(
                  label: order.isRated
                      ? ValueConst.editOrderRatingLabel
                      : ValueConst.rateOrderLabel,
                  onTap: () => rateOrder(order),
                )
              : canCancel
              ? DailyMartOutlineButton(
                  label: DailyMartValueConst.cancelOrderLabel,
                  onTap: _confirmCancel,
                )
              : null,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DailyMartSectionHeader(title: DailyMartValueConst.orderListLabel),
              const SizedBox(height: AppSpacing.base),
              for (var i = 0; i < order.items.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.base),
                DailyMartOrderItemRow(item: order.items[i]),
              ],
              const SizedBox(height: AppSpacing.lg),
              DailyMartSectionHeader(
                title: DailyMartValueConst.orderDetailsTitle,
              ),
              const SizedBox(height: AppSpacing.xs),
              _DetailRow(
                label: DailyMartValueConst.orderIdLabel,
                value: order.id,
                onCopy: () => _copy(order.id),
              ),
              if (showOtp) ...[
                const SizedBox(height: AppSpacing.xs3),
                _DetailRow(
                  label: DailyMartValueConst.deliveryOtpLabel,
                  value: order.deliveryOtp,
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              DailyMartSectionHeader(title: DailyMartValueConst.paymentTitle),
              const SizedBox(height: AppSpacing.xs),
              _DetailRow(
                label: DailyMartValueConst.amountPaidLabel,
                // Net of the coupon and inclusive of delivery — the figure
                // the server actually charged.
                value: order.payableTotal.asPrice,
              ),
              if (order.couponCode.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs3),
                _DetailRow(
                  label: DailyMartValueConst.couponDetailLabel,
                  value: DailyMartValueConst.couponDetailValue(
                    order.couponCode,
                    order.couponDiscount.asPrice,
                  ),
                ),
              ],
              // Shown only when the order carried one — free delivery needs
              // no row to explain the total.
              if (order.deliveryFee > 0) ...[
                const SizedBox(height: AppSpacing.xs3),
                _DetailRow(
                  label: DailyMartValueConst.deliveryLabel,
                  value: order.deliveryFee.asPrice,
                ),
              ],
              const SizedBox(height: AppSpacing.xs3),
              _DetailRow(
                label: DailyMartValueConst.paymentIdLabel,
                // A payment-less (test-mode) order has no reference to
                // quote — say so rather than render an empty right edge.
                value: order.paymentId.isEmpty
                    ? DailyMartValueConst.noOnlinePaymentLabel
                    : order.paymentId,
                onCopy: order.paymentId.isEmpty
                    ? null
                    : () => _copy(order.paymentId),
              ),
              // Only once money has actually moved back — an order that
              // was never paid for has nothing to report here.
              if (refund != null) ...[
                const SizedBox(height: AppSpacing.xs3),
                _DetailRow(
                  label: DailyMartValueConst.refundLabel,
                  value: refund,
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              DailyMartSectionHeader(
                title: DailyMartValueConst.orderStatusTitle,
              ),
              const SizedBox(height: AppSpacing.base),
              DailyMartOrderStatusTimeline(order: order),
              const SizedBox(height: AppSpacing.xs),
              SupportOrderLink(orderId: order.id),
            ],
          ),
        ),
      ),
    );
  }
}

/// One label/value line of the details block — muted label left, ink value
/// right, both at 14 with the value a weight heavier (kit frame `36`).
///
/// [onCopy] adds a tap-to-copy glyph immediately before the value, for the
/// rows carrying an id a shopper would hand to support. A Material symbol:
/// the kit exports no copy glyph, same fallback the pack's Orders and Dark
/// Mode rows make.
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
          style: DailyMartTextStyleConst.bodySmRegular(
            tt,
          ).copyWith(color: cs.onSurfaceVariant),
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
                    color: cs.onSurfaceVariant,
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
                  style: DailyMartTextStyleConst.bodySmMedium(
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
