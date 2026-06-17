import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/empty_state.dart';

import 'package:ai_chat/constants/value_const.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_message_list.dart';

class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<ChatBloc>().add(ChatEvent.sendPressed(prompt: text));
    _controller.clear();
  }

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state.messages.isEmpty) {
                  return const EmptyState(
                    iconData: Icons.auto_awesome,
                    title: ValueConst.emptyTitle,
                    subtitle: ValueConst.emptySubtitle,
                  );
                }
                return ChatMessageList(
                  messages: state.messages,
                  onRetry: () =>
                      context.read<ChatBloc>().add(const ChatEvent.retryPressed()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: BlocBuilder<ChatBloc, ChatState>(
              buildWhen: (a, b) => a.isResponding != b.isResponding,
              builder: (context, state) => ChatInputBar(
                controller: _controller,
                isResponding: state.isResponding,
                hint: ValueConst.inputHint,
                onSend: () => _send(context),
                onStop: () =>
                    context.read<ChatBloc>().add(const ChatEvent.stopPressed()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
