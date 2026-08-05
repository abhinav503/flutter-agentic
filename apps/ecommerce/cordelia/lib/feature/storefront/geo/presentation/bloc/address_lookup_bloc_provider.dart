import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/di/injection_container.dart';

import 'address_lookup_bloc.dart';

/// The canonical [AddressLookupBloc] construction, shared by every
/// template's Add/Edit Address page so the wiring can't drift per pack. No
/// started dispatch — every lookup is user-initiated.
BlocProvider<AddressLookupBloc> addressLookupBlocProvider({
  required Widget child,
}) => BlocProvider(
  create: (_) => AddressLookupBloc(
    getCurrentLocationAddressUseCase: sl(),
    reverseGeocodeUseCase: sl(),
    searchPlacesUseCase: sl(),
    lookupPincodeUseCase: sl(),
  ),
  child: child,
);
