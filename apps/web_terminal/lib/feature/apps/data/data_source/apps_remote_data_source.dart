import '../models/app_model.dart';

abstract interface class AppsRemoteDataSource {
  Future<List<AppModel>> listApps();
  Future<AppModel> runApp(String name);
  Future<AppModel> stopApp(String name);
}
