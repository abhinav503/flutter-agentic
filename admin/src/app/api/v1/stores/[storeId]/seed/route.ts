import { NextResponse } from "next/server";
import { FieldValue } from "firebase-admin/firestore";
import { adminDb } from "@/lib/firebase-admin";
import { authorizeWrite, tracedRoute } from "@/lib/api/v1/catalog-route";
import { buildSeedDocs } from "@/lib/seed/seed-grocery";
import { SEED_MARKETS, type SeedMarket } from "@/lib/seed/seed-markets";

// POST { market } — writes one market's sample grocery catalog into the
// store in a single atomic batch. The console's "Generate sample data" and
// a CLI's `seed` both land here.
export async function POST(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const body = await request.json().catch(() => ({}));
  const market = body.market as SeedMarket;
  if (!SEED_MARKETS.includes(market)) {
    return NextResponse.json(
      { error: `market must be one of ${SEED_MARKETS.join(", ")}` },
      { status: 400 },
    );
  }
  const store = adminDb.collection("stores").doc(storeId);
  const { docs, result } = buildSeedDocs(market, (coll) => store.collection(coll).doc().id);
  const auth = await authorizeWrite(request, storeId, docs.length);
  if ("response" in auth) return auth.response;

  return tracedRoute("POST seed", storeId, auth.actor, async () => {
    const batch = adminDb.batch();
    for (const d of docs) {
      batch.set(store.collection(d.collection).doc(d.id), {
        ...d.data,
        createdAt: FieldValue.serverTimestamp(),
        updatedBy: auth.actor.uid,
      });
    }
    await batch.commit();
    return NextResponse.json({ market, ...result }, { status: 201 });
  }, { market });
}
