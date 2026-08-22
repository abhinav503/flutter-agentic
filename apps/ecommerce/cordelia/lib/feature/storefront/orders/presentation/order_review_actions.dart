import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_screen.dart';

import 'package:cordelia/constants/value_const.dart';

import '../domain/entities/order_entity.dart';
import 'bloc/orders_bloc.dart';

/// Rating a **delivered order** — how the delivery went, which is a
/// different question from what the shopper thought of a product (that's
/// `ProductReviewsActions`, and it's open to anyone signed in).
///
/// Shared by every screen that can offer the action: each pack's order card
/// and its Track Order. Only the sheet chrome differs per pack, which is
/// the one override below — the sheet *body* is the same widget the product
/// reviews use, since a rating form is a rating form.
mixin OrderReviewActions<T extends BaseScreen> on BaseScreenState<T> {
  /// The pack's own rate-order sheet, seeded with what was rated before
  /// (0/'' the first time). Implementations hand [rateOrder] to their body.
  Future<void> showRateOrderSheet({
    required int initialRating,
    required String initialText,
    required Future<String?> Function(int rating, String text) onSubmit,
  });

  /// Opens the sheet for [order] and dispatches its result. Refuses an order
  /// that hasn't arrived — the server refuses it too, so a sheet here would
  /// only collect a rating it then had to throw away.
  Future<void> rateOrder(OrderEntity order) async {
    if (!order.canBeRated) {
      showSnackBar(ValueConst.orderRatingNotDeliveredMessage);
      return;
    }
    final bloc = context.read<OrdersBloc>();
    await showRateOrderSheet(
      initialRating: order.rating,
      initialText: order.reviewText,
      onSubmit: (rating, text) => _submitRating(bloc, order.id, rating, text),
    );
  }

  /// Dispatches the rating and resolves to its failure message, or null once
  /// it landed — so the sheet keeps what the shopper wrote when it fails,
  /// instead of closing and losing it behind a snackbar.
  ///
  /// Subscribing before dispatching, not after: `add` is synchronous and the
  /// handler's first `emit` can land in the same turn. `_onRated` answers on
  /// every path, including the stale-tap guard, so this cannot hang — and
  /// the one path it cannot answer from (a list that never loaded) is
  /// refused here before anything is dispatched.
  Future<String?> _submitRating(
    OrdersBloc bloc,
    String orderId,
    int rating,
    String text,
  ) async {
    if (bloc.state is! OrdersLoaded) return ValueConst.orderRatingFailedMessage;

    final settled = bloc.stream.first;
    bloc.add(OrdersEvent.rated(orderId: orderId, rating: rating, text: text));
    final state = await settled;

    return state is OrdersLoaded && state.rateFailed
        ? ValueConst.orderRatingFailedMessage
        : null;
  }
}
