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
      "No. CordeliaApps never takes a commission on your sales, because shopper payments are settled by Razorpay or Stripe directly into your own account with that provider and never pass through us.",
  },
  {
    id: "faq-cost",
    question: "What does CordeliaApps cost?",
    answer:
      "Nothing. The shopper app and the admin console are free to use: there is no subscription, no setup fee and no per-order cut. You will still have your own Razorpay or Stripe account for taking payments, and that provider's own transaction fees are between you and them.",
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
      "Your data stays yours. Ask us and we will give you a full copy of your catalog and order history, so you can take them with you if you stop using CordeliaApps. There is no self-serve export button in the console yet — it is on the list.",
  },
  {
    id: "faq-push",
    question: "Do you support push notifications?",
    answer:
      "Yes. You can compose a notification with optional artwork and send it to shoppers who follow your store, and every order transition — placed, on the way, delivered, cancelled — notifies the shopper automatically. Each message also lands in the in-app notification centre, so it is not lost if a push is missed. Push is live on Android; iOS push is not enabled yet.",
  },
  {
    id: "faq-payments",
    question: "Which payment providers can I use?",
    answer:
      "Razorpay and Stripe. Razorpay handles INR and covers cards, UPI, netbanking and wallets. Stripe handles INR, EUR, GBP and USD, with the available methods decided by your account's country and the order's currency. You connect one, your keys are stored encrypted, and switching between them is one click.",
  },
  {
    id: "faq-currency",
    question: "Can I sell outside India?",
    answer:
      "Yes. A store sets its own currency and language: prices can be charged in rupees, euros, pounds or dollars, and the storefront reads in English, German, French, Spanish, Italian or Hindi. Amounts, dates and currency symbols are formatted for the shopper's locale automatically. One thing to know: address autocomplete and postal-code lookup are available in India today, so shoppers elsewhere type their delivery address in full.",
  },
] as const;
