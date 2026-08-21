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
  /// Wire → enum. Unknown values — `''` from an older API build, or anything
  /// this app doesn't know yet — read as [StoreStatus.published]: the server
  /// only sends a store this caller is allowed to see, so the safe default is
  /// "nothing special to say about it" rather than falsely badging a live
  /// store as a draft.
  ///
  /// Note this is the **opposite** default from the server's
  /// `normalizeStoreStatus`, which calls an unknown value `draft`. Both are
  /// right for their side: the server decides visibility and must not let an
  /// unrecognised string mean live, while this app has already been told the
  /// store is visible and is only choosing a badge.
  StoreStatus toStoreStatus() => switch (this) {
    'draft' => StoreStatus.draft,
    'pending' => StoreStatus.pending,
    'rejected' => StoreStatus.rejected,
    _ => StoreStatus.published,
  };
}
