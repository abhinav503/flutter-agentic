"use client";

import { useCallback, useEffect, useState } from "react";
import type { User } from "firebase/auth";
import { useAuth } from "@/lib/auth-context";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { STORE_STATUS_LABELS, type StoreStatus } from "@/lib/store-status";

type Check = {
  id: string;
  label: string;
  hint: string;
  passed: boolean;
  blocksPreview: boolean;
};

type PublishState = {
  status: StoreStatus;
  rejectionReason: string;
  readiness: {
    checks: Check[];
    previewReady: boolean;
    publishReady: boolean;
  };
};

const STATUS_TONE: Record<StoreStatus, string> = {
  draft: "bg-muted text-muted-foreground",
  pending: "bg-amber-100 text-amber-900",
  published: "bg-emerald-100 text-emerald-900",
  rejected: "bg-red-100 text-red-900",
};

/// Kept outside the component and free of setState so the effect below can
/// await it and drop the result when the card has already unmounted — the
/// pattern the other dashboard pages use.
///
/// The GET is deliberately not side-effect free: it recomputes readiness and
/// caches `previewReady` back onto the store doc, which is what lets the
/// owner see their own unpublished store in the CordeliaApps app. Opening
/// this card is how that flag stays honest.
async function fetchPublishState(
  user: User,
  storeId: string,
): Promise<PublishState | null> {
  const token = await user.getIdToken();
  const res = await fetch(`/api/stores/${storeId}/publish`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  return res.ok ? ((await res.json()) as PublishState) : null;
}

/// The store owner's half of the publication lifecycle: what's still
/// missing, and the one button that submits the store for review.
export function PublishStoreCard({ storeId }: { storeId: string }) {
  const { user } = useAuth();
  const [state, setState] = useState<PublishState | null>(null);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    if (!user) return;
    let active = true;
    void (async () => {
      const next = await fetchPublishState(user, storeId);
      if (active && next) setState(next);
    })();
    return () => {
      active = false;
    };
  }, [user, storeId]);

  const refresh = useCallback(async () => {
    if (!user) return;
    const next = await fetchPublishState(user, storeId);
    if (next) setState(next);
  }, [user, storeId]);

  async function submit() {
    if (!user) return;
    setBusy(true);
    setError("");
    try {
      const token = await user.getIdToken();
      const res = await fetch(`/api/stores/${storeId}/publish`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({ action: "submit" }),
      });
      if (!res.ok) {
        const body = await res.json().catch(() => ({}));
        setError(body.error ?? "Could not submit this store.");
        return;
      }
      await refresh();
    } finally {
      setBusy(false);
    }
  }

  if (!state) return null;

  const { status, readiness, rejectionReason } = state;
  const canSubmit =
    readiness.publishReady && (status === "draft" || status === "rejected");

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex flex-wrap items-center gap-2">
          Publishing
          <span
            className={`rounded-full px-2 py-0.5 text-xs font-medium ${STATUS_TONE[status]}`}
          >
            {STORE_STATUS_LABELS[status]}
          </span>
        </CardTitle>
        <CardDescription>
          {status === "published"
            ? "This store is live in CordeliaApps for every shopper."
            : readiness.previewReady
              ? "Only you can see this store in the app right now. Submit it for review to go live for everyone."
              : "Complete the checklist below — until then this store doesn't appear in the app at all, even for you."}
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        {status === "rejected" && rejectionReason && (
          <p className="rounded-md bg-red-50 p-3 text-sm text-red-900">
            <span className="font-medium">Changes requested:</span>{" "}
            {rejectionReason}
          </p>
        )}

        <ul className="space-y-2">
          {readiness.checks.map((check) => (
            <li key={check.id} className="flex items-start gap-2 text-sm">
              <span
                aria-hidden
                className={check.passed ? "text-emerald-600" : "text-muted-foreground"}
              >
                {check.passed ? "✓" : "○"}
              </span>
              <span>
                <span className={check.passed ? "" : "font-medium"}>
                  {check.label}
                </span>
                {!check.passed && (
                  <span className="block text-muted-foreground">
                    {check.hint}
                    {!check.blocksPreview &&
                      " (not needed to preview it yourself)"}
                  </span>
                )}
              </span>
            </li>
          ))}
        </ul>

        {error && <p className="text-sm text-red-600">{error}</p>}

        {status === "pending" ? (
          <p className="text-sm text-muted-foreground">
            Submitted — a CordeliaApps reviewer will take a look shortly.
          </p>
        ) : status === "published" ? null : (
          <Button onClick={submit} disabled={!canSubmit || busy}>
            {busy ? "Submitting…" : "Submit for review"}
          </Button>
        )}
      </CardContent>
    </Card>
  );
}
