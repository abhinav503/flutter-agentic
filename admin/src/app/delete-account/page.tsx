import type { Metadata } from "next";
import Link from "next/link";
import { LegalPage, LegalSection } from "@/components/site/legal-page";

const LAST_UPDATED = "7 August 2026";

export const metadata: Metadata = {
  title: "Delete your account — CordeliaApps",
  description:
    "How to delete your CordeliaApps account and data, what is removed, and what is kept.",
  alternates: { canonical: "/delete-account" },
};

/**
 * The data-deletion URL submitted to Google Play.
 *
 * Play requires this as a *web* page for any app offering account creation,
 * separately from the in-app control — someone who has uninstalled the app must
 * still be able to find out how to get their data removed. It has to name the
 * app, give the steps, and say plainly what is deleted and what is retained.
 *
 * The deleted/retained lists mirror deleteShopperAccount in
 * admin/src/lib/account.ts rather than describing an intention: reviews go
 * first (each through deleteReview, so the products they rated aren't left
 * over-counted), then the four subcollections, then the profile doc, then the
 * Auth user last so a partial failure stays recoverable.
 */
export default function DeleteAccountPage() {
  return (
    <LegalPage
      title="Delete your account"
      lastUpdated={LAST_UPDATED}
      intro={
        <>
          This page explains how to delete your account and data from the
          CordeliaApps shopping app (<code>com.cordeliaapps.superapp</code>),
          what gets removed, and what we keep.
        </>
      }
    >
      <LegalSection title="Delete it yourself, in the app">
        <p>The fastest way, and it takes effect immediately:</p>
        <p>
          <strong className="text-foreground">
            Open the app → Profile → Delete account → confirm.
          </strong>
        </p>
        <p>
          You will be asked to confirm, because it cannot be undone. Once it
          completes you are signed out and the account no longer exists.
        </p>
      </LegalSection>

      <LegalSection title="Or ask us to do it">
        <p>
          If you have already uninstalled the app, or cannot sign in, email{" "}
          <a
            href="mailto:support@cordeliaapps.com"
            className="font-semibold text-primary hover:underline"
          >
            support@cordeliaapps.com
          </a>{" "}
          from the address on the account, with the subject{" "}
          <strong className="text-foreground">Delete my account</strong>.
        </p>
        <p>
          We reply within 7 days and complete the deletion within 30 days. We
          may need to confirm you own the address before acting, since the
          request is irreversible.
        </p>
      </LegalSection>

      <LegalSection title="What is deleted">
        <p>Everything tied to you as a person:</p>
        <p>
          Your sign-in account and password. Your profile, including your name
          and profile photo. Every delivery address you saved. The contents of
          your carts in every store. Your favourites. Your recent searches. And
          every review and rating you wrote — removed from the stores where they
          appeared, with the affected products&apos; rating averages corrected
          so nothing is left counting a review that no longer exists.
        </p>
      </LegalSection>

      <LegalSection title="What is kept, and why">
        <p>
          <strong className="text-foreground">Your past orders.</strong> An
          order is the store&apos;s sales record as much as yours. Stores need
          it for their accounts and tax obligations, and it may be evidence in a
          refund or delivery dispute — so a closed account does not erase a
          shop&apos;s transaction history. Retained for as long as the
          store&apos;s legal and accounting obligations require, typically
          several years under local tax law.
        </p>
        <p>
          The order keeps the delivery address and amount it was placed with,
          because those are part of the record. It is no longer linked to a
          usable account, and you can no longer sign in to view it.
        </p>
      </LegalSection>

      <LegalSection title="Related">
        <p>
          What we collect in the first place is set out in the{" "}
          <Link
            href="/app-privacy"
            className="font-semibold text-primary hover:underline"
          >
            app privacy policy
          </Link>
          .
        </p>
      </LegalSection>
    </LegalPage>
  );
}
