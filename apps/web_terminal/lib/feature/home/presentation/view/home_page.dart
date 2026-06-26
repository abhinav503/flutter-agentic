import 'package:core/core/base/base_page.dart';
import 'package:core/core/di/core_injection.dart';
import 'package:core/core/ui/atoms/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_terminal/constants/value_const.dart';
import 'package:web_terminal/feature/apps/presentation/cubit/apps_cubit.dart';
import 'package:web_terminal/feature/setup/presentation/cubit/setup_cubit.dart';
import 'package:web_terminal/feature/setup/presentation/widgets/setup_button.dart';
import '../bloc/terminal_bloc.dart';
import 'home_screen.dart';

class HomePage extends BasePage {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage> {
  // Page-level because both panes read them; cascades kick off the first
  // connect and the app-list load.
  @override
  Widget buildBlocProviders(Widget child) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => TerminalBloc(
              connectTerminalUseCase: sl(),
              sendInputUseCase: sl(),
              resizeTerminalUseCase: sl(),
              disconnectTerminalUseCase: sl(),
            )..add(const TerminalEvent.connectRequested()),
          ),
          BlocProvider(
            create: (_) => AppsCubit(
              listAppsUseCase: sl(),
              runAppUseCase: sl(),
              stopAppUseCase: sl(),
            )..load(),
          ),
          BlocProvider(
            create: (_) =>
                SetupCubit(getSetupStatusUseCase: sl()),
          ),
        ],
        child: child,
      );

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) => AppTopBar.primary(
        title: ValueConst.homeAppBarTitle,
        actions: const [SetupButton()],
      );

  @override
  Widget buildBody(BuildContext context) => const HomeScreen();
}
