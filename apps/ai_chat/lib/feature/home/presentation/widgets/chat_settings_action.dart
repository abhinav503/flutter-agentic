import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/text_field.dart';
import 'package:core/core/ui/molecules/bottom_sheet.dart';

import 'package:ai_chat/constants/value_const.dart';
import '../bloc/chat_bloc.dart';

/// App-bar action to enter / clear the Groq API key. The icon reflects whether
/// a key is set; tapping opens a bottom sheet with the key field.
class ChatSettingsAction extends StatelessWidget {
  const ChatSettingsAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (a, b) => a.hasApiKey != b.hasApiKey,
      builder: (context, state) => IconButton(
        tooltip: ValueConst.settingsTooltip,
        icon: Icon(state.hasApiKey ? Icons.key : Icons.key_outlined),
        onPressed: () {
          final bloc = context.read<ChatBloc>();
          AppBottomSheet.show(
            context,
            title: ValueConst.apiKeySheetTitle,
            child: BlocProvider.value(
              value: bloc,
              child: const _ApiKeySheet(),
            ),
          );
        },
      ),
    );
  }
}

class _ApiKeySheet extends StatefulWidget {
  const _ApiKeySheet();

  @override
  State<_ApiKeySheet> createState() => _ApiKeySheetState();
}

class _ApiKeySheetState extends State<_ApiKeySheet> {
  late final TextEditingController _controller =
      TextEditingController(text: context.read<ChatBloc>().state.apiKey);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final key = _controller.text.trim();
    context.read<ChatBloc>().add(ChatEvent.apiKeySaved(apiKey: key));
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            key.isEmpty ? ValueConst.apiKeyCleared : ValueConst.apiKeySaved,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    // AppBottomSheet only pads the title/actions, not the body child, so the
    // content supplies its own horizontal + bottom padding.
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xs),
          Text(ValueConst.apiKeyHelp,
              style: text.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _controller,
            label: ValueConst.apiKeyFieldLabel,
            hint: ValueConst.apiKeyHint,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: ValueConst.clearButton,
                  variant: AppButtonVariant.secondary,
                  onTap: () {
                    _controller.clear();
                    _save();
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  label: ValueConst.saveButton,
                  onTap: _save,
                  fullWidth: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
