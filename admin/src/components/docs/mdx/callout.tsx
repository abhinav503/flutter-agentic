import type { ReactNode } from "react";
import {
  AlertTriangle,
  CheckCircle2,
  Info,
  Lightbulb,
  StickyNote,
  XCircle,
} from "lucide-react";

/**
 * The tinted panel that pulls one sentence out of the flow — a prerequisite, a
 * warning about live keys, a confirmation of what should have happened.
 *
 * Six intents, not seven: the template shipped `check` and `success` as
 * separate greens that no reader could tell apart. One green, one meaning.
 */
export type CalloutType = "info" | "warning" | "success" | "error" | "tip" | "note";

const icons: Record<CalloutType, typeof Info> = {
  info: Info,
  warning: AlertTriangle,
  success: CheckCircle2,
  error: XCircle,
  tip: Lightbulb,
  note: StickyNote,
};

export function Callout({
  type = "info",
  children,
}: {
  type?: CalloutType;
  children: ReactNode;
}) {
  const Icon = icons[type] ?? Info;

  return (
    <div
      // The three tokens are named per intent in globals.css, so the intent is
      // one string here instead of six branches.
      style={{
        background: `var(--callout-${type}-bg)`,
        borderColor: `var(--callout-${type}-border)`,
      }}
      className="not-prose flex gap-3 rounded-2xl border p-4 text-[0.9375rem] leading-7 text-foreground"
    >
      <Icon
        aria-hidden="true"
        className="mt-0.5 size-[1.125rem] shrink-0"
        style={{ color: `var(--callout-${type})` }}
      />
      {/* Margins collapse against the panel's padding otherwise, so the first
          and last lines sit tighter than the middle ones. */}
      <div className="min-w-0 flex-1 [&>*+*]:mt-2 [&>:first-child]:mt-0 [&>:last-child]:mb-0">
        {children}
      </div>
    </div>
  );
}
