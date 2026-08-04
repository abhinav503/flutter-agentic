import { SectionShell, SectionHeading } from "./ui";
import { Layers, Wallet, KeyRound, Clock } from "lucide-react";

const cards = [
  {
    Icon: Layers,
    title: "Tenant isolation",
    body: "Every store's catalog, orders and payments are namespaced. A store admin can only touch their own store, and a shopper can only see their own data.",
  },
  {
    Icon: Wallet,
    title: "Your money path",
    body: "Every payment is verified on the server before the order is recorded, and a refund can never be issued twice.",
  },
  {
    Icon: KeyRound,
    title: "Secrets protected",
    body: "Payment keys are stored encrypted and never leave the server, passwords are never stored by us, and data is encrypted in transit and at rest.",
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
