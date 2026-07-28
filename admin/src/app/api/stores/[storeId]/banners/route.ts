import { NextResponse } from "next/server";
import { getBanners } from "@/lib/banners";
import { serializeBanner } from "@/lib/api/serializers";

// Feeds a storefront template's promo carousel (dailymart's
// DailyMartHomePromoCarousel). Inactive banners are filtered out server-side
// rather than sent with a flag — a staged or retired banner has no reason to
// reach a shopper's device at all.
export async function GET(
  _request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const banners = await getBanners(storeId);
  return NextResponse.json({
    banners: banners.filter((b) => b.isActive).map(serializeBanner),
  });
}
