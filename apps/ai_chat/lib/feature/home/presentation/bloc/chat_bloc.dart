import 'dart:async';

import 'package:core/core/error/failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/usecase/usecase.dart';

import '../../domain/entities/chat_message_entity.dart';
import 'package:ai_chat/enums/chat_message_status.dart';
import 'package:ai_chat/enums/chat_mode.dart';
import 'package:ai_chat/enums/chat_role.dart';
import '../../domain/usecase/get_api_key_usecase.dart';
import '../../domain/usecase/save_api_key_usecase.dart';
import '../../domain/usecase/send_message_usecase.dart';

part 'chat_bloc.freezed.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase _sendMessage;
  final GetApiKeyUseCase _getApiKey;
  final SaveApiKeyUseCase _saveApiKey;

  ChatBloc({
    required SendMessageUseCase sendMessageUseCase,
    required GetApiKeyUseCase getApiKeyUseCase,
    required SaveApiKeyUseCase saveApiKeyUseCase,
  })  : _sendMessage = sendMessageUseCase,
        _getApiKey = getApiKeyUseCase,
        _saveApiKey = saveApiKeyUseCase,
        super(const ChatState()) {
    on<ChatStarted>(_onStarted);
    on<ChatSendPressed>(_onSend);
    on<ChatStopPressed>(_onStop);
    on<ChatRetryPressed>(_onRetry);
    on<ChatModeChanged>(_onModeChanged);
    on<ChatApiKeySaved>(_onApiKeySaved);
  }

  Future<void> _onStarted(ChatStarted event, Emitter<ChatState> emit) async {
    final apiKey = await _getApiKey(const NoParams());
    emit(state.copyWith(apiKey: apiKey));
  }

  Future<void> _onApiKeySaved(
    ChatApiKeySaved event,
    Emitter<ChatState> emit,
  ) async {
    await _saveApiKey(SaveApiKeyParams(apiKey: event.apiKey));
    emit(state.copyWith(apiKey: event.apiKey.trim()));
  }

  void _onModeChanged(ChatModeChanged event, Emitter<ChatState> emit) {
    if (state.isResponding) return;
    emit(state.copyWith(mode: event.mode));
  }

  // Active reply subscription + a completer the send/retry handler awaits, so
  // a Stop event can cancel mid-stream and let the handler finish cleanly.
  StreamSubscription<Either<Failure, String>>? _subscription;
  Completer<void>? _replyCompleter;
  int _seq = 0;

  String _nextId() => '${++_seq}';

  Future<void> _onSend(ChatSendPressed event, Emitter<ChatState> emit) async {
    if (state.isResponding) return;
    final prompt = event.prompt.trim();
    if (prompt.isEmpty) return;

    emit(state.copyWith(
      messages: [
        ...state.messages,
        ChatMessageEntity(
          id: _nextId(),
          role: ChatRole.user,
          content: prompt,
          status: ChatMessageStatus.done,
        ),
      ],
    ));

    await _streamReply(prompt, emit);
  }

  Future<void> _onRetry(ChatRetryPressed event, Emitter<ChatState> emit) async {
    if (state.isResponding) return;

    // Retry context comes from the conversation itself — no inspecting prior
    // BLoC states. Drop any trailing failed assistant message, then re-stream
    // the last user prompt.
    ChatMessageEntity? lastUser;
    for (final m in state.messages.reversed) {
      if (m.role == ChatRole.user) {
        lastUser = m;
        break;
      }
    }
    if (lastUser == null) return;

    final cleaned = state.messages
        .where((m) => m.status != ChatMessageStatus.error)
        .toList();
    emit(state.copyWith(messages: cleaned));

    await _streamReply(lastUser.content, emit);
  }

  /// Appends a streaming assistant placeholder, then consumes the use-case
  /// stream, appending each token delta. Stays alive (awaiting [_replyCompleter])
  /// until the stream completes, errors, or a Stop cancels the subscription.
  Future<void> _streamReply(String prompt, Emitter<ChatState> emit) async {
    final assistantId = _nextId();
    emit(state.copyWith(
      isResponding: true,
      messages: [
        ...state.messages,
        ChatMessageEntity(
          id: assistantId,
          role: ChatRole.assistant,
          content: '',
          status: ChatMessageStatus.streaming,
        ),
      ],
    ));

    final completer = Completer<void>();
    _replyCompleter = completer;

    _subscription =
        _sendMessage(SendMessageParams(prompt: prompt, mode: state.mode))
            .listen(
      (either) => either.fold(
        (failure) => emit(_mapAssistant(
          assistantId,
          (m) => m.copyWith(status: ChatMessageStatus.error),
        )),
        (delta) => emit(_mapAssistant(
          assistantId,
          (m) => m.copyWith(content: m.content + delta),
        )),
      ),
      onDone: () {
        emit(_finalize(assistantId));
        if (!completer.isCompleted) completer.complete();
      },
      onError: (_) {
        emit(_mapAssistant(
          assistantId,
          (m) => m.copyWith(status: ChatMessageStatus.error),
        ).copyWith(isResponding: false));
        if (!completer.isCompleted) completer.complete();
      },
      cancelOnError: true,
    );

    await completer.future;
    await _subscription?.cancel();
    _subscription = null;
    _replyCompleter = null;
  }

  Future<void> _onStop(ChatStopPressed event, Emitter<ChatState> emit) async {
    if (!state.isResponding) return;
    await _subscription?.cancel();
    _subscription = null;
    // Finalize whatever streamed so far as a completed message.
    emit(state.copyWith(
      isResponding: false,
      messages: state.messages
          .map((m) => m.status == ChatMessageStatus.streaming
              ? m.copyWith(status: ChatMessageStatus.done)
              : m)
          .toList(),
    ));
    _replyCompleter?.complete();
    _replyCompleter = null;
  }

  // Returns a new state with the assistant message [id] transformed by [f].
  ChatState _mapAssistant(
    String id,
    ChatMessageEntity Function(ChatMessageEntity) f,
  ) =>
      state.copyWith(
        messages:
            state.messages.map((m) => m.id == id ? f(m) : m).toList(),
      );

  // Marks the streaming assistant message done and clears the responding flag.
  ChatState _finalize(String id) => _mapAssistant(
        id,
        (m) => m.status == ChatMessageStatus.streaming
            ? m.copyWith(status: ChatMessageStatus.done)
            : m,
      ).copyWith(isResponding: false);

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
