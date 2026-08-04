/**
 * Small presentational primitives shared across the marketing sections.
 * Server-safe: no hooks, no browser APIs.
 */
import Link from "next/link";
import type { ReactNode } from "react";

/// Internal app routes navigate through next/link (client-side, prefetched);
/// same-page anchors and mailto: stay plain <a>, where a router would only
/// get in the way.
function isInternalRoute(href: string) {
  return href.startsWith("/");
}

export function Eyebrow({ children }: { children: ReactNode }) {
  return (
    <span className="inline-flex items-center gap-2 rounded-full border border-border bg-surface px-3 py-1 text-[0.7rem] font-semibold uppercase tracking-[0.16em] text-muted-foreground">
      {children}
    </span>
  );
}

export function SectionShell({
  id,
  labelledBy,
  children,
  className = "",
}: {
  id: string;
  labelledBy: string;
  children: ReactNode;
  className?: string;
}) {
  return (
    <section
      id={id}
      aria-labelledby={labelledBy}
      className={`scroll-mt-24 border-t border-border py-20 sm:py-28 ${className}`}
    >
      <div className="mx-auto w-full max-w-6xl px-5 sm:px-8">{children}</div>
    </section>
  );
}

export function SectionHeading({
  id,
  title,
  lead,
  eyebrow,
  align = "left",
}: {
  id: string;
  title: string;
  lead?: string;
  eyebrow?: string;
  align?: "left" | "center";
}) {
  return (
    <header className={align === "center" ? "mx-auto max-w-2xl text-center" : "max-w-2xl"}>
      {eyebrow ? <Eyebrow>{eyebrow}</Eyebrow> : null}
      <h2
        id={id}
        className="mt-5 text-balance text-3xl font-extrabold tracking-tight text-ink sm:text-4xl"
      >
        {title}
      </h2>
      {lead ? <p className="mt-4 text-pretty text-base leading-7 text-muted-foreground">{lead}</p> : null}
    </header>
  );
}

const buttonBase =
  "inline-flex items-center justify-center gap-2 rounded-full text-sm font-semibold transition-colors";

export function PrimaryLink({
  href,
  children,
  className = "",
}: {
  href: string;
  children: ReactNode;
  className?: string;
}) {
  const classes = `${buttonBase} bg-primary px-5 py-3 text-primary-foreground shadow-[var(--shadow-soft)] hover:bg-primary/90 ${className}`;

  return isInternalRoute(href) ? (
    <Link href={href} className={classes}>
      {children}
    </Link>
  ) : (
    <a href={href} className={classes}>
      {children}
    </a>
  );
}

export function GhostLink({
  href,
  children,
  className = "",
}: {
  href: string;
  children: ReactNode;
  className?: string;
}) {
  const classes = `${buttonBase} border border-border-strong bg-surface px-5 py-3 text-foreground hover:bg-secondary ${className}`;

  return isInternalRoute(href) ? (
    <Link href={href} className={classes}>
      {children}
    </Link>
  ) : (
    <a href={href} className={classes}>
      {children}
    </a>
  );
}
