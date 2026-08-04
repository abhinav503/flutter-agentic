/**
 * The marketing site's two button recipes, as plain strings.
 *
 * They live apart from `ui.tsx` because both a server component (the section
 * links) and a client component (the auth-dialog triggers) need them — a
 * shared string module keeps the two shapes identical without dragging the
 * server components into a client bundle.
 */
const base =
  "inline-flex items-center justify-center gap-2 rounded-full text-sm font-semibold transition-colors";

export const primaryButtonClasses = `${base} bg-primary px-5 py-3 text-primary-foreground shadow-[var(--shadow-soft)] hover:bg-primary/90`;

export const ghostButtonClasses = `${base} border border-border-strong bg-surface px-5 py-3 text-foreground hover:bg-secondary`;

/** The nav's tighter variants — same shapes, sized for a 56px-tall bar. */
export const navPrimaryButtonClasses = `${base} bg-primary px-4 py-2 text-primary-foreground shadow-[var(--shadow-soft)] hover:bg-primary/90`;

export const navGhostButtonClasses = `${base} border border-border-strong bg-surface px-4 py-2 text-foreground hover:bg-secondary`;
