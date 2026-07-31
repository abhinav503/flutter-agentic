import 'package:cordelia/widgets/cordelia_primary_button.dart';

export 'package:cordelia/widgets/cordelia_primary_button.dart';

/// Gravia's full-width primary CTA — every docked bottom bar's confirm
/// action renders this, never a re-typed `AppButton` param recipe. The
/// implementation lives app-level as [CordeliaPrimaryButton] — the shared
/// auth screens render the same CTA — and this alias keeps the pack's own
/// call sites reading as pack widgets.
typedef GraviaPrimaryButton = CordeliaPrimaryButton;
