import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import 'package:gravia/feature/cart/domain/entities/cart_item_entity.dart';

import '../entities/payment_intent_entity.dart';
import '../repository/orders_repository.dart';

class CreatePaymentParams {
  final List<CartItemEntity> items;
  final String addressId;

  const CreatePaymentParams({required this.items, required this.addressId});
}

class CreatePaymentUseCase
    extends UseCase<Either<Failure, PaymentIntentEntity>, CreatePaymentParams> {
  final OrdersRepository _repository;

  const CreatePaymentUseCase(this._repository);

  @override
  Future<Either<Failure, PaymentIntentEntity>> call(
    CreatePaymentParams params,
  ) => _repository.createPayment(params.items, params.addressId);
}
