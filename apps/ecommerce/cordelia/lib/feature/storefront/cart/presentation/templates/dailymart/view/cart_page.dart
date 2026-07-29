import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_page.dart';

import 'package:cordelia/di/injection_container.dart';

import '../../../bloc/checkout_bloc.dart';
import 'cart_screen.dart';

/// `dailymart` template's routed Cart entry — what the PDP/search cart
/// controls push. The shell's Cart *tab* mounts [CartScreen] directly with
/// its own [CheckoutBloc]; both hosts share the app-root `CartCubit`.
///
/// No `CartBloc` here, unlike gravia's page: that bloc only feeds gravia's
/// upsell rail, and this kit's cart draws none.
class CartPage extends BasePage {
  final String storeId;

  const CartPage({super.key, required this.storeId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends BasePageState<CartPage> {
  @override
  Color? backgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) => BlocProvider(
    create: (_) => CheckoutBloc(
      createPaymentUseCase: sl(),
      processPaymentUseCase: sl(),
      createOrderUseCase: sl(),
      storeId: widget.storeId,
    ),
    child: Builder(
      builder: (context) => CartScreen(onBack: () => context.pop()),
    ),
  );
}
