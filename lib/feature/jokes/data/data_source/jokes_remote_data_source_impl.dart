import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/joke_model.dart';
import '../models/joke_search_response_model.dart';
import 'jokes_remote_data_source.dart';

part 'jokes_remote_data_source_impl.g.dart';

@RestApi()
abstract class JokesRemoteDataSourceImpl implements JokesRemoteDataSource {
  factory JokesRemoteDataSourceImpl(Dio dio, {String? baseUrl}) =
      _JokesRemoteDataSourceImpl;

  @override
  @GET('/')
  Future<JokeModel> getRandomJoke();

  @override
  @GET('/search')
  Future<JokeSearchResponseModel> searchJokes({
    @Query('term')  required String term,
    @Query('page')  required int page,
    @Query('limit') int limit = 20,
  });
}
