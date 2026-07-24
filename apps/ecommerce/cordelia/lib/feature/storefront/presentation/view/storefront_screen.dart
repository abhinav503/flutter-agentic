import 'package:core/core/base/base_screen.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:flutter/material.dart';

import 'package:cordelia/constants/value_const.dart';

class StorefrontScreen extends BaseScreen {
  const StorefrontScreen({super.key});

  @override
  State<StorefrontScreen> createState() => _StorefrontScreenState();
}

class _StorefrontScreenState extends BaseScreenState<StorefrontScreen> {
  @override
  Widget body(BuildContext context) => EmptyState(
    iconData: Icons.storefront_outlined,
    title: ValueConst.storefrontComingSoonTitle,
    subtitle: ValueConst.storefrontComingSoonSubtitle,
  );
}
