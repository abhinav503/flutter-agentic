import '../models/setup_model.dart';

abstract interface class SetupRemoteDataSource {
  Future<List<SetupItemModel>> getSetupStatus();
}
