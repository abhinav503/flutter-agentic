import 'package:ai_chat/enums/chat_message_status.dart';
import 'package:ai_chat/enums/chat_mode.dart';
import 'package:ai_chat/enums/chat_role.dart';
import 'package:ai_chat/feature/home/domain/usecase/get_api_key_usecase.dart';
import 'package:ai_chat/feature/home/domain/usecase/save_api_key_usecase.dart';
import 'package:ai_chat/feature/home/domain/usecase/send_message_usecase.dart';
import 'package:ai_chat/feature/home/presentation/bloc/chat_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_chat_repository.dart';

void main() {
  late FakeChatRepository fake;

  ChatBloc buildBloc() => ChatBloc(
        sendMessageUseCase: SendMessageUseCase(fake),
        getApiKeyUseCase: GetApiKeyUseCase(fake),
        saveApiKeyUseCase: SaveApiKeyUseCase(fake),
      );

  setUp(() => fake = FakeChatRepository());

  group('ChatBloc', () {
    blocTest<ChatBloc, ChatState>(
      'accumulates streamed deltas into the assistant message and marks it done',
      build: () {
        fake.deltas = const ['Hello ', 'world'];
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ChatEvent.sendPressed(prompt: 'hi')),
      verify: (bloc) {
        final messages = bloc.state.messages;
        expect(messages.length, 2);
        expect(messages.first.role, ChatRole.user);
        expect(messages.first.content, 'hi');
        expect(messages.last.role, ChatRole.assistant);
        expect(messages.last.content, 'Hello world');
        expect(messages.last.status, ChatMessageStatus.done);
        expect(bloc.state.isResponding, false);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'marks the assistant message as error when the stream fails',
      build: () {
        fake
          ..deltas = const ['partial ']
          ..failure = const Failure.unexpected(message: 'boom');
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ChatEvent.sendPressed(prompt: 'hi')),
      verify: (bloc) {
        expect(bloc.state.messages.last.status, ChatMessageStatus.error);
        expect(bloc.state.isResponding, false);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'one-shot mode sends the selected mode and yields the whole reply at once',
      build: () {
        fake.deltas = const ['the entire reply'];
        return buildBloc();
      },
      act: (bloc) {
        bloc.add(const ChatEvent.modeChanged(mode: ChatMode.oneShot));
        bloc.add(const ChatEvent.sendPressed(prompt: 'hi'));
      },
      verify: (bloc) {
        expect(fake.lastMode, ChatMode.oneShot);
        expect(bloc.state.mode, ChatMode.oneShot);
        expect(bloc.state.messages.last.content, 'the entire reply');
        expect(bloc.state.messages.last.status, ChatMessageStatus.done);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'retry drops the failed assistant message and re-streams the last prompt',
      build: () {
        fake
          ..deltas = const ['oops']
          ..failure = const Failure.unexpected(message: 'boom');
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(const ChatEvent.sendPressed(prompt: 'hi'));
        await Future<void>.delayed(const Duration(milliseconds: 10));
        fake
          ..deltas = const ['recovered']
          ..failure = null;
        bloc.add(const ChatEvent.retryPressed());
      },
      verify: (bloc) {
        final messages = bloc.state.messages;
        expect(messages.where((m) => m.role == ChatRole.user).length, 1);
        expect(messages.last.status, ChatMessageStatus.done);
        expect(messages.last.content, 'recovered');
      },
    );

    blocTest<ChatBloc, ChatState>(
      'started loads the persisted key; apiKeySaved persists and exposes it',
      build: () {
        fake.storedKey = 'gsk_existing';
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(const ChatEvent.started());
        await Future<void>.delayed(const Duration(milliseconds: 5));
        bloc.add(const ChatEvent.apiKeySaved(apiKey: 'gsk_new '));
      },
      verify: (bloc) {
        expect(bloc.state.apiKey, 'gsk_new');
        expect(bloc.state.hasApiKey, true);
        expect(fake.storedKey, 'gsk_new');
      },
    );
  });
}
