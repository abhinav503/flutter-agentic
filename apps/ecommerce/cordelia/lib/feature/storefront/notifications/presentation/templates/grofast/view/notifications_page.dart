import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';
import 'package:cordelia/feature/storefront/presentation/chromeless_page.dart';

import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';

import '../../../bloc/notifications_bloc_provider.dart';
import 'notifications_screen.dart';

/// `grofast` template's Notifications entry. Which pack's bundled list loads
/// follows the active store's own `template_id`, not a constant here — the
/// store picks the template, so it also picks the notifications.
class NotificationsPage extends BasePage {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends BasePageState<NotificationsPage>
    with ChromelessStorefrontPage {
  @override
  Widget buildBody(BuildContext context) {
    final store = context.read<ActiveStoreCubit>().state!;

    return notificationsBlocProvider(
      storeId: store.storeId,
      child: const NotificationsScreen(),
    );
  }
}
