/// Who wrote a notification: the store the shopper is browsing, or
/// CordeliaApps itself.
///
/// Kept apart from [NotificationKind], which says what a notification is
/// *about*. A platform outage notice and a store's own delivery delay can be
/// the same kind and still need different attribution — a store shouldn't be
/// blamed for a message it didn't send.
enum NotificationSource { store, platform }

/// Wire value → enum. An unrecognised source falls back to [store]: a feed
/// item whose origin can't be read is safer shown unlabelled than announced
/// as coming from CordeliaApps.
extension NotificationSourceParse on String {
  NotificationSource toNotificationSource() => switch (this) {
    'platform' => NotificationSource.platform,
    _ => NotificationSource.store,
  };
}
