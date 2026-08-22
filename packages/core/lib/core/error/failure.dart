import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/location/location_service.dart' show LocationFailureReason;

part 'failure.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.network({required String message}) = NetworkFailure;
  const factory Failure.server({
    required int statusCode,
    required String message,
  }) = ServerFailure;
  const factory Failure.unexpected({required String message}) =
      UnexpectedFailure;

  /// A payment gateway ended without a successful charge — a real failure or
  /// the shopper cancelling the sheet ([cancelled] true). Provider-agnostic:
  /// which SDK produced it (Razorpay, Stripe, …) never reaches this layer.
  const factory Failure.payment({
    required String message,
    @Default(false) bool cancelled,
  }) = PaymentFailure;

  /// Device location could not be resolved into a position/address —
  /// service off, permission declined, or no fix. [message] is technical
  /// context; screens match on the type and show their own (localized)
  /// copy, same as [PaymentFailure].
  ///
  /// [reason] is what the device said, so a screen can tell "turn location
  /// on" from "grant the permission" instead of printing one catch-all
  /// line. Null means the fix itself succeeded and only the geocode came
  /// back empty — a fourth case the device service has no reason for.
  const factory Failure.location({
    required String message,
    LocationFailureReason? reason,
  }) = LocationFailure;

  /// The server declined an operation and named why with a machine-readable
  /// [code], rather than simply failing. Callers switch on [code] to react
  /// to the *reason* — re-read state, send the shopper somewhere, offer a
  /// different action — instead of only printing [message].
  ///
  /// Deliberately just the two fields: which codes exist, and what each one
  /// means, is the app's business. Core only guarantees the code survives
  /// the trip from the data layer to the screen.
  const factory Failure.refused({
    required String code,
    required String message,
  }) = RefusedFailure;
}
