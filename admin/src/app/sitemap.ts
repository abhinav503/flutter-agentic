import type { MetadataRoute } from "next";
import { docCategories, getAllDocs } from "@/lib/docs";
import { SITE_URL } from "@/lib/site";

/**
 * The public, indexable pages — and only those.
 *
 * `/login` and `/signup` are deliberately absent: both redirect to `/`, and a
 * sitemap should never list a URL that doesn't answer with content. Everything
 * under `/dashboard` and `/api` is auth-gated. A sitemap is a statement about
 * what should rank, not an inventory of routes.
 *
 * `/docs` and everything under it is enumerated from the MDX collection on
 * disk, so a guide added as a file appears here without anyone remembering to
 * list it. A category with no articles yet is skipped — it 404s.
 *
 * No `lastModified`: this file is a cached Route Handler, so any `new Date()`
 * here would evaluate at build time and claim every page changed on every
 * deploy. Google discounts a lastmod it can't trust, which makes a wrong one
 * worse than none.
 */
export default function sitemap(): MetadataRoute.Sitemap {
  const docs = getAllDocs();

  return [
    {
      url: SITE_URL,
      changeFrequency: "monthly",
      priority: 1,
    },
    {
      url: `${SITE_URL}/privacy`,
      changeFrequency: "yearly",
      priority: 0.3,
    },
    {
      url: `${SITE_URL}/terms`,
      changeFrequency: "yearly",
      priority: 0.3,
    },
    {
      url: `${SITE_URL}/refunds`,
      changeFrequency: "yearly",
      priority: 0.3,
    },
    // Submitted to Google Play as the app's privacy-policy and data-deletion
    // URLs, so they must stay publicly reachable and indexable.
    {
      url: `${SITE_URL}/app-privacy`,
      changeFrequency: "yearly",
      priority: 0.3,
    },
    {
      url: `${SITE_URL}/delete-account`,
      changeFrequency: "yearly",
      priority: 0.3,
    },
    {
      url: `${SITE_URL}/docs`,
      changeFrequency: "weekly",
      priority: 0.8,
    },
    ...docCategories
      .filter((category) => docs.some((d) => d.categorySlug === category.slug))
      .map((category) => ({
        url: `${SITE_URL}/docs/${category.slug}`,
        changeFrequency: "weekly" as const,
        priority: 0.6,
      })),
    ...docs.map((doc) => ({
      url: `${SITE_URL}${doc.href}`,
      changeFrequency: "monthly" as const,
      priority: 0.6,
    })),
  ];
}
