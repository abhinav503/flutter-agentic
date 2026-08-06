import type { Metadata } from "next";
import Link from "next/link";
import { LegalPage, LegalSection } from "@/components/site/legal-page";

const LAST_UPDATED = "7 August 2026";

export const metadata: Metadata = {
  title: "App privacy policy — CordeliaApps",
  description:
    "What the CordeliaApps shopping app collects from shoppers, who it is shared with, and how to delete it.",
  alternates: { canonical: "/app-privacy" },
};

/**
 * The **shopper-facing** privacy policy, and the URL submitted to Google Play.
 *
 * Play requires a publicly reachable policy covering the app's own data
 * handling. `/privacy` could not serve that: it is written for store owners
 * using the console, a different audience with a different relationship to the
 * data. Pointing Play at it would describe the wrong processing to the wrong
 * reader.
 *
 * Every claim here is checked against the code rather than boilerplate — the
 * subcollection list matches USER_SUBCOLLECTIONS in admin/src/lib/account.ts,
 * and the "no analytics, no ads" paragraph is true because the Flutter app
 * ships no analytics, messaging or ads SDK at all.
 */
export default function AppPrivacyPage() {
  return (
    <LegalPage
      title="App privacy policy"
      lastUpdated={LAST_UPDATED}
      intro={
        <>
          This policy covers the CordeliaApps shopping app, where you browse
          local stores and place orders. If you run a store and use the admin
          console, the{" "}
          <Link
            href="/privacy"
            className="font-semibold text-primary hover:underline"
          >
            website and console policy
          </Link>{" "}
          applies to you instead.
        </>
      }
    >
      <LegalSection title="1. Who handles your data">
        <p>
          CordeliaApps builds and operates the app. When you place an order, the
          store you ordered from decides how that order is handled and is the
          controller of it; we hold it on that store&apos;s behalf. For your
          account itself — your sign-in, profile and saved preferences — we are
          the controller. We are based in India and can be reached at{" "}
          <a
            href="mailto:support@cordeliaapps.com"
            className="font-semibold text-primary hover:underline"
          >
            support@cordeliaapps.com
          </a>
          .
        </p>
      </LegalSection>

      <LegalSection title="2. What the app collects">
        <p>
          <strong className="text-foreground">Your account.</strong> Your email
          address and password, handled by Firebase Authentication — we never
          see or store your password. Your name and, if you add one, a profile
          photo.
        </p>
        <p>
          <strong className="text-foreground">Shopping.</strong> Delivery
          addresses you save, the contents of your cart in each store, products
          you mark as favourites, and your recent searches so you can return to
          them.
        </p>
        <p>
          <strong className="text-foreground">Orders.</strong> What you ordered,
          the delivery address, the amount, the status as it changes, and any
          cancellation or refund.
        </p>
        <p>
          <strong className="text-foreground">Reviews.</strong> Star ratings and
          any text you write about a product or a delivered order, shown
          publicly in that store alongside your name.
        </p>
      </LegalSection>

      <LegalSection title="3. What the app does not do">
        <p>
          There is no advertising, no ad identifier, no third-party tracking and
          no analytics SDK in the app — we do not measure what you browse or
          build a profile of you. We do not sell your data to anyone, and we do
          not send marketing email you have not asked for.
        </p>
      </LegalSection>

      <LegalSection title="4. Permissions the app asks for">
        <p>
          <strong className="text-foreground">Camera and photos</strong> — only
          when you choose a profile picture. Nothing is read from your library
          unless you pick it.
        </p>
        <p>
          <strong className="text-foreground">Location</strong> — only if you
          tap &quot;use my location&quot; while adding a delivery address, to
          fill in the address for you. The app does not track your location in
          the background, and you can type the address instead.
        </p>
      </LegalSection>

      <LegalSection title="5. Payments">
        <p>
          Payments are handled by the store&apos;s own payment provider. Your
          card, UPI or bank details are entered into the provider&apos;s secure
          screen and are never sent to, seen by or stored by CordeliaApps or the
          store. We keep only the provider&apos;s reference for the payment, so
          the order can be matched and refunded.
        </p>
      </LegalSection>

      <LegalSection title="6. Who else sees it">
        <p>
          <strong className="text-foreground">The store you order from</strong>{" "}
          sees your order, your delivery address and your name — it has to, in
          order to deliver to you. It does not see your orders from other
          stores.
        </p>
        <p>
          <strong className="text-foreground">Google (Firebase)</strong> hosts
          the sign-in, database and file storage.{" "}
          <strong className="text-foreground">The payment provider</strong>{" "}
          processes the payment. When you use address lookup, the address text
          you type is sent to a mapping service to return suggestions. Each acts
          on our instructions, and this can involve transfers outside your
          country.
        </p>
      </LegalSection>

      <LegalSection title="7. Deleting your data">
        <p>
          You can delete your account from inside the app at any time —{" "}
          <strong className="text-foreground">
            Profile → Delete account
          </strong>
          . That removes your profile, saved addresses, carts, favourites,
          recent searches and the reviews you have written.
        </p>
        <p>
          Orders are kept. They are the store&apos;s sales record as much as
          yours, needed for its accounts, tax and any open dispute, so they are
          not erased when you close your account. Full detail, and how to ask us
          to do it for you, is on the{" "}
          <Link
            href="/delete-account"
            className="font-semibold text-primary hover:underline"
          >
            account deletion page
          </Link>
          .
        </p>
      </LegalSection>

      <LegalSection title="8. Your rights">
        <p>
          You can ask for a copy of your data, ask us to correct it, ask us to
          delete it, or object to how it is used. Email us and we will respond
          within a month. If you are in the United Kingdom or the European
          Union, you keep every right your local law gives you, including
          complaining to your data protection authority.
        </p>
      </LegalSection>

      <LegalSection title="9. Children">
        <p>
          The app is not directed at children and is not intended for anyone
          under 13. We do not knowingly collect data from children; if you
          believe a child has created an account, email us and we will remove
          it.
        </p>
      </LegalSection>

      <LegalSection title="10. Changes">
        <p>
          We update this policy as the app changes, and the date at the top
          shows when it last changed. Questions go to{" "}
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
