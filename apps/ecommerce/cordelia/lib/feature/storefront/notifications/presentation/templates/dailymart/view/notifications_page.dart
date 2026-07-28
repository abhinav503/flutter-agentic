import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';

import 'package:cordelia/di/injection_container.dart';
import 'package:cordelia/feature/storefront/template/storefront_template.dart';

import '../../../bloc/notifications_bloc.dart';
import 'notifications_screen.dart';

class NotificationsPage extends BasePage {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends BasePageState<NotificationsPage> {
  /// No app bar anywhere in this pack — `NotificationsScreen` renders the
  /// header row as the first item of its own scroll view (spec sheet §8).
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Color? backgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  @override
  Widget buildBody(BuildContext context) => BlocProvider(
    create: (_) =>
        NotificationsBloc(getNotificationsUseCase: sl())
          ..add(
          const NotificationsEvent.started(
            template: StorefrontTemplate.dailymart,
          ),
        ),
    child: const NotificationsScreen(),
  );
}
