# add-feature-template

If the feature name was not passed as an argument, ask:
"What is the feature name? (e.g. `products`, `auth`, `settings`)"

Derive the two required substitution forms from the answer:
- `{Feature}` = PascalCase, e.g. `Products`
- `{feature}` = snake_case, e.g. `products`

Then follow every step in the guide below exactly, substituting these values throughout
all folder names, file names, class names, and import paths. Do not skip any step.
Run `make gen` and `make analyze` at the end before reporting done.

@docs/how-to/add-feature-template.md
