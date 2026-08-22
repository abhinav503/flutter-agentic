import type { Metadata } from "next";
import Link from "next/link";
import { LegalPage, LegalSection } from "@/components/site/legal-page";

const LAST_UPDATED = "22 August 2026";

export const metadata: Metadata = {
  title: "Terms of service — CordeliaApps",
  description:
    "The agreement between CordeliaApps and store owners using the platform: your store, your responsibilities, payments, availability and governing law.",
  alternates: { canonical: "/terms" },
};

/**
 * The platform terms, between CordeliaApps and a **store owner**.
 *
 * Not to be confused with the Terms inside the Cordelia shopper app, which
 * govern a shopper buying from a store. The two are deliberately separate
 * agreements between different parties, and they agree on the pivot that
 * matters: the store sells to the shopper, and CordeliaApps is neither the
 * seller nor a party to that sale.
 */
export default function TermsPage() {
  return (
    <LegalPage
      title="Terms of service"
      lastUpdated={LAST_UPDATED}
      intro={
        <>
          These terms cover using CordeliaApps to run a store. If you are
          shopping in a store&apos;s app rather than running one, the terms
          inside that app apply to you instead.
        </>
      }
    >
      <LegalSection title="1. Who we are and what this covers">
        <p>
          CordeliaApps builds and operates the platform that gives independent
          stores a branded shopping app and an admin console to run it. We are
          based in India and work with stores in India, the United Kingdom, the
          United States and across Europe. Creating an account means you accept
          these terms on behalf of yourself and any business you represent.
        </p>
      </LegalSection>

      <LegalSection title="2. Your account">
        <p>
          Give accurate details and keep your password to yourself — anything
          done through your account is treated as done by you. One person or
          business per account. Tell us promptly if you think someone else has
          access.
        </p>
      </LegalSection>

      <LegalSection title="3. Your store is yours to run">
        <p>
          We provide the software. Everything inside your store is yours: the
          products you list, the prices you set, the descriptions and images you
          upload, and the orders you accept. You sell directly to your shoppers
          and the sale contract is between you and them — CordeliaApps is not
          the seller, the importer or a party to it.
        </p>
        <p>
          That also makes the legal obligations yours. You are responsible for
          having the right to sell what you list, for the accuracy of what you
          publish, for the taxes you charge, for fulfilling and delivering
          orders, and for handling your shoppers&apos; returns, refunds and
          complaints.
        </p>
      </LegalSection>

      <LegalSection title="4. Payments">
        <p>
          Payments are taken by your own payment provider account and settle
          directly to you. CordeliaApps never holds your money and never holds
          your shoppers&apos;. Your agreement with that provider is separate
          from this one, and its rules — including on refunds, chargebacks and
          the goods you may sell — apply to you directly.
        </p>
        <p>
          The platform is free to use today. If we introduce a charge we will
          tell you before it applies to your store, with enough notice to decide
          whether to continue.
        </p>
      </LegalSection>

      <LegalSection title="5. Your shoppers' data">
        <p>
          Shopper accounts, addresses, orders and reviews belong to your store.
          For that data you are the controller and we act on your instructions
          as a processor — we hold it to run the service for you and do not use
          it for our own purposes. What we collect, and from whom, is set out in
          our{" "}
          <Link
            href="/privacy"
            className="font-semibold text-primary hover:underline"
          >
            privacy policy
          </Link>
          . You are responsible for telling your own shoppers what you collect
          and why.
        </p>
      </LegalSection>

      <LegalSection title="6. Acceptable use">
        <p>
          Do not use CordeliaApps to sell anything you are not legally allowed
          to sell, to defraud shoppers, to launder money, to publish content
          that infringes someone else&apos;s rights, or to interfere with how
          the platform works for anyone else. We may suspend or close a store
          that does, and we will say why.
        </p>
        <p>
          Some things are off the platform even where you are licensed to sell
          them. You may not list <strong>alcoholic drinks</strong>, or{" "}
          <strong>tobacco, nicotine and related products</strong> — cigarettes,
          cigars, bidis, chewing tobacco, gutkha, hookah and shisha supplies,
          vapes and e-cigarettes. Alcohol-free and nicotine-free versions of a
          product are fine, and so are everyday goods that merely mention one
          of these words, such as wine vinegar, root beer or a lighter.
        </p>
        <p>
          This is a platform-wide rule, not a legal one: the shopping app is
          rated for a general audience on the App Store and Google Play on the
          basis that its stores do not carry these products, and one store
          listing them puts every store&apos;s app at risk. The console blocks
          products that look like these when you add or import them, and a
          store cannot be submitted for review while its catalog contains any.
          If a legitimate product is refused, rename it or email us and we will
          sort it out.
        </p>
      </LegalSection>

      <LegalSection title="7. Availability and changes">
        <p>
          We work to keep the platform running well, but it is provided as-is:
          we cannot promise it will always be available or free of faults, and
          we may add, change or withdraw features as the product develops. We
          will give reasonable notice before removing something your store
          depends on.
        </p>
      </LegalSection>

      <LegalSection title="8. Ending it">
        <p>
          You can stop using CordeliaApps at any time: unpublish your store from
          the console, and email us to close your account. We may close an
          account that breaches these terms, or wind the service down with
          reasonable notice. Either way, ask us before you go and we will give
          you a copy of your catalog and your order history, which remain your
          business records.
        </p>
      </LegalSection>

      <LegalSection title="9. Our responsibility">
        <p>
          We are responsible for the platform itself. We are not responsible for
          the goods you sell, the accuracy of what you publish, your dealings
          with your shoppers, or losses caused by a third-party service such as
          your payment provider. Because the service is currently free, our
          liability to you is limited to the maximum extent the law allows.
        </p>
        <p>
          Nothing here limits any liability that the law does not permit us to
          limit.
        </p>
      </LegalSection>

      <LegalSection title="10. Governing law">
        <p>
          These terms are governed by the laws of India and the courts of India
          have jurisdiction. If you are a business in the United Kingdom or the
          European Union, this does not remove any protection that mandatory
          local law gives you.
        </p>
      </LegalSection>

      <LegalSection title="11. Changes and contact">
        <p>
          We update these terms as the platform changes, and the date at the top
          shows when they last changed. Continuing to use CordeliaApps after a
          change means you accept the updated terms. Questions go to{" "}
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
