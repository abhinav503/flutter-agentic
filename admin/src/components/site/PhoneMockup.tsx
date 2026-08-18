/**
 * Pure CSS/SVG device mockups. Entirely decorative — every instance is
 * aria-hidden and the frames carry explicit aspect ratios so nothing
 * shifts while the page paints.
 * Server-safe: no hooks, no browser APIs.
 */
import type { ReactNode } from "react";

export function PhoneFrame({
  children,
  className = "",
  tone = "default",
  decorative = true,
  flush = false,
}: {
  children: ReactNode;
  className?: string;
  tone?: "default" | "dark";
  /**
   * False when the frame holds real content (a storefront recording) rather
   * than a drawn mockup — an aria-hidden wrapper would hide that from
   * assistive tech. Defaults to true, which is what every CSS mockup wants.
   */
  decorative?: boolean;
  /**
   * True to let the child fill the screen edge to edge, skipping the status
   * bar inset the drawn mockups lay their content out under.
   */
  flush?: boolean;
}) {
  return (
    <div
      aria-hidden={decorative ? "true" : undefined}
      className={`relative mx-auto w-full max-w-[19rem] rounded-[2.6rem] border border-border-strong bg-surface-2 p-2.5 shadow-[var(--shadow-phone)] ${className}`}
      style={{ aspectRatio: "9 / 18.6" }}
    >
      <div
        className={`relative h-full w-full overflow-hidden rounded-[2rem] ${
          tone === "dark" ? "bg-ink" : "bg-surface"
        }`}
      >
        <div className="absolute left-1/2 top-2 z-20 h-5 w-24 -translate-x-1/2 rounded-full bg-ink/85" />
        {flush ? (
          children
        ) : (
          <div className="flex h-full w-full flex-col pt-8">{children}</div>
        )}
      </div>
    </div>
  );
}

function StatusRow({ label }: { label: string }) {
  return (
    <div className="flex items-center justify-between px-4 pb-1 text-[0.55rem] font-semibold text-muted-foreground">
      <span>9:41</span>
      <span>{label}</span>
    </div>
  );
}

function Bar({ w, h = 6, className = "" }: { w: string; h?: number; className?: string }) {
  return <span className={`block rounded-full ${className}`} style={{ width: w, height: h }} />;
}

/** Hero: a grocery storefront inside the shopper app. */
export function HeroStorefrontMockup() {
  return (
    <PhoneFrame>
      <StatusRow label="CordeliaApps" />
      <div className="flex items-center gap-2 px-4">
        <div className="grid size-8 place-items-center rounded-xl bg-primary text-[0.6rem] font-black text-primary-foreground">
          SB
        </div>
        <div className="flex-1">
          <Bar w="72%" h={7} className="bg-foreground/80" />
          <Bar w="46%" h={5} className="mt-1.5 bg-muted-foreground/40" />
        </div>
        <div className="size-7 rounded-full bg-secondary" />
      </div>

      <div className="mx-4 mt-3 flex h-8 items-center gap-2 rounded-xl bg-secondary px-3">
        <span className="size-3 rounded-full border-2 border-muted-foreground/50" />
        <Bar w="58%" h={5} className="bg-muted-foreground/35" />
      </div>

      <div className="mx-4 mt-3 h-[4.6rem] rounded-2xl bg-[image:var(--gradient-brand)] p-3">
        <Bar w="55%" h={7} className="bg-primary-foreground/90" />
        <Bar w="38%" h={5} className="mt-2 bg-primary-foreground/60" />
        <span className="mt-3 inline-block rounded-full bg-primary-foreground/90 px-2 py-1 text-[0.5rem] font-bold text-primary">
          ₹40 off
        </span>
      </div>

      <div className="mt-3 flex gap-2 overflow-hidden px-4">
        {["Fruit", "Dairy", "Atta", "Snacks"].map((c) => (
          <span
            key={c}
            className="shrink-0 rounded-full bg-accent px-2.5 py-1 text-[0.55rem] font-semibold text-accent-foreground"
          >
            {c}
          </span>
        ))}
      </div>

      <div className="mt-3 grid flex-1 grid-cols-2 gap-2 px-4 pb-3">
        {[
          ["₹62", "1 kg"],
          ["₹149", "500 g"],
          ["₹28", "200 g"],
          ["₹310", "5 kg"],
        ].map(([price, size], i) => (
          <div key={price} className="rounded-2xl border border-border bg-surface p-2">
            <div
              className={`h-11 rounded-xl ${
                i % 2 === 0 ? "bg-primary-soft" : "bg-secondary"
              }`}
            />
            <Bar w="80%" h={5} className="mt-2 bg-foreground/70" />
            <div className="mt-1.5 flex items-center justify-between">
              <span className="text-[0.55rem] font-bold text-foreground">{price}</span>
              <span className="text-[0.5rem] text-muted-foreground">{size}</span>
            </div>
          </div>
        ))}
      </div>

      <div className="mt-auto flex items-center justify-around border-t border-border bg-surface-2 px-4 py-2.5">
        {[0, 1, 2, 3].map((i) => (
          <span
            key={i}
            className={`size-4 rounded-md ${i === 0 ? "bg-primary" : "bg-muted-foreground/25"}`}
          />
        ))}
      </div>
    </PhoneFrame>
  );
}

