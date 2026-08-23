"use client";

import { useEffect, useState } from "react";
import { Trash2 } from "lucide-react";
import { toast } from "sonner";
import { useAuth } from "@/lib/auth-context";
import type { CatalogEntity } from "@/lib/catalog-api";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";

type TrashRow = {
  id: string;
  entity: CatalogEntity;
  record_id: string;
  name: string;
  deleted_at: string;
  purge_at: string;
};

// "Recently deleted" for one catalog page: what was deleted in the last 30
// days (of that entity), each with Restore. Deletes are moves into the
// store's trash (see lib/api/v1/catalog.ts), so this is the undo a
// confused agent turn or a slip needs.
export function RecentlyDeletedButton({
  storeId,
  entity,
  entityPlural,
}: {
  storeId: string;
  entity: CatalogEntity;
  entityPlural: string;
}) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button variant="ghost" size="sm" onClick={() => setOpen(true)}>
        <Trash2 className="size-4" />
        Recently deleted
      </Button>
      {open && (
        <RecentlyDeletedDialog
          storeId={storeId}
          entity={entity}
          entityPlural={entityPlural}
          onClose={() => setOpen(false)}
        />
      )}
    </>
  );
}

function RecentlyDeletedDialog({
  storeId,
  entity,
  entityPlural,
  onClose,
}: {
  storeId: string;
  entity: CatalogEntity;
  entityPlural: string;
  onClose: () => void;
}) {
  const { user } = useAuth();
  const [rows, setRows] = useState<TrashRow[] | null>(null);
  const [busy, setBusy] = useState<string | null>(null);

  async function load() {
    if (!user) return null;
    const token = await user.getIdToken();
    const res = await fetch(`/api/v1/stores/${storeId}/trash`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    if (!res.ok) return [];
    const body = (await res.json()) as { items: TrashRow[] };
    return body.items.filter((r) => r.entity === entity);
  }

  useEffect(() => {
    let active = true;
    load().then((r) => {
      if (active && r) setRows(r);
    });
    return () => {
      active = false;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [user, storeId, entity]);

  async function restore(row: TrashRow) {
    if (!user) return;
    setBusy(row.id);
    try {
      const token = await user.getIdToken();
      const res = await fetch(`/api/v1/stores/${storeId}/trash/${encodeURIComponent(row.id)}/restore`, {
        method: "POST",
        headers: { Authorization: `Bearer ${token}` },
      });
      const payload = await res.json().catch(() => ({}));
      if (!res.ok) throw new Error(payload.error ?? "Could not restore");
      toast.success(`Restored "${row.name}"`);
      const r = await load();
      if (r) setRows(r);
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not restore");
    } finally {
      setBusy(null);
    }
  }

  return (
    <Dialog open onOpenChange={(o) => !o && onClose()}>
      <DialogContent className="sm:max-w-lg">
        <DialogHeader>
          <DialogTitle>Recently deleted {entityPlural}</DialogTitle>
          <DialogDescription>
            Deleted {entityPlural} stay here for 30 days — from the console, an
            assistant or the API — and can be put back as they were.
          </DialogDescription>
        </DialogHeader>
        {rows === null ? (
          <p className="text-sm text-muted-foreground">Loading…</p>
        ) : rows.length === 0 ? (
          <p className="text-sm text-muted-foreground">Nothing deleted in the last 30 days.</p>
        ) : (
          <ul className="max-h-96 divide-y divide-border overflow-y-auto rounded-md border border-border">
            {rows.map((row) => (
              <li key={row.id} className="flex items-center gap-3 p-3">
                <div className="min-w-0 flex-1">
                  <p className="truncate font-medium">{row.name || row.record_id}</p>
                  <p className="text-xs text-muted-foreground">
                    Deleted {row.deleted_at ? new Date(row.deleted_at).toLocaleString() : "—"}
                    {row.purge_at && ` · gone for good ${new Date(row.purge_at).toLocaleDateString()}`}
                  </p>
                </div>
                <Button size="sm" variant="outline" disabled={busy === row.id} onClick={() => restore(row)}>
                  {busy === row.id ? "Restoring…" : "Restore"}
                </Button>
              </li>
            ))}
          </ul>
        )}
      </DialogContent>
    </Dialog>
  );
}
