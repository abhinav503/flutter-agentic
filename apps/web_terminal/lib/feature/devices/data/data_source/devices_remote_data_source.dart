import '../models/device_model.dart';

abstract interface class DevicesRemoteDataSource {
  Future<List<DeviceModel>> listDevices();
}
