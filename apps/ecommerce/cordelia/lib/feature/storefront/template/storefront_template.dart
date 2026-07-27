/// Which per-store `presentation/templates/<name>/` a storefront renders —
/// the swappable UI layer selected per store, while `domain`/`data` under
/// `feature/storefront/` stay shared across every template.
enum StorefrontTemplate { gravia, dailymart }

extension StorefrontTemplateX on StorefrontTemplate {
  /// Enum → wire value, for the data layer's model-to-JSON mapping. Matches
  /// the `templates/{id}` doc ids the admin backend seeds
  /// (`admin/scripts/seed-templates.mjs`).
  String get wireValue => switch (this) {
    StorefrontTemplate.gravia => 'gravia',
    StorefrontTemplate.dailymart => 'dailymart',
  };
}

/// Wire value → enum: tolerates unknown/missing values by defaulting to
/// `gravia`, so a store whose `template_id` this build doesn't know yet
/// still opens instead of crashing.
extension StorefrontTemplateParse on String {
  StorefrontTemplate toStorefrontTemplate() => switch (this) {
    'dailymart' => StorefrontTemplate.dailymart,
    _ => StorefrontTemplate.gravia,
  };
}
