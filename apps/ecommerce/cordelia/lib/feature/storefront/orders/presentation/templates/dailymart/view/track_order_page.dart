import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/active_store_capture.dart';
import 'package:cordelia/feature/storefront/presentation/chromeless_page.dart';

import '../../../../domain/entities/order_entity.dart';
import '../../../bloc/orders_bloc_provider.dart';
import 'track_order_screen.dart';

class TrackOrderPage extends BasePage {
  final OrderEntity order;

  const TrackOrderPage({super.key, required this.order});

  @override
  State<TrackOrderPage> createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends BasePageState<TrackOrderPage>
    with ChromelessStorefrontPage, ActiveStoreCapture {
  @override
  Widget buildBody(BuildContext context) {
    // `!`: this route is only reachable from inside a storefront, which
    // seeds the cubit before any of its screens build.

    // The screen's *cancel* still reports back by popping the order id, so
    // the list's optimistic update and warm cache stay with the one bloc
    // that owns them (see TrackOrderScreen). This provider is for rating,
    // which is a plain server write with nothing optimistic to reconcile —
    // it lands in the same `ScopedBlocCache` the list reads, so the two
    // can't disagree. Same shape grofast's Track Order already uses.
    return ordersBlocProvider(
      storeId: storeId,
      child: TrackOrderScreen(order: widget.order),
    );
  }
}
