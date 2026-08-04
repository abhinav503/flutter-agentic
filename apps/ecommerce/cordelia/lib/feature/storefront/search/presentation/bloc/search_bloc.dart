import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/base/bloc_cache.dart';
import 'package:core/core/error/failure.dart';

import 'package:cordelia/utils/event_transformers.dart';

import '../../domain/entities/recent_search_entity.dart';
import '../../domain/entities/search_entity.dart';
import '../../domain/entities/search_results_entity.dart';
import '../../domain/usecase/add_recent_search_usecase.dart';
import '../../domain/usecase/get_search_usecase.dart';
import '../../domain/usecase/remove_recent_search_usecase.dart';
import '../../domain/usecase/search_catalog_usecase.dart';

part 'search_bloc.freezed.dart';
part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetSearchUseCase _getSearch;
  final SearchCatalogUseCase _searchCatalog;
  final AddRecentSearchUseCase _addRecentSearch;
  final RemoveRecentSearchUseCase _removeRecentSearch;
  final String _storeId;

  // Warm-start cache: reopening Search seeds straight into loaded (recents +
  // popular) instead of the shimmer; started then refreshes silently. Only
  // the fetched SearchEntity is cached — query/results are transient view
  // state and always start cold. Scoped to the store: store A's search then
  // store B's behind an unscoped static cache would flash A's stale popular
  // products/recents before B's fetch resolves.
  static final _cache = ScopedBlocCache<SearchEntity>();

  @visibleForTesting
  static void resetCache() => _cache.reset();

  /// Hard cap on suggestions shown under the search field.
  static const int maxSuggestions = 5;

  /// Categories keep a couple of guaranteed slots so a long product list
  /// can't push them out entirely; unused slots flow to the other kind.
  static const int _reservedCategorySuggestions = 2;

  SearchBloc({
    required GetSearchUseCase getSearchUseCase,
    required SearchCatalogUseCase searchCatalogUseCase,
    required AddRecentSearchUseCase addRecentSearchUseCase,
    required RemoveRecentSearchUseCase removeRecentSearchUseCase,
    required String storeId,
  }) : _getSearch = getSearchUseCase,
       _searchCatalog = searchCatalogUseCase,
       _addRecentSearch = addRecentSearchUseCase,
       _removeRecentSearch = removeRecentSearchUseCase,
       _storeId = storeId,
       super(
         _cache.seed(
           scope: storeId,
           warm: (search) => SearchState.loaded(search: search),
           cold: SearchState.loading,
         ),
       ) {
    on<SearchStarted>(_onStarted);
    on<SearchQueryChanged>(_onQueryChanged, transformer: debounceRestartable());
    on<SearchResultSelected>(_onResultSelected);
    on<SearchRecentSearchRemoved>(_onRecentSearchRemoved);
  }

  Future<void> _onStarted(
    SearchStarted event,
    Emitter<SearchState> emit,
  ) async {
    final result = await _getSearch(GetSearchParams(storeId: _storeId));
    result.fold((failure) {
      switch (state) {
        // Warm start: cached content is already on screen — keep it there
        // and let the failure surface as a snackbar instead of an error view.
        case final SearchLoaded loaded:
          emit(loaded.copyWith(refreshFailed: true));
        case SearchLoading():
        case SearchError():
          emit(SearchState.error(message: failure.message));
      }
    }, (search) => _emitFreshSearch(search, emit));
  }

  void _emitFreshSearch(SearchEntity search, Emitter<SearchState> emit) {
    _cache.save(_storeId, search);
    switch (state) {
      // copyWith, not a fresh loaded — on a warm start the shopper may
      // already be typing when the refresh lands; keep their query state.
      case SearchLoaded loaded:
        _emitView(loaded.copyWith(search: search), emit);
      case SearchLoading():
      case SearchError():
        emit(SearchState.loaded(search: search));
    }
  }

  /// Emits a view update with the one-shot [SearchLoaded.refreshFailed] flag
  /// cleared — carried forward by `copyWith`, it would toast again on every
  /// keystroke (same reasoning as `OrdersBloc._emitView`).
  void _emitView(SearchLoaded next, Emitter<SearchState> emit) =>
      emit(next.copyWith(refreshFailed: false));

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    switch (state) {
      case SearchLoaded loaded:
        final query = event.query.trim();
        if (query.isEmpty) {
          _emitView(
            loaded.copyWith(
              query: '',
              searching: false,
              results: null,
              resultsError: null,
            ),
            emit,
          );
          return;
        }

        _emitView(
          loaded.copyWith(
            query: query,
            searching: true,
            results: null,
            resultsError: null,
          ),
          emit,
        );
        final result = await _searchCatalog(
          SearchCatalogParams(storeId: _storeId, query: query),
        );
        switch (state) {
          // The query re-check is belt-and-braces on top of switchMap: only
          // apply results that still answer what's in the field.
          case SearchLoaded current when current.query == query:
            result.fold(
              (failure) => _emitView(
                current.copyWith(
                  searching: false,
                  resultsError: failure.message,
                ),
                emit,
              ),
              (results) => _emitView(
                current.copyWith(
                  searching: false,
                  results: _capSuggestions(results),
                ),
                emit,
              ),
            );
          case SearchLoaded():
          case SearchLoading():
          case SearchError():
            break;
        }
      case SearchLoading():
      case SearchError():
        break;
    }
  }

  Future<void> _onResultSelected(
    SearchResultSelected event,
    Emitter<SearchState> emit,
  ) async {
    switch (state) {
      case SearchLoaded loaded:
        // Optimistic move-to-top so the browse view is correct the moment
        // the shopper navigates back; the server response then replaces it
        // with the authoritative (deduped, capped) list.
        _emitRecents(
          loaded,
          _withNewest(loaded.search.recentSearches, event.item),
          emit,
        );
        final result = await _addRecentSearch(
          AddRecentSearchParams(storeId: _storeId, item: event.item),
        );
        _syncRecents(result, emit);
      case SearchLoading():
      case SearchError():
        break;
    }
  }

  Future<void> _onRecentSearchRemoved(
    SearchRecentSearchRemoved event,
    Emitter<SearchState> emit,
  ) async {
    switch (state) {
      case SearchLoaded loaded:
        _emitRecents(
          loaded,
          _without(loaded.search.recentSearches, event.item),
          emit,
        );
        final result = await _removeRecentSearch(
          RemoveRecentSearchParams(
            storeId: _storeId,
            id: event.item.id,
            type: event.item.type,
          ),
        );
        _syncRecents(result, emit);
      case SearchLoading():
      case SearchError():
        break;
    }
  }

  /// Recents are a nicety, not the screen's content — on failure the
  /// optimistic list simply stands until the next full fetch, rather than
  /// surfacing an error for something the shopper barely notices.
  void _syncRecents(
    Either<Failure, List<RecentSearchEntity>> result,
    Emitter<SearchState> emit,
  ) {
    result.fold((_) {}, (recents) {
      switch (state) {
        case SearchLoaded current:
          _emitRecents(current, recents, emit);
        case SearchLoading():
        case SearchError():
          break;
      }
    });
  }

  /// Single emit path for recents changes — keeps the warm cache in step
  /// with every optimistic update and server sync.
  void _emitRecents(
    SearchLoaded current,
    List<RecentSearchEntity> recents,
    Emitter<SearchState> emit,
  ) {
    final search = current.search.copyWith(recentSearches: recents);
    _cache.save(_storeId, search);
    _emitView(current.copyWith(search: search), emit);
  }

  static List<RecentSearchEntity> _withNewest(
    List<RecentSearchEntity> recents,
    RecentSearchEntity item,
  ) => [
    item,
    ...recents.where((r) => !(r.id == item.id && r.type == item.type)),
  ];

  static List<RecentSearchEntity> _without(
    List<RecentSearchEntity> recents,
    RecentSearchEntity item,
  ) => recents.where((r) => !(r.id == item.id && r.type == item.type)).toList();

  static SearchResultsEntity _capSuggestions(SearchResultsEntity full) {
    var categories = full.categories
        .take(_reservedCategorySuggestions)
        .toList();
    final products = full.products
        .take(maxSuggestions - categories.length)
        .toList();
    if (products.length + categories.length < maxSuggestions) {
      categories = full.categories
          .take(maxSuggestions - products.length)
          .toList();
    }
    return SearchResultsEntity(products: products, categories: categories);
  }
}
