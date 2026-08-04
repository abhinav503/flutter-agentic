import 'package:cordelia/di/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core/base/base_page.dart';
import '../../../bloc/cart_bloc.dart';
import 'package:cordelia/feature/storefront/checkout/presentation/bloc/checkout_bloc.dart';
import 'cart_screen.dart';

class CartPage extends BasePage {
  final String storeId;

  const CartPage({super.key, required this.storeId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends BasePageState<CartPage> {
  // No AppBar: the screen renders its own coloured hero header (back +
  // centered title), same reasoning as AddressPage/Product Details.
  @override
  Widget buildBody(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) =>
            CartBloc(getHomeUseCase: sl(), storeId: widget.storeId)
              ..add(const CartEvent.started()),
      ),
      BlocProvider(
        create: (_) => CheckoutBloc(
          createPaymentUseCase: sl(),
          processPaymentUseCase: sl(),
          createOrderUseCase: sl(),
          storeId: widget.storeId,
        ),
      ),
    ],
    child: CartScreen(storeId: widget.storeId),
  );
}
