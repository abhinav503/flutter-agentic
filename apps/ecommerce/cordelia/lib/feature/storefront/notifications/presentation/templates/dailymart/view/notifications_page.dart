import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/active_store_capture.dart';
import 'package:cordelia/feature/storefront/presentation/chromeless_page.dart';

import '../../../bloc/notifications_bloc_provider.dart';
import 'notifications_screen.dart';

class NotificationsPage extends BasePage {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends BasePageState<NotificationsPage>
    with ChromelessStorefrontPage, ActiveStoreCapture {
  @override
  Widget buildBody(BuildContext context) {
    final store = activeStore;

    return notificationsBlocProvider(
      storeId: store.storeId,
      child: const NotificationsScreen(),
    );
  }
}
