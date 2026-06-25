import 'package:core/core/network/http_service.dart';

import 'package:web_terminal/constants/api_constants.dart';
import '../models/app_model.dart';
import 'apps_remote_data_source.dart';

class AppsRemoteDataSourceImpl implements AppsRemoteDataSource {
  const AppsRemoteDataSourceImpl();

  @override
  Future<List<AppModel>> listApps() async {
    final data = await _get(ApiConstants.appsPath);
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
    final data = await _post(path);
    return AppModel.fromJson(data['app'] as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> _get(String path) =>
      _send((origin) => HttpService.instance
          .get<Map<String, dynamic>>('$origin$path')
          .then((r) => r.data!));

  Future<Map<String, dynamic>> _post(String path) =>
      _send((origin) => HttpService.instance
          .post<Map<String, dynamic>>('$origin$path')
          .then((r) => r.data!));

  // Serving origin first, then the default bridge address (dev fallback).
  Future<T> _send<T>(Future<T> Function(String origin) request) async {
    final origins = <String>{
      if (Uri.base.scheme.startsWith('http')) Uri.base.origin,
      ApiConstants.defaultBridgeOrigin,
    };

    Object? lastError;
    for (final origin in origins) {
      try {
        return await request(origin);
      } catch (e) {
        lastError = e;
      }
    }
    throw Exception('Could not reach the local bridge. $lastError');
  }
}
