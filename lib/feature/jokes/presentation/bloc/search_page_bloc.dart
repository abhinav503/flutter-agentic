import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/joke_entity.dart';
import '../../domain/usecase/search_jokes_usecase.dart';

part 'search_page_bloc.freezed.dart';
part 'search_page_event.dart';
part 'search_page_state.dart';

class SearchPageBloc extends Bloc<SearchPageEvent, SearchPageState> {
  final SearchJokesUseCase _searchJokes;

  SearchPageBloc({required SearchJokesUseCase searchJokesUseCase})
      : _searchJokes = searchJokesUseCase,
        super(const SearchPageState.initial()) {
    on<SearchPageSubmitted>(_onSubmitted);
    on<SearchPageChipSelected>(_onChipSelected);
    on<SearchPageLoadMore>(_onLoadMore);
  }

  Future<void> _onSubmitted(
    SearchPageSubmitted event,
    Emitter<SearchPageState> emit,
  ) async {
    await _doSearch(term: event.term, emit: emit);
  }

  Future<void> _onChipSelected(
    SearchPageChipSelected event,
    Emitter<SearchPageState> emit,
  ) async {
    await _doSearch(term: event.term, emit: emit);
  }

  Future<void> _doSearch({
    required String term,
    required Emitter<SearchPageState> emit,
  }) async {
    emit(const SearchPageState.loading());
    final result = await _searchJokes(SearchJokesParams(term: term, page: 1));
    result.fold(
      (f) => emit(SearchPageState.error(message: f.message, searchTerm: term)),
      (page) => emit(SearchPageState.loaded(
        results: page.results,
        totalJokes: page.totalJokes,
        totalPages: page.totalPages,
        currentPage: page.currentPage,
        searchTerm: page.searchTerm,
      )),
    );
  }

  Future<void> _onLoadMore(
    SearchPageLoadMore event,
    Emitter<SearchPageState> emit,
  ) async {
    final current = switch (state) {
      SearchPageLoaded() => state as SearchPageLoaded,
      _ => null,
    };
    if (current == null) return;
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
