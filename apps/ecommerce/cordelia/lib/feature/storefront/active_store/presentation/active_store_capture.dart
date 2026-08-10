import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/feature/storefront/active_store/domain/entities/active_store_entity.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';

/// Captures the open store **once, at mount**, for any page or screen inside
/// a storefront.
///
/// Every one of these belongs to exactly one store for its whole life. The
/// app-level [ActiveStoreCubit] does not: `StorefrontPage` clears it as the
/// storefront tears down, and that teardown runs *while the pop is still
/// animating*, so the outgoing screen is still mounted and still rebuilding
/// when its store disappears.
///
/// Reading the cubit during `build` therefore threw
/// `Null check operator used on a null value` on the way out of a store. A
/// back **swipe** made it reliable rather than occasional: the gesture
/// changes viewport metrics on every frame, which rebuilds anything
/// depending on `MediaQuery` — dozens of chances to read a store that is
/// already gone, where a button back gets one.
///
/// Reads inside callbacks (`onTap`, a submit handler) are fine and are left
/// alone: a callback only fires while the screen is live and interactive,
/// long before any teardown.
mixin ActiveStoreCapture<T extends StatefulWidget> on State<T> {
  /// The store this screen was opened for. Safe from `initState` onward.
  late final ActiveStoreEntity activeStore;

  String get storeId => activeStore.storeId;

  @override
  void initState() {
    super.initState();
    // `!` is honest here in a way it is not in `build`: nothing mounts a
    // storefront screen before StorefrontPage has seeded the store.
    activeStore = context.read<ActiveStoreCubit>().state!;
  }
}
