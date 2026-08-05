import { NextResponse } from "next/server";
import { adminDb } from "@/lib/firebase-admin";
import {
  requireStoreOwner,
  ForbiddenError,
  UnauthorizedError,
} from "@/lib/api/admin-guard";
import { getTemplates } from "@/lib/templates";
import { serializeStore } from "@/lib/api/serializers";
import { STORE_LANGUAGES, type Store } from "@/lib/types";

// Same doc→Store defaults as mapStoreDoc in src/lib/stores.ts, but over an
// Admin-SDK snapshot (that helper is typed to the client SDK the dashboard
// uses — same split as orders.ts vs orders-dashboard.ts).
function mapAdminStoreDoc(
  id: string,
  data: FirebaseFirestore.DocumentData,
): Store {
  return {
    id,
    name: (data.name as string) ?? "",
    logoUrl: (data.logoUrl as string) ?? "",
    description: (data.description as string) ?? "",
    ownerUid: (data.ownerUid as string) ?? "",
    status: (data.status as string) ?? "active",
    searchKeywords: (data.searchKeywords as string[] | undefined) ?? [],
    templateId: (data.templateId as string) ?? "gravia",
    language: (data.language as string) ?? "en",
  };
}

// Public single-store read — same world-readable reasoning as the
// discovery GET in ../route.ts.
export async function GET(
  _request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const snap = await adminDb.collection("stores").doc(storeId).get();
  const data = snap.data();
  if (!data || data.status !== "active") {
    return NextResponse.json({ error: "Store not found" }, { status: 404 });
  }
  return NextResponse.json({
    store: serializeStore(mapAdminStoreDoc(snap.id, data)),
  });
}

// Owner-only partial update of the store's public profile — the
// post-creation half of the templateId flow (creation-time selection lives
// in POST ../route.ts), following the payment-config route's guard pattern.
export async function PUT(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  try {
    await requireStoreOwner(request, storeId);
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    if (e instanceof ForbiddenError) {
      return NextResponse.json({ error: e.message }, { status: 403 });
    }
    throw e;
  }

  const body = await request.json().catch(() => ({}));
  const update: Record<string, unknown> = {};

  if (body.name !== undefined) {
    const name = typeof body.name === "string" ? body.name.trim() : "";
    if (!name) {
      return NextResponse.json(
        { error: "name cannot be empty" },
        { status: 400 },
      );
    }
    update.name = name;
  }
  if (body.description !== undefined) {
    update.description =
      typeof body.description === "string" ? body.description.trim() : "";
  }
  if (body.logoUrl !== undefined) {
    update.logoUrl = typeof body.logoUrl === "string" ? body.logoUrl.trim() : "";
  }
  if (body.searchKeywords !== undefined) {
    update.searchKeywords = Array.isArray(body.searchKeywords)
      ? body.searchKeywords
          .filter((k: unknown): k is string => typeof k === "string")
          .map((k: string) => k.trim())
          .filter(Boolean)
      : [];
  }
  if (body.templateId !== undefined) {
    const templateId =
      typeof body.templateId === "string" ? body.templateId.trim() : "";
    // Validated against the seeded templates collection — a typo here would
    // silently fall back to gravia on the cordelia client (its parse
    // extension is deliberately tolerant), so fail loud on the write side.
    const templates = await getTemplates();
    if (!templates.some((t) => t.id === templateId)) {
      return NextResponse.json(
        {
          error: `Unknown templateId "${templateId}" — valid: ${templates
            .map((t) => t.id)
            .join(", ")}`,
        },
        { status: 400 },
      );
    }
    update.templateId = templateId;
  }
  if (body.language !== undefined) {
    const language =
      typeof body.language === "string" ? body.language.trim() : "";
    // Fail loud like templateId — cordelia's parse silently falls back to
    // English on an unknown value.
    if (!(STORE_LANGUAGES as readonly string[]).includes(language)) {
      return NextResponse.json(
        {
          error: `Unknown language "${language}" — valid: ${STORE_LANGUAGES.join(", ")}`,
        },
        { status: 400 },
      );
    }
    update.language = language;
  }

  if (Object.keys(update).length === 0) {
    return NextResponse.json({ error: "Nothing to update" }, { status: 400 });
  }

  const ref = adminDb.collection("stores").doc(storeId);
  await ref.update(update);
  const snap = await ref.get();
  return NextResponse.json({
    store: serializeStore(mapAdminStoreDoc(snap.id, snap.data()!)),
  });
}
