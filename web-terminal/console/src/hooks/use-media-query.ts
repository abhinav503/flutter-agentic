"use client";

import { useCallback, useSyncExternalStore } from "react";

// External-store subscription is the idiomatic way to read a media query in
// React 19 — no setState-in-effect, and it stays in sync on breakpoint change.
export function useMediaQuery(query: string): boolean {
  const subscribe = useCallback(
    (onChange: () => void) => {
      const mql = window.matchMedia(query);
      mql.addEventListener("change", onChange);
      return () => mql.removeEventListener("change", onChange);
    },
    [query],
  );

  return useSyncExternalStore(
    subscribe,
    () => window.matchMedia(query).matches,
    () => false, // SSR: assume the narrow layout until hydrated
  );
}
