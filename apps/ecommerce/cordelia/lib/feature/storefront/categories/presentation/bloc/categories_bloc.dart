import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/base/bloc_cache.dart';

import '../../domain/entities/categories_entity.dart';
import '../../domain/usecase/get_categories_usecase.dart';

part 'categories_bloc.freezed.dart';
part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetCategoriesUseCase _getCategories;
  final String _storeId;
  static final _cache = BlocCache<CategoriesEntity>();

  // Opening store A's categories then store B's behind the same static
  // cache would otherwise flash A's stale groups before B's fetch resolves
  // — same guard as HomeBloc's _cachedStoreId.
  static String? _cachedStoreId;

  @visibleForTesting
  static void resetCache() {
    _cache.reset();
    _cachedStoreId = null;
  }

  CategoriesBloc({
    required GetCategoriesUseCase getCategoriesUseCase,
    required String storeId,
  }) : _getCategories = getCategoriesUseCase,
       _storeId = storeId,
       super(_seed(storeId)) {
    on<CategoriesStarted>(_onStarted);
  }

  static CategoriesState _seed(String storeId) {
    if (_cachedStoreId != storeId) {
      _cache.reset();
      _cachedStoreId = storeId;
    }
    return _cache.seed(
      warm: (categories) => CategoriesState.loaded(categories: categories),
      cold: CategoriesState.loading,
    );
  }

  Future<void> _onStarted(
    CategoriesStarted event,
    Emitter<CategoriesState> emit,
  ) async {
    final result = await _getCategories(GetCategoriesParams(storeId: _storeId));
    result.fold((failure) {
      switch (state) {
        case CategoriesLoaded(:final categories):
          emit(
            CategoriesState.loaded(categories: categories, refreshFailed: true),
          );
        case CategoriesLoading():
        case CategoriesError():
          emit(CategoriesState.error(message: failure.message));
      }
    }, (categories) => _emitLoaded(categories, emit));
  }

  void _emitLoaded(CategoriesEntity categories, Emitter<CategoriesState> emit) {
    _cache.save(categories);
    emit(CategoriesState.loaded(categories: categories));
  }
}
