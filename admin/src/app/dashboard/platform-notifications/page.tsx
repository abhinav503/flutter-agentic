"use client";

import { useEffect, useState } from "react";
import { useStore } from "@/lib/store-context";
import {
  watchPlatformNotifications,
  sendPlatformNotification,
  deletePlatformNotification,
} from "@/lib/notifications";
import { PLATFORM_STORAGE_PREFIX } from "@/lib/storage";
import type { StoreNotification } from "@/lib/types";
import { NotificationWorkspace } from "@/components/notification-workspace";

/**
 * The CordeliaApps-wide feed: one message that appears in **every** store's
 * app, labelled as coming from us rather than from the store.
 *
 * `isSuperAdmin` here only decides what renders — firestore.rules is what
 * actually stops a store owner writing to the top-level `notifications`
 * collection, and it checks the `role: 'superAdmin'` custom claim that only
 * scripts/grant-superadmin.mjs can set.
 */
export default function PlatformNotificationsPage() {
  const { isSuperAdmin, loading: storeLoading } = useStore();
  const [items, setItems] = useState<StoreNotification[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!isSuperAdmin) return;
    return watchPlatformNotifications((next) => {
      setItems(next);
      setLoading(false);
    });
  }, [isSuperAdmin]);

  if (storeLoading) {
    return <p className="text-sm text-muted-foreground">Loading…</p>;
  }

  if (!isSuperAdmin) {
    return (
      <div className="rounded-2xl border border-dashed border-border-strong p-10 text-center">
        <h1 className="font-semibold text-ink">Not available</h1>
        <p className="mt-1.5 text-sm text-muted-foreground">
          Platform notifications are sent by CordeliaApps staff. Your store
          notifications are under Notifications.
        </p>
      </div>
    );
  }

  return (
    <NotificationWorkspace
      heading="Admin notifications"
      description="Send a message from CordeliaApps to shoppers in every store. Use it for platform news, outages and policy changes — not for a single store's offers."
      audienceNote={
        <>
          Goes to <strong>shoppers in every store</strong>, labelled as from
          CordeliaApps.
        </>
      }
      storagePrefix={PLATFORM_STORAGE_PREFIX}
      items={items}
      loading={loading}
      onSend={sendPlatformNotification}
      onDelete={deletePlatformNotification}
    />
  );
}
