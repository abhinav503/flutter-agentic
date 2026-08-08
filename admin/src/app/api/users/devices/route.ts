import { NextResponse } from "next/server";
import {
  registerDevice,
  unregisterDevice,
  type DevicePlatform,
} from "@/lib/devices";
import { UnauthorizedError, requireAuthedUser } from "@/lib/api/admin-guard";

// The token belongs to whoever the verified token says it does — never to a
// uid taken from the body, which would let any caller file a device under
// someone else's account and receive their order updates.
function parseBody(
  body: unknown,
): { token: string; platform: DevicePlatform; granted: boolean } | null {
  if (typeof body !== "object" || body === null) return null;
  const { token, platform, granted } = body as Record<string, unknown>;
  if (typeof token !== "string" || token.trim().length === 0) return null;
  if (platform !== "android" && platform !== "ios") return null;
  // Absent means granted: a client old enough not to send it only registered
  // at all once permission was given.
  return {
    token: token.trim(),
    platform,
    granted: typeof granted === "boolean" ? granted : true,
  };
}

/// Registers or refreshes this device's FCM token for the signed-in shopper.
/// Idempotent — the app calls it on every open, and the token is the doc id.
export async function POST(request: Request) {
  try {
    const { uid } = await requireAuthedUser(request);
    const body = parseBody(await request.json().catch(() => null));
    if (!body) {
      return NextResponse.json(
        { error: "token and a valid platform are required" },
        { status: 400 },
      );
    }

    await registerDevice(uid, body.token, body.platform, body.granted);
    return NextResponse.json({ ok: true });
  } catch (error) {
    if (error instanceof UnauthorizedError) {
      return NextResponse.json({ error: error.message }, { status: 401 });
    }
    throw error;
  }
}

/// Drops this device on sign-out, so the handset stops being addressable as
/// the account that just left it.
export async function DELETE(request: Request) {
  try {
    const { uid } = await requireAuthedUser(request);
    const body = parseBody(await request.json().catch(() => null));
    if (!body) {
      return NextResponse.json({ error: "token is required" }, { status: 400 });
    }

    await unregisterDevice(uid, body.token);
    return NextResponse.json({ ok: true });
  } catch (error) {
    if (error instanceof UnauthorizedError) {
      return NextResponse.json({ error: error.message }, { status: 401 });
    }
    throw error;
  }
}
