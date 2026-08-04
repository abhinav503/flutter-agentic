/**
 * JSON-LD structured data for the CordeliaApps marketing page.
 * Server-safe: renders static <script type="application/ld+json"> blocks.
 *
 * No aggregateRating and no priced offers are emitted: CordeliaApps has no
 * published ratings and no published pricing, and fabricated rating or price
 * markup is a manual-action risk.
 */
import { faqItems } from "./faq-data";

const SITE_URL = "https://cordeliaapps.com/";

const organization = {
  "@context": "https://schema.org",
  "@type": "Organization",
  name: "CordeliaApps",
  url: SITE_URL,
  // Replace with the absolute URL of the CordeliaApps logo once hosted.
  logo: "https://cordeliaapps.com/logo.png",
  email: "hello@cordeliaapps.com",
  contactPoint: [
    {
      "@type": "ContactPoint",
      contactType: "sales",
      email: "hello@cordeliaapps.com",
      availableLanguage: ["en"],
    },
  ],
};

const softwareApplication = {
  "@context": "https://schema.org",
  "@type": "SoftwareApplication",
  name: "CordeliaApps",
  url: SITE_URL,
  applicationCategory: "BusinessApplication",
  operatingSystem: "iOS, Android, Web",
  description:
    "CordeliaApps gives grocery and retail store owners in India a branded shopping app with catalog, cart, coupons and Razorpay checkout, with zero commission on sales.",
  publisher: { "@type": "Organization", name: "CordeliaApps", url: SITE_URL },
};

const faqPage = {
  "@context": "https://schema.org",
  "@type": "FAQPage",
  mainEntity: faqItems.map((item) => ({
    "@type": "Question",
    name: item.question,
    acceptedAnswer: { "@type": "Answer", text: item.answer },
  })),
};

export function StructuredData() {
  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(organization) }}
      />
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(softwareApplication) }}
      />
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(faqPage) }}
      />
    </>
  );
}
