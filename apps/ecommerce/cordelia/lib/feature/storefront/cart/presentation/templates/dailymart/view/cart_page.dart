import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_page.dart';
import 'package:cordelia/feature/storefront/presentation/chromeless_page.dart';

import 'cart_screen.dart';

/// `dailymart` template's routed Cart entry — what the PDP/search cart
/// controls push. The shell's Cart *tab* mounts [CartScreen] directly; both
/// hosts share the app-root `CartCubit` and neither provides anything else.
///
/// No `CartBloc` here, unlike gravia's page: that bloc only feeds gravia's
/// upsell rail, and this kit's cart draws none. No `CheckoutBloc` either —
/// this template's checkout is its own route, which scopes its own.
class CartPage extends BasePage {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends BasePageState<CartPage>
    with ChromelessStorefrontPage {
  @override
  Widget buildBody(BuildContext context) =>
      CartScreen(onBack: () => context.pop());
}
