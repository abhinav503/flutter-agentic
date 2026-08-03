import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';

import 'package:cordelia/di/injection_container.dart';
import 'package:cordelia/feature/storefront/template/storefront_template.dart';

import '../../../bloc/notifications_bloc.dart';
import 'notifications_screen.dart';

/// `grofast` template's Notifications entry. The bloc is told which pack's
/// bundled list to load — a compile-time constant here, so a template can
/// never render another's notifications.
class NotificationsPage extends BasePage {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends BasePageState<NotificationsPage> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Color? backgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  @override
  Widget buildBody(BuildContext context) => BlocProvider(
    create: (_) => NotificationsBloc(getNotificationsUseCase: sl())
      ..add(
        const NotificationsEvent.started(template: StorefrontTemplate.grofast),
      ),
    child: const NotificationsScreen(),
  );
}
