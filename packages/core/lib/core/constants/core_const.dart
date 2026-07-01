/// Generic constants used by core's own widgets and services.
///
/// App-specific copy, feature strings, and API URLs do NOT belong here — each
/// app owns those in its own `lib/constants/`.
abstract final class CoreConst {
  // ── Shared UI ─────────────────────────────────────────────────────────────
  static const retryButton = 'Retry';

  // ── Theme-mode toggle (ThemeModeToggle tooltips) ──────────────────────────
  static const themeModeSystemTooltip = 'Theme: System (tap for Light)';
  static const themeModeLightTooltip = 'Theme: Light (tap for Dark)';
  static const themeModeDarkTooltip = 'Theme: Dark (tap for System)';

  // ── Image picker (ImagePickerService config) ──────────────────────────────
  static const imagePickerQuality = 90;
  static const imagePickerMaxWidth = 1600;
  static const imagePickerMaxHeight = 2000;
}
