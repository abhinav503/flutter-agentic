// Verifies every image URL in EVERY market's grocery seed dataset still
// resolves — the canary for URL rot. Run whenever a *-seed-data.ts file
// changes:  npm run verify:seed-images
//
// Reads the TS source as text (no TS tooling in scripts/) and extracts URLs
// by pattern, so it needs no build step.

import { readFile } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

// Every market's catalog (see src/lib/seed/seed-markets.ts). Adding a market
// means adding its file here, otherwise its URLs go unchecked.
const dataFiles = [
  "grocery-seed-data.ts",
  "germany-seed-data.ts",
  "france-seed-data.ts",
  "spain-seed-data.ts",
  "italy-seed-data.ts",
  "uk-seed-data.ts",
  "us-seed-data.ts",
].map((name) =>
  join(dirname(fileURLToPath(import.meta.url)), "../src/lib/seed", name),
);

const source = (
  await Promise.all(dataFiles.map((file) => readFile(file, "utf8")))
).join("\n");
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

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

// A 404/410 means the image is genuinely gone — that is the URL rot this
// script exists to catch. A 429 or 5xx or a socket error means the host is
// throttling us, which at this catalog size it will: the run crossed 550 URLs
// and started reporting failures that a single manual fetch answered 200 for.
// Retrying those keeps the gate honest, because a check that cries wolf is one
// people learn to ignore.
const DEFINITIVE = new Set([404, 410]);

async function check(url) {
  for (let attempt = 0; ; attempt++) {
    let status = 0;
    try {
      let res = await fetch(url, { method: "HEAD", headers });
      if (!res.ok) {
        // Some CDNs reject HEAD; confirm with a ranged GET before failing.
        res = await fetch(url, { headers: { ...headers, Range: "bytes=0-0" } });
      }
      if (res.ok) return { ok: true };
      status = res.status;
      if (DEFINITIVE.has(status)) return { ok: false, reason: `HTTP ${status}` };
    } catch (err) {
      status = 0;
      if (attempt >= 3) {
        return { ok: false, reason: err.cause?.code ?? err.name };
      }
    }
    if (attempt >= 3) {
      return { ok: false, reason: `HTTP ${status} after 4 attempts` };
    }
    await sleep(1500 * (attempt + 1));
  }
}

const CONCURRENCY = 5;
const queue = [...urls];
const failures = [];
let checked = 0;

await Promise.all(
  Array.from({ length: CONCURRENCY }, async () => {
    for (let url = queue.shift(); url; url = queue.shift()) {
      const { ok, reason } = await check(url);
      checked += 1;
      if (!ok) {
        failures.push(url);
        console.error(`FAIL (${reason}) ${url}`);
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
