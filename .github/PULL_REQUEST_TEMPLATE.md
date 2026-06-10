## What changed

<!-- Bullet list of changes -->

## Why

<!-- Motivation — link to issue if applicable. Closes #123 -->

## Checklist

- [ ] `make analyze` passes with zero issues
- [ ] `make test` passes
- [ ] No forbidden patterns introduced (see `docs/ai-rules/conventions.md`)
- [ ] No hardcoded colours, strings, spacing, or radii
- [ ] New atoms/molecules added to `core/ui/` — not feature folders
- [ ] DI registrations added to `injection_container.dart` in the correct order
- [ ] Generated files re-created with `make gen` if any `@freezed` / `@JsonSerializable` / `@RestApi()` files changed
- [ ] Docs updated if conventions, architecture, or setup steps changed
