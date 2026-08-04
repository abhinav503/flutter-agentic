import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';

/// The page-chrome pair almost every storefront page repeats: no app bar
/// (each pack's screen draws its own header — a hero canvas or a header row
/// as the first item of its scroll view) and an explicit surface backdrop
/// (the colour behind the screen's own canvas and behind overscroll), the
/// same override `StorefrontShellState` applies to the shells.
mixin ChromelessStorefrontPage<T extends BasePage> on BasePageState<T> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Color? backgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;
}
