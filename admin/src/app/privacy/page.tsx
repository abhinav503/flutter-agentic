import type { Metadata } from "next";
import { ConsentPreference } from "@/components/consent-preference";
import { LegalPage, LegalSection } from "@/components/site/legal-page";

const LAST_UPDATED = "7 August 2026";

export const metadata: Metadata = {
  title: "Privacy policy — CordeliaApps",
  description:
    "What CordeliaApps collects on this website and in the store admin console, who processes it, and how to exercise your rights.",
  alternates: { canonical: "/privacy" },
};

/**
 * The website and console privacy policy — for **store owners**.
 *
 * Deliberately separate from the shopper-facing policy inside the Cordelia
 * app: different audience, different data, different controller. This one
 * covers what CordeliaApps collects as the operator; that one covers what a
 * shopper's storefront collects.
 *
 * The consent banner is required to link somewhere that explains the
 * processing, which is why this page exists at all — a banner without it is
 * only half of what the law asks for.
 */
export default function PrivacyPage() {
  return (
    <LegalPage
      title="Privacy policy"
      lastUpdated={LAST_UPDATED}
      intro={
        <>
          This policy covers this website and the CordeliaApps store admin
          console. If you are shopping in a store&apos;s app rather than running
          a store, the policy inside that app applies to you instead.
        </>
      }
    >
      <LegalSection title="1. Who we are">
        <p>
          CordeliaApps builds and operates the platform that gives independent
          stores their own shopping app. We are based in India and work with
          stores in India, the United Kingdom, the United States and across
          Europe. For the data described below, we are the controller, and you
          can reach us at{" "}
          <a
            href="mailto:support@cordeliaapps.com"
            className="font-semibold text-primary hover:underline"
          >
            support@cordeliaapps.com
          </a>
          .
        </p>
      </LegalSection>

      <LegalSection title="2. What this website collects">
        <p>
          If you allow it, we use Google Analytics to understand how people find
          and use this site — pages viewed, the site that referred you, rough
          location derived from your IP address, and your device and browser
          type. We also record when someone opens the sign-up dialog and when an
          account is created, so we can tell whether the site actually helps.
        </p>
        <p>
          <strong className="text-foreground">
            Nothing is loaded until you accept.
          </strong>{" "}
          Decline and no analytics script is downloaded, no request is made and
          no cookie is set. We do not use analytics for advertising and we do
          not sell data to anyone.
        </p>
        <p>
          Our host, Vercel, keeps short-lived server logs including IP
          addresses, as any web server does. That is necessary to serve and
          secure the site.
        </p>
      </LegalSection>

      <LegalSection title="3. Your analytics choice">
        <p>
          You can change your mind at any time, and withdrawing is as easy as
          allowing. Declining stops anything further being sent; it cannot
          recall what was already delivered.
        </p>
        <ConsentPreference />
      </LegalSection>

      <LegalSection title="4. What the admin console collects">
        <p>
          Creating a store account gives us your email address and a password,
          which is handled by Firebase Authentication and never visible to us.
          Alongside it we keep a record of your account, the stores you own, and
          when it was created.
        </p>
        <p>
          Running a store means we store what you put into it: your store&apos;s
          name and settings, your catalog of products, categories, brands,
          banners and coupons, the orders your shoppers place, and any images
          you upload. Your Razorpay key identifier is stored so payments can
          settle to you; the corresponding secret is encrypted at rest.
        </p>
      </LegalSection>

      <LegalSection title="5. Your shoppers' data">
        <p>
          When shoppers use your store&apos;s app, their accounts, addresses,
          carts, orders and reviews sit in the same platform. For that data you
          are the controller and we act on your behalf as a processor — we
          handle it to run the service for you and do not use it for our own
          purposes.
        </p>
      </LegalSection>

      <LegalSection title="6. Who else processes it">
        <p>
          Google (Firebase and Google Analytics) for authentication, database,
          file storage and analytics. Vercel for hosting. Razorpay for payments,
          where a store has connected an account. Each processes data on our
          instructions, and this may involve transfers outside your country.
        </p>
      </LegalSection>

      <LegalSection title="7. How long we keep it">
        <p>
          Account and store data stays for as long as the account is open.
          Delete your account and we remove your profile and the store data tied
          to it. Orders are kept as a business record — they are a store&apos;s
          sales history and may be needed for tax or a dispute, so they are not
          erased on request. Analytics data is retained by Google under that
          product&apos;s own retention settings.
        </p>
      </LegalSection>

      <LegalSection title="8. Your rights">
        <p>
          You can ask for a copy of your data, ask us to correct it, ask us to
          delete it, or object to how we use it. Email us and we will answer
          within a month.
        </p>
        <p>
          If you are in the United Kingdom or the European Union you keep every
          right your local law gives you, including the right to complain to
          your data protection authority. Nothing here reduces those rights.
        </p>
      </LegalSection>

      <LegalSection title="9. Changes">
        <p>
          We update this policy as the product changes, and the date at the top
          shows when it last changed. If a change matters to you, we will say so
          rather than quietly reposting it.
        </p>
      </LegalSection>
    </LegalPage>
  );
}
