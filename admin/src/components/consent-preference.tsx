"use client";

import { useSyncExternalStore } from "react";
import { Button } from "@/components/ui/button";
import {
  CONSENT_EVENT,
  readConsent,
  writeConsent,
  type ConsentChoice,
} from "@/lib/telemetry";

function subscribe(onChange: () => void) {
  window.addEventListener(CONSENT_EVENT, onChange);
  window.addEventListener("storage", onChange);
  return () => {
    window.removeEventListener(CONSENT_EVENT, onChange);
    window.removeEventListener("storage", onChange);
  };
}

const serverSnapshot = () => null;

/**
 * Lets a visitor see and change their analytics choice.
 *
 * Required, not a nicety: withdrawing consent has to be as easy as giving it,
 * and the banner is deliberately shown once and never again — so without this
 * there would be no way back. Declining here takes effect immediately for
 * anything sent afterwards; it cannot recall events already delivered to
 * Google, which is why the copy says so rather than implying a full erase.
 */
export function ConsentPreference() {
  const consent = useSyncExternalStore<ConsentChoice | null>(
    subscribe,
    readConsent,
    serverSnapshot,
  );

  const label =
    consent === "granted"
      ? "You have allowed analytics on this browser."
      : consent === "denied"
        ? "You have declined analytics on this browser."
        : "You have not been asked yet on this browser.";

  return (
    <div className="mt-4 rounded-xl border border-border bg-surface-2/60 p-5">
      <p className="text-sm font-medium text-foreground">{label}</p>
      <p className="mt-1 text-sm text-muted-foreground">
        The choice is stored in this browser only, so it does not follow you to
        another device.
      </p>
      <div className="mt-4 flex flex-wrap gap-2">
        <Button
          size="sm"
          variant={consent === "granted" ? "secondary" : "default"}
          className="rounded-full"
          onClick={() => writeConsent("granted")}
          disabled={consent === "granted"}
        >
          Allow analytics
        </Button>
        <Button
          size="sm"
          variant={consent === "denied" ? "secondary" : "outline"}
          className="rounded-full"
          onClick={() => writeConsent("denied")}
          disabled={consent === "denied"}
        >
          Decline analytics
        </Button>
      </div>
    </div>
  );
}
