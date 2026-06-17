import 'package:ai_chat/enums/chat_message_status.dart';
import 'package:ai_chat/enums/chat_role.dart';

/// A single message in the conversation. Plain Dart, no annotations.
///
/// Assistant messages accumulate [content] as stream deltas arrive; [status]
/// tracks whether the response is still streaming, finished, or failed.
class ChatMessageEntity {
  final String id;
  final ChatRole role;
  final String content;
  final ChatMessageStatus status;

  const ChatMessageEntity({
    required this.id,
    required this.role,
    required this.content,
    required this.status,
  });

  ChatMessageEntity copyWith({
    String? content,
    ChatMessageStatus? status,
  }) =>
      ChatMessageEntity(
        id: id,
        role: role,
        content: content ?? this.content,
        status: status ?? this.status,
      );
}
