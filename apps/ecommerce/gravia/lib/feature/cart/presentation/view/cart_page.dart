import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';

import 'package:gravia/di/injection_container.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/checkout_bloc.dart';
import 'cart_screen.dart';

class CartPage extends BasePage {
  const CartPage({super.key});

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
            CartBloc(getHomeUseCase: sl())..add(const CartEvent.started()),
      ),
      BlocProvider(
        create: (_) => CheckoutBloc(createOrderUseCase: sl()),
      ),
    ],
    child: const CartScreen(),
  );
}
