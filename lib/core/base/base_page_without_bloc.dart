import 'package:flutter/material.dart';

/// Abstract base for pages that manage loading entirely through their own
/// feature BLoC state and do not need a [MasterBloc] loader.
///
/// Identical scaffold hooks to [BasePage] — swap the superclass when you
/// need MasterBloc, keep this one when you don't.
abstract class BasePageWithoutBloc extends StatefulWidget {
  const BasePageWithoutBloc({super.key});
}

abstract class BasePageWithoutBlocState<T extends BasePageWithoutBloc>
    extends State<T> {
  Widget buildBody(BuildContext context);

  PreferredSizeWidget? buildAppBar(BuildContext context) => null;
  Widget? buildFab(BuildContext context) => null;
  Widget? buildBottomNav(BuildContext context) => null;
  Color? backgroundColor(BuildContext context) => null;
  bool get resizeToAvoidBottomInset => true;

  /// Override to wrap feature BLoCs above the Scaffold so they are accessible
  /// to buildBody(), buildFab(), and buildAppBar().
  Widget buildBlocProviders(Widget child) => child;

  @override
  Widget build(BuildContext context) {
    return buildBlocProviders(
      Scaffold(
        appBar: buildAppBar(context),
        body: buildBody(context),
        floatingActionButton: buildFab(context),
        bottomNavigationBar: buildBottomNav(context),
        backgroundColor: backgroundColor(context),
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      ),
    );
  }
}
