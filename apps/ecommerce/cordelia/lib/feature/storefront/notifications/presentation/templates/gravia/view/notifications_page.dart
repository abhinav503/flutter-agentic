import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';

import 'package:cordelia/feature/storefront/active_store/presentation/active_store_capture.dart';

import '../../../bloc/notifications_bloc_provider.dart';
import 'notifications_screen.dart';

class NotificationsPage extends BasePage {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends BasePageState<NotificationsPage>
    with ActiveStoreCapture {
  // NotificationsScreen renders its own coloured hero header (back +
  // centered title), per the pack's "coloured header canvas" composition —
  // same reasoning as Address/Cart.
  @override
  Widget buildBody(BuildContext context) {
    // `!`: this page only opens from inside a storefront, which seeds the
    // cubit before its first build.
    final store = activeStore;

    return notificationsBlocProvider(
      storeId: store.storeId,
      child: const NotificationsScreen(),
    );
  }
}
