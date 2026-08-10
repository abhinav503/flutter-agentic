"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import type { User } from "firebase/auth";
import { useAuth } from "@/lib/auth-context";
import { useStore } from "@/lib/store-context";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { STORE_STATUS_LABELS, type StoreStatus } from "@/lib/store-status";
import { toast } from "sonner";

type QueueStore = {
  id: string;
  name: string;
  logoUrl: string;
  description: string;
  ownerUid: string;
  status: StoreStatus;
  rejectionReason: string;
  previewReady: boolean;
};

const FILTERS: { value: StoreStatus | "all"; label: string }[] = [
  { value: "all", label: "All" },
  { value: "pending", label: "In review" },
  { value: "published", label: "Published" },
  { value: "draft", label: "Draft" },
  { value: "rejected", label: "Changes requested" },
];

type QueueResult =
  | { ok: true; stores: QueueStore[] }
  | { ok: false; error: string };

/// setState-free so the mount effect can discard a result that arrived after
/// the page unmounted (React 19 flags setState called straight from an
/// effect body).
///
/// Retries once with a force-refreshed token on 401/403. `isSuperAdmin` in
/// the sidebar reads the mirrored `admins/{uid}.role` doc, but this route
/// trusts the `role` custom CLAIM — and a claim granted by
/// scripts/grant-superadmin.mjs is only baked into a token the next time one
/// is minted. Without the retry, a freshly-promoted superadmin sees the page
/// render and the list come back empty for up to an hour, with no clue why.
/// Same reasoning as createStore's force-refresh in store-context.
async function fetchQueue(user: User): Promise<QueueResult> {
  for (const forceRefresh of [false, true]) {
    const token = await user.getIdToken(forceRefresh);
    const res = await fetch("/api/admin/stores", {
      headers: { Authorization: `Bearer ${token}` },
    });
    if (res.ok) {
      return { ok: true, stores: (await res.json()).stores as QueueStore[] };
    }
    if (res.status !== 401 && res.status !== 403) {
      const body = await res.json().catch(() => ({}));
      return { ok: false, error: body.error ?? `Request failed (${res.status})` };
    }
  }
  return {
    ok: false,
    error:
      "Your session doesn't carry superadmin permissions yet. Sign out and back in, then try again.",
  };
}

const STATUS_TONE: Record<StoreStatus, string> = {
  draft: "bg-muted text-muted-foreground",
  pending: "bg-amber-100 text-amber-900",
  published: "bg-emerald-100 text-emerald-900",
  rejected: "bg-red-100 text-red-900",
};

