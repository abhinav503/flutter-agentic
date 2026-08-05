#!/usr/bin/env python3
"""Validate a cordelia translation ARB against the gen-l10n template.

gen-l10n falls back to the template's English for any key a translation is
missing, so a half-finished locale ships as a half-English screen instead of a
build failure. This is the gate that turns that into a failure.

    scripts/check-arb-parity.py de            # check one locale
    scripts/check-arb-parity.py --all         # every app_*.arb beside the template
    scripts/check-arb-parity.py de --merge-from /tmp/chunks

`--merge-from DIR` assembles the locale from `de_*.json` chunk files in DIR
(the shape a batched translation pass produces), validates, and only then
writes `app_de.arb` in the template's key order. Without it, an existing
`app_de.arb` is validated in place.

Run from the repo root. Exits non-zero on the first failing locale.
"""
import argparse
import collections
import glob
import io
import json
import os
import re
import sys

L10N_DIR = "apps/ecommerce/cordelia/lib/l10n"
TEMPLATE = "app_en.arb"

# Values a translator is told to pass through unchanged: a language names
# itself in every locale, and the T&C body is known placeholder copy.
PASSTHROUGH = {
    "languageEnglish",
    "languageHindi",
    "languageGerman",
    "termsAndConditionsBody",
}

# A plain {name} placeholder. Careful: this also matches an ICU branch body
# such as the `{pc}` in `one{pc}`, so ICU strings are compared on their
# argument name via ICU_ARG instead — otherwise a correct German branch like
# `one{Stk.}` reads as a dropped placeholder.
PLACEHOLDER = re.compile(r"\{([a-zA-Z][a-zA-Z0-9_]*)\}")
ICU_ARG = re.compile(r"\{\s*([a-zA-Z][a-zA-Z0-9_]*)\s*,\s*(?:plural|select)\b")


def load(path):
    with io.open(path, encoding="utf-8") as f:
        return json.load(f, object_pairs_hook=collections.OrderedDict)


def content_keys(arb):
    return [k for k in arb if not k.startswith("@")]


def merge_chunks(directory, locale):
    pattern = os.path.join(directory, f"{locale}_*.json")
    paths = sorted(glob.glob(pattern))
    if not paths:
        sys.exit(f"no chunk files matched {pattern}")
    merged = {}
    for path in paths:
        part = load(path)
        clash = merged.keys() & part.keys()
        if clash:
            sys.exit(f"key present in two chunks: {sorted(clash)[:5]}")
        merged.update(part)
    print(f"  merged {len(paths)} chunk(s) -> {len(merged)} keys")
    return merged


def validate(template, translation, locale):
    """Return a list of human-readable problems (empty means it's good)."""
    problems = []
    keys = content_keys(template)

    missing = [k for k in keys if k not in translation]
    # content_keys on both sides: a translation legitimately carries @@locale,
    # and the template's own @-metadata is never mirrored into a translation.
    extra = [k for k in content_keys(translation) if k not in keys]
    if missing:
        problems.append(
            f"{len(missing)} key(s) missing — these would render as English: "
            f"{missing[:10]}"
        )
    if extra:
        problems.append(f"{len(extra)} key(s) not in the template: {extra[:10]}")

    for k in keys:
        if k not in translation:
            continue
        src, dst = template[k], translation[k]
        if not isinstance(dst, str):
            problems.append(f"{k}: value is not a string")
            continue

        is_icu = "plural," in src or "select," in src
        extract = ICU_ARG if is_icu else PLACEHOLDER
        if sorted(extract.findall(src)) != sorted(extract.findall(dst)):
            problems.append(
                f"{k}: placeholders differ "
                f"{sorted(set(extract.findall(src)))} -> "
                f"{sorted(set(extract.findall(dst)))}"
            )

        if is_icu:
            for branch in ("one{", "other{", "zero{", "two{", "few{", "many{"):
                if branch in src and branch not in dst:
                    problems.append(f"{k}: lost ICU '{branch}' branch")
            if src.count("{") != dst.count("{") or src.count("}") != dst.count("}"):
                problems.append(f"{k}: unbalanced ICU braces")

        # Layout-significant whitespace, e.g. "Don't have an account? ".
        if src[:1].isspace() != dst[:1].isspace():
            problems.append(f"{k}: leading-space mismatch")
        if src[-1:].isspace() != dst[-1:].isspace():
            problems.append(f"{k}: trailing-space mismatch")
        if src.count("\n") != dst.count("\n"):
            problems.append(f"{k}: newline count differs")

        if k in PASSTHROUGH and src != dst:
            problems.append(f"{k}: must pass through verbatim but was changed")

        # An identical long string is usually a skipped key, not a loanword.
        if src == dst and k not in PASSTHROUGH and len(src) > 25:
            problems.append(f"{k}: identical to English ({src[:40]!r}) — untranslated?")

        # Money is formatted by core's AppFormat from the store's currency;
        # a glyph in copy would print rupees at a euro store.
        for glyph in ("₹", "$", "€", "£"):
            if glyph in dst and glyph not in src:
                problems.append(f"{k}: introduced a hardcoded '{glyph}'")

    return problems


def write_arb(template, translation, locale):
    out = collections.OrderedDict()
    out["@@locale"] = locale
    for k in content_keys(template):
        out[k] = translation[k]
    path = os.path.join(L10N_DIR, f"app_{locale}.arb")
    with io.open(path, "w", encoding="utf-8") as f:
        f.write(json.dumps(out, ensure_ascii=False, indent=2) + "\n")
    return path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("locales", nargs="*", help="locale codes, e.g. de fr")
    parser.add_argument("--all", action="store_true",
                        help="check every app_*.arb beside the template")
    parser.add_argument("--merge-from", metavar="DIR",
                        help="assemble the locale from <locale>_*.json chunks in DIR")
    args = parser.parse_args()

    template_path = os.path.join(L10N_DIR, TEMPLATE)
    if not os.path.exists(template_path):
        sys.exit(f"template not found: {template_path} (run from the repo root)")
    template = load(template_path)

    locales = list(args.locales)
    if args.all:
        for path in sorted(glob.glob(os.path.join(L10N_DIR, "app_*.arb"))):
            code = os.path.basename(path)[len("app_"):-len(".arb")]
            if code != "en" and code not in locales:
                locales.append(code)
    if not locales:
        parser.error("name at least one locale, or pass --all")
    if args.merge_from and len(locales) != 1:
        parser.error("--merge-from takes exactly one locale")

    failed = False
    for locale in locales:
        print(f"{locale}:")
        if args.merge_from:
            translation = merge_chunks(args.merge_from, locale)
        else:
            path = os.path.join(L10N_DIR, f"app_{locale}.arb")
            if not os.path.exists(path):
                print(f"  FAIL — {path} does not exist")
                failed = True
                continue
            translation = load(path)

        problems = validate(template, translation, locale)
        if problems:
            failed = True
            print(f"  FAIL — {len(problems)} problem(s):")
            for p in problems:
                print("    -", p)
            continue

        if args.merge_from:
            written = write_arb(template, translation, locale)
            print(f"  OK — wrote {written}")
        else:
            print(f"  OK — {len(content_keys(template))} keys, full parity")

    if failed:
        sys.exit(1)
    print("\nAll checked locales are at full parity with the template.")


if __name__ == "__main__":
    main()
