/**
 * Single source of truth for the FAQ. The rendered accordion and the
 * FAQPage JSON-LD both read from here, so the markup can never drift
 * from the visible text.
 * Server-safe: plain data.
 */
export const faqItems = [
  {
    id: "faq-cut",
    question: "Do you take a cut of my sales?",
    answer:
      "No. CordeliaApps never takes a commission on your sales, because shopper payments are settled by Razorpay directly into your own Razorpay account and never pass through us. You pay a flat subscription for hosting and the admin console instead of a revenue share.",
  },
  {
    id: "faq-separate-app",
    question: "Do my customers download a separate app?",
    answer:
      "No. One CordeliaApps shopper app hosts every store, so your customers use the app they may already have rather than installing something new. That is how your store has shoppers on day one instead of starting at zero downloads.",
  },
  {
    id: "faq-change-template",
    question: "Can I change template later?",
    answer:
      "Yes. Switching between gravia, dailymart and grofast is one dropdown in the admin console, and there is no data migration because a template restyles the shopper experience at runtime over the same store data.",
  },
  {
    id: "faq-developer",
    question: "Do I need a developer?",
    answer:
      "No. Creating your store, picking a template, adding products and running orders are all done in the admin console, so no code, no build step and no app submission is involved.",
  },
  {
    id: "faq-data",
    question: "What happens to my data if I leave?",
    answer:
      "Your data stays yours. Your catalog and your orders are exportable, so you can take your product data and order history with you if you stop using CordeliaApps.",
  },
  {
    id: "faq-push",
    question: "Do you support push notifications?",
    answer:
      "Honestly, not yet. In-app notifications ship today, while store-composed notifications and push notifications are on the roadmap and are not available right now.",
  },
] as const;
