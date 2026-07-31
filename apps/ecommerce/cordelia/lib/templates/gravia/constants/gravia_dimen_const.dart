import 'package:cordelia/constants/cordelia_dimen_const.dart';

abstract final class GraviaDimenConst {
  /// The kit's fixed height for pill buttons, glass icon discs, form fields,
  /// and segmented tab bars — one shared source instead of several
  /// independently-named constants (`GraviaPrimaryButton.barHeight`,
  /// `GraviaTintedButton.height`, `GraviaGlassIconButton.containerSize`, …)
  /// that happen to agree on the same number. The value lives app-level
  /// (`CordeliaDimenConst`) because the shared auth screens size their
  /// controls to it too.
  static const double controlHeight = CordeliaDimenConst.controlHeight;

  // ── CollapsingHeaderSheet `initialHeaderHeight` tiers ────────────────────
  // Named tiers instead of per-screen literals: every screen repeats its
  // height across its loading/error/loaded arms, and bare numbers let the
  // arms drift apart on edit.
  /// Back disc + title row (cart, addresses, notifications, profile forms).
  static const double headerHeightCompact = 110;

  /// Title row + the pinned search field (Search).
  static const double headerHeightSearch = 120;

  /// Title row with a trailing action / hero spacing (categories,
  /// favourites, product details).
  static const double headerHeightRegular = 130;

  /// Title + sort/price chips row (category details).
  static const double headerHeightChips = 165;

  /// Title + segmented tab bar (orders).
  static const double headerHeightTabs = 190;

  /// The profile avatar identity header.
  static const double headerHeightIdentity = 195;

  /// The product hero carousel's fixed height — the skeleton sizes against
  /// this instead of guessing its own number, so the page doesn't reflow
  /// when data lands (same rule as dailymart's `detailImageHeight`).
  static const double detailImageHeight = 300;

  /// `GraviaProductGridSkeleton`'s card silhouette (image well + text
  /// chrome), matching the loaded `GraviaProductCard`'s footprint.
  static const double gridCardSkeletonHeight = 260;

  /// Stroke width of the shell's docked-bar hairlines; the colour comes from
  /// `AppColorsExtension.dockedHairline`.
  static const double hairlineWidth = 0.5;
}
