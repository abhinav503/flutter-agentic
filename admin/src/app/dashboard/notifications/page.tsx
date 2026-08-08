"use client";

import { useEffect, useState } from "react";
import { useStore } from "@/lib/store-context";
import {
  watchStoreNotifications,
  sendStoreNotification,
  deleteStoreNotification,
} from "@/lib/notifications";
import type { StoreNotification } from "@/lib/types";
import {
  NotificationWorkspace,
  type NotificationDraft,
} from "@/components/notification-workspace";

/**
 * A store owner's own feed — a push to everyone currently in this store's
 * app, plus the record it leaves in their notification centre.
 */
export default function StoreNotificationsPage() {
  const { storeId, storeName } = useStore();
  const [items, setItems] = useState<StoreNotification[]>([]);
  const [loading, setLoading] = useState(true);

  // No setLoading(true) here: the dashboard layout remounts pages with
  // key={storeId}, so a store switch restarts this component with loading
  // already true rather than needing it reset mid-effect.
  useEffect(() => {
    if (!storeId) return;
    return watchStoreNotifications(storeId, (next) => {
      setItems(next);
      setLoading(false);
    });
  }, [storeId]);

  async function handleSend(draft: NotificationDraft) {
    if (!storeId) return;
    return sendStoreNotification(storeId, draft);
  }

  async function handleDelete(id: string) {
    if (!storeId) return;
    await deleteStoreNotification(storeId, id);
  }

  return (
    <NotificationWorkspace
      heading="Notifications"
      description="Send a message to shoppers using your store's app. It appears in their notifications list the next time they open it."
      audienceNote={
        <>
          Goes to shoppers of <strong>{storeName ?? "this store"}</strong>.
        </>
      }
      storagePrefix={storeId ?? ""}
      items={items}
      loading={loading}
      onSend={handleSend}
      onDelete={handleDelete}
    />
  );
}
