import 'joke_entity.dart';

class JokeSearchPageEntity {
  final int currentPage;
  final int totalJokes;
  final int totalPages;
  final int nextPage;
  final String searchTerm;
  final List<JokeEntity> results;

  const JokeSearchPageEntity({
    required this.currentPage,
    required this.totalJokes,
    required this.totalPages,
    required this.nextPage,
    required this.searchTerm,
    required this.results,
  });
}
