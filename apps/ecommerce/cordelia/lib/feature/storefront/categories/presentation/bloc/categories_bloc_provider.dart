import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/di/injection_container.dart';

import 'categories_bloc.dart';

/// The canonical [CategoriesBloc] construction + started dispatch, shared by
/// every template's Categories tab so the wiring can't drift per pack.
BlocProvider<CategoriesBloc> categoriesBlocProvider({
  required String storeId,
  required Widget child,
}) => BlocProvider(
  create: (_) =>
      CategoriesBloc(getCategoriesUseCase: sl(), storeId: storeId)
        ..add(const CategoriesEvent.started()),
  child: child,
);
