import { NextResponse } from "next/server";
import { requireAuthedUser, UnauthorizedError } from "@/lib/api/admin-guard";
import { blockShopper } from "@/lib/blocked-shoppers";
import { isReviewReportReason, reportReview, ReviewError } from "@/lib/reviews";

// A shopper reports someone else's review, and optionally stops seeing that
// shopper's reviews at all. App Store Review Guideline 1.2 asks for both:
// a way to flag objectionable content, and a way to block the person who
// posted it.
//
// One route for the pair because in the app they are one action — the sheet
// that asks why also offers "and hide their reviews", so a reader who has
// had enough of someone doesn't have to find a second control. Blocking on
// its own is still possible (`reason` plus `block: true` covers it); there
// is no separate endpoint until a surface needs one.
//
// The reporter is always the token's uid: a caller can neither report on
// someone else's behalf nor stuff the count.
export async function POST(
  request: Request,
  {
    params,
  }: { params: Promise<{ storeId: string; productId: string; uid: string }> },
) {
  const { storeId, productId, uid } = await params;

  let reporterUid: string;
  try {
    reporterUid = (await requireAuthedUser(request)).uid;
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    throw e;
  }

  const body = await request.json().catch(() => ({}));
  if (!isReviewReportReason(body.reason)) {
    return NextResponse.json({ error: "Unknown report reason" }, { status: 400 });
  }

  try {
    const reportCount = await reportReview(
      reporterUid,
      storeId,
      productId,
      uid,
      body.reason,
    );
    // Blocking after the report, and not in the same transaction: they are
    // separate promises to the shopper. A block that failed would be worth
    // retrying, but not at the cost of losing a report the store owner
    // needs to see.
    const blocked = body.block === true;
    if (blocked) await blockShopper(reporterUid, uid);

    return NextResponse.json({ report_count: reportCount, blocked });
  } catch (e) {
    if (e instanceof ReviewError) {
      return NextResponse.json({ error: e.message }, { status: 400 });
    }
    throw e;
  }
}
