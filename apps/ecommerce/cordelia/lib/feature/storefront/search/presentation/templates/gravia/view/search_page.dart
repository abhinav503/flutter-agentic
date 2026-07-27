import 'package:cordelia/di/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core/base/base_page.dart';
import '../../../bloc/search_bloc.dart';
import 'search_screen.dart';

class SearchPage extends BasePage {
  final String storeId;

  const SearchPage({super.key, required this.storeId});

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
      storeId: widget.storeId,
    )..add(const SearchEvent.started()),
    child: SearchScreen(storeId: widget.storeId),
  );
}
