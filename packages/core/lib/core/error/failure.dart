import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.network({required String message}) = NetworkFailure;
  const factory Failure.server({required int statusCode, required String message}) = ServerFailure;
  const factory Failure.unexpected({required String message}) = UnexpectedFailure;

  /// A payment gateway ended without a successful charge — a real failure or
  /// the shopper cancelling the sheet ([cancelled] true). Provider-agnostic:
  /// which SDK produced it (Razorpay, Stripe, …) never reaches this layer.
  const factory Failure.payment({
    required String message,
    @Default(false) bool cancelled,
  }) = PaymentFailure;
}
