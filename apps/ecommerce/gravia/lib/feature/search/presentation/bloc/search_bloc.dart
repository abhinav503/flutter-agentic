import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/usecase/usecase.dart';

import '../../domain/entities/search_entity.dart';
import '../../domain/usecase/get_search_usecase.dart';

part 'search_bloc.freezed.dart';
part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetSearchUseCase _getSearch;

  SearchBloc({required GetSearchUseCase getSearchUseCase})
      : _getSearch = getSearchUseCase,
        super(const SearchState.loading()) {
    on<SearchStarted>(_onStarted);
    on<SearchRecentSearchRemoved>(_onRecentSearchRemoved);
  }

  Future<void> _onStarted(SearchStarted event, Emitter<SearchState> emit) async {
    final result = await _getSearch(const NoParams());
    result.fold(
      (failure) => emit(SearchState.error(message: failure.message)),
      (search) => emit(SearchState.loaded(search: search)),
    );
  }

  void _onRecentSearchRemoved(
    SearchRecentSearchRemoved event,
    Emitter<SearchState> emit,
  ) {
    switch (state) {
      case SearchLoaded(:final search):
        final updated =
            search.recentSearches.where((t) => t != event.term).toList();
        emit(SearchState.loaded(search: search.copyWith(recentSearches: updated)));
      case SearchLoading():
      case SearchError():
        break;
    }
  }
}
