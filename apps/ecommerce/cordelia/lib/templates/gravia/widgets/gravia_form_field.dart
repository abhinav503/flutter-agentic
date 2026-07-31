import 'package:cordelia/widgets/cordelia_form_field.dart';

export 'package:cordelia/widgets/cordelia_form_field.dart';

/// Gravia's one true form-field look. The implementation lives app-level as
/// [CordeliaFormField] — the shared auth screens render the same field — and
/// this alias keeps the pack's own call sites reading as pack widgets.
typedef GraviaFormField = CordeliaFormField;
