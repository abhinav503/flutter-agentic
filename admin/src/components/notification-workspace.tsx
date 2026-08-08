"use client";

import { useState, type FormEvent, type ReactNode } from "react";
import { Trash2 } from "lucide-react";
import {
  NOTIFICATION_IMAGE_MAX_BYTES,
  NOTIFICATION_KINDS,
  NOTIFICATION_KIND_LABELS,
  type NotificationKind,
  type StoreNotification,
} from "@/lib/types";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { ImageUploadField } from "@/components/image-upload-field";
import { toast } from "sonner";

/**
 * The compose-and-list surface both notification pages are. Extracted at the
 * moment there were two of them (store-scoped and platform-wide) — they differ
 * only in who they reach and which writer they call, and letting them drift
 * would mean a store owner and a superadmin composing the same message through
 * two different forms.
 *
 * No edit affordance, matching lib/notifications.ts: a sent notification is
 * history. Delete removes it from the feed for everyone who hasn't opened the
 * app yet; it can't unsend.
 */

// Long enough for a real message, short enough that a storefront row doesn't
// have to render an essay — cordelia's notification rows are two lines of
// title + message and clip beyond that.
const TITLE_MAX = 60;
const MESSAGE_MAX = 180;

// Enforced at upload so the sender finds out here rather than from a shopper.
// The send routes re-check the stored URL's size — this one is a courtesy to
// whoever is typing, not the gate (see lib/api/notification-input.ts).

export type NotificationDraft = {
  kind: NotificationKind;
  title: string;
  message: string;
  imageUrl: string;
};

