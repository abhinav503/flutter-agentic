/// Where a store sits in the CordeliaApps publication lifecycle
/// (`admin/src/lib/store-status.ts` owns the same set on the server).
///
/// The shopper app never uses this for access control — the discovery API
/// has already decided which stores this caller may see, and only ever
/// returns an unpublished one to the person who owns it. This is presentation
/// only: it labels an owner's own in-progress store and drives the filter
/// chips they get on top of it.
enum StoreStatus { draft, pending, published, rejected }

extension StoreStatusX on StoreStatus {
  /// Everything except [published] is a store still being set up — one
  /// question the UI asks constantly, and the reason the chip row exists.
  bool get isUnpublished => this != StoreStatus.published;
}

extension StoreStatusParse on String {
  /// Wire → enum. Unknown values (including `''` from an older API build,
  /// and the legacy `'active'` marker that predates the lifecycle) read as
  /// [StoreStatus.published]: the server only sends a store this caller is
  /// allowed to see, so the safe default is "nothing special to say about
  /// it" rather than falsely badging a live store as a draft.
  StoreStatus toStoreStatus() => switch (this) {
    'draft' => StoreStatus.draft,
    'pending' => StoreStatus.pending,
    'rejected' => StoreStatus.rejected,
    _ => StoreStatus.published,
  };
}
