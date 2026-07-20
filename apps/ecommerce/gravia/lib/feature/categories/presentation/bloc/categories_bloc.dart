import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/base/bloc_cache.dart';
import 'package:core/core/usecase/usecase.dart';

import '../../domain/entities/categories_entity.dart';
import '../../domain/usecase/get_categories_usecase.dart';

part 'categories_bloc.freezed.dart';
part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetCategoriesUseCase _getCategories;
  static final _cache = BlocCache<CategoriesEntity>();

  @visibleForTesting
  static void resetCache() => _cache.reset();

  CategoriesBloc({required GetCategoriesUseCase getCategoriesUseCase})
    : _getCategories = getCategoriesUseCase,
      super(
        _cache.seed(
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
    final result = await _getCategories(const NoParams());
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
