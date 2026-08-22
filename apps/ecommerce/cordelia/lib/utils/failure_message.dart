import 'package:core/core/error/failure.dart';

import 'package:cordelia/constants/value_const.dart';

/// What a shopper should read when a [Failure] has to be shown.
///
/// Only [NetworkFailure] is rewritten, and that is the point: its `message`
/// is whatever Dio said, which is a developer's sentence in English —
/// "Failed host lookup: 'admin-…vercel.app'. This indicates an error which
/// most likely cannot be solved by the library." A shopper who turned their
/// wifi off should read that they are offline, in their own language.
///
/// Everything else passes through untouched, because everything else has
/// already been written for a person by the time it gets here: a
/// [ServerFailure] carries the API's own `error` text (checkout refusals and
/// coupon rejections are re-written app-side before they reach this point),
/// a [PaymentFailure] carries `ValueConst.paymentFailedMessage`, a
/// [RefusedFailure] carries the localized reason, and auth's
/// [UnexpectedFailure]s carry `readableMessage`. Replacing those with a
/// generic line would lose the specific thing worth saying.
///
/// A [LocationFailure]'s message *is* technical, but nothing prints it —
/// its callers switch on `reason` through `locationFailureMessage`.
extension FailureMessageX on Failure {
  String get shopperMessage => switch (this) {
    NetworkFailure() => ValueConst.noConnectionMessage,
    _ => message,
  };
}
