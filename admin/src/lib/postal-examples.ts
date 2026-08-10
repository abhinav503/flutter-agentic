// Postal-code guidance for the Delivery settings form, per market.
//
// The delivery-areas field takes postal-code prefixes, and a prefix is only
// obvious once you've seen one from your own country. The first version of
// this form showed Bengaluru pincodes to every store — a Berlin owner reading
// "560 covers all of 560xxx" learns nothing about what to type, and a New
// York one doesn't even call it a postal code.
//
// The store already declares its language and currency, which between them
// name a market (see lib/market.ts), so none of this needs asking for.
//
// The console's own UI stays English — one dashboard language is a decision
// made in lib/money.ts and unchanged here. What varies is the *example*, not
// the sentence around it.

import { marketForStore, type Market } from "./market";

export type PostalGuidance = {
  /** What this market calls the thing — "PIN code", "ZIP code", "postcode". */
  noun: string;
  /** Plural of [noun], for "One … per line". */
  nounPlural: string;
  /** Two full codes and one prefix, shown as the field's placeholder. */
  examples: string[];
  /** The prefix used in the help sentence. */
  prefix: string;
  /** What that prefix covers, completing "… covers ". */
  prefixCovers: string;
};

const GUIDANCE: Record<Market, PostalGuidance> = {
  india: {
    noun: "PIN code",
    nounPlural: "PIN codes",
    examples: ["560001", "560002", "560"],
    prefix: "560",
    prefixCovers: "every 560xxx code in Bengaluru",
  },
  germany: {
    noun: "postal code",
    nounPlural: "postal codes",
    examples: ["10115", "10117", "101"],
    prefix: "101",
    prefixCovers: "every 101xx code in Berlin",
  },
  france: {
    noun: "postal code",
    nounPlural: "postal codes",
    examples: ["75001", "75002", "750"],
    prefix: "750",
    prefixCovers: "every 750xx code in Paris",
  },
  spain: {
    noun: "postal code",
    nounPlural: "postal codes",
    examples: ["28001", "28002", "280"],
    prefix: "280",
    prefixCovers: "every 280xx code in Madrid",
  },
  italy: {
    noun: "CAP",
    nounPlural: "CAPs",
    examples: ["00184", "00185", "001"],
    prefix: "001",
    prefixCovers: "every 001xx code in Rome",
  },
  uk: {
    // The one market whose codes aren't digits, which is also why its example
    // has to be a real one: "SW1A 1AA" tells an owner both that letters are
    // fine and that the space doesn't matter (the server strips it).
    noun: "postcode",
    nounPlural: "postcodes",
    examples: ["SW1A 1AA", "SW1P 3PA", "SW1"],
    prefix: "SW1",
    prefixCovers: "every SW1 postcode in Westminster",
  },
  us: {
    noun: "ZIP code",
    nounPlural: "ZIP codes",
    examples: ["10001", "10002", "100"],
    prefix: "100",
    prefixCovers: "every 100xx ZIP in Manhattan",
  },
};

export function postalGuidanceFor(
  language: string,
  currency: string,
): PostalGuidance {
  return GUIDANCE[marketForStore(language, currency)];
}
