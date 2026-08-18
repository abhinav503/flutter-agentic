import { SectionShell, SectionHeading } from "./ui";
import { Layers, UserRoundX, Fingerprint, Clock } from "lucide-react";

const cards = [
  {
    Icon: Layers,
    title: "Tenant isolation",
    body: "Every store's catalog, orders and payments are namespaced. A store admin can only touch their own store, and a shopper can only see their own data.",
  },
  {
    Icon: UserRoundX,
    title: "Shoppers control their data",
    body: "A shopper can delete their account from inside the app, which removes their profile, addresses, cart, wishlist, searches and every review they wrote. Your orders stay — they are your sales records, not theirs.",
  },
  {
    Icon: Fingerprint,
    title: "Secrets protected",
    body: "Passwords are never stored by us, and your data is encrypted in transit and at rest.",
  },
  {
    Icon: Clock,
    title: "Honest order state",
    body: "Every status change is timestamped and shown to the shopper as a dated timeline — no fake pipeline steps.",
  },
];

export function Trust() {
  return (
    <SectionShell id="trust" labelledBy="trust-heading">
      <SectionHeading
        id="trust-heading"
        eyebrow="Trust"
        title="How your store data and payments are protected"
        lead="The parts of the platform that touch money and customer data are the parts we are most specific about."
      />

      <div className="mt-14 grid gap-6 sm:grid-cols-2">
        {cards.map(({ Icon, title, body }) => (
          <article key={title} className="surface-panel rounded-2xl p-7">
            <span
              aria-hidden="true"
              className="grid size-10 place-items-center rounded-xl bg-primary-soft text-accent-foreground"
            >
              <Icon className="size-5" />
            </span>
            <h3 className="mt-4 text-lg font-bold tracking-tight text-ink">{title}</h3>
            <p className="mt-2.5 text-sm leading-6 text-muted-foreground">{body}</p>
          </article>
        ))}
      </div>
    </SectionShell>
  );
}
