import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_screen.dart';

import '../../cart/presentation/cubit/cart_cubit.dart';

/// What every template does when the server turns a checkout down. Shared so
/// the two halves can't come apart: the shopper is told, *and* the cart is
/// re-read so the rows say the same thing the message does.
mixin CheckoutFailureHandling<T extends BaseScreen> on BaseScreenState<T> {
  void onCheckoutFailed(String message) {
    showSnackBar(message);
    // The refusal names one product, but anything could have moved while the
    // shopper sat on this screen — re-reading the whole cart corrects every
    // row at once, which is also what turns "there isn't enough X left" into
    // a row that shows how many there are.
    context.read<CartCubit>().refresh();
  }
}
