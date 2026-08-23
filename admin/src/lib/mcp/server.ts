import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import { FieldValue } from "firebase-admin/firestore";
import { adminDb } from "@/lib/firebase-admin";
import type { ApiTokenScope } from "@/lib/api-token-scopes";
import {
  CATALOG_ENTITIES,
  deleteCatalogDoc,
  loadCatalog,
  upsertCatalog,
  MAX_UPSERT_ROWS,
} from "@/lib/api/v1/catalog";
import { serializeCatalogRecord } from "@/lib/api/v1/serializers";
import { IMPORT_FORMATS, ImportError, runImport } from "@/lib/api/v1/import";
import { ImageRehostError, rehostImage } from "@/lib/api/v1/images";
import { readinessWithPreviewFlag, submitStoreForReview, SubmitError } from "@/lib/store-publish";
import { buildSeedDocs } from "@/lib/seed/seed-grocery";
import { SEED_MARKETS } from "@/lib/seed/seed-markets";
import { getOrdersForStore } from "@/lib/orders";
import { serializeOrder } from "@/lib/api/serializers";
import { normalizeStoreStatus } from "@/lib/store-status";
import { SITE_URL } from "@/lib/site";
import { traced } from "@/lib/api/telemetry";

// The Cordelia MCP server: one tool per thing the v1 API can do, calling
// the same functions the routes call (no HTTP hop, no second validator).
// Built per request — stateless, so it runs on serverless — for whoever
// the bearer resolved to: an OAuth grant (claude.ai custom connector,
// Claude Code, Cursor, ChatGPT) listing the stores it may touch, or a
// store token (the stdio wrapper) bound to one.
//
// Annotations are the MCP spec's: readOnlyHint for the reads,
// destructiveHint for delete, so a host can confirm before a destructive
// call and the Connectors directory's requirements are met on day one.

export type McpActor =
  | { kind: "oauth"; uid: string; email: string; client: string; storeIds: string[]; scopes: ApiTokenScope[] }
  | { kind: "token"; uid: string; client: string; storeIds: string[]; scopes: ApiTokenScope[] };

const GUIDE = `How to publish a store on CordeliaApps through this connector.

A store is a catalog (categories, brands, products with optional variants,
coupons, banners) plus a few settings. The owner edits settings, payments and
support contact in the console; everything else you can do here.

Typical flow for a merchant bringing a catalog:
1. list_stores — find the store id (or ask the owner which store).
2. get_readiness — see the seven publish checks; fix what you can.
3. import_csv with dry_run=true — send their Shopify products_export.csv
   (format "shopify") or a Cordelia CSV. Read the plan: created/updated,
   per-row errors, skipped rows and notes. Shopify imports create missing
   categories (from Type/Tags) and brands (from Vendor) automatically.
4. Fix errors by editing rows (upsert_records) or the file, re-run the dry
   run, then import with dry_run=false.
5. Products without a photo: rehost_image copies a public image into the
   store. Shopify image URLs are rehosted automatically when you pass
   rehost_images=true.
6. get_readiness again; when every check passes, submit_for_review.

Rules the server enforces (you will see them as errors):
- Alcohol and tobacco products are refused platform-wide.
- A product with options needs one variant per combination, each with a
  price; up to 3 option axes.
- Categories/brands/coupon targets named in a row must exist — create
  them first (upsert_records on "categories"/"brands") unless the import
  creates them for you.
- Matching on update: id, else external_id, else name/code. Use
  external_id for anything that came from another system so re-imports
  update instead of duplicating.
- Payment keys, support email and the trading address can only be set by
  the owner in the console (Settings); the readiness hints say which.`;

function text(payload: unknown) {
  return { content: [{ type: "text" as const, text: typeof payload === "string" ? payload : JSON.stringify(payload, null, 2) }] };
}

function fail(message: string) {
  return { isError: true as const, content: [{ type: "text" as const, text: message }] };
}

