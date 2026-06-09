import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/joke_search_result_entity.dart';
import '../../domain/usecase/search_jokes_usecase.dart';

part 'joke_search_bloc.freezed.dart';
part 'joke_search_event.dart';
part 'joke_search_state.dart';

class JokeSearchBloc extends Bloc<JokeSearchEvent, JokeSearchState> {
  final SearchJokesUseCase _searchJokes;

  JokeSearchBloc(this._searchJokes) : super(const JokeSearchState.initial()) {
    on<JokeSearchSubmitted>(_onSubmitted);
    on<JokeSearchChipSelected>(_onChipSelected);
    on<JokeSearchLoadMore>(_onLoadMore);
  }

  Future<void> _onSubmitted(
    JokeSearchSubmitted event,
    Emitter<JokeSearchState> emit,
  ) async {
    emit(const JokeSearchState.loading());
    final result = await _searchJokes(
      SearchJokesParams(term: event.term, page: 1),
    );
    result.fold(
      (f) => emit(JokeSearchState.error(message: f.message)),
      (page) => emit(JokeSearchState.loaded(
        results: page.results,
        totalJokes: page.totalJokes,
        totalPages: page.totalPages,
        currentPage: page.currentPage,
        searchTerm: page.searchTerm,
      )),
    );
  }

  Future<void> _onChipSelected(
    JokeSearchChipSelected event,
    Emitter<JokeSearchState> emit,
  ) async {
    add(JokeSearchEvent.submitted(term: event.term));
  }

  Future<void> _onLoadMore(
    JokeSearchLoadMore event,
    Emitter<JokeSearchState> emit,
  ) async {
    final current = state;
    if (current is! JokeSearchLoaded) return;
    if (current.currentPage >= current.totalPages) return;

    emit(current.copyWith(isLoadingMore: true));
    final result = await _searchJokes(
      SearchJokesParams(term: current.searchTerm, page: current.currentPage + 1),
    );
    result.fold(
      (f) => emit(current.copyWith(isLoadingMore: false)),
      (page) => emit(current.copyWith(
        results: [...current.results, ...page.results],
        currentPage: page.currentPage,
        isLoadingMore: false,
      )),
    );
  }
}
