import '../models/joke_model.dart';
import '../models/joke_search_response_model.dart';

abstract interface class JokesRemoteDataSource {
  Future<JokeModel> getRandomJoke();

  Future<JokeSearchResponseModel> searchJokes({
    required String term,
    required int page,
    int limit = 20,
  });
}
