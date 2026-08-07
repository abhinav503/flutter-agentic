import type { Metadata } from "next";
import Link from "next/link";
import { LegalPage, LegalSection } from "@/components/site/legal-page";

const LAST_UPDATED = "7 August 2026";

export const metadata: Metadata = {
  title: "Refunds and cancellation — CordeliaApps",
  description:
    "How cancellation and refunds work at CordeliaApps: the platform is free to use, what happens if a paid plan is introduced, and why a refund for a shop order comes from the store rather than from us.",
  alternates: { canonical: "/refunds" },
};

/**
 * Two different refunds share one page because two different people arrive
 * looking for it, and sending either to the wrong answer is worse than a
 * slightly longer page: a **store owner** asking what happens to money paid to
 * CordeliaApps, and a **shopper** asking about an order they placed in a
 * store's app. They have opposite answers — we charge nothing today, and we
 * cannot refund an order because the money never reaches us.
 *
 * Written before there is anything to refund, deliberately. Card networks and
 * payment providers expect a published cancellation policy at onboarding, not
 * after the first charge, and a policy authored while no money is at stake is
 * the one that can be written honestly.
 */
export default function RefundsPage() {
  return (
    <LegalPage
      title="Refunds and cancellation"
      lastUpdated={LAST_UPDATED}
      intro={
        <>
          Two different things get called a refund here. If you run a store,
          this is about money you pay CordeliaApps. If you bought something in a
          store&apos;s app, that refund comes from the store you bought from,
          not from us — jump to the last section.
        </>
      }
    >
      <LegalSection title="1. CordeliaApps is free to use">
        <p>
          There is no subscription, no setup fee, no per-order commission and no
          charge for the admin console or the shopper app. Nothing is billed, so
          there is nothing to cancel and nothing to refund.
        </p>
        <p>
          Razorpay&apos;s own transaction fees are a separate matter between
          your store and Razorpay, charged against your own account under your
          own agreement with them. We do not set those fees, collect them or
          refund them.
        </p>
      </LegalSection>

      <LegalSection title="2. If we introduce a paid plan">
        <p>
          We may charge for the platform in future. If we do, we will tell you
          before any charge applies to your store, with enough notice to decide
          whether to continue, exactly as our{" "}
          <Link
            href="/terms"
            className="font-semibold text-primary hover:underline"
          >
            terms of service
          </Link>{" "}
          commit us to. Using a store you already run will never become
          chargeable without your agreement.
        </p>
        <p>The terms that would apply to such a plan:</p>
        <ul className="ml-5 list-disc space-y-2">
          <li>
            The price, the billing period and the date of the first charge are
            shown before you agree to them, never only after.
          </li>
          <li>
            You can cancel at any time from the admin console. Cancelling stops
            the next charge — it does not end your access immediately.
          </li>
          <li>
            After cancelling you keep full access until the end of the period
            you have already paid for.
          </li>
          <li>
            We do not refund the unused part of a period that has already
            started. Cancel before the next renewal date and you are not charged
            again.
          </li>
          <li>
            Cancelling does not delete your store or your data. Deleting your
            account is a separate, deliberate action you take in the console.
          </li>
        </ul>
      </LegalSection>

      <LegalSection title="3. Charges that should not have happened">
        <p>
          A duplicate charge, a charge after you cancelled, or a charge for an
          amount you never agreed to is refunded in full. That is a mistake on
          our side, not a refund request, and the policy above does not apply to
          it.
        </p>
        <p>
          Write to{" "}
          <a
            href="mailto:support@cordeliaapps.com"
            className="font-semibold text-primary hover:underline"
          >
            support@cordeliaapps.com
          </a>{" "}
          with the date and amount. We aim to reply within two business days.
          Approved refunds go back to the card or account originally charged —
          we cannot send them anywhere else — and usually appear within five to
          ten business days, depending on your bank.
        </p>
      </LegalSection>

      <LegalSection title="4. Orders you placed in a store's app">
        <p>
          If you are a shopper, your order was sold to you by an independent
          store, not by CordeliaApps. The store sets its own returns and refunds
          policy, and the payment settled directly into that store&apos;s own
          payment account — it never passes through us. We therefore cannot
          refund an order, reverse a payment or overrule a store&apos;s
          decision, however much we might want to help.
        </p>
        <p>
          Contact the store you bought from. Its contact details are in the app
          you ordered through, alongside your order.
        </p>
        <p>
          Two things the app does handle directly. You can cancel an order
          yourself while it has not yet been dispatched, and the refund is
          started automatically when you do. Once an order has been dispatched,
          cancelling is no longer available in the app and the store handles it
          with you. Either way the money is returned by the store&apos;s payment
          provider to the method you paid with, on that provider&apos;s
          timescale rather than ours.
        </p>
      </LegalSection>

      <LegalSection title="5. Changes and contact">
        <p>
          We update this policy as the platform changes, and the date at the top
          shows when it last changed. Anything unclear, or anything that looks
          wrong on your account, goes to{" "}
          <a
            href="mailto:support@cordeliaapps.com"
            className="font-semibold text-primary hover:underline"
          >
            support@cordeliaapps.com
          </a>
          .
        </p>
      </LegalSection>
    </LegalPage>
  );
}
