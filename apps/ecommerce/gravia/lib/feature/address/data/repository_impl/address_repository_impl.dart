import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/address_entity.dart';
import '../../domain/repository/address_repository.dart';
import '../data_source/address_remote_data_source.dart';

class AddressRepositoryImpl with BaseRepository implements AddressRepository {
  final AddressRemoteDataSource _dataSource;

  const AddressRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddresses() =>
      handleRequest(() async {
        final models = await _dataSource.getAddresses();
        return right(models.map((m) => m.toEntity()).toList());
      });

  @override
  Future<Either<Failure, AddressEntity>> createAddress(AddressEntity address) =>
      handleRequest(() async {
        final model = await _dataSource.createAddress(address);
        return right(model.toEntity());
      });

  @override
  Future<Either<Failure, AddressEntity>> updateAddress(AddressEntity address) =>
      handleRequest(() async {
        final model = await _dataSource.updateAddress(address);
        return right(model.toEntity());
      });
}
