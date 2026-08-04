import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/di/injection_container.dart';

import 'home_bloc.dart';

/// The canonical [HomeBloc] construction + started dispatch, shared by every
/// template's Home tab so the wiring can't drift per pack.
BlocProvider<HomeBloc> homeBlocProvider({
  required String storeId,
  required Widget child,
}) => BlocProvider(
  create: (_) =>
      HomeBloc(getHomeUseCase: sl(), storeId: storeId)
        ..add(const HomeEvent.started()),
  child: child,
);
