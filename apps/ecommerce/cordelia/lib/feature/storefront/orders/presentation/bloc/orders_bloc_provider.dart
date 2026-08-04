import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/di/injection_container.dart';

import 'orders_bloc.dart';

/// The canonical [OrdersBloc] construction + started dispatch, shared by
/// every template's Orders host (shell tab or routed page) so the wiring
/// can't drift per pack.
BlocProvider<OrdersBloc> ordersBlocProvider({
  required String storeId,
  required Widget child,
}) => BlocProvider(
  create: (_) => OrdersBloc(
    getOrdersUseCase: sl(),
    cancelOrderUseCase: sl(),
    rateOrderUseCase: sl(),
    storeId: storeId,
  )..add(const OrdersEvent.started()),
  child: child,
);
