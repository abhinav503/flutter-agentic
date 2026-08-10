import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/active_store_capture.dart';
import 'package:cordelia/feature/storefront/presentation/chromeless_page.dart';

import '../../../bloc/orders_bloc_provider.dart';
import 'orders_screen.dart';

/// `gravia`'s My Orders as a **routed page**, for the jumps that reach it
/// from outside the shell (Profile's "My Orders", Checkout's "Track Your
/// Order"). The shell renders the same [OrdersScreen] in its own tab — this
/// only adds the page chrome and the bloc that the tab otherwise gets from
/// `ShellPage`.
class OrdersPage extends BasePage {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends BasePageState<OrdersPage>
    with ChromelessStorefrontPage, ActiveStoreCapture {
  @override
  Widget buildBody(BuildContext context) {
    // `!`: this route is only reachable from inside a storefront, which
    // seeds the cubit before any of its screens build.

    return ordersBlocProvider(storeId: storeId, child: const OrdersScreen());
  }
}
