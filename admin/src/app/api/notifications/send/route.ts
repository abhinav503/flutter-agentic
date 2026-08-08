import { NextResponse } from "next/server";
import { sendNotification } from "@/lib/push";
import {
  ForbiddenError,
  UnauthorizedError,
  requireSuperAdmin,
} from "@/lib/api/admin-guard";
import { imageSizeError, parsePushInput } from "@/lib/api/notification-input";

/**
 * CordeliaApps addressing every store's shoppers at once.
 *
 * Guarded on the `role: 'superAdmin'` custom claim, which only
 * scripts/grant-superadmin.mjs can set — deliberately not on the mirrored
 * admins-doc field, which is client-creatable at sign-up.
 */
export async function POST(request: Request) {
  try {
    const uid = await requireSuperAdmin(request);
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

    const result = await sendNotification({ scope: "platform" }, input, uid);
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
