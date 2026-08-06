import { app } from "./firebase";

/**
 * Google Analytics 4, via Firebase, for the marketing site.
 *
 * Named telemetry, not analytics: `lib/analytics.ts` is already the dashboard's
 * chart derivations, and two modules called "analytics" meaning different
 * things is how someone imports the wrong one.
 *
 * **Nothing loads until consent is granted.** `firebase/analytics` is behind a
 * dynamic `import()`, so before a visitor accepts there is no SDK in the
 * bundle, no gtag script, no network request and no cookie — which is a
 * stronger position than Consent Mode's "load but restrict", and simpler to
 * defend. `setConsent` is still called so the state is explicit to the tag
 * once it does load.
 *
 * The measurement ID rides in the Firebase config
 * (`NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID`); there is deliberately no gtag.js
 * snippet anywhere — pairing one with this SDK would double-count every view.
 */

export type ConsentChoice = "granted" | "denied";

const CONSENT_KEY = "cordelia-analytics-consent";

/** Fired on the window so any mounted component can react to a choice. */
export const CONSENT_EVENT = "cordelia-consent-change";

export function readConsent(): ConsentChoice | null {
  if (typeof window === "undefined") return null;
  const stored = window.localStorage.getItem(CONSENT_KEY);
  return stored === "granted" || stored === "denied" ? stored : null;
}

export function writeConsent(choice: ConsentChoice): void {
  window.localStorage.setItem(CONSENT_KEY, choice);
  window.dispatchEvent(new CustomEvent(CONSENT_EVENT, { detail: choice }));
}

type AnalyticsInstance = Awaited<
  ReturnType<typeof import("firebase/analytics").getAnalytics>
>;

let analytics: AnalyticsInstance | null = null;
let starting: Promise<AnalyticsInstance | null> | null = null;

/**
 * Loads and initialises Analytics, once. Safe to call repeatedly — concurrent
 * callers share the same in-flight promise rather than racing two SDK loads.
 *
 * Returns null when analytics cannot run at all: during SSR, in a browser
 * `isSupported()` rejects (no IndexedDB, some in-app webviews), or when the
 * measurement ID is missing from the environment.
 */
async function start(): Promise<AnalyticsInstance | null> {
  if (analytics) return analytics;
  if (starting) return starting;
  if (typeof window === "undefined") return null;
  if (!process.env.NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID) return null;

  starting = (async () => {
    const { initializeAnalytics, isSupported, setConsent } = await import(
      "firebase/analytics"
    );
    if (!(await isSupported())) return null;

    setConsent({ analytics_storage: "granted", ad_storage: "denied" });

    // send_page_view: false because this app router sends its own — the SDK's
    // automatic one fires on init and would double-count the landing page,
    // which is the page that matters most here.
    analytics = initializeAnalytics(app, {
      config: { send_page_view: false },
    });
    return analytics;
  })();

  return starting;
}

/** No-ops entirely when consent has not been granted. */
async function withAnalytics(
  run: (
    instance: AnalyticsInstance,
    log: typeof import("firebase/analytics").logEvent,
  ) => void,
): Promise<void> {
  if (readConsent() !== "granted") return;
  const instance = await start();
  if (!instance) return;
  const { logEvent } = await import("firebase/analytics");
  run(instance, logEvent);
}

export function trackPageView(path: string, title?: string): void {
  void withAnalytics((instance, logEvent) => {
    logEvent(instance, "page_view", {
      page_path: path,
      page_location: window.location.href,
      page_title: title ?? document.title,
    });
  });
}

/**
 * A visitor opened the sign-up dialog. `location` names which CTA did it, so
 * the hero, pricing and footer buttons can be compared — the page has four and
 * without this they're indistinguishable.
 */
export function trackSignupOpened(location: string): void {
  void withAnalytics((instance, logEvent) => {
    logEvent(instance, "signup_opened", { location });
  });
}

/**
 * A store account was actually created. `sign_up` is GA4's own recommended
 * event name rather than a custom one, so it lands in the built-in reports
 * instead of needing a custom definition.
 */
export function trackSignupCompleted(): void {
  void withAnalytics((instance, logEvent) => {
    logEvent(instance, "sign_up", { method: "password" });
  });
}
