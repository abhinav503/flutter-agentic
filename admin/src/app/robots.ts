import type { MetadataRoute } from "next";
import { SITE_URL } from "@/lib/site";

/**
 * Keeps crawlers on the pages that can actually rank.
 *
 * `/dashboard` is auth-gated — a bot only ever receives its "Loading…" shell,
 * so every crawl of one is budget not spent on the landing page. `/api` serves
 * store data behind a token and has no business in a search result.
 *
 * `/login` and `/signup` are **not** disallowed, deliberately. Both now 307 to
 * `/`, and a crawler blocked from fetching a URL never learns that — it would
 * keep the dead URL on file instead of following the redirect and dropping it.
 */
export default function robots(): MetadataRoute.Robots {
  return {
    rules: {
      userAgent: "*",
      allow: "/",
      disallow: ["/dashboard/", "/api/"],
    },
    sitemap: `${SITE_URL}/sitemap.xml`,
  };
}
