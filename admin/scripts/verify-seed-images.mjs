// Verifies every Open Food Facts image URL in the grocery seed dataset still
// resolves — the canary for URL rot. Run whenever grocery-seed-data.ts
// changes:  npm run verify:seed-images
//
// Reads the TS source as text (no TS tooling in scripts/) and extracts URLs
// by pattern, so it needs no build step.

import { readFile } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const dataFile = join(
  dirname(fileURLToPath(import.meta.url)),
  "../src/lib/seed/grocery-seed-data.ts",
);

const source = await readFile(dataFile, "utf8");
// Product URLs appear as `${IMG}/<path>` template literals over the IMG base
// constant; banner (Unsplash) and brand-logo (gstatic favicon / DiceBear)
// URLs are plain string literals.
const base = "https://images.openfoodfacts.org/images/products";
const urls = [
  ...new Set([
    ...(source.match(/https:\/\/[^"'`\s]+/g) ?? []).filter(
      (url) => url !== base && !url.startsWith("https://world.openfoodfacts"),
    ),
    ...[...source.matchAll(/\$\{IMG\}(\/[^`]+)`/g)].map((m) => base + m[1]),
  ]),
];

if (urls.length === 0) {
  console.error("No Open Food Facts URLs found — is the dataset empty?");
  process.exit(1);
}

// Descriptive User-Agent per OFF API etiquette.
const headers = {
  "User-Agent": "CordeliaBase-admin-seed-verifier/1.0 (cordeliaapps@gmail.com)",
};

async function check(url) {
  try {
    let res = await fetch(url, { method: "HEAD", headers });
    if (!res.ok) {
      // Some CDNs reject HEAD; confirm with a ranged GET before failing.
      res = await fetch(url, {
        headers: { ...headers, Range: "bytes=0-0" },
      });
    }
    return res.ok;
  } catch {
    return false;
  }
}

const CONCURRENCY = 5;
const queue = [...urls];
const failures = [];
let checked = 0;

await Promise.all(
  Array.from({ length: CONCURRENCY }, async () => {
    for (let url = queue.shift(); url; url = queue.shift()) {
      const ok = await check(url);
      checked += 1;
      if (!ok) {
        failures.push(url);
        console.error(`FAIL ${url}`);
      }
      if (checked % 25 === 0) console.error(`…${checked}/${urls.length}`);
    }
  }),
);

if (failures.length > 0) {
  console.error(`\n${failures.length}/${urls.length} URLs failed.`);
  process.exit(1);
}
console.error(`All ${urls.length} image URLs OK.`);
