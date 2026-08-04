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
    required void Function(int rating, String text) onSubmit,
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
      onSubmit: (rating, text) => bloc.add(
        OrdersEvent.rated(orderId: order.id, rating: rating, text: text),
      ),
    );
  }
}
