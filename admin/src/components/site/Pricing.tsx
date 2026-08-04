import { SectionShell, SectionHeading, PrimaryLink } from "./ui";

export function Pricing() {
  return (
    <SectionShell id="pricing" labelledBy="pricing-heading" className="bg-surface-2/60">
      <SectionHeading
        id="pricing-heading"
        eyebrow="Pricing"
        title="Sell online without commission on any order"
        align="center"
        lead="Flat subscription. No commission, ever."
      />

      <div className="mx-auto mt-12 max-w-xl">
        <div className="surface-panel rounded-3xl p-9 text-center">
          <h3 className="text-xl font-extrabold tracking-tight text-ink">
            Flat subscription. No commission, ever.
          </h3>
          <p className="mt-4 text-sm leading-7 text-muted-foreground">
            You pay for hosting and the admin console. There is no per-order cut and no settlement
            delay imposed by us — Razorpay settles shopper payments into your own account on your
            own schedule.
          </p>
          <ul className="mx-auto mt-7 max-w-sm space-y-2.5 text-left">
            {[
              "No revenue share on any order",
              "No settlement delay imposed by CordeliaApps",
              "Your Razorpay account, your money",
            ].map((item) => (
              <li key={item} className="flex gap-2.5 text-sm leading-6 text-foreground">
                <span aria-hidden="true" className="mt-2 size-1.5 shrink-0 rounded-full bg-primary" />
                {item}
              </li>
            ))}
          </ul>
          <div className="mt-8 flex justify-center">
            <PrimaryLink href="mailto:hello@cordeliaapps.com">Talk to us about pricing</PrimaryLink>
          </div>
          <p className="mt-4 text-xs text-muted-foreground">
            Pricing is shared at onboarding, once we understand your catalog size and order volume.
          </p>
        </div>
      </div>
    </SectionShell>
  );
}
