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

  // Scoped to the store: store A's categories then store B's behind an
  // unscoped static cache would flash A's stale groups before B's fetch
  // resolves.
  static final _cache = ScopedBlocCache<CategoriesEntity>();

  @visibleForTesting
  static void resetCache() => _cache.reset();

  CategoriesBloc({
    required GetCategoriesUseCase getCategoriesUseCase,
    required String storeId,
  }) : _getCategories = getCategoriesUseCase,
       _storeId = storeId,
       super(
         _cache.seed(
           scope: storeId,
           warm: (categories) => CategoriesState.loaded(categories: categories),
           cold: CategoriesState.loading,
         ),
       ) {
    on<CategoriesStarted>(_onStarted);
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
    _cache.save(_storeId, categories);
    emit(CategoriesState.loaded(categories: categories));
  }
}
