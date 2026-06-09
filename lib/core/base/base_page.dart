import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/master_bloc.dart';

/// Abstract base for all full-featured pages.
///
/// Provides a [MasterBloc]-scoped [Scaffold] with a full-page loading overlay.
/// Any descendant can trigger the overlay via:
/// ```dart
/// context.read<MasterBloc>().add(ShowLoader());
/// context.read<MasterBloc>().add(HideLoader());
/// ```
abstract class BasePage extends StatefulWidget {
  const BasePage({super.key});
}

abstract class BasePageState<T extends BasePage> extends State<T> {
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
      BlocProvider(
        create: (_) => MasterBloc(),
        // Builder gives scaffold methods a context that has MasterBloc in scope.
        child: Builder(
          builder: (ctx) => Stack(
            children: [
              Scaffold(
                appBar: buildAppBar(ctx),
                body: buildBody(ctx),
                floatingActionButton: buildFab(ctx),
                bottomNavigationBar: buildBottomNav(ctx),
                backgroundColor: backgroundColor(ctx),
                resizeToAvoidBottomInset: resizeToAvoidBottomInset,
              ),
              BlocBuilder<MasterBloc, MasterState>(
                builder: (_, state) => state is MasterLoading
                    ? const _PageLoader()
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageLoader extends StatelessWidget {
  const _PageLoader();

  @override
  Widget build(BuildContext context) {
    final scrim = Theme.of(context).colorScheme.scrim.withValues(alpha: 0.33);
    return ColoredBox(
      color: scrim,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
