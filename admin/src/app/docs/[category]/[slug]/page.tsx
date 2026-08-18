import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { compileMDX } from "next-mdx-remote/rsc";
import rehypeHighlight from "rehype-highlight";
import remarkGfm from "remark-gfm";

import { ArticlePager } from "@/components/docs/article-pager";
import { TableOfContents } from "@/components/docs/table-of-contents";
import { mdxComponents } from "@/components/docs/mdx";
import { SITE_URL } from "@/lib/site";
import {
  getAllDocs,
  getCategory,
  getDoc,
  getDocNeighbours,
  getDocSource,
} from "@/lib/docs";

type Params = { params: Promise<{ category: string; slug: string }> };

export function generateStaticParams() {
  return getAllDocs().map((doc) => ({
    category: doc.categorySlug,
    slug: doc.slug,
  }));
}

export async function generateMetadata({ params }: Params): Promise<Metadata> {
  const { category, slug } = await params;
  const doc = getDoc(category, slug);
  if (!doc) return {};

  return {
    title: `${doc.title} — CordeliaApps docs`,
    description: doc.description,
    alternates: { canonical: doc.href },
    openGraph: {
      type: "article",
      title: doc.title,
      description: doc.description,
      url: `${SITE_URL}${doc.href}`,
    },
  };
}

export default async function DocArticlePage({ params }: Params) {
  const { category: categorySlug, slug } = await params;
  const doc = getDoc(categorySlug, slug);
  const category = getCategory(categorySlug);
  if (!doc || !category) notFound();

  const { content } = await compileMDX({
    source: getDocSource(categorySlug, slug),
    components: mdxComponents,
    options: {
      parseFrontmatter: true,
      // next-mdx-remote blocks `{…}` expressions by default, which is the
      // right posture for MDX arriving from users. This collection is files in
      // the repo, reviewed in a PR — and with expressions blocked, props like
      // `labels={[…]}` and `cols={3}` are silently stripped rather than
      // erroring, which is a worse failure than the one being guarded against.
      // `blockDangerousJS` stays on: eval, Function and process are still
      // unreachable.
      blockJS: false,
      mdxOptions: {
        // Tables are the reason: plain MDX is CommonMark, where a pipe table
        // is literal text. Guides are full of column specs, so GFM is not
        // optional here. Strikethrough and autolinks come along with it.
        remarkPlugins: [remarkGfm],
        // Highlighting runs here, at build time, so the reader downloads
        // coloured markup instead of a highlighter.
        rehypePlugins: [rehypeHighlight],
      },
    },
  });

  const { previous, next } = getDocNeighbours(doc);

  return (
    <div className="flex gap-10">
      <article className="min-w-0 max-w-3xl flex-1">
        <nav aria-label="Breadcrumb" className="mb-6 text-sm text-muted-foreground">
          <Link href="/docs" className="hover:text-foreground">
            Documentation
          </Link>
          <span className="mx-2" aria-hidden="true">
            /
          </span>
          <Link href={`/docs/${category.slug}`} className="hover:text-foreground">
            {category.name}
          </Link>
        </nav>

        <header className="mb-8">
          <h1 className="text-3xl font-bold tracking-tight text-ink sm:text-4xl">
            {doc.title}
          </h1>
          <p className="mt-3 text-lg leading-8 text-muted-foreground">
            {doc.description}
          </p>
        </header>

        <div className="docs-prose">{content}</div>

        <ArticlePager previous={previous} next={next} />

        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{
            __html: JSON.stringify({
              "@context": "https://schema.org",
              "@type": "TechArticle",
              headline: doc.title,
              description: doc.description,
              url: `${SITE_URL}${doc.href}`,
              isPartOf: { "@type": "WebSite", url: SITE_URL },
            }),
          }}
        />
      </article>

      {/* Its own sticky context, offset by the nav — the article column
          scrolls the page, this one holds. */}
      <aside className="sticky top-16 hidden h-fit max-h-[calc(100vh-5rem)] w-56 shrink-0 overflow-y-auto pt-1 xl:block">
        <TableOfContents headings={doc.headings} />
      </aside>
    </div>
  );
}
