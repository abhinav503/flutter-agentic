import '../models/app_config_model.dart';

abstract interface class AppConfigRemoteDataSource {
  Future<AppConfigModel> getAppConfig();
}
