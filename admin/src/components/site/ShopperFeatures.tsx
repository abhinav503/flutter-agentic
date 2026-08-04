import { SectionShell, SectionHeading } from "./ui";

const groups = [
  {
    title: "Finding your store and your products",
    items: [
      "Store discovery across every CordeliaApps store",
      "Home with your promo banners",
      "Per-store search with recent searches",
      "Categories with sort and price filters",
      "Product details with brands, per-size pricing and discounts",
      "Wishlist",
    ],
  },
  {
    title: "Checking out and paying",
    items: [
      "Cart",
      "Coupons",
      "Razorpay checkout",
      "Address book",
      "Email sign-up with verification",
      "Profile with avatar",
    ],
  },
  {
    title: "After the order is placed",
    items: [
      "Order history with a dated status timeline and track-order view",
      "Self-cancel with automatic refund",
      "Product ratings and reviews with a Verified purchase badge",
      "Delivery ratings",
    ],
  },
];

export function ShopperFeatures() {
  return (
    <SectionShell id="features" labelledBy="shopper-features-heading">
      <SectionHeading
        id="shopper-features-heading"
        eyebrow="For your customers"
        title="What your customers get in the shopping app"
        lead="One shopper app hosts many stores, so anyone already shopping a CordeliaApps store can shop yours with the same account, saved addresses and payment flow."
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
    </SectionShell>
  );
}
