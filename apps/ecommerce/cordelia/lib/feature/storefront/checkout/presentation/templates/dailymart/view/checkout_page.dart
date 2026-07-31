import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';

import 'package:cordelia/di/injection_container.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/address/domain/entities/address_entity.dart';

import '../../../bloc/checkout_bloc.dart';
import 'checkout_screen.dart';

/// Route-scoped host for `dailymart`'s Checkout. The [CheckoutBloc] lives
/// here rather than at shell level (where this template used to keep it for
/// the Cart tab): checkout now owns a pushed route that stays mounted for the
/// whole flow, so there's no tab switch that could dispose it mid-order.
class CheckoutPage extends BasePage {
  final AddressEntity address;

  const CheckoutPage({super.key, required this.address});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends BasePageState<CheckoutPage> {
  /// No app bar anywhere in this pack — the screen renders its own header
  /// row as the first item of its body (spec sheet §8).
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Color? backgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  /// `!`: this route is only pushed from inside a storefront, which seeds the
  /// cubit before any of its screens can render — the same assumption every
  /// other pushed storefront route makes (see `StorefrontTemplateSwitch`).
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
