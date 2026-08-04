import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/di/injection_container.dart';

import 'address_bloc.dart';

/// The canonical [AddressBloc] construction + started dispatch, shared by
/// every template's Select Address page so the wiring can't drift per pack.
BlocProvider<AddressBloc> addressBlocProvider({required Widget child}) =>
    BlocProvider(
      create: (_) => AddressBloc(
        getAddressesUseCase: sl(),
        createAddressUseCase: sl(),
        updateAddressUseCase: sl(),
        deleteAddressUseCase: sl(),
      )..add(const AddressEvent.started()),
      child: child,
    );
