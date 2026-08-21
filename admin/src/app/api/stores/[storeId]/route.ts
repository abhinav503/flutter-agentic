import { NextResponse } from "next/server";
import { adminDb } from "@/lib/firebase-admin";
import {
  requireStoreOwner,
  ForbiddenError,
  UnauthorizedError,
} from "@/lib/api/admin-guard";
import { getTemplates } from "@/lib/templates";
import { serializeStore } from "@/lib/api/serializers";
import { isPubliclyVisible, normalizeStoreStatus } from "@/lib/store-status";
import {
  MAX_DELIVERY_AREAS,
  mapStoreDelivery,
  normalizeDeliveryAreas,
} from "@/lib/delivery";
import {
  MAX_SUPPORT_HOURS_LENGTH,
  isSupportEmail,
  isSupportPhone,
  mapStoreSupport,
} from "@/lib/support";
import {
  MAX_STORE_ADDRESS_LENGTH,
  STORE_CURRENCIES,
  STORE_LANGUAGES,
  type Store,
} from "@/lib/types";

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
    address: (data.address as string) ?? "",
    ownerUid: (data.ownerUid as string) ?? "",
    status: normalizeStoreStatus(data.status),
    rejectionReason: (data.rejectionReason as string) ?? "",
    previewReady: (data.previewReady as boolean | undefined) ?? false,
    searchKeywords: (data.searchKeywords as string[] | undefined) ?? [],
    templateId: (data.templateId as string) ?? "gravia",
    language: (data.language as string) ?? "en",
    currency: (data.currency as string) ?? "INR",
    delivery: mapStoreDelivery(data.delivery),
    support: mapStoreSupport(data.support),
    createdAtMs:
      (data.createdAt as FirebaseFirestore.Timestamp | null | undefined)?.toMillis() ??
      0,
  };
}

// A money amount off the request body: a finite, non-negative number, or
// null for anything else. Deliberately not coercing — mapStoreDelivery's
// silent `?? 0` is right for *reading* a doc written long ago, but a write
// that quietly turns a typo into free delivery is a different thing.
function money(value: unknown): number | null {
  if (value === undefined || value === null || value === "") return 0;
  const n = typeof value === "number" ? value : Number(value);
  if (!Number.isFinite(n) || n < 0) return null;
  return Math.round(n * 100) / 100;
}

// A trimmed string off the request body. Non-strings become "" rather than
// "undefined" — this is a form field the owner may deliberately be clearing.
function str(value: unknown): string {
  return typeof value === "string" ? value.trim() : "";
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
  // Through the normalizer, like every other reader. This used to compare
  // raw against the pre-lifecycle `"active"`, so a store that reached
  // `published` the ordinary way — submit, approve — answered 404 here. The
  // path that breaks is the notification tap: a push carries only a store
  // id, and mounting the storefront behind it starts with this call.
  if (!data || !isPubliclyVisible(normalizeStoreStatus(data.status))) {
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
  if (body.address !== undefined) {
    const address = str(body.address);
    // Refused only when the key is *sent* empty — this is a partial update,
    // so the Support and Delivery forms, which send neither name nor address,
    // must keep saving. Publishing is gated separately in store-readiness.
    if (!address) {
      return NextResponse.json(
        { error: "address cannot be empty" },
        { status: 400 },
      );
    }
    if (address.length > MAX_STORE_ADDRESS_LENGTH) {
      return NextResponse.json(
        {
          error: `Address must be ${MAX_STORE_ADDRESS_LENGTH} characters or fewer`,
        },
        { status: 400 },
      );
    }
    update.address = address;
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
  if (body.currency !== undefined) {
    const currency =
      typeof body.currency === "string" ? body.currency.trim().toUpperCase() : "";
    // Fail loud like language — cordelia's parse silently falls back to INR,
    // which would quietly misprice every product in the storefront.
    if (!(STORE_CURRENCIES as readonly string[]).includes(currency)) {
      return NextResponse.json(
        {
          error: `Unknown currency "${currency}" — valid: ${STORE_CURRENCIES.join(", ")}`,
        },
        { status: 400 },
      );
    }
    update.currency = currency;
  }
  if (body.delivery !== undefined) {
    // Written as a whole map, never field-by-field: the form edits the three
    // together, and a partial write would let a fee survive the removal of
    // the threshold that was waiving it.
    const raw = (body.delivery ?? {}) as Record<string, unknown>;
    const fee = money(raw.fee);
    const freeAbove = money(raw.freeAbove);
    if (fee === null || freeAbove === null) {
      return NextResponse.json(
        { error: "delivery fee and free-above must be numbers of 0 or more" },
        { status: 400 },
      );
    }
    if (Array.isArray(raw.areas) && raw.areas.length > MAX_DELIVERY_AREAS) {
      // Loud rather than silently truncating to the cap — an owner who pasted
      // 800 postal codes must not be told everything saved when 300 didn't.
      return NextResponse.json(
        { error: `At most ${MAX_DELIVERY_AREAS} delivery areas` },
        { status: 400 },
      );
    }
    update.delivery = {
      fee,
      freeAbove,
      areas: normalizeDeliveryAreas(raw.areas),
    };
  }

  if (body.support !== undefined) {
    // Whole map, same reasoning as delivery: the form edits the three
    // together, and a partial write could leave opening hours advertised
    // against a contact that has since been removed.
    const raw = (body.support ?? {}) as Record<string, unknown>;
    const email = str(raw.email);
    const phone = str(raw.phone);
    const hours = str(raw.hours);
    // Empty is always allowed — publishing no contact is a legitimate choice
    // (the app falls back to the platform address), and requiring one here
    // would lock an owner out of *clearing* a stale address.
    if (email && !isSupportEmail(email)) {
      return NextResponse.json(
        { error: `"${email}" is not a valid email address` },
        { status: 400 },
      );
    }
    if (phone && !isSupportPhone(phone)) {
      return NextResponse.json(
        { error: `"${phone}" is not a valid phone number` },
        { status: 400 },
      );
    }
    if (hours.length > MAX_SUPPORT_HOURS_LENGTH) {
      return NextResponse.json(
        { error: `Opening hours must be ${MAX_SUPPORT_HOURS_LENGTH} characters or fewer` },
        { status: 400 },
      );
    }
    update.support = { email, phone, hours };
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
