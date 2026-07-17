import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

// Wildcard origin is safe here — every route under /api is an unauthenticated,
// world-readable catalog read (same access Firestore rules already grant
// anyone), not a cookie/session-authenticated endpoint. Needed so Flutter Web
// builds (browser fetch, subject to CORS) can call this API; native
// Android/iOS builds aren't CORS-restricted and don't need this at all.
const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type",
};

export function proxy(request: NextRequest) {
  if (request.method === "OPTIONS") {
    return NextResponse.json({}, { headers: corsHeaders });
  }

  const response = NextResponse.next();
  for (const [key, value] of Object.entries(corsHeaders)) {
    response.headers.set(key, value);
  }
  return response;
}

export const config = {
  matcher: "/api/:path*",
};
