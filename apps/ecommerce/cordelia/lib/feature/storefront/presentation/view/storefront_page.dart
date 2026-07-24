import 'package:core/core/base/base_page.dart';
import 'package:core/core/ui/atoms/top_bar.dart';
import 'package:flutter/material.dart';

import 'storefront_screen.dart';

/// Placeholder landing page for a selected store — presentation-only, no
/// data/domain layer, since there's genuinely nothing to fetch yet. Proves
/// the discovery → storefront hop works; real per-store catalog/cart/
/// checkout wiring is a later pass (see docs/explanation/superapp-ecommerce-plan.md).
class StorefrontPage extends BasePage {
  final String storeId;
  final String storeName;

  const StorefrontPage({
    super.key,
    required this.storeId,
    required this.storeName,
  });

  @override
  State<StorefrontPage> createState() => _StorefrontPageState();
}

class _StorefrontPageState extends BasePageState<StorefrontPage> {
  @override
  PreferredSizeWidget buildAppBar(BuildContext context) =>
      AppTopBar.primary(title: widget.storeName);

  @override
  Widget buildBody(BuildContext context) => const StorefrontScreen();
}
