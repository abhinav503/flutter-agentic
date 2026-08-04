import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';
import 'package:cordelia/feature/storefront/presentation/chromeless_page.dart';

import 'package:cordelia/di/injection_container.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/address/domain/entities/address_entity.dart';

import '../../../bloc/checkout_bloc.dart';
import 'checkout_screen.dart';

/// Route-scoped host for `grofast`'s Checkout — the [CheckoutBloc] lives here
/// so it stays mounted for the whole order, exactly as the `dailymart`
/// template hosts its own.
class CheckoutPage extends BasePage {
  final AddressEntity address;

  const CheckoutPage({super.key, required this.address});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends BasePageState<CheckoutPage>
    with ChromelessStorefrontPage {
  /// `!`: this route is only pushed from inside a storefront, which seeds the
  /// cubit before any of its screens can render.
  @override
  Widget buildBody(BuildContext context) => BlocProvider(
    create: (_) => CheckoutBloc(
      createPaymentUseCase: sl(),
      processPaymentUseCase: sl(),
      createOrderUseCase: sl(),
      storeId: context.read<ActiveStoreCubit>().state!.storeId,
    ),
    child: CheckoutScreen(address: widget.address),
  );
}