/** gravia — sheet-and-header layout, soft depth. */
export function GraviaMockup() {
  return (
    <PhoneFrame className="max-w-[15rem]">
      <div className="mx-3 rounded-2xl bg-gravia p-3 shadow-[var(--shadow-soft)]">
        <Bar w="60%" h={6} className="bg-primary-foreground/90" />
        <Bar w="40%" h={4} className="mt-1.5 bg-primary-foreground/55" />
        <div className="mt-3 h-7 rounded-xl bg-primary-foreground/90" />
      </div>
      <div className="-mt-3 flex-1 rounded-t-[1.6rem] bg-gravia-soft px-3 pt-5">
        <Bar w="45%" h={5} className="bg-gravia/70" />
        <div className="mt-3 space-y-2">
          {[0, 1, 2].map((i) => (
            <div key={i} className="flex items-center gap-2 rounded-2xl bg-surface p-2 shadow-[var(--shadow-soft)]">
              <span className="size-9 rounded-xl bg-gravia/20" />
              <span className="flex-1">
                <Bar w="70%" h={5} className="bg-foreground/65" />
                <Bar w="35%" h={4} className="mt-1 bg-muted-foreground/40" />
              </span>
              <span className="rounded-lg bg-gravia px-1.5 py-1 text-[0.45rem] font-bold text-primary-foreground">
                ADD
              </span>
            </div>
          ))}
        </div>
      </div>
    </PhoneFrame>
  );
}

/** dailymart — stacked nav, carded rows.
 *
 * Priced in euros while the hero storefront above is in rupees. The mockups
 * are the page's only concrete prices, and a page that says a store picks its
 * own currency shouldn't illustrate that with one currency everywhere. */
export function DailymartMockup() {
  return (
    <PhoneFrame className="max-w-[15rem]">
      <div className="px-3">
        <Bar w="50%" h={6} className="bg-dailymart" />
        <div className="mt-2 flex gap-1.5">
          {[0, 1, 2].map((i) => (
            <span
              key={i}
              className={`h-5 flex-1 rounded-md ${i === 0 ? "bg-dailymart" : "bg-dailymart-soft"}`}
            />
          ))}
        </div>
        <div className="mt-2 h-6 rounded-md bg-secondary" />
      </div>
      <div className="mt-3 flex-1 space-y-2 px-3 pb-3">
        {[0, 1, 2, 3].map((i) => (
          <div key={i} className="flex items-center gap-2 rounded-lg border border-border bg-surface p-2">
            <span className="size-8 rounded-md bg-dailymart-soft" />
            <span className="flex-1">
              <Bar w="75%" h={5} className="bg-foreground/65" />
              <Bar w="30%" h={4} className="mt-1 bg-dailymart/60" />
            </span>
            <span className="text-[0.5rem] font-bold text-foreground">{2 + i} €</span>
          </div>
        ))}
      </div>
    </PhoneFrame>
  );
}

/** grofast — playful gradient, domed sheets, staggered grid. */
export function GrofastMockup() {
  return (
    <PhoneFrame className="max-w-[15rem]">
      <div
        className="h-24 px-3 pt-1"
        style={{
          backgroundImage:
            "linear-gradient(135deg, var(--grofast), color-mix(in oklab, var(--grofast) 55%, var(--primary)))",
        }}
      >
        <Bar w="55%" h={6} className="bg-primary-foreground/90" />
        <Bar w="35%" h={4} className="mt-1.5 bg-primary-foreground/60" />
        <div className="mt-3 h-6 rounded-full bg-primary-foreground/85" />
      </div>
      <div className="-mt-5 flex-1 rounded-t-[2.2rem] bg-grofast-soft px-3 pt-4">
        <div className="grid grid-cols-2 gap-2">
          {[0, 1, 2, 3].map((i) => (
            <div
              key={i}
              className={`rounded-2xl bg-surface p-2 shadow-[var(--shadow-soft)] ${i % 2 ? "mt-3" : ""}`}
            >
              <span className="block h-9 rounded-xl bg-grofast/25" />
              <Bar w="80%" h={4} className="mt-1.5 bg-foreground/65" />
              <Bar w="40%" h={4} className="mt-1 bg-grofast/70" />
            </div>
          ))}
        </div>
      </div>
    </PhoneFrame>
  );
}
