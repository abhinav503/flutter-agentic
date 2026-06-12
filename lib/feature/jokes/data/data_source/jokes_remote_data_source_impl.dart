import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/http_service.dart';
import '../models/joke_model.dart';
import '../models/joke_search_response_model.dart';
import 'jokes_remote_data_source.dart';

class JokesRemoteDataSourceImpl implements JokesRemoteDataSource {
  const JokesRemoteDataSourceImpl();

  @override
  Future<JokeModel> getRandomJoke() async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      '${ApiConstants.jokesBaseUrl}/',
    );
    return JokeModel.fromJson(response.data!);
  }

  @override
  Future<JokeSearchResponseModel> searchJokes({
    required String term,
    required int page,
    int limit = 20,
  }) async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      '${ApiConstants.jokesBaseUrl}/search',
      queryParameters: {'term': term, 'page': page, 'limit': limit},
    );
    return JokeSearchResponseModel.fromJson(response.data!);
  }
}
