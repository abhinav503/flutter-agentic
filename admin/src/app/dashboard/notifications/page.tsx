"use client";

import { useEffect, useState } from "react";
import { useAuth } from "@/lib/auth-context";
import { useStore } from "@/lib/store-context";
import {
  watchStoreNotifications,
  addStoreNotification,
  deleteStoreNotification,
} from "@/lib/notifications";
import type { StoreNotification } from "@/lib/types";
import {
  NotificationWorkspace,
  type NotificationDraft,
} from "@/components/notification-workspace";

/**
 * A store owner's own feed — reaches only shoppers in this store, and only
 * inside the app. There is no push here: this writes the notification centre
 * the storefront reads on open.
 */
export default function StoreNotificationsPage() {
  const { user } = useAuth();
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
    if (!storeId || !user) return;
    await addStoreNotification(storeId, draft, user.uid);
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
      items={items}
      loading={loading}
      onSend={handleSend}
      onDelete={handleDelete}
    />
  );
}
