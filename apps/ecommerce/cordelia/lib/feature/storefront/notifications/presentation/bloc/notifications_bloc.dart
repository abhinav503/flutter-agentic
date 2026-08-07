import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
  }

  Future<void> _onStarted(
    NotificationsStarted event,
    Emitter<NotificationsState> emit,
  ) async {
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
