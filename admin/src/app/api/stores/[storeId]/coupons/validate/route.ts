import { NextResponse } from "next/server";
import {
  CouponError,
  couponErrorBody,
  previewCoupon,
} from "@/lib/coupon-engine";
import { requireAuthedUser, UnauthorizedError } from "@/lib/api/admin-guard";
import type { CreateOrderItemInput } from "@/lib/orders";

// The shopper's "Apply" preview — validates a code against their current
// cart and returns the discount the order routes will grant for the same
// lines (previewCoupon is also what prices the payment intent).
// Token-verified because per-user limits key on the caller's uid.
//
// Purely a preview: nothing is reserved or counted here; the order
// transaction re-checks every limit with transaction-consistent reads, so a
// code that runs out between Apply and Checkout fails the order cleanly.
export async function POST(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;

  let uid: string;
  try {
    uid = (await requireAuthedUser(request)).uid;
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    throw e;
  }

  const body = await request.json().catch(() => ({}));
  const code = typeof body.code === "string" ? body.code.trim() : "";
  const items = body.items as CreateOrderItemInput[] | undefined;
  if (!code) {
    return NextResponse.json({ error: "code is required" }, { status: 400 });
  }
  if (!Array.isArray(items) || items.length === 0) {
    return NextResponse.json(
      { error: "items must be a non-empty array" },
      { status: 400 },
    );
  }

  try {
    const priced = await previewCoupon(storeId, uid, code, items);
    return NextResponse.json({
      code: priced.coupon.code,
      type: priced.coupon.type,
      value: priced.coupon.value,
      discount: priced.discount,
      eligible_subtotal: priced.eligible,
    });
  } catch (e) {
    if (e instanceof CouponError) {
      return NextResponse.json(couponErrorBody(e), { status: 400 });
    }
    throw e;
  }
}