/// The superadmin review queue — the other half of the publication
/// lifecycle. Store owners submit from Settings; this is where a submission
/// becomes live to shoppers, or comes back with a reason.
export default function StoresPage() {
  const { user } = useAuth();
  const { isSuperAdmin, loading: storeLoading } = useStore();
  const [stores, setStores] = useState<QueueStore[]>([]);
  const [filter, setFilter] = useState<StoreStatus | "all">("all");
  const [busyId, setBusyId] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    if (!user) return;
    let active = true;
    void (async () => {
      const next = await fetchQueue(user);
      if (!active) return;
      if (next.ok) setStores(next.stores);
      else setError(next.error);
      setLoading(false);
    })();
    return () => {
      active = false;
    };
  }, [user]);

  const load = useCallback(async () => {
    if (!user) return;
    const next = await fetchQueue(user);
    if (next.ok) setStores(next.stores);
    else setError(next.error);
  }, [user]);

  async function act(
    store: QueueStore,
    action: "approve" | "reject" | "unpublish",
  ) {
    if (!user) return;
    let reason = "";
    if (action === "reject") {
      // The API refuses a reasonless rejection — the owner has to know what
      // to fix — so ask before spending the round trip.
      reason = window.prompt(`What should ${store.name} fix?`)?.trim() ?? "";
      if (!reason) return;
    }
    setBusyId(store.id);
    try {
      const token = await user.getIdToken();
      const res = await fetch(`/api/stores/${store.id}/publish`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({ action, reason }),
      });
      const body = await res.json().catch(() => ({}));
      if (!res.ok) throw new Error(body.error ?? "Could not update this store");
      toast.success(
        action === "approve"
          ? `${store.name} is live`
          : action === "reject"
            ? `Sent back to ${store.name}`
            : `${store.name} unpublished`,
      );
      await load();
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Something went wrong");
    } finally {
      setBusyId("");
    }
  }

  const counts = useMemo(() => {
    const map: Record<string, number> = { all: stores.length };
    for (const s of stores) map[s.status] = (map[s.status] ?? 0) + 1;
    return map;
  }, [stores]);

  const visible = useMemo(
    () => (filter === "all" ? stores : stores.filter((s) => s.status === filter)),
    [stores, filter],
  );

  if (storeLoading) return null;
  if (!isSuperAdmin) {
    return (
      <p className="text-sm text-muted-foreground">
        This page is for CordeliaApps staff.
      </p>
    );
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-semibold">Stores</h1>
        <p className="text-sm text-muted-foreground">
          Every store on the platform. Approving one puts it in front of every
          shopper in CordeliaApps discovery.
        </p>
      </div>

      <div className="flex flex-wrap gap-2">
        {FILTERS.map((f) => (
          <Button
            key={f.value}
            size="sm"
            variant={filter === f.value ? "default" : "outline"}
            onClick={() => setFilter(f.value)}
          >
            {f.label}
            <span className="ml-1.5 opacity-70">{counts[f.value] ?? 0}</span>
          </Button>
        ))}
      </div>

      {loading ? (
        <p className="text-sm text-muted-foreground">Loading…</p>
      ) : error ? (
        <p className="rounded-md bg-red-50 p-3 text-sm text-red-900">{error}</p>
      ) : visible.length === 0 ? (
        <p className="text-sm text-muted-foreground">
          Nothing here right now.
        </p>
      ) : (
        <div className="space-y-3">
          {visible.map((store) => (
            <Card key={store.id}>
              <CardHeader>
                <CardTitle className="flex flex-wrap items-center gap-2 text-base">
                  {store.name || "(unnamed)"}
                  <span
                    className={`rounded-full px-2 py-0.5 text-xs font-medium ${STATUS_TONE[store.status]}`}
                  >
                    {STORE_STATUS_LABELS[store.status]}
                  </span>
                  {!store.previewReady && (
                    <span className="rounded-full bg-muted px-2 py-0.5 text-xs text-muted-foreground">
                      incomplete setup
                    </span>
                  )}
                </CardTitle>
                <CardDescription>
                  {store.description || "No description yet."}
                </CardDescription>
              </CardHeader>
              <CardContent className="flex flex-wrap items-center gap-2">
                {store.status === "pending" && (
                  <>
                    <Button
                      size="sm"
                      disabled={busyId === store.id}
                      onClick={() => act(store, "approve")}
                    >
                      Approve &amp; publish
                    </Button>
                    <Button
                      size="sm"
                      variant="outline"
                      disabled={busyId === store.id}
                      onClick={() => act(store, "reject")}
                    >
                      Request changes
                    </Button>
                  </>
                )}
                {store.status === "published" && (
                  <Button
                    size="sm"
                    variant="outline"
                    disabled={busyId === store.id}
                    onClick={() => act(store, "unpublish")}
                  >
                    Unpublish
                  </Button>
                )}
                {store.status === "rejected" && store.rejectionReason && (
                  <p className="text-sm text-muted-foreground">
                    Sent back: {store.rejectionReason}
                  </p>
                )}
                {store.status === "draft" && (
                  <p className="text-sm text-muted-foreground">
                    Waiting on its owner to submit.
                  </p>
                )}
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
