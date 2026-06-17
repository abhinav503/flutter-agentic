import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';
import 'package:core/core/di/core_injection.dart';
import 'package:core/core/ui/atoms/top_bar.dart';

import 'package:ai_chat/constants/value_const.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/chat_mode_action.dart';
import '../widgets/chat_settings_action.dart';
import 'home_screen.dart';

class HomePage extends BasePage {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage> {
  // ChatBloc lives at the page level because the AppBar's mode toggle reads it
  // (see CLAUDE.md: provide in buildBlocProviders when the AppBar needs it).
  @override
  Widget buildBlocProviders(Widget child) => BlocProvider(
        create: (_) => ChatBloc(
          sendMessageUseCase: sl(),
          getApiKeyUseCase: sl(),
          saveApiKeyUseCase: sl(),
        )..add(const ChatEvent.started()),
        child: child,
      );

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) => AppTopBar.primary(
        title: ValueConst.homeAppBarTitle,
        actions: const [ChatSettingsAction(), ChatModeAction()],
      );

  @override
  Widget buildBody(BuildContext context) => const HomeScreen();
}
