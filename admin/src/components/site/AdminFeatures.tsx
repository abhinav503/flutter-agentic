import { SectionShell, SectionHeading } from "./ui";

const groups = [
  {
    title: "Your storefront",
    items: [
      "Store setup and template switching",
      "Category and product catalog",
      "Brands",
      "Per-size pricing",
      "Promo banners",
    ],
  },
  {
    title: "Selling and pricing",
    items: [
      "Coupons scoped to a store, a category or a product",
      "Percentage or flat discounts, with caps",
      "Validity windows and usage limits",
      "Connect your own Razorpay account",
    ],
  },
  {
    title: "Running the day",
    items: [
      "Live order dashboard with delivery OTP",
      "Status control on every order",
      "Cancel with restock, and refunds",
      "Review moderation",
    ],
  },
];

export function AdminFeatures() {
  return (
    <SectionShell id="admin" labelledBy="admin-features-heading" className="bg-surface-2/60">
      <SectionHeading
        id="admin-features-heading"
        eyebrow="For you"
        title="What you get in the admin console"
        lead="The console is a separate surface from the shopper app. It is where the store, the catalog and the day's orders are run."
      />

      <div className="mt-14 grid gap-6 md:grid-cols-3">
        {groups.map((g) => (
          <div key={g.title} className="surface-panel rounded-2xl p-6">
            <h3 className="text-base font-bold tracking-tight text-ink">{g.title}</h3>
            <ul className="mt-4 space-y-3">
              {g.items.map((item) => (
                <li key={item} className="flex gap-2.5 text-sm leading-6 text-muted-foreground">
                  <span aria-hidden="true" className="mt-2 size-1.5 shrink-0 rounded-full bg-primary" />
                  {item}
                </li>
              ))}
            </ul>
          </div>
        ))}
      </div>

      <div
        aria-hidden="true"
        className="mt-10 overflow-hidden rounded-2xl border border-dashed border-border-strong bg-surface p-8 text-center"
        style={{ aspectRatio: "16 / 6" }}
      >
        <p className="text-sm font-semibold text-muted-foreground">
          Placeholder — admin console screenshot goes here (16:6).
        </p>
      </div>
    </SectionShell>
  );
}
