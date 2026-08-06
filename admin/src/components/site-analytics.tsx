"use client";

import { useCallback, useEffect, useSyncExternalStore } from "react";
import { usePathname } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import {
  CONSENT_EVENT,
  readConsent,
  trackPageView,
  writeConsent,
  type ConsentChoice,
} from "@/lib/telemetry";

/**
 * Consent gate plus page-view tracking for the marketing site.
 *
 * Mounted once in the root layout. Two things worth knowing about its scope:
 *
 * - **`/dashboard` is not tracked.** It is the signed-in console, not
 *   marketing; mixing owners working in the product with visitors reading the
 *   landing page would make every marketing number wrong. Product analytics is
 *   a separate decision, and would belong in its own property.
 * - **The banner is shown to everyone**, not just EU/UK visitors. Geo-gating
 *   would need the request country, which a client component doesn't have, and
 *   "ask everybody" is both simpler and the more privacy-respecting default.
 */
/** The stored choice is external state, so it is read rather than mirrored. */
function subscribeToConsent(onChange: () => void) {
  // Same-tab answers arrive on CONSENT_EVENT; another tab's arrive on storage.
  window.addEventListener(CONSENT_EVENT, onChange);
  window.addEventListener("storage", onChange);
  return () => {
    window.removeEventListener(CONSENT_EVENT, onChange);
    window.removeEventListener("storage", onChange);
  };
}

// The server cannot know the stored choice. Returning null for the hydration
// render and letting React re-render with the real value is what
// useSyncExternalStore is for — mirroring localStorage into state inside an
// effect would both flash and trip the repo's set-state-in-effect rule.
const serverConsent = () => null;

export function SiteAnalytics() {
  const pathname = usePathname();
  const consent = useSyncExternalStore<ConsentChoice | null>(
    subscribeToConsent,
    readConsent,
    serverConsent,
  );

  const trackable = !pathname.startsWith("/dashboard");

  useEffect(() => {
    if (consent !== "granted" || !trackable) return;
    trackPageView(pathname);
  }, [consent, pathname, trackable]);

  // writeConsent dispatches CONSENT_EVENT, so the store above re-reads and
  // this component updates — no local copy of the choice to keep in step.
  const choose = useCallback(
    (choice: ConsentChoice) => writeConsent(choice),
    [],
  );

  // Asked once, on marketing pages only — a signed-in owner being interrupted
  // mid-task by a cookie banner for a page we don't even measure is noise.
  if (consent !== null || !trackable) return null;

  return (
    <div
      role="dialog"
      aria-modal="false"
      aria-label="Analytics consent"
      className="fixed inset-x-0 bottom-0 z-100 border-t border-border bg-background/95 backdrop-blur-md"
    >
      <div className="mx-auto flex w-full max-w-6xl flex-col gap-3 px-5 py-4 sm:flex-row sm:items-center sm:justify-between sm:px-8">
        <p className="text-sm text-muted-foreground">
          We&apos;d like to measure how people find and use this site, using
          Google Analytics. Nothing is loaded until you choose, and we never use
          it for advertising.{" "}
          {/* A consent banner has to link to the explanation — without it the
              choice isn't an informed one, which is most of what the law asks. */}
          <Link
            href="/privacy"
            className="font-semibold text-primary underline underline-offset-4 hover:text-primary/80"
          >
            Privacy policy
          </Link>
        </p>
        <div className="flex shrink-0 gap-2">
          <Button
            variant="outline"
            size="sm"
            onClick={() => choose("denied")}
            className="rounded-full"
          >
            Decline
          </Button>
          <Button
            size="sm"
            onClick={() => choose("granted")}
            className="rounded-full"
          >
            Accept
          </Button>
        </div>
      </div>
    </div>
  );
}
