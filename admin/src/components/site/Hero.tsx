import { HeroStorefrontMockup } from "./PhoneMockup";
import { GhostLink } from "./ui";
import { AuthCta } from "./AuthCta";

export function Hero() {
  return (
    <section aria-labelledby="hero-heading" className="hero-wash relative overflow-hidden">
      <div className="mx-auto grid w-full max-w-6xl gap-14 px-5 pb-20 pt-16 sm:px-8 sm:pb-28 sm:pt-24 lg:grid-cols-[1.05fr_0.95fr] lg:items-center">
        <div>
          <span className="inline-flex items-center gap-2 rounded-full border border-border bg-surface px-3 py-1.5 text-xs font-semibold text-muted-foreground">
            <span aria-hidden="true" className="size-1.5 rounded-full bg-primary" />
            Currently onboarding early stores.
          </span>

          <h1
            id="hero-heading"
            className="mt-6 text-balance text-4xl font-extrabold leading-[1.06] tracking-tight text-ink sm:text-6xl"
          >
            Your store. Your own shopping app.{" "}
            <span className="text-brand-gradient">Zero commission.</span>
          </h1>

          <p className="mt-6 max-w-xl text-pretty text-lg leading-8 text-muted-foreground">
            CordeliaApps gives a grocery or retail store owner in India a branded shopping app —
            catalog, cart, coupons and Razorpay checkout — without building or submitting an app,
            and without giving up a cut of any sale.
          </p>

          <p className="mt-4 max-w-xl text-pretty text-base leading-7 text-muted-foreground">
            Payments settle straight into your own Razorpay account. CordeliaApps is free to use —
            no subscription, no setup fee, and never a share of your revenue.
          </p>

          <div className="mt-9 flex flex-wrap gap-3">
            <AuthCta mode="signup">Start free — create your store</AuthCta>
            <GhostLink href="#templates">See the three templates</GhostLink>
          </div>

          <dl className="mt-12 grid max-w-lg grid-cols-3 gap-6 border-t border-border pt-8">
            {[
              // Was "Commission 0%". The stronger claim now is the whole
              // price, and the headline beside it still carries the
              // commission point.
              ["Price", "₹0"],
              ["Time to launch", "Minutes"],
              ["App reviews", "None"],
            ].map(([label, value]) => (
              <div key={label}>
                <dt className="text-xs font-semibold uppercase tracking-[0.12em] text-muted-foreground">
                  {label}
                </dt>
                <dd className="mt-1.5 text-2xl font-extrabold tracking-tight text-ink">{value}</dd>
              </div>
            ))}
          </dl>
        </div>

        <div className="relative">
          <div
            aria-hidden="true"
            className="rule-grid absolute inset-x-0 top-10 -z-10 h-[70%] opacity-60 [mask-image:radial-gradient(60%_60%_at_50%_40%,#000,transparent)]"
          />
          <HeroStorefrontMockup />
        </div>
      </div>
    </section>
  );
}
