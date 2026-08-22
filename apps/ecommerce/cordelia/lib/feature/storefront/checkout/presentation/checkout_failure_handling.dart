import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_screen.dart';

import 'package:cordelia/enums/checkout_refusal_code.dart';

import '../../cart/presentation/cubit/cart_cubit.dart';

/// What every template does when the server turns a checkout down. Shared so
/// the two halves can't come apart: the shopper is told, *and* whatever the
/// refusal was about is put right on screen.
mixin CheckoutFailureHandling<T extends BaseScreen> on BaseScreenState<T> {
  void onCheckoutFailed(String message, CheckoutRefusalCode code) {
    showSnackBar(message);
    // Only a stock refusal means the cart on screen is out of date. The
    // refusal names one product, but anything could have moved while the
    // shopper sat here — re-reading the whole cart corrects every row at
    // once, which is also what turns "there isn't enough X left" into a row
    // that shows how many there are.
    //
    // An unserviceable address is about *where*, not *what*: the rows are
    // correct and re-fetching them would only make the screen flicker while
    // saying nothing. The shopper's next move is to pick another address,
    // which the message tells them.
    //
    // A failure the server didn't name could be anything, stock included, so
    // it re-reads too rather than leave a wrong row up.
    final refreshCart = switch (code) {
      CheckoutRefusalCode.insufficientStock ||
      CheckoutRefusalCode.other => true,
      CheckoutRefusalCode.unserviceableAddress => false,
    };
    if (refreshCart) context.read<CartCubit>().refresh();
  }
}
