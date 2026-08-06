/**
 * The public origin, without a trailing slash.
 *
 * One const because four places need it and they must never disagree: the
 * landing page's `metadataBase`, the JSON-LD blocks, `sitemap.ts` and
 * `robots.ts`. A sitemap listing a domain the canonical tag doesn't use is
 * worse than no sitemap at all.
 */
export const SITE_URL = "https://cordeliaapps.com";
