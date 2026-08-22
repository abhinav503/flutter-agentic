#!/usr/bin/env python3
"""Fail when a test can reach the network.

A test that builds the app's real dependency graph runs the real data sources,
which call the real API. It then passes for exactly as long as some deployment
answers — and starts failing the day that environment changes, with nothing
about the app having broken.

This repo shipped that: a widget test called the app's `initDependencies()`
and drove three tabs against a live store. It went red months later when the
store stopped answering, and the fakes it needed were already sitting unused
in the same `test/helpers/` folder.

Two things are flagged:

  1. A test that calls `initDependencies()` without registering any override
     afterwards — the real repositories and data sources stay in the graph.
  2. A test naming a real host (`https://…`) outside a comment.

    scripts/check-test-isolation.py

Deliberate exceptions carry a marker comment anywhere in the test file:

    // test-isolation: ignore — <why>

There is rarely a good reason; an integration suite that genuinely needs a
server belongs outside `test/`. Run from the repo root; exits non-zero on the
first offending file.
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

IGNORE = re.compile(r"//\s*test-isolation:\s*ignore")
REAL_DI = re.compile(r"\binitDependencies\s*\(")
# Any of these means the graph was replaced with test doubles afterwards.
OVERRIDE = re.compile(r"\bregister(?:LazySingleton|Singleton|Factory)\b|\bFake[A-Z]\w*|\bMock[A-Z]\w*")
LIVE_HOST = re.compile(r"https?://(?!localhost|127\.0\.0\.1|example\.com|example\.org)[\w.-]+")


def test_files():
    for path in ROOT.glob("apps/**/test/**/*.dart"):
        if path.name.endswith((".g.dart", ".freezed.dart")):
            continue
        yield path
    for path in ROOT.glob("packages/*/test/**/*.dart"):
        yield path


def strip_comments(source: str) -> str:
    source = re.sub(r"/\*.*?\*/", "", source, flags=re.S)
    return re.sub(r"//[^\n]*", "", source)


def main() -> int:
    problems = []

    for path in sorted(set(test_files())):
        source = path.read_text(encoding="utf-8")
        if IGNORE.search(source):
            continue
        rel = path.relative_to(ROOT)
        code = strip_comments(source)

        if REAL_DI.search(code) and not OVERRIDE.search(code):
            problems.append(
                (rel, "calls initDependencies() and registers no override — "
                      "this runs the real data sources")
            )

        hosts = {m.group(0) for m in LIVE_HOST.finditer(code)}
        if hosts:
            problems.append((rel, f"names a live host: {', '.join(sorted(hosts))}"))

    if not problems:
        print("test isolation OK — no test builds the real graph or names a live host")
        return 0

    print("Tests that can reach the network:\n")
    for rel, why in problems:
        print(f"  {rel}\n      {why}\n")
    print(
        "Inject fakes at the data-source or repository boundary (see"
        "\n`test/helpers/`), or mark a deliberate exception with"
        "\n  // test-isolation: ignore — <why>"
    )
    return 1


if __name__ == "__main__":
    sys.exit(main())
