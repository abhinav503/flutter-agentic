import { NextResponse } from "next/server";
import { sendNotification } from "@/lib/push";
import {
  ForbiddenError,
  UnauthorizedError,
  requireStoreOwner,
} from "@/lib/api/admin-guard";
import { imageSizeError, parsePushInput } from "@/lib/api/notification-input";

/**
 * A store owner broadcasting to their own shoppers.
 *
 * Composing goes through here rather than a client-SDK write because sending
 * *is* pushing: only the Admin SDK can reach FCM, so the push and the record
 * have to be made in one place (see lib/push.ts).
 */
export async function POST(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;

  try {
    const uid = await requireStoreOwner(request, storeId);
    const input = parsePushInput(await request.json().catch(() => null));
    if (!input) {
      return NextResponse.json(
        { error: "title, message and a valid kind are required" },
        { status: 400 },
      );
    }

    const oversized = await imageSizeError(input.imageUrl);
    if (oversized) {
      return NextResponse.json({ error: oversized }, { status: 400 });
    }

    const result = await sendNotification({ scope: "store", storeId }, input, uid);
    return NextResponse.json(result);
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
