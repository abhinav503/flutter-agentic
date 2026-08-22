import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/home/domain/entities/store_support_entity.dart';
import 'package:cordelia/feature/storefront/active_store/domain/entities/active_store_entity.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/services/app_info_service.dart';
import 'package:core/core/auth/auth_session.dart';

import 'package:cordelia/di/injection_container.dart';

import 'package:cordelia/feature/support/presentation/support_message.dart';

/// What a support row does when tapped — the packs use this to pick a glyph,
/// and [SupportLauncher] to pick a fallback when nothing can open the URI.
enum SupportChannelKind { email, phone, link }

/// One tappable way to reach someone.
class SupportChannel {
  final SupportChannelKind kind;

  /// What the row says ("Send an email").
  final String label;

  /// The address or number under the label, shown so a shopper can read it
  /// even when nothing on the device can open it. Empty for a link row,
  /// where the destination adds nothing the label hasn't said.
  final String value;

  final Uri uri;

  const SupportChannel({
    required this.kind,
    required this.label,
    required this.value,
    required this.uri,
  });
}

/// A titled group of channels — the store, CordeliaApps, the policies.
class SupportSection {
  final String title;
  final String subtitle;

  /// An aside under the channels ("Replies Mon–Sat, 9am–7pm"). Empty when
  /// the store hasn't said when it answers.
  final String note;

  final List<SupportChannel> channels;

  const SupportSection({
    required this.title,
    required this.subtitle,
    required this.channels,
    this.note = '',
  });
}

/// Everything Help & Support renders, resolved once and handed to whichever
/// template is drawing it.
///
/// The three packs draw rows differently but must not each decide *which*
/// rows exist — whether the store publishes a contact, and what the platform
/// section then says, is one rule with one home. Same split as
/// [LegalDocumentContent]: shared content, per-pack chrome.
class SupportChannels {
  final List<SupportSection> sections;

  /// "Cordelia 1.0.4 (4)", or empty if the bundle couldn't be read. Printed
  /// at the foot of the screen and repeated inside the message, because the
  /// answer to "which version are you on" should not depend on the shopper
  /// finding it.
  final String versionLabel;

  const SupportChannels._({required this.sections, required this.versionLabel});

  /// Builds the channels for [store], or for CordeliaApps alone when there
  /// is no storefront open.
  ///
  /// [accountEmail] is the signed-in shopper's address, used to identify them
  /// in the message body; empty is tolerated (the line is simply omitted).
  /// [orderId] present means the shopper arrived from a specific order, which
  /// changes only the subject line and adds one line to the body — the
  /// channels themselves are the same either way.
  factory SupportChannels.build({
    ActiveStoreEntity? store,
    String accountEmail = '',
    String orderId = '',
  }) {
    final version = AppInfoService.instance.displayVersion;
    final message = SupportMessage(
      store: store,
      accountEmail: accountEmail,
      orderId: orderId,
      version: version,
    );

    final support = store?.support ?? StoreSupportEntity.none;

    final sections = <SupportSection>[
      if (support.hasAny)
        SupportSection(
          title: ValueConst.supportStoreSectionTitle(store!.storeName),
          subtitle: ValueConst.supportStoreSectionSubtitle,
          note: support.hasHours
              ? ValueConst.supportHoursLabel(support.hours)
              : '',
          channels: [
            if (support.hasEmail)
              SupportChannel(
                kind: SupportChannelKind.email,
                label: ValueConst.supportEmailAction,
                value: support.email,
                uri: message.mailtoStore(support.email),
              ),
            if (support.hasPhone)
              SupportChannel(
                kind: SupportChannelKind.phone,
                label: ValueConst.supportCallAction,
                value: support.phone,
                uri: SupportMessage.tel(support.phone),
              ),
          ],
        ),
      SupportSection(
        title: ValueConst.supportPlatformSectionTitle,
        // A store with no published contact leaves order problems here too,
        // and the copy says so — the difference between a fallback and a
        // dead end is whether the shopper is told it will be passed on.
        subtitle: support.hasAny
            ? ValueConst.supportPlatformSectionSubtitle
            : ValueConst.supportPlatformOnlySubtitle,
        channels: [
          SupportChannel(
            kind: SupportChannelKind.email,
            label: ValueConst.supportEmailAction,
            value: ValueConst.platformSupportEmail,
            uri: message.mailtoPlatform(),
          ),
        ],
      ),
      SupportSection(
        title: ValueConst.supportPolicySectionTitle,
        subtitle: '',
        channels: [
          SupportChannel(
            kind: SupportChannelKind.link,
            label: ValueConst.supportRefundPolicyAction,
            value: '',
            uri: Uri.parse(ValueConst.refundPolicyUrl),
          ),
        ],
      ),
    ];

    return SupportChannels._(
      sections: sections,
      versionLabel: version.isEmpty
          ? ''
          : ValueConst.supportAppVersionLabel(version),
    );
  }
}

/// Resolves the channels from whatever the app already knows — the storefront
/// session and the signed-in shopper.
///
/// Here rather than at each entry point so Profile, an order's "need help"
/// row and any later caller compose the same message: the identifiers support
/// needs must not depend on which screen the shopper happened to start from.
extension SupportChannelsX on BuildContext {
  /// [orderId] when the shopper arrived from a specific order, which puts the
  /// order number in the subject line and the body.
  SupportChannels supportChannels({String orderId = ''}) =>
      SupportChannels.build(
        store: read<ActiveStoreCubit>().state,
        // Null before sign-in and on a session that has just ended — the
        // account line is then dropped rather than printed empty.
        accountEmail: sl<AuthSession>().currentEmail ?? '',
        orderId: orderId,
      );
}
