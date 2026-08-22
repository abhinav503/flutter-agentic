import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../../domain/usecase/add_favourite_usecase.dart';
import '../../domain/usecase/get_favourites_usecase.dart';
import '../../domain/usecase/remove_favourite_usecase.dart';
import 'favourites_state.dart';

/// Favourite state shared across the whole app (Home, Product Details,
/// Search, and the Favourite tab itself) — provided once at the app root in
/// `app.dart`, same reasoning and same shape as [CartCubit]: local state is
/// the source of truth for the UI (every toggle emits synchronously), the
/// backend is kept in sync as a best-effort side effect via `_persist`. The
/// state holds full [ProductEntity]s, not just ids, so the Favourite tab has
/// something to render without a second fetch.
class FavouritesCubit extends Cubit<FavouritesState> {
  final GetFavouritesUseCase _getFavourites;
  final AddFavouriteUseCase _addFavourite;
  final RemoveFavouriteUseCase _removeFavourite;

  // FavouritesCubit is a single app-root instance (see class doc) reused
  // across every store a shopper opens — this tracks which store's
  // favourites are currently loaded, same reasoning as CartCubit._storeId.
  String? _storeId;

  // Bumped by every local mutation and by [reset], so a hydrate that was
  // already in flight can tell its result is no longer wanted — same guard
  // CartCubit keeps, and for the same reason: the account can change under
  // an unfinished fetch.
  int _revision = 0;

  FavouritesCubit({
    required GetFavouritesUseCase getFavouritesUseCase,
    required AddFavouriteUseCase addFavouriteUseCase,
    required RemoveFavouriteUseCase removeFavouriteUseCase,
  }) : _getFavourites = getFavouritesUseCase,
       _addFavourite = addFavouriteUseCase,
       _removeFavourite = removeFavouriteUseCase,
       // isLoading starts true — not warm-cached like HomeBloc/AddressBloc,
       // so a shopper landing straight on the Favourite tab (before
       // ShellPage.initState's hydrate resolves) sees a skeleton, not a
       // premature "no favourites yet".
       super(const FavouritesState(isLoading: true, items: []));

  /// Loads the signed-in shopper's persisted favourites — called once, from
  /// `ShellPage.initState` alongside `CartCubit.hydrate`. A failed load
  /// leaves the list empty rather than surfacing an error, same reasoning as
  /// `CartCubit.hydrate`: an empty favourites list is always a safe,
  /// recoverable start state — it just also clears [FavouritesState.isLoading]
  /// so the tab stops showing its skeleton.
  Future<void> hydrate(String storeId) async {
    if (_storeId != storeId) {
      _storeId = storeId;
      // Switching stores — the previous store's favourites don't apply here.
      emit(const FavouritesState(isLoading: true, items: []));
    }
    final revision = _revision;
    final result = await _getFavourites(GetFavouritesParams(storeId: storeId));
    if (_revision != revision || _storeId != storeId) return;
    result.fold(
      (failure) => emit(FavouritesState(isLoading: false, items: state.items)),
      (products) => emit(FavouritesState(isLoading: false, items: products)),
    );
  }

  bool isFavourite(String productId) =>
      state.items.any((p) => p.id == productId);

  void toggle(ProductEntity product) {
    if (isFavourite(product.id)) {
      _emitAndPersistRemove(product.id);
    } else {
      _emitAndPersistAdd(product);
    }
  }

  void _emitAndPersistAdd(ProductEntity product) {
    _revision++;
    emit(FavouritesState(isLoading: false, items: [...state.items, product]));
    final storeId = _storeId;
    if (storeId != null) {
      unawaited(
        _addFavourite(
          AddFavouriteParams(storeId: storeId, productId: product.id),
        ),
      );
    }
  }

  void _emitAndPersistRemove(String productId) {
    _revision++;
    emit(
      FavouritesState(
        isLoading: false,
        items: state.items.where((p) => p.id != productId).toList(),
      ),
    );
    final storeId = _storeId;
    if (storeId != null) {
      unawaited(
        _removeFavourite(
          RemoveFavouriteParams(storeId: storeId, productId: productId),
        ),
      );
    }
  }

  /// Local-only reset for sign-out — same reasoning as `CartCubit.reset`:
  /// the signed-out user's server-side favourites survive untouched for
  /// their next sign-in, this only drops this device's in-memory copy. The
  /// revision bump and forgotten store are that method's invariants too: a
  /// hydrate still in flight must not paint the previous account's hearts
  /// back on, and a later toggle must not persist against a store this
  /// device is no longer signed into.
  void reset() {
    _revision++;
    _storeId = null;
    emit(const FavouritesState(isLoading: false, items: []));
  }
}
