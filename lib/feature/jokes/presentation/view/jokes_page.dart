import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/value_const.dart';
import '../../../../core/base/base_page.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/ui/atoms/top_bar.dart';
import '../bloc/joke_bloc.dart';
import '../bloc/joke_search_bloc.dart';

import 'jokes_screen.dart';

class JokesPage extends BasePage {
  const JokesPage({super.key});

  @override
  State<JokesPage> createState() => _JokesPageState();
}

class _JokesPageState extends BasePageState<JokesPage> {
  @override
  Widget buildBlocProviders(Widget child) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => JokeBloc(getRandomJokeUseCase: sl())),
          BlocProvider(create: (_) => JokeSearchBloc(searchJokesUseCase: sl())),
        ],
        child: child,
      );

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) =>
      AppTopBar.primary(
        title: ValueConst.jokeAppBarTitle,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      );

  @override
  Widget buildBody(BuildContext context) => const JokesScreen();

  // FAB is hidden while search is active — use Builder so the context
  // is a descendant of the BlocProviders added by buildBlocProviders.
  @override
  Widget? buildFab(BuildContext context) {
    return Builder(
      builder: (ctx) => BlocBuilder<JokeSearchBloc, JokeSearchState>(
        builder: (_, searchState) {
          if (searchState is! JokeSearchInitial) return const SizedBox.shrink();
          return FloatingActionButton(
            tooltip: ValueConst.jokeFabTooltip,
            onPressed: () =>
                ctx.read<JokeBloc>().add(const JokeEvent.fetched()),
            child: const Icon(Icons.refresh),
          );
        },
      ),
    );
  }
}
