import 'package:flutter/foundation.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/storefront/active_store/domain/entities/active_store_entity.dart';

/// Composes the `mailto:` a support row opens — subject, and a body that
/// already says who is writing and about what.
///
/// The prefill is the whole point of the channel: a support mail that arrives
/// as "my order is wrong" with no order number costs a round trip before
/// anyone can even look it up, and the shopper is the one waiting through it.
class SupportMessage {
  /// The storefront the shopper is in. Null outside one — Help & Support
  /// reached from CordeliaApps' own chrome, where there is no store to name
  /// and nothing about an order to describe.
  final ActiveStoreEntity? store;

  /// The signed-in shopper's address. Empty is tolerated — the line is
  /// dropped rather than printed blank.
  final String accountEmail;

  /// Set when the shopper came from a specific order. Empty otherwise.
  final String orderId;

  /// "1.0.4 (4)", or empty when the bundle couldn't be read.
  final String version;

  const SupportMessage({
    required this.store,
    required this.accountEmail,
    required this.orderId,
    required this.version,
  });

  /// To the store's own address — the channel for anything about an order.
  Uri mailtoStore(String address) => _mailto(address, _subjectForStore());

  /// To CordeliaApps. Same body: whoever answers still needs to know which
  /// store and which order, and a shopper who arrived here from an order
  /// should not have to retype it because the store published no address.
  Uri mailtoPlatform() =>
      _mailto(ValueConst.platformSupportEmail, _subjectForPlatform());

  /// A dialable `tel:` for [phone].
  ///
  /// Punctuation the owner typed for readability ("+91 98765 43210") is not
  /// valid in the URI, so only `+` and digits survive here — the row still
  /// *displays* the number exactly as it was written.
  static Uri tel(String phone) =>
      Uri(scheme: 'tel', path: phone.replaceAll(RegExp(r'[^\d+]'), ''));

  String _subjectForStore() => orderId.isEmpty
      ? ValueConst.supportEmailSubjectStore(store?.storeName ?? '')
      : ValueConst.supportEmailSubjectOrder(orderId);

  String _subjectForPlatform() => orderId.isEmpty
      ? ValueConst.supportEmailSubjectPlatform
      : ValueConst.supportEmailSubjectOrder(orderId);

  /// The body: room to write, then the identifiers support needs.
  ///
  /// The details sit *below* a rule with a line asking for them to be left
  /// in, rather than above the cursor — a shopper writing on a phone starts
  /// at the top, and anything in the way there tends to be deleted.
  String _body() {
    final details = <String>[
      if (orderId.isNotEmpty) '${ValueConst.supportEmailOrderLabel}: $orderId',
      if (store != null)
        '${ValueConst.supportEmailStoreLabel}: '
            '${store!.storeName} (${store!.storeId})',
      if (accountEmail.isNotEmpty)
        '${ValueConst.supportEmailAccountLabel}: $accountEmail',
      '${ValueConst.supportEmailAppLabel}: ${_appLine()}',
    ];
    return [
      ValueConst.supportEmailBodyPrompt,
      '',
      '',
      '—',
      ValueConst.supportEmailBodyDetailsHeading,
      ...details,
    ].join('\n');
  }

  /// Diagnostic, so deliberately not localized: a version string and a
  /// platform name mean the same thing to whoever reads the ticket in every
  /// language, and translating "android" would only make it harder to match
  /// against a crash report.
  String _appLine() {
    final platform = kIsWeb ? 'web' : defaultTargetPlatform.name;
    return version.isEmpty
        ? 'Cordelia · $platform'
        : 'Cordelia $version · $platform';
  }

  /// Built by hand rather than through [Uri]'s `queryParameters`, which
  /// encodes a space as `+` — correct for a form post, and shown literally
  /// as a plus sign by several mail clients when it lands in a subject line.
  Uri _mailto(String address, String subject) => Uri.parse(
    'mailto:${Uri.encodeComponent(address)}'
    '?subject=${Uri.encodeComponent(subject)}'
    '&body=${Uri.encodeComponent(_body())}',
  );
}
