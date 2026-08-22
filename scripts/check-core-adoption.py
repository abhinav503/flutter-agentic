#!/usr/bin/env python3
"""Fail when a widget in `packages/core/lib/core/ui/` has no callers.

Extracting a widget into `core` and adopting it are one task. A promotion that
stops at "the shared version now exists" leaves the codebase strictly worse
than before: the hand-rolled copies it was extracted *from* are still shipping,
and now there is a second thing to keep in step with them.

This is not hypothetical. A full review of this repo found **six** such widgets
— ConfirmSheetBody, ActionSheetBody, ActionPair, BottomFade, ScreenBody,
AppPickerField — every one of them unused, while each style pack shipped its
own copy of what they replaced. One of them documented its own intent ("packs
keep a thin wrapper over this") and had no wrapper anywhere. Nothing noticed,
because nothing looked.

    scripts/check-core-adoption.py

Deliberate exceptions carry a marker comment anywhere in the widget's file:

    // core-adoption: ignore — <why>

Use it for something genuinely staged ahead of its first consumer, and say
when that consumer is expected. Run from the repo root; exits non-zero on the
first unused widget.
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
UI = ROOT / "packages" / "core" / "lib" / "core" / "ui"
SEARCH_ROOTS = [ROOT / "apps", ROOT / "packages" / "core" / "lib"]

IGNORE = re.compile(r"//\s*core-adoption:\s*ignore")
# Public, top-level, non-abstract declarations — what a caller would name.
DECL = re.compile(r"^(?:class|mixin|enum)\s+([A-Z][A-Za-z0-9_]*)", re.M)


def dart_files(root: Path):
    for path in root.rglob("*.dart"):
        name = path.name
        if name.endswith((".g.dart", ".freezed.dart")):
            continue
        yield path


def main() -> int:
    if not UI.is_dir():
        print(f"No core UI directory at {UI}", file=sys.stderr)
        return 1

    corpus = [(p, p.read_text(encoding="utf-8")) for r in SEARCH_ROOTS for p in dart_files(r)]
    unused = []

    for path in sorted(dart_files(UI)):
        source = path.read_text(encoding="utf-8")
        if IGNORE.search(source):
            continue
        names = DECL.findall(source)
        if not names:
            continue
        # The file's headline declaration — the one a caller would reach for.
        name = names[0]
        word = re.compile(rf"\b{re.escape(name)}\b")
        callers = [
            other
            for other, text in corpus
            if other != path and word.search(text)
        ]
        if not callers:
            unused.append((name, path.relative_to(ROOT)))

    if not unused:
        print(f"core adoption OK — every widget under {UI.relative_to(ROOT)} has a caller")
        return 0

    print("Unused widgets in core/ui — these were extracted but never adopted,")
    print("so whatever they replaced is still hand-rolled somewhere:\n")
    for name, rel in unused:
        print(f"  {name:28} {rel}")
    print(
        "\nAdopt each at its call sites, or mark a deliberate exception with"
        "\n  // core-adoption: ignore — <why>"
    )
    return 1


if __name__ == "__main__":
    sys.exit(main())
