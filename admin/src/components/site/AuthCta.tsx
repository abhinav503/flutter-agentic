"use client";

import type { ReactNode } from "react";
import { useAuthDialog, type AuthMode } from "@/components/auth-dialog";
import {
  ghostButtonClasses,
  navGhostButtonClasses,
  navPrimaryButtonClasses,
  primaryButtonClasses,
} from "./button-classes";

const recipes = {
  primary: primaryButtonClasses,
  ghost: ghostButtonClasses,
  navPrimary: navPrimaryButtonClasses,
  navGhost: navGhostButtonClasses,
} as const;

/**
 * A marketing CTA that opens the auth dialog instead of navigating. Same
 * shapes as `PrimaryLink`/`GhostLink` — a visitor can't tell which of the two
 * they're looking at, which is the point.
 */
export function AuthCta({
  mode,
  variant = "primary",
  className = "",
  onOpen,
  children,
}: {
  mode: AuthMode;
  variant?: keyof typeof recipes;
  className?: string;
  /** Fires alongside the dialog opening — the mobile nav closes itself here. */
  onOpen?: () => void;
  children: ReactNode;
}) {
  const openAuth = useAuthDialog();

  return (
    <button
      type="button"
      onClick={() => {
        onOpen?.();
        openAuth(mode);
      }}
      className={`${recipes[variant]} ${className}`}
    >
      {children}
    </button>
  );
}
