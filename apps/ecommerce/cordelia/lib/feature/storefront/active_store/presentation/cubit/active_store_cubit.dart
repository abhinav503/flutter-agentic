import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/feature/storefront/active_store/domain/entities/active_store_entity.dart';

/// Which store's storefront is currently open — `null` outside a storefront.
///
/// Lives app-level (provided in `App`, same as `CartCubit`/`FavouritesCubit`
/// and for the same reason: Cart/Product Details/Search are separate GoRouter
/// pages, not descendants of the storefront subtree, yet still need the
/// active store's identity — e.g. Cart's "Track Your Order" jump back to the
/// Orders tab). `StorefrontPage` seeds it on mount and clears it on dispose,
/// so per-store-visit semantics are unchanged: opening a different store
/// means popping to discovery and mounting a new `StorefrontPage`, which
/// re-seeds it.
class ActiveStoreCubit extends Cubit<ActiveStoreEntity?> {
  ActiveStoreCubit() : super(null);

  void open(ActiveStoreEntity store) => emit(store);

  void clear() => emit(null);
}
