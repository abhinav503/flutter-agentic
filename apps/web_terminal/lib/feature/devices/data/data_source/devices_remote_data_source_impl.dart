import 'package:web_terminal/constants/api_constants.dart';
import 'package:web_terminal/network/bridge_client.dart';
import '../models/device_model.dart';
import 'devices_remote_data_source.dart';

class DevicesRemoteDataSourceImpl implements DevicesRemoteDataSource {
  const DevicesRemoteDataSourceImpl();

  @override
  Future<List<DeviceModel>> listDevices() async {
    final data = await BridgeClient.instance.getJson(ApiConstants.devicesPath);
    return (data['devices'] as List)
        .cast<Map<String, dynamic>>()
        .map(DeviceModel.fromJson)
        .toList();
  }
}
