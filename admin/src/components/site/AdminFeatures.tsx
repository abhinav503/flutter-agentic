import Image from "next/image";
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
      "Generate a realistic sample catalog in one click",
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
      "Sort, filter and search every catalog list",
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

      {/* The real console, not a mockup. Rendered at the screenshot's own
          1916×987 ratio rather than the 16:6 the placeholder reserved —
          16:6 would have cropped about a quarter of the height off, taking
          the charts row with it. */}
      <figure className="surface-panel mt-10 overflow-hidden rounded-2xl p-2">
        <Image
          src="/images/admin-console.png"
          alt="The CordeliaApps admin console: revenue, orders and customer totals above charts of orders and reviews per day, order status, and best-selling products."
          width={1916}
          height={987}
          // Below the fold, so it stays lazy (Next's default); `sizes` keeps
          // the srcset honest at the section's 1152px max width.
          sizes="(min-width: 1152px) 1104px, 100vw"
          className="h-auto w-full rounded-xl"
        />
      </figure>
    </SectionShell>
  );
}
