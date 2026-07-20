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

  // ── Form validation (TextfieldValidations defaults) ───────────────────────
  // Generic field copy, not product copy — an app needing different wording
  // overrides the mixin method, not these.
  static const nameRequiredErrorMessage = 'Please enter your name.';
  static const emailRequiredErrorMessage = 'Please enter your email address.';
  static const emailInvalidErrorMessage = 'Enter a valid email address.';
  static const mobileRequiredErrorMessage = 'Please enter your mobile number.';
  static const mobileInvalidErrorMessage = 'Enter a valid mobile number.';
  static const passwordRequiredErrorMessage = 'Please enter your password.';
  static const weakPasswordErrorMessage =
      'Password must be at least 6 characters.';
  static const confirmPasswordRequiredErrorMessage =
      'Please confirm your new password.';
  static const passwordsDontMatchErrorMessage = 'Passwords do not match.';
}
