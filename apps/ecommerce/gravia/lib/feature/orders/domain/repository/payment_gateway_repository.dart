import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/payment_intent_entity.dart';
import '../entities/payment_result_entity.dart';

/// The payment provider, seen only as a capability: "take this server-created
/// intent through a checkout and return a verifiable result". The concrete
/// provider (Razorpay today, another tomorrow) lives entirely in the data
/// layer — swapping it is a data-source-impl change, invisible here, in the
/// use case, the BLoC, and the screen.
abstract interface class PaymentGatewayRepository {
  Future<Either<Failure, PaymentResultEntity>> processPayment(
    PaymentIntentEntity intent,
  );
}
