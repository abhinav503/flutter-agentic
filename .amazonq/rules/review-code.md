# Review Generated Code

Run after any AI-generated code to catch rule violations before committing.

If no files were specified, ask: "Which files or feature should I review?"

Read the project rules in this order before checking anything:
1. `docs/ai-rules/conventions.md` — forbidden patterns and build rules
2. `docs/reference/architecture.md` — layer boundaries, naming, DI, error flow, testing

Then audit the specified files against every check in `docs/how-to/review-code.md`
and report a ✅/❌ checklist. Offer to fix each violation after reporting.
