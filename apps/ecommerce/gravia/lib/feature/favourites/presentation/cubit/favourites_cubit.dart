import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/usecase/usecase.dart';

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
  Future<void> hydrate() async {
    final result = await _getFavourites(const NoParams());
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
    emit(FavouritesState(isLoading: false, items: [...state.items, product]));
    unawaited(_addFavourite(product.id));
  }

  void _emitAndPersistRemove(String productId) {
    emit(
      FavouritesState(
        isLoading: false,
        items: state.items.where((p) => p.id != productId).toList(),
      ),
    );
    unawaited(_removeFavourite(productId));
  }

  /// Local-only reset for sign-out — same reasoning as `CartCubit.reset`:
  /// the signed-out user's server-side favourites survive untouched for
  /// their next sign-in, this only drops this device's in-memory copy.
  void reset() => emit(const FavouritesState(isLoading: false, items: []));
}