export function NotificationWorkspace({
  heading,
  description,
  audienceNote,
  storagePrefix,
  items,
  loading,
  onSend,
  onDelete,
}: {
  heading: string;
  description: string;
  /** Rendered beside the send button — who is about to receive this. */
  audienceNote: ReactNode;
  /**
   * First path segment artwork uploads land under — the store id for a
   * store's own notifications, `PLATFORM_STORAGE_PREFIX` for CordeliaApps
   * ones. storage.rules gates the two differently.
   */
  storagePrefix: string;
  items: StoreNotification[];
  loading: boolean;
  /** Resolves with `pushed: false` when the record saved but FCM refused it. */
  onSend: (draft: NotificationDraft) => Promise<{ pushed: boolean } | void>;
  onDelete: (id: string) => Promise<void>;
}) {
  const [kind, setKind] = useState<NotificationKind>("discount");
  const [title, setTitle] = useState("");
  const [message, setMessage] = useState("");
  const [imageUrl, setImageUrl] = useState("");
  const [sending, setSending] = useState(false);
  const [pendingDelete, setPendingDelete] = useState<StoreNotification | null>(
    null,
  );

  const canSend =
    title.trim().length > 0 && message.trim().length > 0 && !sending;

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    if (!canSend) return;
    setSending(true);
    try {
      const result = await onSend({
        kind,
        title: title.trim(),
        message: message.trim(),
        imageUrl: imageUrl.trim(),
      });
      setTitle("");
      setMessage("");
      setImageUrl("");
      // Saying "sent" when FCM refused the push would be a lie the sender
      // only discovers from complaints. The record is real either way, so
      // this reports what actually happened rather than failing the send.
      if (result && result.pushed === false) {
        toast.warning("Saved, but the push could not be delivered");
      } else {
        toast.success("Notification sent");
      }
    } catch (error) {
      toast.error(
        error instanceof Error
          ? error.message
          : "Could not send the notification",
      );
    } finally {
      setSending(false);
    }
  }

  async function handleDelete() {
    if (!pendingDelete) return;
    const target = pendingDelete;
    setPendingDelete(null);
    try {
      await onDelete(target.id);
      toast.success("Notification deleted");
    } catch {
      toast.error("Could not delete the notification");
    }
  }

  return (
    <div className="space-y-8">
      <header>
        <h1 className="text-2xl font-extrabold tracking-tight text-ink">
          {heading}
        </h1>
        <p className="mt-1.5 text-sm text-muted-foreground">{description}</p>
      </header>

      <form
        onSubmit={handleSubmit}
        className="rounded-2xl border border-border bg-surface p-6"
      >
        <div className="grid gap-5 sm:grid-cols-[200px_1fr]">
          <div className="space-y-2">
            <Label htmlFor="notification-kind">Type</Label>
            <Select
              value={kind}
              onValueChange={(next) => setKind(next as NotificationKind)}
            >
              <SelectTrigger id="notification-kind">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                {NOTIFICATION_KINDS.map((k) => (
                  <SelectItem key={k} value={k}>
                    {NOTIFICATION_KIND_LABELS[k]}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
            {/* The kind is not decoration: each storefront template draws its
                own pack's glyph from it, so picking the wrong one ships the
                wrong icon to every shopper. */}
            <p className="text-xs text-muted-foreground">
              Picks the icon each storefront shows.
            </p>
          </div>

          <div className="space-y-5">
            <div className="space-y-2">
              <div className="flex items-baseline justify-between gap-3">
                <Label htmlFor="notification-title">Title</Label>
                <span className="text-xs text-muted-foreground">
                  {title.length}/{TITLE_MAX}
                </span>
              </div>
              <Input
                id="notification-title"
                value={title}
                maxLength={TITLE_MAX}
                placeholder="Best deal of the day"
                onChange={(e) => setTitle(e.target.value)}
              />
            </div>

            <div className="space-y-2">
              <div className="flex items-baseline justify-between gap-3">
                <Label htmlFor="notification-message">Message</Label>
                <span className="text-xs text-muted-foreground">
                  {message.length}/{MESSAGE_MAX}
                </span>
              </div>
              <Textarea
                id="notification-message"
                value={message}
                maxLength={MESSAGE_MAX}
                rows={3}
                placeholder="Buy 1 get 1 on selected products — hurry up."
                onChange={(e) => setMessage(e.target.value)}
              />
            </div>

            <ImageUploadField
              id="notification-image"
              label="Image (optional)"
              storeId={storagePrefix}
              kind="notifications"
              value={imageUrl}
              onChange={setImageUrl}
              maxBytes={NOTIFICATION_IMAGE_MAX_BYTES}
              hint="Under 300 KB, roughly 2:1. Shown under the message when the phone is locked or the app is in the background."
            />
          </div>
        </div>

        <div className="mt-6 flex flex-wrap items-center justify-between gap-3 border-t border-border pt-5">
          <p className="text-sm text-muted-foreground">{audienceNote}</p>
          <Button type="submit" disabled={!canSend}>
            {sending ? "Sending…" : "Send notification"}
          </Button>
        </div>
      </form>

      <section className="space-y-3">
        <h2 className="text-sm font-semibold uppercase tracking-[0.14em] text-muted-foreground">
          Sent
        </h2>

        {loading ? (
          <p className="text-sm text-muted-foreground">Loading…</p>
        ) : items.length === 0 ? (
          <div className="rounded-2xl border border-dashed border-border-strong p-10 text-center">
            <p className="text-sm text-muted-foreground">
              Nothing sent yet. The first notification you send appears here.
            </p>
          </div>
        ) : (
          <ul className="space-y-2.5">
            {items.map((item) => (
              <li
                key={item.id}
                className="flex items-start gap-4 rounded-2xl border border-border bg-surface p-4"
              >
                <div className="min-w-0 flex-1">
                  <div className="flex flex-wrap items-baseline gap-x-2.5 gap-y-1">
                    <p className="font-semibold text-ink">{item.title}</p>
                    <span className="text-xs text-muted-foreground">
                      {NOTIFICATION_KIND_LABELS[item.kind]}
                    </span>
                  </div>
                  <p className="mt-1 text-sm leading-6 text-muted-foreground">
                    {item.message}
                  </p>
                  <p className="mt-1.5 text-xs text-muted-foreground">
                    {/* 0 while the serverTimestamp round-trips — the snapshot
                        fires locally before the server stamps it. */}
                    {item.createdAtMs
                      ? new Date(item.createdAtMs).toLocaleString()
                      : "Just now"}
                  </p>
                </div>
                <Button
                  type="button"
                  variant="ghost"
                  size="icon"
                  aria-label={`Delete ${item.title}`}
                  onClick={() => setPendingDelete(item)}
                >
                  <Trash2 className="size-4" />
                </Button>
              </li>
            ))}
          </ul>
        )}
      </section>

      <AlertDialog
        open={pendingDelete !== null}
        onOpenChange={(open) => !open && setPendingDelete(null)}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete this notification?</AlertDialogTitle>
            <AlertDialogDescription>
              It disappears from the app for anyone who hasn&apos;t opened it
              yet. Shoppers who already read it aren&apos;t affected — this
              can&apos;t unsend.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction onClick={handleDelete}>Delete</AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
