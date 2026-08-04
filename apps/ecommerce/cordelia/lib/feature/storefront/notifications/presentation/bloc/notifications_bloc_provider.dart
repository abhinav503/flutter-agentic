import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/di/injection_container.dart';

import 'notifications_bloc.dart';

/// The canonical [NotificationsBloc] construction + started dispatch, shared
/// by every template's Notifications page so the wiring can't drift per
/// pack. [templateId] is the active store's `template_id` wire string
/// (`ActiveStoreEntity.templateId.wireValue`) — store data, which is why the
/// bloc takes it rather than a `StorefrontTemplate`.
BlocProvider<NotificationsBloc> notificationsBlocProvider({
  required String storeId,
  required String templateId,
  required Widget child,
}) => BlocProvider(
  create: (_) => NotificationsBloc(
    getNotificationsUseCase: sl(),
    storeId: storeId,
    templateId: templateId,
  )..add(const NotificationsEvent.started()),
  child: child,
);
