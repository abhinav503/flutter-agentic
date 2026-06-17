import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/text_field.dart';

import 'package:ai_chat/constants/value_const.dart';

/// Prompt field + a Send/Stop button. The button toggles to Stop while a reply
/// is streaming so the user can cancel mid-response.
class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isResponding;
  final String hint;
  final VoidCallback onSend;
  final VoidCallback onStop;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.isResponding,
    required this.hint,
    required this.onSend,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    // IntrinsicHeight + stretch makes the Send/Stop button match the text
    // field's height (the field is the taller child and sets the row height).
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AppTextField(
              controller: controller,
              hint: hint,
              minLines: 1,
              maxLines: 5,
              dense: true,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => isResponding ? null : onSend(),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          AppButton(
            label:
                isResponding ? ValueConst.stopButton : ValueConst.sendButton,
            variant: isResponding
                ? AppButtonVariant.secondary
                : AppButtonVariant.primary,
            onTap: isResponding ? onStop : onSend,
            leadingIcon: Icon(
              isResponding ? Icons.stop : Icons.send,
              size: AppSpacing.lg,
            ),
          ),
        ],
      ),
    );
  }
}
