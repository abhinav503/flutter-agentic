import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/ui/atoms/dropdown_menu.dart';

import 'package:ai_chat/constants/value_const.dart';
import 'package:ai_chat/enums/chat_mode.dart';
import '../bloc/chat_bloc.dart';

/// App-bar action to switch between streaming and one-shot replies. Disabled
/// while a reply is in flight so the mode can't change mid-response.
class ChatModeAction extends StatelessWidget {
  const ChatModeAction({super.key});

  static const _items = <AppDropdownItem<ChatMode>>[
    AppDropdownItem(
      value: ChatMode.streaming,
      label: ValueConst.modeStreaming,
      subtitle: ValueConst.modeStreamingSubtitle,
      icon: Icons.bolt,
    ),
    AppDropdownItem(
      value: ChatMode.oneShot,
      label: ValueConst.modeOneShot,
      subtitle: ValueConst.modeOneShotSubtitle,
      icon: Icons.article_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (a, b) => a.mode != b.mode || a.isResponding != b.isResponding,
      builder: (context, state) => AppDropdownMenu<ChatMode>(
        value: state.mode,
        enabled: !state.isResponding,
        tooltip: ValueConst.modeTooltip,
        onSelected: (mode) =>
            context.read<ChatBloc>().add(ChatEvent.modeChanged(mode: mode)),
        items: _items,
        trigger: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            state.mode == ChatMode.streaming
                ? Icons.bolt
                : Icons.article_outlined,
          ),
        ),
      ),
    );
  }
}
