import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';

import 'package:gravia/di/injection_container.dart';

import '../bloc/notifications_bloc.dart';
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
  Widget buildBody(BuildContext context) => BlocProvider(
    create: (_) =>
        NotificationsBloc(getNotificationsUseCase: sl())
          ..add(const NotificationsEvent.started()),
    child: const NotificationsScreen(),
  );
}
