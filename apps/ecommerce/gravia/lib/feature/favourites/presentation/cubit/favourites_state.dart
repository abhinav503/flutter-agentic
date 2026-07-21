import '../../../home/domain/entities/product_entity.dart';

/// [FavouritesCubit]'s state — a flat class rather than a sealed
/// loading/loaded/error hierarchy: unlike a per-screen bloc, this cubit's
/// failure mode is "keep showing whatever's cached" (see `hydrate`'s doc),
/// so [isLoading] is the only transition the Favourite tab needs to render
/// a skeleton instead of a premature "no favourites yet" on first open.
class FavouritesState {
  final bool isLoading;
  final List<ProductEntity> items;

  const FavouritesState({required this.isLoading, required this.items});
}
