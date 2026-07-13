import '../models/home_model.dart';

abstract interface class HomeRemoteDataSource {
  Future<HomeModel> getHome();
}
