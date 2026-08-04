import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/di/injection_container.dart';

import 'checkout_bloc.dart';

/// The canonical [CheckoutBloc] construction, shared by every template's
/// Checkout host so the wiring can't drift per pack. No started dispatch:
/// the bloc idles until the screen submits the order.
BlocProvider<CheckoutBloc> checkoutBlocProvider({
  required String storeId,
  required Widget child,
}) => BlocProvider(
  create: (_) => CheckoutBloc(
    createPaymentUseCase: sl(),
    processPaymentUseCase: sl(),
    createOrderUseCase: sl(),
    storeId: storeId,
  ),
  child: child,
);
