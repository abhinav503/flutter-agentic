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

    // Rating writes through this bloc; cancel still pops the order id back
    // to the list that owns the optimistic update (see TrackOrderScreen).
    return ordersBlocProvider(
      storeId: storeId,
      child: TrackOrderScreen(order: widget.order),
    );
  }
}
