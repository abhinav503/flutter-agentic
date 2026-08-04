import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notification_section_entity.dart';
import '../../domain/usecase/get_notifications_usecase.dart';

part 'notifications_bloc.freezed.dart';
part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase _getNotifications;
  final String _storeId;
  final String _templateId;

  NotificationsBloc({
    required GetNotificationsUseCase getNotificationsUseCase,
    required String storeId,
    required String templateId,
  }) : _getNotifications = getNotificationsUseCase,
       // An initializing formal can't be used here: the fields are private and
       // Dart forbids a named parameter starting with an underscore.
       // ignore: prefer_initializing_formals
       _storeId = storeId,
       // ignore: prefer_initializing_formals
       _templateId = templateId,
       super(const NotificationsState.loading()) {
    on<NotificationsStarted>(_onStarted);
  }

  Future<void> _onStarted(
    NotificationsStarted event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await _getNotifications(
      GetNotificationsParams(storeId: _storeId, templateId: _templateId),
    );
    result.fold(
      (failure) => emit(NotificationsState.error(message: failure.message)),
      (sections) => emit(NotificationsState.loaded(sections: sections)),
    );
  }
}
