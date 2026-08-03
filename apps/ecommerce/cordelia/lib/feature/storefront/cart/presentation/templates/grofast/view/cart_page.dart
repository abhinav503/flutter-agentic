import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';

import 'cart_screen.dart';

/// The routed copy of `grofast`'s Bag — pushed from a header bag control, so
/// its back pops. The shell renders the same [CartScreen] as a tab instead.
///
/// No `storeId` and no bloc: the bag's items live in the app-root
/// `CartCubit`, and Checkout resolves the store itself.
class CartPage extends BasePage {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends BasePageState<CartPage> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Color? backgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  @override
  Widget buildBody(BuildContext context) =>
      CartScreen(onBack: () => Navigator.of(context).maybePop());
}
