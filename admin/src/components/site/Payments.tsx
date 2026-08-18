import Link from "next/link";
import { LockKeyhole, RotateCcw, ShieldCheck, Wallet } from "lucide-react";
import { SectionShell, SectionHeading } from "./ui";
import { RazorpayBadge, StripeBadge } from "./brand-icons";

/**
 * The payment integrations, as a section of their own.
 *
 * It exists because "who takes the money, and where does it land" is the
 * second question a store owner has after price, and it used to be answered
 * only in passing — one clause in the hero, one bullet in the admin list, both
 * naming Razorpay as if it were the only option. With two providers live, that
 * clause couldn't carry it: the choice between them is a currency decision,
 * and a currency decision needs both columns visible at once.
 *
 * Deliberately claims nothing about fees. A store's gateway rate is between
 * that store and its provider, and quoting a number here would be a promise
 * this product doesn't control — the same line Pricing holds.
 */

const providers = [
  {
    name: "Razorpay",
    Badge: RazorpayBadge,
    tagline: "The default for stores charging in rupees.",
    currencies: [["₹", "INR"]],
    methods: "Cards, UPI, netbanking and wallets.",
    points: [
      "Generate a key pair in the Razorpay dashboard and paste it in — that is the whole setup.",
      "Refunds settle back automatically through a signed webhook.",
    ],
  },
  {
    name: "Stripe",
    Badge: StripeBadge,
    tagline: "For everywhere else — and for rupees too, if you prefer it.",
    currencies: [
      ["₹", "INR"],
      ["€", "EUR"],
      ["£", "GBP"],
      ["$", "USD"],
    ],
    methods:
      "Cards and wallets. Which methods a shopper is offered is decided by Stripe from your account's country and the order's currency.",
    points: [
      "Works with a restricted key scoped to payments and refunds, so a leaked key can't read your balance or customers.",
      "Refunds settle back automatically through a signed webhook.",
    ],
  },
];

/**
 * Rendered as a compact strip rather than four more icon-topped panels: Trust
 * sits directly below with exactly that treatment, and six identical cards
 * across two adjacent sections read as one long undifferentiated list. These
 * are the fine print under the two provider cards, and they are sized like it.
 */
const guarantees = [
  {
    Icon: Wallet,
    title: "Your account, your money",
    body: "No platform wallet in the middle. A shopper pays and it lands in the account whose keys you pasted, on your provider's own settlement schedule.",
  },
  {
    Icon: ShieldCheck,
    title: "Every payment verified",
    body: "The server prices the cart, then confirms the payment with the provider before writing the order. The app is never trusted for an amount.",
  },
  {
    Icon: LockKeyhole,
    title: "Keys encrypted at rest",
    body: "Your secret is encrypted before it is stored and is never sent to the shopper app. Each store's keys are its own.",
  },
  {
    Icon: RotateCcw,
    title: "Refunds built in",
    body: "Cancelling an order restocks it and returns the money. Retrying a failed refund can't pay a shopper twice.",
  },
];

export function Payments() {
  return (
    <SectionShell id="payments" labelledBy="payments-heading">
      <SectionHeading
        id="payments-heading"
        eyebrow="Payments"
        title="Take payments into your own account"
        lead="Two providers are integrated. You connect one, and your storefront never names it — pasting a key is how you choose."
      />

      <div className="mt-14 grid gap-6 md:grid-cols-2">
        {providers.map(({ name, Badge, tagline, currencies, methods, points }) => (
          <article key={name} className="surface-panel flex flex-col rounded-2xl p-7">
            <div className="flex items-center gap-3.5">
              {/* size-11 = 44px. Keep this an integer: a fractional box against
                  the badge's viewBox is what made the first cut look soft. No
                  `rounded-*` either — the artwork draws its own corners, and a
                  CSS radius on top clips at a different one and shaves them. */}
              <Badge className="size-11 shrink-0" />
              <div className="min-w-0">
                <h3 className="text-xl font-extrabold tracking-tight text-ink">{name}</h3>
                <ul className="mt-1.5 flex flex-wrap gap-1.5">
                  {currencies.map(([symbol, code]) => (
                    <li
                      key={code}
                      className="flex items-center gap-1 rounded-full border border-border py-0.5 pl-1.5 pr-2 text-[0.6875rem] text-muted-foreground"
                    >
                      <span aria-hidden="true" className="text-xs font-bold text-foreground">
                        {symbol}
                      </span>
                      <span className="font-mono font-semibold tracking-wider">{code}</span>
                    </li>
                  ))}
                </ul>
              </div>
            </div>

            <p className="mt-5 text-sm font-medium leading-6 text-foreground">{tagline}</p>
            <p className="mt-2 text-sm leading-6 text-muted-foreground">{methods}</p>

            <ul className="mt-5 space-y-3 border-t border-border pt-5">
              {points.map((point) => (
                <li key={point} className="flex gap-2.5 text-sm leading-6 text-muted-foreground">
                  <span
                    aria-hidden="true"
                    className="mt-2 size-1.5 shrink-0 rounded-full bg-primary"
                  />
                  {point}
                </li>
              ))}
            </ul>
          </article>
        ))}
      </div>

      <ul className="mt-10 grid gap-x-10 gap-y-7 sm:grid-cols-2">
        {guarantees.map(({ Icon, title, body }) => (
          <li key={title} className="flex gap-3.5">
            <Icon aria-hidden="true" className="mt-0.5 size-[1.15rem] shrink-0 text-primary" />
            <div>
              <h3 className="text-sm font-bold tracking-tight text-ink">{title}</h3>
              <p className="mt-1 text-sm leading-6 text-muted-foreground">{body}</p>
            </div>
          </li>
        ))}
      </ul>

      <p className="mt-10 border-t border-border pt-6 text-sm leading-6 text-muted-foreground">
        Keys for both providers are stored independently, so switching is one click and does not
        mean re-entering anything.{" "}
        <Link
          href="/docs/payments/how-checkout-works"
          className="font-semibold text-primary hover:underline"
        >
          How checkout works
        </Link>
        .
      </p>
    </SectionShell>
  );
}
