import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:gravia/feature/notifications/domain/entities/notification_entity.dart';
import 'package:gravia/feature/notifications/domain/entities/notification_section_entity.dart';
import 'package:gravia/feature/notifications/domain/usecase/get_notifications_usecase.dart';
import 'package:gravia/feature/notifications/presentation/bloc/notifications_bloc.dart';

import '../../../../helpers/fake_notifications_repository.dart';

void main() {
  late FakeNotificationsRepository repository;

  const sections = [
    NotificationSectionEntity(
      title: 'Today',
      notifications: [
        NotificationEntity(
          id: 'notif_1',
          iconAsset: 'assets/icons/badge-percent.svg',
          title: 'Best Deal of the Day',
          message: 'Buy 1 Get 1 Offer on selected product… hurry up',
        ),
      ],
    ),
  ];

  setUp(() {
    repository = FakeNotificationsRepository()..result = right(sections);
  });

  blocTest<NotificationsBloc, NotificationsState>(
    'emits [loading, loaded] when started succeeds',
    build: () => NotificationsBloc(
      getNotificationsUseCase: GetNotificationsUseCase(repository),
    ),
    act: (bloc) => bloc.add(const NotificationsEvent.started()),
    expect: () => [const NotificationsState.loaded(sections: sections)],
  );

  blocTest<NotificationsBloc, NotificationsState>(
    'emits [loading, error] when started fails',
    setUp: () =>
        repository.result = left(const Failure.unexpected(message: 'boom')),
    build: () => NotificationsBloc(
      getNotificationsUseCase: GetNotificationsUseCase(repository),
    ),
    act: (bloc) => bloc.add(const NotificationsEvent.started()),
    expect: () => [const NotificationsState.error(message: 'boom')],
  );
}
