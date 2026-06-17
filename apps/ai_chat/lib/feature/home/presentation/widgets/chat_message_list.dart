import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

import '../../domain/entities/chat_message_entity.dart';
import 'chat_bubble.dart';

/// Scrollable conversation. Newest message at the bottom; the list pins to the
/// bottom (`reverse: true`) so streaming replies stay in view.
class ChatMessageList extends StatelessWidget {
  final List<ChatMessageEntity> messages;
  final VoidCallback onRetry;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final reversed = messages.reversed.toList(growable: false);
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.base,
      ),
      itemCount: reversed.length,
      itemBuilder: (context, i) => ChatBubble(
        message: reversed[i],
        onRetry: onRetry,
      ),
    );
  }
}
