import 'package:web_terminal/constants/api_constants.dart';
import 'package:web_terminal/network/bridge_client.dart';
import '../models/app_model.dart';
import 'apps_remote_data_source.dart';

class AppsRemoteDataSourceImpl implements AppsRemoteDataSource {
  const AppsRemoteDataSourceImpl();

  @override
  Future<List<AppModel>> listApps() async {
    final data = await BridgeClient.instance.getJson(ApiConstants.appsPath);
    return (data['apps'] as List)
        .cast<Map<String, dynamic>>()
        .map(AppModel.fromJson)
        .toList();
  }

  @override
  Future<AppModel> runApp(String name) =>
      _appAction('${ApiConstants.appsPath}/$name/run');

  @override
  Future<AppModel> stopApp(String name) =>
      _appAction('${ApiConstants.appsPath}/$name/stop');

  Future<AppModel> _appAction(String path) async {
    final data = await BridgeClient.instance.postJson(path);
    return AppModel.fromJson(data['app'] as Map<String, dynamic>);
  }
}
