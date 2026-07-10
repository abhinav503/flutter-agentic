import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';
import 'package:jokes/constants/value_const.dart';
import 'package:core/core/di/core_injection.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/theme/theme_mode_scope.dart';
import 'package:core/core/ui/atoms/badge.dart';
import 'package:core/core/ui/atoms/theme_mode_toggle.dart';
import 'package:core/core/ui/atoms/top_bar.dart';
import '../../domain/entities/joke_entity.dart';
import '../bloc/for_you_bloc.dart';
import '../bloc/kept_jokes_cubit.dart';
import '../bloc/search_page_bloc.dart';
import 'for_you_screen.dart';
import 'search_screen.dart';

class HomePage extends BasePage {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage> {
  int _currentTab = 0;

  @override
  Widget buildBlocProviders(Widget child) => BlocProvider(
        create: (_) => KeptJokesCubit(),
        child: child,
      );

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) {
    final themeMode = ThemeModeScope.maybeOf(context);
    final themeToggle = themeMode == null
        ? null
        : ThemeModeToggle(mode: themeMode.value, onTap: themeMode.cycle);
    if (_currentTab == 1) {
      return AppTopBar.primary(
        title: ValueConst.jokeSearchTabTitle,
        actions: [?themeToggle],
      );
    }
    return AppTopBar.primary(
      title: ValueConst.jokeForYouTabTitle,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      actions: [
        BlocBuilder<KeptJokesCubit, List<JokeEntity>>(
          builder: (_, jokes) {
            if (jokes.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.base),
              child: Center(
                child: AppBadge(
                  text: jokes.length.toString(),
                  intent: AppBadgeIntent.success,
                ),
              ),
            );
          },
        ),
        ?themeToggle,
      ],
    );
  }

  @override
  Widget buildBody(BuildContext context) => IndexedStack(
        index: _currentTab,
        children: [
          BlocProvider(
            create: (_) => ForYouBloc(getRandomJokeUseCase: sl())
              ..add(const ForYouEvent.started()),
            child: const ForYouScreen(),
          ),
          BlocProvider(
            create: (_) => SearchPageBloc(searchJokesUseCase: sl()),
            child: const SearchScreen(),
          ),
        ],
      );

  // ── Bottom nav via BasePage getters ───────────────────────────────────────
  @override
  bool get showBottomNav => true;

  @override
  List<BottomNavigationBarItem> get bottomNavItems => const [
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_awesome_outlined),
          activeIcon: Icon(Icons.auto_awesome),
          label: ValueConst.jokeForYouTabTitle,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          activeIcon: Icon(Icons.search),
          label: ValueConst.jokeSearchTabTitle,
        ),
      ];

  @override
  int get selectedNavIndex => _currentTab;

  @override
  void onNavItemTapped(int index) => setState(() => _currentTab = index);
}
