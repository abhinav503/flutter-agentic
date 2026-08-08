import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cordelia/services/notification/firebase_messaging_service.dart';

import '../../domain/entities/notification_section_entity.dart';
import '../../domain/usecase/get_notifications_usecase.dart';
import '../../domain/usecase/mark_notifications_read_usecase.dart';

part 'notifications_bloc.freezed.dart';
part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase _getNotifications;
  final MarkNotificationsReadUseCase _markRead;
  final String _storeId;

  NotificationsBloc({
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkNotificationsReadUseCase markNotificationsReadUseCase,
    required String storeId,
  }) : _getNotifications = getNotificationsUseCase,
       _markRead = markNotificationsReadUseCase,
       // An initializing formal can't be used here: the fields are private and
       // Dart forbids a named parameter starting with an underscore.
       // ignore: prefer_initializing_formals
       _storeId = storeId,
       super(const NotificationsState.loading()) {
    on<NotificationsStarted>(_onStarted);
    on<NotificationsPermissionRequested>(_onPermissionRequested);
  }

  /// The permission gate comes before the fetch, deliberately: a notification
  /// centre the shopper is not being notified from is the wrong thing to
  /// show first, and asking after the list has rendered buries the ask.
  Future<void> _onStarted(
    NotificationsStarted event,
    Emitter<NotificationsState> emit,
  ) async {
    if (!await FirebaseMessagingService.instance.isPermissionGranted()) {
      emit(const NotificationsState.permissionRequired());
      return;
    }
    await _load(emit);
  }

  Future<void> _onPermissionRequested(
    NotificationsPermissionRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(const NotificationsState.permissionRequired(requesting: true));

    if (!await FirebaseMessagingService.instance.requestPermission()) {
      // No dialog was shown — the shopper answered this once already, so the
      // only thing left to tell them is where the switch lives.
      emit(const NotificationsState.permissionRequired(blocked: true));
      return;
    }

    emit(const NotificationsState.loading());
    await _load(emit);
  }

  /// The fetch every path shares, once permission is settled.
  Future<void> _load(Emitter<NotificationsState> emit) async {
    final result = await _getNotifications(
      GetNotificationsParams(storeId: _storeId),
    );
    result.fold(
      (failure) => emit(NotificationsState.error(message: failure.message)),
      (sections) {
        emit(NotificationsState.loaded(sections: sections));
        _acknowledge(sections);
      },
    );
  }

  /// Marks everything just rendered as read, without awaiting or emitting.
  ///
  /// Deliberately fire-and-forget: opening the screen *is* the read, so the
  /// rows must not re-render as read under the shopper's eyes, and a failed
  /// receipt is worth an unread dot returning — never an error state over a
  /// list that loaded fine. The next open retries it for free.
  void _acknowledge(List<NotificationSectionEntity> sections) {
    final unreadIds = [
      for (final section in sections)
        for (final notification in section.notifications)
          if (!notification.isRead) notification.id,
    ];
    if (unreadIds.isEmpty) return;

    unawaited(
      _markRead(
        MarkNotificationsReadParams(
          storeId: _storeId,
          notificationIds: unreadIds,
        ),
      ),
    );
  }
}
