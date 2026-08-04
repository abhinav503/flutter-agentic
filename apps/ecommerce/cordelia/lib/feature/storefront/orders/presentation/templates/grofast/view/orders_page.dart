import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';
import 'package:cordelia/feature/storefront/presentation/chromeless_page.dart';

import 'package:cordelia/di/injection_container.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';

import '../../../bloc/orders_bloc.dart';
import 'orders_screen.dart';

class OrdersPage extends BasePage {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends BasePageState<OrdersPage>
    with ChromelessStorefrontPage {
  @override
  Widget buildBody(BuildContext context) {
    // `!`: this route is only reachable from inside a storefront, which seeds
    // the cubit before any of its screens build.
    final storeId = context.read<ActiveStoreCubit>().state!.storeId;

    return BlocProvider(
      create: (_) => OrdersBloc(
        getOrdersUseCase: sl(),
        cancelOrderUseCase: sl(),
        storeId: storeId,
      )..add(const OrdersEvent.started()),
      child: const OrdersScreen(),
    );
  }
}