export function buildMcpServer(actor: McpActor): McpServer {
  const server = new McpServer(
    {
      name: "cordelia",
      title: "CordeliaApps",
      version: "1.0.0",
      websiteUrl: SITE_URL,
      // A full-bleed square: hosts apply their own corner mask, so a
      // pre-rounded icon (the apple-touch one) shows clipped corners.
      icons: [{ src: `${SITE_URL}/brand/connector-icon.png`, mimeType: "image/png", sizes: ["512x512"] }],
    },
    { instructions: GUIDE },
  );

  const storeId = z.string().describe("The store id (from list_stores).");
  const entity = z.enum(CATALOG_ENTITIES).describe("products | categories | brands | coupons | banners");

  // A store the actor may act on, with the scope the tool needs — the same
  // two checks the HTTP guard makes.
  function authorize(id: string, scope: ApiTokenScope): string | null {
    if (!actor.storeIds.includes(id)) return `This connection has no access to store ${id}. Call list_stores.`;
    if (!actor.scopes.includes(scope)) return `This connection lacks the ${scope} scope.`;
    return null;
  }

  // Every tool call is one telemetry event: tool name, store (when the
  // arguments name one), who, how long, and whether the handler returned
  // isError — what tells us which tools agents actually reach for.
  type ToolResult = { isError?: boolean; content: { type: "text"; text: string }[] };
  const originalRegister = server.registerTool.bind(server);
  const registerTraced: typeof server.registerTool = (name, config, cb) =>
    originalRegister(name, config, (async (...cbArgs: unknown[]) => {
      const args = (cbArgs.length === 2 ? cbArgs[0] : {}) as Record<string, unknown>;
      // Attributed to the store only when the connection may touch it —
      // a typo'd id shouldn't mint a usage doc for a store that isn't ours.
      const storeIdArg =
        typeof args?.store_id === "string" && actor.storeIds.includes(args.store_id) ? args.store_id : null;
      return traced(
        {
          surface: "mcp",
          operation: name,
          storeId: storeIdArg,
          actor: { kind: actor.kind, uid: actor.uid, client: actor.client },
        },
        () => (cb as (...a: unknown[]) => Promise<ToolResult>)(...cbArgs),
        (result) => ({
          ok: !result.isError,
          error: result.isError ? result.content[0]?.text.slice(0, 200) : undefined,
        }),
      );
    }) as typeof cb);
  server.registerTool = registerTraced;

  server.registerTool(
    "get_guide",
    {
      title: "How to use this connector",
      description: "The import contract and publish flow. Read this first.",
      annotations: { readOnlyHint: true },
    },
    async () => text(GUIDE),
  );

  server.registerTool(
    "list_stores",
    {
      title: "List stores",
      description: "The stores this connection may manage, with status and template.",
      annotations: { readOnlyHint: true },
    },
    async () => {
      const snaps = await Promise.all(actor.storeIds.map((id) => adminDb.collection("stores").doc(id).get()));
      return text(
        snaps
          .filter((s) => s.exists)
          .map((s) => {
            const d = s.data()!;
            return {
              id: s.id,
              name: (d.name as string) ?? "",
              status: normalizeStoreStatus(d.status),
              template_id: (d.templateId as string) ?? "gravia",
              language: (d.language as string) ?? "",
              currency: (d.currency as string) ?? "",
            };
          }),
      );
    },
  );

  server.registerTool(
    "get_readiness",
    {
      title: "Publish readiness",
      description: "The store's status and the seven checks it must pass to be submitted, with a hint for each that fails.",
      inputSchema: { store_id: storeId },
      annotations: { readOnlyHint: true },
    },
    async ({ store_id }) => {
      const denied = authorize(store_id, "store:publish");
      if (denied) return fail(denied);
      try {
        return text(await readinessWithPreviewFlag(store_id));
      } catch (e) {
        return fail(e instanceof Error ? e.message : String(e));
      }
    },
  );

  server.registerTool(
    "list_catalog",
    {
      title: "List catalog records",
      description: "Every record of one entity in the store, in the shape upsert_records accepts (so you can edit and send back).",
      inputSchema: { store_id: storeId, entity },
      annotations: { readOnlyHint: true },
    },
    async ({ store_id, entity: ent }) => {
      const denied = authorize(store_id, "catalog:write");
      if (denied) return fail(denied);
      const catalog = await loadCatalog(store_id);
      return text([...catalog[ent].values()].map((r) => serializeCatalogRecord(ent, r)));
    },
  );

  server.registerTool(
    "upsert_records",
    {
      title: "Create or update records",
      description: `Upsert up to ${MAX_UPSERT_ROWS} records of one entity. Each item matches an existing record by id, else external_id, else name/code; fields omitted on an update are left alone. Use dry_run=true first to see the plan and per-item errors without writing. Product fields: name, description, images[], external_id, sku, barcode, price, original_price, stock, unit_value, unit_type (g|ml|pcs), categories (names or ids), brand (name or id), is_popular, option_names[], variants[{options[], price, original_price, stock, sku, barcode, sell_when_out_of_stock, image, pack_size}], attributes{}.`,
      inputSchema: {
        store_id: storeId,
        entity,
        items: z.array(z.record(z.unknown())).max(MAX_UPSERT_ROWS),
        dry_run: z.boolean().default(false),
      },
      annotations: { readOnlyHint: false, idempotentHint: true },
    },
    async ({ store_id, entity: ent, items, dry_run }) => {
      const denied = authorize(store_id, "catalog:write");
      if (denied) return fail(denied);
      const outcome = await upsertCatalog(store_id, ent, items, { dryRun: dry_run, actorUid: actor.uid });
      return text({ dry_run, ...outcome });
    },
  );

  server.registerTool(
    "delete_record",
    {
      title: "Delete a record",
      description: "Permanently delete one record by id.",
      inputSchema: { store_id: storeId, entity, id: z.string() },
      annotations: { destructiveHint: true, idempotentHint: true },
    },
    async ({ store_id, entity: ent, id }) => {
      const denied = authorize(store_id, "catalog:write");
      if (denied) return fail(denied);
      const found = await deleteCatalogDoc(store_id, ent, id);
      return found ? text({ deleted: id }) : fail(`No ${ent} record with id ${id}.`);
    },
  );

  server.registerTool(
    "import_csv",
    {
      title: "Import a CSV",
      description: "Import products (or categories/brands/coupons/banners) from CSV text. format \"shopify\" takes a Shopify products_export.csv (either header dialect) and creates missing categories/brands; \"cordelia\" takes our own columns. Always dry_run=true first: the plan lists per-row results, skipped rows and what was derived. rehost_images copies each product's image URLs into the store so they outlive the source.",
      inputSchema: {
        store_id: storeId,
        csv: z.string().describe("The file contents."),
        format: z.enum(IMPORT_FORMATS).default("cordelia"),
        entity: entity.default("products"),
        dry_run: z.boolean().default(true),
        create_missing: z.boolean().optional().describe("Create categories/brands the rows name. Defaults to true for shopify, false for cordelia."),
        tags_as_categories: z.boolean().default(false),
        rehost_images: z.boolean().default(false),
      },
      annotations: { readOnlyHint: false, idempotentHint: true },
    },
    async ({ store_id, csv, format, entity: ent, dry_run, create_missing, tags_as_categories, rehost_images }) => {
      const denied = authorize(store_id, "catalog:write");
      if (denied) return fail(denied);
      try {
        const report = await runImport(
          store_id,
          csv,
          {
            entity: ent,
            format,
            commit: !dry_run,
            createMissing: create_missing ?? format === "shopify",
            tagsAsCategories: tags_as_categories,
          },
          actor.uid,
        );
        let rehosted = 0;
        const rehostFailures: string[] = [];
        if (!dry_run && rehost_images && ent === "products") {
          const catalog = await loadCatalog(store_id);
          const ids = report.results.filter((r) => r.action !== "error").map((r) => r.id as string);
          for (const id of ids) {
            const p = catalog.products.get(id);
            if (!p) continue;
            const next: string[] = [];
            let changed = false;
            for (const url of p.images) {
              if (url.includes("firebasestorage.googleapis.com")) {
                next.push(url);
                continue;
              }
              try {
                next.push((await rehostImage(store_id, "products", url)).url);
                rehosted++;
                changed = true;
              } catch (e) {
                next.push(url);
                rehostFailures.push(`${p.name}: ${e instanceof Error ? e.message : "failed"}`);
              }
            }
            if (changed) {
              await adminDb.collection("stores").doc(store_id).collection("products").doc(id).set(
                { images: next, imageUrl: next[0] ?? "", updatedAt: FieldValue.serverTimestamp() },
                { merge: true },
              );
            }
          }
        }
        return text({ ...report, rehosted_images: rehosted, rehost_failures: rehostFailures });
      } catch (e) {
        if (e instanceof ImportError) return fail(e.message);
        throw e;
      }
    },
  );

  server.registerTool(
    "rehost_image",
    {
      title: "Copy an image into the store",
      description: "Fetch a public https image (≤10 MB) and store it in the store's own bucket; returns the new URL to put on a product, category, banner or brand.",
      inputSchema: {
        store_id: storeId,
        url: z.string().url(),
        kind: z.enum(["products", "categories", "banners", "brands", "store"]).default("products"),
      },
      annotations: { readOnlyHint: false, idempotentHint: false },
    },
    async ({ store_id, url, kind }) => {
      const denied = authorize(store_id, "catalog:write");
      if (denied) return fail(denied);
      try {
        return text(await rehostImage(store_id, kind, url));
      } catch (e) {
        if (e instanceof ImageRehostError) return fail(e.message);
        throw e;
      }
    },
  );

  server.registerTool(
    "seed_sample_data",
    {
      title: "Generate sample data",
      description: "Write a market's sample grocery catalog (~100 products, 10 categories, brands, coupons, banners) into an empty store, for trying the app before a real catalog exists.",
      inputSchema: { store_id: storeId, market: z.enum(SEED_MARKETS) },
      annotations: { readOnlyHint: false, idempotentHint: false },
    },
    async ({ store_id, market }) => {
      const denied = authorize(store_id, "catalog:write");
      if (denied) return fail(denied);
      const store = adminDb.collection("stores").doc(store_id);
      const { docs, result } = buildSeedDocs(market, (coll) => store.collection(coll).doc().id);
      const batch = adminDb.batch();
      for (const d of docs) {
        batch.set(store.collection(d.collection).doc(d.id), {
          ...d.data,
          createdAt: FieldValue.serverTimestamp(),
          updatedBy: actor.uid,
        });
      }
      await batch.commit();
      return text({ market, ...result });
    },
  );

  server.registerTool(
    "submit_for_review",
    {
      title: "Submit the store for review",
      description: "Moves a draft (or rejected) store to pending review, if every readiness check passes. A CordeliaApps superadmin then approves it. Returns the failing checks otherwise.",
      inputSchema: { store_id: storeId },
      annotations: { readOnlyHint: false, idempotentHint: true },
    },
    async ({ store_id }) => {
      const denied = authorize(store_id, "store:publish");
      if (denied) return fail(denied);
      try {
        return text(await submitStoreForReview(store_id));
      } catch (e) {
        if (e instanceof SubmitError) return fail(JSON.stringify({ error: e.message, checks: e.checks }, null, 2));
        throw e;
      }
    },
  );

  server.registerTool(
    "list_orders",
    {
      title: "List orders",
      description: "The store's orders, newest first.",
      inputSchema: { store_id: storeId, limit: z.number().int().min(1).max(200).default(50) },
      annotations: { readOnlyHint: true },
    },
    async ({ store_id, limit }) => {
      const denied = authorize(store_id, "orders:read");
      if (denied) return fail(denied);
      const orders = await getOrdersForStore(store_id);
      return text(orders.slice(0, limit).map(serializeOrder));
    },
  );

  return server;
}
