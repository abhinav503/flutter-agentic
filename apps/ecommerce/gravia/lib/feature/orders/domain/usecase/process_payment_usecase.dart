import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/payment_intent_entity.dart';
import '../entities/payment_result_entity.dart';
import '../repository/payment_gateway_repository.dart';

class ProcessPaymentParams {
  final PaymentIntentEntity intent;

  const ProcessPaymentParams({required this.intent});
}

/// Takes a server-created payment intent through the provider's checkout and
/// returns the verifiable result. The BLoC calls this without knowing which
/// provider runs underneath.
class ProcessPaymentUseCase
    extends UseCase<Either<Failure, PaymentResultEntity>, ProcessPaymentParams> {
  final PaymentGatewayRepository _repository;

  const ProcessPaymentUseCase(this._repository);

  @override
  Future<Either<Failure, PaymentResultEntity>> call(
    ProcessPaymentParams params,
  ) => _repository.processPayment(params.intent);
}
