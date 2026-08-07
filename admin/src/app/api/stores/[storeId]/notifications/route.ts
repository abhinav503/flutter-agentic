import { NextResponse } from "next/server";
import {
  getNotificationFeed,
  markNotificationsRead,
} from "@/lib/notifications-feed";
import { serializeNotification } from "@/lib/api/serializers";
import { optionalAuthedUser, requireAuthedUser } from "@/lib/api/admin-guard";
import { UnauthorizedError } from "@/lib/api/admin-guard";

/**
 * The storefront's notification centre: this store's own messages merged with
 * the CordeliaApps platform feed, newest first.
 *
 * `optionalAuthedUser`, not `requireAuthedUser` — the screen is reachable
 * before sign-in and a signed-out shopper simply gets everything unread,
 * matching how recent searches treat an anonymous caller.
 */
export async function GET(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const uid = await optionalAuthedUser(request);
  const notifications = await getNotificationFeed(storeId, uid);
  return NextResponse.json({
    notifications: notifications.map(serializeNotification),
  });
}

/**
 * Marks notifications read for the calling shopper.
 *
 * Requires a real token even though GET doesn't: a read receipt belongs to
 * someone, and there is nowhere to put one for an anonymous caller.
 *
 * Takes explicit ids rather than "mark everything read" so the client decides
 * what the shopper actually saw — and stays idempotent, so the app can fire it
 * on every open without tracking what it already sent.
 */
export async function POST(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  // storeId is part of the path for consistency with the rest of the
  // storefront API, but read receipts are keyed by notification id alone:
  // a platform notification read in one store stays read in the next.
  await params;

  try {
    const { uid } = await requireAuthedUser(request);
    const body = (await request.json().catch(() => null)) as {
      notification_ids?: unknown;
    } | null;

    const ids = Array.isArray(body?.notification_ids)
      ? body.notification_ids.filter((id): id is string => typeof id === "string")
      : [];

    await markNotificationsRead(uid, ids);
    return NextResponse.json({ ok: true });
  } catch (error) {
    if (error instanceof UnauthorizedError) {
      return NextResponse.json({ error: error.message }, { status: 401 });
    }
    throw error;
  }
}
