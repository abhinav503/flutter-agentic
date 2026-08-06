import type { MetadataRoute } from "next";
import { SITE_URL } from "@/lib/site";

/**
 * The two public pages, and only those.
 *
 * `/login` and `/signup` are deliberately absent: both redirect to `/`, and a
 * sitemap should never list a URL that doesn't answer with content. Everything
 * under `/dashboard` and `/api` is auth-gated. A sitemap is a statement about
 * what should rank, not an inventory of routes.
 *
 * No `lastModified`: this file is a cached Route Handler, so any `new Date()`
 * here would evaluate at build time and claim every page changed on every
 * deploy. Google discounts a lastmod it can't trust, which makes a wrong one
 * worse than none.
 */
export default function sitemap(): MetadataRoute.Sitemap {
  return [
    {
      url: SITE_URL,
      changeFrequency: "monthly",
      priority: 1,
    },
    {
      url: `${SITE_URL}/docs`,
      changeFrequency: "monthly",
      priority: 0.5,
    },
  ];
}
