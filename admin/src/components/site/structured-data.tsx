/**
 * JSON-LD structured data for the CordeliaApps marketing page.
 * Server-safe: renders static <script type="application/ld+json"> blocks.
 *
 * No aggregateRating is emitted: CordeliaApps has no published ratings, and
 * fabricated rating markup is a manual-action risk.
 *
 * A zero-price Offer IS emitted, because the product genuinely is free —
 * this is the schema.org way to say so, and it is what lets a result show
 * "Free" rather than nothing. It must be deleted the day anything is charged.
 */
import { faqItems } from "./faq-data";
import { SITE_URL as ORIGIN } from "@/lib/site";

// JSON-LD `url` values are the site root, so they keep the trailing slash the
// markup shipped with; the origin itself comes from the one shared const.
const SITE_URL = `${ORIGIN}/`;

const organization = {
  "@context": "https://schema.org",
  "@type": "Organization",
  name: "CordeliaApps",
  url: SITE_URL,
  // 512px render of the app icon (public/brand/logo.png). Google wants a real,
  // fetchable raster here — this pointed at /logo.png, which never existed.
  logo: `${ORIGIN}/brand/logo.png`,
  email: "cordeliaapps@gmail.com",
  contactPoint: [
    {
      "@type": "ContactPoint",
      contactType: "sales",
      email: "cordeliaapps@gmail.com",
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
    "CordeliaApps gives grocery and retail store owners in India a branded shopping app with catalog, cart, coupons and Razorpay checkout, free to use and with zero commission on sales.",
  offers: {
    "@type": "Offer",
    price: "0",
    priceCurrency: "INR",
  },
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
