import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/di/injection_container.dart';

import 'product_details_bloc.dart';

/// The canonical [ProductDetailsBloc] construction + started dispatch,
/// shared by every template's Product Details page so the wiring can't
/// drift per pack.
BlocProvider<ProductDetailsBloc> productDetailsBlocProvider({
  required String storeId,
  required String productId,
  required Widget child,
}) => BlocProvider(
  create: (_) => ProductDetailsBloc(getProductDetailsUseCase: sl())
    ..add(ProductDetailsEvent.started(storeId: storeId, productId: productId)),
  child: child,
);
