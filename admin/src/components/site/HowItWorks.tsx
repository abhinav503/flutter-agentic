import { SectionShell, SectionHeading } from "./ui";

const steps = [
  {
    n: "01",
    title: "Create your store",
    body: "Sign up, name your store, pick your currency and language, set your delivery area and connect your own Razorpay or Stripe account. Nothing to install, no developer needed.",
  },
  {
    n: "02",
    title: "Pick a template, add products",
    body: "Choose gravia, dailymart or grofast, then build your catalog: categories, brands, per-size pricing, promo banners and coupons.",
  },
  {
    n: "03",
    title: "Live for every CordeliaApps shopper",
    body: "Saving publishes your store inside the shopper app. A new storefront is a data change, not an app submission — so there is no review queue to wait on.",
  },
];

export function HowItWorks() {
  return (
    <SectionShell id="how-it-works" labelledBy="how-it-works-heading">
      <SectionHeading
        id="how-it-works-heading"
        eyebrow="How it works"
        title="How to launch a store app without app store approval"
        lead="Three steps between signing up and taking your first online order."
      />

      <ol className="mt-14 grid gap-6 md:grid-cols-3">
        {steps.map((s) => (
          <li key={s.n} className="surface-panel relative rounded-2xl p-6">
            <span
              aria-hidden="true"
              className="text-sm font-black tracking-[0.2em] text-primary"
            >
              {s.n}
            </span>
            <h3 className="mt-3 text-lg font-bold tracking-tight text-ink">{s.title}</h3>
            <p className="mt-2.5 text-sm leading-6 text-muted-foreground">{s.body}</p>
          </li>
        ))}
      </ol>
    </SectionShell>
  );
}
