import fs from "node:fs";
import path from "node:path";
import matter from "gray-matter";

import type { DocIconName } from "@/components/docs/icon";

/**
 * The docs content collection.
 *
 * Articles are MDX files on disk under `src/content/docs/<category>/<slug>.mdx`,
 * read at build time. There is no CMS and no database behind this: a guide is a
 * file in the repo, so a doc change ships in the same PR as the feature it
 * documents and is reviewable as a diff.
 *
 * Categories are declared here rather than inferred from the folder listing —
 * the order guides appear in is editorial (what a new merchant hits first), not
 * alphabetical, and a folder name can't carry a description or an icon.
 */

export const DOCS_ROOT = path.join(process.cwd(), "src/content/docs");

export type DocCategory = {
  slug: string;
  name: string;
  description: string;
  icon: DocIconName;
};

export const docCategories: DocCategory[] = [
  {
    slug: "getting-started",
    name: "Getting started",
    description:
      "Create your account, open your first store, and see it running before anyone else can.",
    icon: "rocket",
  },
  {
    slug: "store-setup",
    name: "Store setup",
    description:
      "Your storefront's identity: profile, template, delivery fees and where you deliver.",
    icon: "store",
  },
  {
    slug: "catalog",
    name: "Catalog",
    description:
      "Categories, brands and products — added one at a time, imported from a CSV, or generated.",
    icon: "package",
  },
  {
    slug: "payments",
    name: "Payments",
    description:
      "Connect Razorpay or Stripe so money settles into your own account, and test before you charge anyone.",
    icon: "credit-card",
  },
  {
    slug: "orders",
    name: "Orders",
    description:
      "How an order moves from placed to delivered, and what to do when it doesn't.",
    icon: "receipt",
  },
  {
    slug: "growing",
    name: "Growing your store",
    description: "Coupons, reviews and the notifications that bring shoppers back.",
    icon: "trending-up",
  },
  {
    slug: "going-live",
    name: "Going live",
    description: "The readiness checklist, review, and running your account day to day.",
    icon: "globe",
  },
  {
    slug: "ai-and-api",
    name: "AI assistants & API",
    description:
      "Let Claude or ChatGPT manage your store by talking to it, bring a Shopify catalog over in one go, or script the API with a token.",
    icon: "sparkles",
  },
];

export type DocFrontmatter = {
  title: string;
  description: string;
  /** Position within its category. Ties fall back to the title. */
  order?: number;
  /** Overrides `title` in the sidebar when the full title is too long for it. */
  sidebarTitle?: string;
};

export type DocHeading = { id: string; text: string; level: 2 | 3 };

export type Doc = DocFrontmatter & {
  slug: string;
  categorySlug: string;
  /** `/docs/<category>/<slug>` — the one place this path is composed. */
  href: string;
  headings: DocHeading[];
};

/**
 * A heading's anchor. Shared by the table of contents and the `h2`/`h3` MDX
 * components, which must agree exactly or every TOC link is a dead scroll.
 */
export function slugifyHeading(text: string): string {
  return text
    .toLowerCase()
    .replace(/[`*_~]/g, "")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

/**
 * Markdown headings, for the right-hand rail.
 *
 * Read off the raw source rather than the compiled tree: the compile happens in
 * a server component that returns an opaque element, so there is nothing left
 * to walk by the time it renders. Fenced code is stripped first — a `#` comment
 * inside a bash block is not a heading.
 */
function extractHeadings(source: string): DocHeading[] {
  const withoutFences = source.replace(/^```[\s\S]*?^```/gm, "");
  const headings: DocHeading[] = [];

  for (const line of withoutFences.split("\n")) {
    const match = /^(#{2,3})\s+(.+?)\s*$/.exec(line);
    if (!match) continue;
    const text = match[2].replace(/[`*_]/g, "");
    headings.push({
      id: slugifyHeading(text),
      text,
      level: match[1].length as 2 | 3,
    });
  }

  return headings;
}

function readDoc(categorySlug: string, fileName: string): Doc {
  const slug = fileName.replace(/\.mdx$/, "");
  const raw = fs.readFileSync(path.join(DOCS_ROOT, categorySlug, fileName), "utf8");
  const { data, content } = matter(raw);
  const frontmatter = data as DocFrontmatter;

  return {
    ...frontmatter,
    slug,
    categorySlug,
    href: `/docs/${categorySlug}/${slug}`,
    headings: extractHeadings(content),
  };
}

/** Every published doc, in reading order: category order, then `order`. */
export function getAllDocs(): Doc[] {
  return docCategories.flatMap((category) => {
    const dir = path.join(DOCS_ROOT, category.slug);
    if (!fs.existsSync(dir)) return [];

    return fs
      .readdirSync(dir)
      .filter((f) => f.endsWith(".mdx"))
      .map((f) => readDoc(category.slug, f))
      .sort(
        (a, b) =>
          (a.order ?? Number.MAX_SAFE_INTEGER) - (b.order ?? Number.MAX_SAFE_INTEGER) ||
          a.title.localeCompare(b.title),
      );
  });
}

export function getDocsByCategory(categorySlug: string): Doc[] {
  return getAllDocs().filter((d) => d.categorySlug === categorySlug);
}

export function getCategory(categorySlug: string): DocCategory | undefined {
  return docCategories.find((c) => c.slug === categorySlug);
}

export function getDoc(categorySlug: string, slug: string): Doc | undefined {
  return getAllDocs().find((d) => d.categorySlug === categorySlug && d.slug === slug);
}

/** The MDX body, uncompiled. Only the article route needs it. */
export function getDocSource(categorySlug: string, slug: string): string {
  return fs.readFileSync(path.join(DOCS_ROOT, categorySlug, `${slug}.mdx`), "utf8");
}

/**
 * The neighbours of a doc in the flat reading order — so "next" walks off the
 * end of a category into the start of the following one, which is how someone
 * reading the setup path straight through expects it to behave.
 */
export function getDocNeighbours(doc: Doc): { previous?: Doc; next?: Doc } {
  const all = getAllDocs();
  const index = all.findIndex((d) => d.href === doc.href);
  return { previous: all[index - 1], next: all[index + 1] };
}
