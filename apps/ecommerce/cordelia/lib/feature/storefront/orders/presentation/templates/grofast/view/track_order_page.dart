import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';
import 'package:cordelia/feature/storefront/presentation/chromeless_page.dart';

import 'package:cordelia/di/injection_container.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/orders/domain/entities/order_entity.dart';

import '../../../bloc/orders_bloc.dart';
import 'track_order_screen.dart';

/// Route host for `grofast`'s Track Order. It provides its own [OrdersBloc]
/// so the screen can cancel — the bloc's warm-start cache means this doesn't
/// re-shimmer the list the shopper just came from.
class TrackOrderPage extends BasePage {
  final OrderEntity order;

  const TrackOrderPage({super.key, required this.order});

  @override
  State<TrackOrderPage> createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends BasePageState<TrackOrderPage>
    with ChromelessStorefrontPage {
  @override
  Widget buildBody(BuildContext context) {
    final storeId = context.read<ActiveStoreCubit>().state!.storeId;

    return BlocProvider(
      create: (_) => OrdersBloc(
        getOrdersUseCase: sl(),
        cancelOrderUseCase: sl(),
        storeId: storeId,
      )..add(const OrdersEvent.started()),
      child: TrackOrderScreen(order: widget.order),
    );
  }
}
