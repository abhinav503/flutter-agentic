import 'package:core/core/base/base_screen.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:flutter/material.dart';

import 'package:gravia/constants/value_const.dart';

class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen> {
  @override
  Widget body(BuildContext context) => const EmptyState(
        iconData: Icons.storefront_rounded,
        title: ValueConst.storefrontComingTitle,
        subtitle: ValueConst.storefrontComingSubtitle,
      );
}
