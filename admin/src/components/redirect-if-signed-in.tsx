"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth-context";

/**
 * Sends an already-signed-in visitor straight to the dashboard.
 *
 * Deliberately client-side. Firebase keeps the session in IndexedDB, so
 * "is this person signed in?" simply cannot be answered while rendering on
 * the server — and that is what keeps the page crawlable: a bot has no
 * session, `user` stays null, and it receives the same statically
 * prerendered marketing HTML as any signed-out visitor. Nothing here changes
 * what is served; it only changes where a returning admin ends up.
 *
 * Renders nothing until auth has resolved, so the landing page is never held
 * back waiting on it.
 */
export function RedirectIfSignedIn() {
  const router = useRouter();
  const { user, loading } = useAuth();

  useEffect(() => {
    if (loading || !user) return;
    // replace, not push: the marketing page shouldn't sit in history behind
    // the dashboard, or Back would bounce straight into this redirect again.
    router.replace("/dashboard");
  }, [loading, user, router]);

  if (loading || !user) return null;

  // The redirect is already in flight. Cover the marketing page rather than
  // letting a returning admin watch the hero paint for a moment first —
  // only ever seen by someone who is signed in.
  return (
    <div className="fixed inset-0 z-100 grid place-items-center bg-background text-sm text-muted-foreground">
      Opening your dashboard…
    </div>
  );
}
