import { NextResponse } from "next/server";
import { getOrderForStore, OrderRatingError, rateOrder } from "@/lib/orders";
import { serializeOrder } from "@/lib/api/serializers";
import { requireAuthedUser, UnauthorizedError } from "@/lib/api/admin-guard";

// The shopper rates their own delivered order — how the delivery went, not
// what they thought of a product (that's the product's own reviews route,
// which is deliberately open to anyone signed in).
//
// Shopper-only: there is no store-owner branch here, unlike the cancel
// route. An owner rating their own store's delivery would be fabricating
// customer feedback, so `rateOrder` keys strictly on the caller's uid.
//
// Posting again replaces the rating — an order has exactly one shopper, so
// "one review per subject, re-posting edits it" needs no per-user keying.
export async function POST(
  request: Request,
  { params }: { params: Promise<{ storeId: string; orderId: string }> },
) {
  const { storeId, orderId } = await params;

  let uid: string;
  try {
    uid = (await requireAuthedUser(request)).uid;
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    throw e;
  }

  // Scopes the order to the store in the path before anything else — the
  // orders collection is flat, so without this a caller could rate their own
  // order through any store's URL and land it in that store's dashboard.
  const scoped = await getOrderForStore(orderId, storeId);
  if (!scoped) {
    return NextResponse.json({ error: "Order not found" }, { status: 404 });
  }

  const body = await request.json().catch(() => ({}));
  const rating = typeof body.rating === "number" ? body.rating : NaN;
  const text = typeof body.text === "string" ? body.text : "";

  try {
    const order = await rateOrder(orderId, uid, rating, text);
    return NextResponse.json({ order: serializeOrder(order) });
  } catch (e) {
    if (e instanceof OrderRatingError) {
      // 400 bad rating / 404 not yours / 409 not delivered — the error picks
      // its own status, so this route never has to re-derive intent.
      return NextResponse.json({ error: e.message }, { status: e.status });
    }
    throw e;
  }
}
