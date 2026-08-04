import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';

import 'storefront_template.dart';

/// Picks the active store's implementation of a storefront screen that is
/// **pushed on top of** the shell (Notifications, Cart, Search, …).
///
/// The shell itself is dispatched inside `StorefrontPage.buildBody`, but
/// these are separate GoRouter pages outside that subtree — so they resolve
/// the template the same way they already resolve the store: off the
/// app-level [ActiveStoreCubit].
///
/// `read`, not `watch`: which store is open cannot change while one of these
/// routes is on the stack (switching stores means popping back to Discovery
/// and mounting a new `StorefrontPage`), and watching would flip a
/// still-visible page to the fallback when `StorefrontPage` clears the cubit
/// on the way out.
class StorefrontTemplateSwitch extends StatelessWidget {
  final WidgetBuilder gravia;
  final WidgetBuilder dailymart;
  final WidgetBuilder grofast;

  const StorefrontTemplateSwitch({
    super.key,
    required this.gravia,
    required this.dailymart,
    required this.grofast,
  });

  @override
  Widget build(BuildContext context) {
    final template = context.read<ActiveStoreCubit>().state?.templateId;
    // `null` only outside a storefront — Legal pushed from Signup is the one
    // real case. Falling back to gravia matches the same default
    // `String.toStorefrontTemplate()` uses for an unknown template. Handled
    // before the switch so the enum switch stays exhaustive: a 4th template
    // is then a compile error here, not a silent gravia fallback.
    if (template == null) return gravia(context);
    return switch (template) {
      StorefrontTemplate.gravia => gravia(context),
      StorefrontTemplate.dailymart => dailymart(context),
      StorefrontTemplate.grofast => grofast(context),
    };
  }
}
