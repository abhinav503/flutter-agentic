import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/di/injection_container.dart';

import 'notifications_bloc.dart';

/// The canonical [NotificationsBloc] construction + started dispatch, shared
/// by every template's Notifications page so the wiring can't drift per
/// pack. Only [storeId] is needed: the feed comes from the backend keyed on
/// the store, and the template decides only how it is drawn.
BlocProvider<NotificationsBloc> notificationsBlocProvider({
  required String storeId,
  required Widget child,
}) => BlocProvider(
  create: (_) => NotificationsBloc(
    getNotificationsUseCase: sl(),
    markNotificationsReadUseCase: sl(),
    storeId: storeId,
  )..add(const NotificationsEvent.started()),
  child: child,
);
