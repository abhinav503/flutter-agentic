import { docCategories, getAllDocs } from "@/lib/docs";
import { SITE_URL } from "@/lib/site";

// llms.txt (llmstxt.org): what an AI agent reads when it lands on the site
// with a question — what CordeliaApps is, how to connect, and where every
// guide lives. Plain text, built from the same docs collection as the
// sitemap, so it can't go stale separately.
export async function GET() {
  const docs = getAllDocs();
  const lines = [
    "# CordeliaApps",
    "",
    "> CordeliaApps gives a grocery or retail store its own branded shopping app (Android and iOS) with zero commission. A merchant brings a catalog — from Shopify, WooCommerce, a CSV, or by hand — connects their own Razorpay or Stripe account, and submits the store for review. An AI assistant (Claude, ChatGPT, Claude Code) can manage the store through MCP; scripts can use the HTTP API with a store token.",
    "",
    "## Connect an AI assistant",
    "",
    `- MCP endpoint (Streamable HTTP, OAuth sign-in): ${SITE_URL}/api/mcp`,
    `- Claude.ai: Settings → Connectors → Add custom connector → paste the URL`,
    `- Claude Code: claude mcp add --transport http cordelia ${SITE_URL}/api/mcp`,
    `- OAuth discovery: ${SITE_URL}/.well-known/oauth-authorization-server`,
    "",
    "## HTTP API",
    "",
    `- Base: ${SITE_URL}/api/v1/stores/{storeId} — products, categories, brands, coupons, banners (GET/POST/PUT/PATCH/DELETE), import (CSV, Shopify or WooCommerce export, dry run by default), images, seed, readiness, publish`,
    `- Auth: Authorization: Bearer cord_live_… (store token from Settings → Developers), scopes catalog:write, store:publish, orders:read`,
    "",
    "## Docs",
    "",
  ];
  for (const category of docCategories) {
    const inCategory = docs.filter((d) => d.categorySlug === category.slug);
    if (!inCategory.length) continue;
    lines.push(`### ${category.name}`, "");
    for (const doc of inCategory) {
      lines.push(`- [${doc.title}](${SITE_URL}${doc.href}): ${doc.description}`);
    }
    lines.push("");
  }
  lines.push("## Policies", "", `- [Terms](${SITE_URL}/terms)`, `- [Privacy](${SITE_URL}/privacy)`, `- [Refunds](${SITE_URL}/refunds)`, "");
  return new Response(lines.join("\n"), {
    headers: { "Content-Type": "text/plain; charset=utf-8", "Cache-Control": "public, max-age=3600" },
  });
}
