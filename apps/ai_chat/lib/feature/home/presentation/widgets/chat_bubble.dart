import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/loading_dots.dart';

import 'package:ai_chat/constants/value_const.dart';
import '../../domain/entities/chat_message_entity.dart';
import 'package:ai_chat/enums/chat_message_status.dart';
import 'package:ai_chat/enums/chat_role.dart';
import 'chat_markdown.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageEntity message;
  final VoidCallback onRetry;

  const ChatBubble({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isUser = message.role == ChatRole.user;

    final bubbleColor = isUser ? cs.primaryContainer : cs.surfaceContainerHigh;
    final textColor = isUser ? cs.onPrimaryContainer : cs.onSurface;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.82,
        ),
        decoration: BoxDecoration(color: bubbleColor, borderRadius: AppRadius.lg),
        child: _content(context, textColor, cs),
      ),
    );
  }

  Widget _content(BuildContext context, Color textColor, ColorScheme cs) {
    if (message.status == ChatMessageStatus.error) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ValueConst.assistantError,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: cs.error),
          ),
          const SizedBox(height: AppSpacing.xs),
          AppButton(
            label: ValueConst.retryButton,
            variant: AppButtonVariant.text,
            size: AppButtonSize.small,
            onTap: onRetry,
            leadingIcon: const Icon(Icons.refresh, size: AppSpacing.lg),
          ),
        ],
      );
    }

    // Assistant message still waiting for its first token.
    if (message.role == ChatRole.assistant &&
        message.status == ChatMessageStatus.streaming &&
        message.content.isEmpty) {
      return const LoadingDots();
    }

    if (message.role == ChatRole.user) {
      return Text(
        message.content,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: textColor, fontSize: 13, height: 1.18),
      );
    }

    return ChatMarkdown(data: message.content, color: textColor);
  }
}
