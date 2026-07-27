import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/usecase/usecase.dart';

import '../../domain/entities/notification_section_entity.dart';
import '../../domain/usecase/get_notifications_usecase.dart';

part 'notifications_bloc.freezed.dart';
part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase _getNotifications;

  NotificationsBloc({required GetNotificationsUseCase getNotificationsUseCase})
    : _getNotifications = getNotificationsUseCase,
      super(const NotificationsState.loading()) {
    on<NotificationsStarted>(_onStarted);
  }

  Future<void> _onStarted(
    NotificationsStarted event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await _getNotifications(const NoParams());
    result.fold(
      (failure) => emit(NotificationsState.error(message: failure.message)),
      (sections) => emit(NotificationsState.loaded(sections: sections)),
    );
  }
}
