import { NextResponse } from "next/server";
import { getAppConfig } from "@/lib/app-config";

// Public, cached: every launch of the shopper app reads this before
// anything else, and a minimum version is not a secret.
export async function GET() {
  const config = await getAppConfig();
  return NextResponse.json(
    {
      min_version: config.minVersion,
      update_url: config.updateUrl,
    },
    { headers: { "Cache-Control": "public, max-age=300, s-maxage=300" } },
  );
}
