import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/di/injection_container.dart';

import 'search_bloc.dart';

/// The canonical [SearchBloc] construction + started dispatch, shared by
/// every template's Search page so the wiring can't drift per pack.
BlocProvider<SearchBloc> searchBlocProvider({
  required String storeId,
  required Widget child,
}) => BlocProvider(
  create: (_) => SearchBloc(
    getSearchUseCase: sl(),
    searchCatalogUseCase: sl(),
    addRecentSearchUseCase: sl(),
    removeRecentSearchUseCase: sl(),
    storeId: storeId,
  )..add(const SearchEvent.started()),
  child: child,
);
