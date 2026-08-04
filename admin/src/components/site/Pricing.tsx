import { SectionShell, SectionHeading } from "./ui";
import { AuthCta } from "./AuthCta";

/**
 * The section keeps its `pricing` id and its place in the page: "what does
 * this cost?" is the first question a store owner has, and deleting the
 * section would leave it unanswered rather than answered with "nothing".
 *
 * Deliberately says CordeliaApps is free — not that selling is free. A store
 * still has its own Razorpay account, and Razorpay's gateway fees are between
 * the store and Razorpay; claiming otherwise here would be a promise this
 * product doesn't control.
 */
export function Pricing() {
  return (
    <SectionShell id="pricing" labelledBy="pricing-heading" className="bg-surface-2/60">
      <SectionHeading
        id="pricing-heading"
        eyebrow="Pricing"
        title="Free to use, with no commission on any order"
        align="center"
        lead="No subscription, no per-order cut, no setup fee."
      />

      <div className="mx-auto mt-12 max-w-xl">
        <div className="surface-panel rounded-3xl p-9 text-center">
          <h3 className="text-xl font-extrabold tracking-tight text-ink">
            CordeliaApps is free.
          </h3>
          <p className="mt-4 text-sm leading-7 text-muted-foreground">
            The shopper app and the admin console cost you nothing to use. There is no per-order
            cut and no settlement delay imposed by us — Razorpay settles shopper payments into
            your own account on your own schedule.
          </p>
          <ul className="mx-auto mt-7 max-w-sm space-y-2.5 text-left">
            {[
              "Free shopper app and admin console",
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
            <AuthCta mode="signup">Start free — create your store</AuthCta>
          </div>
        </div>
      </div>
    </SectionShell>
  );
}
