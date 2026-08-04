import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/di/injection_container.dart';

import 'category_details_bloc.dart';

/// The canonical [CategoryDetailsBloc] construction + started dispatch,
/// shared by every template's Category Details page so the wiring can't
/// drift per pack.
BlocProvider<CategoryDetailsBloc> categoryDetailsBlocProvider({
  required String storeId,
  required String categoryId,
  required String categoryName,
  required Widget child,
}) => BlocProvider(
  create: (_) => CategoryDetailsBloc(getCategoryDetailsUseCase: sl())
    ..add(
      CategoryDetailsEvent.started(
        storeId: storeId,
        categoryId: categoryId,
        categoryName: categoryName,
      ),
    ),
  child: child,
);
