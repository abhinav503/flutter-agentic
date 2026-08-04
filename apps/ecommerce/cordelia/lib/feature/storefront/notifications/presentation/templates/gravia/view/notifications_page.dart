import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';

import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/template/storefront_template.dart';

import '../../../bloc/notifications_bloc_provider.dart';
import 'notifications_screen.dart';

class NotificationsPage extends BasePage {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends BasePageState<NotificationsPage> {
  // NotificationsScreen renders its own coloured hero header (back +
  // centered title), per the pack's "coloured header canvas" composition —
  // same reasoning as Address/Cart.
  @override
  Widget buildBody(BuildContext context) {
    // `!`: this page only opens from inside a storefront, which seeds the
    // cubit before its first build.
    final store = context.read<ActiveStoreCubit>().state!;

    return notificationsBlocProvider(
      storeId: store.storeId,
      templateId: store.templateId.wireValue,
      child: const NotificationsScreen(),
    );
  }
}
