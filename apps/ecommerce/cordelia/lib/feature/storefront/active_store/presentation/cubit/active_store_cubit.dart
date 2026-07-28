import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/feature/storefront/active_store/domain/entities/active_store_entity.dart';

/// Which store's storefront is currently open — `null` outside a storefront.
///
/// Lives app-level (provided in `App`, same as `CartCubit`/`FavouritesCubit`
/// and for the same reason: Cart/Product Details/Search are separate GoRouter
/// pages, not descendants of the storefront subtree, yet still need the
/// active store's identity — e.g. Cart's "Track Your Order" jump back to the
/// Orders tab). `StorefrontPage` seeds it on mount and closes it on dispose,
/// so per-store-visit semantics are unchanged: opening a different store
/// means popping to discovery and mounting a new `StorefrontPage`, which
/// re-seeds it.
class ActiveStoreCubit extends Cubit<ActiveStoreEntity?> {
  ActiveStoreCubit() : super(null);

  /// Bumped on every [open]. A storefront tearing itself down compares its own
  /// token against this to learn whether it is still the one on screen — see
  /// [isCurrentSession].
  int _session = 0;

  /// Opens [store] and returns a token identifying this storefront session,
  /// which the caller hands back when it tears down.
  int open(ActiveStoreEntity store) {
    emit(store);
    return ++_session;
  }

  /// Whether [session] is still the storefront on screen.
  ///
  /// A tab jump — `context.go(AppRoutes.storefront, …)`, used by Cart's "Track
  /// Your Order", Profile's "My Orders" and Home's "see all" — mounts the next
  /// `StorefrontPage` **before** the outgoing one's deferred teardown runs. An
  /// outgoing storefront must check this first, or it tears down the session
  /// the incoming one just opened and every later frame reads a null store.
  bool isCurrentSession(int session) => session == _session;

  /// Clears the active store, unless another storefront has opened since
  /// [session] began — in which case that one now owns this state.
  ///
  /// Named `closeSession`, not `close`: `BlocBase.close()` already exists and
  /// disposes the cubit itself.
  void closeSession(int session) {
    if (!isCurrentSession(session)) return;
    emit(null);
  }
}
