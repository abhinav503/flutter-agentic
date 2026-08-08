import { NextResponse } from "next/server";
import {
  STALE_DEVICE_DAYS,
  pruneStaleDevices,
} from "@/lib/devices";
import {
  ForbiddenError,
  UnauthorizedError,
  requireSuperAdmin,
} from "@/lib/api/admin-guard";

/**
 * Deletes device rows nothing has refreshed in {@link STALE_DEVICE_DAYS}.
 *
 * Two callers, two credentials. **Vercel Cron** sends
 * `Authorization: Bearer $CRON_SECRET` and holds no Firebase identity at all,
 * so it can't go through the usual ID-token guard; a **superadmin** can also
 * run it by hand from a signed-in session, which is how you'd verify it does
 * what you expect before trusting a schedule with it.
 *
 * `CRON_SECRET` unset means the cron door is simply closed — never open. An
 * unauthenticated prune endpoint is a delete-everyone's-notifications button.
 */
function isCronCaller(request: Request): boolean {
  const secret = process.env.CRON_SECRET;
  if (!secret) return false;
  return request.headers.get("authorization") === `Bearer ${secret}`;
}

export async function POST(request: Request) {
  if (!isCronCaller(request)) {
    try {
      await requireSuperAdmin(request);
    } catch (error) {
      if (error instanceof UnauthorizedError) {
        return NextResponse.json({ error: error.message }, { status: 401 });
      }
      if (error instanceof ForbiddenError) {
        return NextResponse.json({ error: error.message }, { status: 403 });
      }
      throw error;
    }
  }

  const deleted = await pruneStaleDevices();
  return NextResponse.json({ deleted, olderThanDays: STALE_DEVICE_DAYS });
}

/**
 * Vercel Cron issues GET, not POST. Same guard, same work — a declared
 * delegate rather than `export const GET = POST`, since Next detects a
 * route's methods from its exported declarations.
 */
export async function GET(request: Request) {
  return POST(request);
}
