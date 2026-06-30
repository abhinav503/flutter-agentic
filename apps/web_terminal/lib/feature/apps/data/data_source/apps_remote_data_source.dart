import '../models/app_model.dart';

abstract interface class AppsRemoteDataSource {
  Future<List<AppModel>> listApps();
  Future<AppModel> runApp(
    String name, {
    required String deviceId,
    required String platform,
    required String kind,
  });
  Future<AppModel> stopApp(String name);
}
