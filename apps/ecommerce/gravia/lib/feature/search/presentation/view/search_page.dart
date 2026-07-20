import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';

import 'package:gravia/di/injection_container.dart';

import '../bloc/search_bloc.dart';
import 'search_screen.dart';

class SearchPage extends BasePage {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends BasePageState<SearchPage> {
  // SearchScreen renders its own coloured header canvas (the search field) —
  // a generic top bar would double up, same reasoning as HomeScreen.
  @override
  Widget buildBody(BuildContext context) => BlocProvider(
    create: (_) => SearchBloc(
      getSearchUseCase: sl(),
      searchCatalogUseCase: sl(),
      addRecentSearchUseCase: sl(),
      removeRecentSearchUseCase: sl(),
    )..add(const SearchEvent.started()),
    child: const SearchScreen(),
  );
}
