import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/pincode_info_entity.dart';
import '../repository/geo_repository.dart';

class LookupPincodeParams {
  final String pincode;
  const LookupPincodeParams({required this.pincode});
}

class LookupPincodeUseCase
    extends
        UseCase<Either<Failure, PincodeInfoEntity?>, LookupPincodeParams> {
  final GeoRepository _repository;
  const LookupPincodeUseCase(this._repository);

  @override
  Future<Either<Failure, PincodeInfoEntity?>> call(LookupPincodeParams params) =>
      _repository.lookupPincode(params.pincode);
}
