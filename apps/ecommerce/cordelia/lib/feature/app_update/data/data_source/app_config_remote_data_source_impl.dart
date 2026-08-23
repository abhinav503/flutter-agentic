import 'package:core/core/network/http_service.dart';

import 'package:cordelia/constants/api_constants.dart';

import '../models/app_config_model.dart';
import 'app_config_remote_data_source.dart';

class AppConfigRemoteDataSourceImpl implements AppConfigRemoteDataSource {
  const AppConfigRemoteDataSourceImpl();

  @override
  Future<AppConfigModel> getAppConfig() async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.appConfigPath,
    );
    return AppConfigModel.fromJson(response.data ?? const {});
  }
}
