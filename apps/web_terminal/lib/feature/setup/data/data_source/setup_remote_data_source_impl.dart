import 'package:web_terminal/constants/api_constants.dart';
import 'package:web_terminal/network/bridge_client.dart';
import '../models/setup_model.dart';
import 'setup_remote_data_source.dart';

class SetupRemoteDataSourceImpl implements SetupRemoteDataSource {
  const SetupRemoteDataSourceImpl();

  @override
  Future<List<SetupItemModel>> getSetupStatus() async {
    final data = await BridgeClient.instance.getJson(ApiConstants.setupPath);
    return (data['items'] as List)
        .cast<Map<String, dynamic>>()
        .map(SetupItemModel.fromJson)
        .toList();
  }
}
