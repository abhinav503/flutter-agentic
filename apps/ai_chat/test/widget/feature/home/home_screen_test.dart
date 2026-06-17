import 'package:ai_chat/constants/value_const.dart';
import 'package:ai_chat/feature/home/domain/entities/chat_message_entity.dart';
import 'package:ai_chat/enums/chat_message_status.dart';
import 'package:ai_chat/enums/chat_role.dart';
import 'package:ai_chat/feature/home/presentation/bloc/chat_bloc.dart';
import 'package:ai_chat/feature/home/presentation/view/home_screen.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core/theme/app_theme.dart';
import 'package:core/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockChatBloc extends MockBloc<ChatEvent, ChatState>
    implements ChatBloc {}

Widget _wrap(ChatBloc bloc) => MaterialApp(
      theme: AppTheme.fromConfig(AppThemeConfig.defaults),
      home: BlocProvider<ChatBloc>.value(
        value: bloc,
        child: const Scaffold(body: HomeScreen()),
      ),
    );

void main() {
  late _MockChatBloc bloc;

  setUp(() => bloc = _MockChatBloc());
  tearDown(() => bloc.close());

  group('HomeScreen', () {
    testWidgets('shows empty state when there are no messages', (tester) async {
      whenListen(bloc, const Stream<ChatState>.empty(),
          initialState: const ChatState());

      await tester.pumpWidget(_wrap(bloc));

      expect(find.text(ValueConst.emptyTitle), findsOneWidget);
    });

    testWidgets('renders a message bubble when messages exist', (tester) async {
      whenListen(
        bloc,
        const Stream<ChatState>.empty(),
        initialState: const ChatState(
          messages: [
            ChatMessageEntity(
              id: '1',
              role: ChatRole.user,
              content: 'hello there',
              status: ChatMessageStatus.done,
            ),
          ],
        ),
      );

      await tester.pumpWidget(_wrap(bloc));

      expect(find.text('hello there'), findsOneWidget);
      expect(find.text(ValueConst.emptyTitle), findsNothing);
    });
  });
}
