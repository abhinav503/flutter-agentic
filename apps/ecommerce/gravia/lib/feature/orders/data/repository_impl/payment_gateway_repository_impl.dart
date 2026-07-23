import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/payment_intent_entity.dart';
import '../../domain/entities/payment_result_entity.dart';
import '../../domain/repository/payment_gateway_repository.dart';
import '../data_source/payment_gateway_data_source.dart';

/// Deliberately does not use [BaseRepository]: that maps [DioException]s, but a
/// payment gateway fails with a [PaymentGatewayException], not a Dio error.
/// This is the one place that translation lives.
class PaymentGatewayRepositoryImpl implements PaymentGatewayRepository {
  final PaymentGatewayDataSource _dataSource;

  const PaymentGatewayRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, PaymentResultEntity>> processPayment(
    PaymentIntentEntity intent,
  ) async {
    try {
      final result = await _dataSource.processPayment(intent);
      return right(result);
    } on PaymentGatewayException catch (e) {
      return left(Failure.payment(message: e.message, cancelled: e.cancelled));
    } catch (e) {
      return left(Failure.unexpected(message: e.toString()));
    }
  }
}
