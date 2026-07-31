import 'package:cordelia/widgets/cordelia_glass_icon_button.dart';

export 'package:cordelia/widgets/cordelia_glass_icon_button.dart';

/// Gravia's glass header action (back, search, favourite, notification).
/// The implementation lives app-level as [CordeliaGlassIconButton] — the
/// shared auth screens render the same disc — and this alias keeps the
/// pack's own call sites reading as pack widgets.
typedef GraviaGlassIconButton = CordeliaGlassIconButton;
