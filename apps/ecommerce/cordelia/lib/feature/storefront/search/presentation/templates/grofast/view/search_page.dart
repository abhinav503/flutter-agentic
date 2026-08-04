import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';
import 'package:cordelia/feature/storefront/presentation/chromeless_page.dart';

import 'package:cordelia/di/injection_container.dart';

import '../../../bloc/search_bloc.dart';
import 'search_screen.dart';

/// `grofast` template's Search entry — same shared [SearchBloc] (and its
/// warm-start cache) as the other templates, different skin.
class SearchPage extends BasePage {
  final String storeId;

  const SearchPage({super.key, required this.storeId});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends BasePageState<SearchPage>
    with ChromelessStorefrontPage {
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
