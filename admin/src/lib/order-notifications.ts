import { adminDb } from "./firebase-admin";
import { sendNotification } from "./push";
import type { NotificationKind, Order, OrderStatus } from "./types";

/**
 * The notifications an order sends itself.
 *
 * Composed on the server because the events are server-side: the shopper who
 * needs to hear "delivered" is by definition not the person who pressed the
 * button. That creates the one problem this file exists to solve —
 * **server-authored copy can't be localized by the app**, and printing
 * English into a Hindi or German storefront is exactly the trap
 * docs/how-to/add-language-pack.md warns about.
 *
 * So the copy is written per language here and picked by the **store's**
 * language. That is the best available answer, not a perfect one: a shopper
 * who overrode the language on their own device (see cordelia's
 * StoreLocalePrefs) still gets the store's default, because nothing
 * server-side knows about an on-device override.
 */

type Copy = { title: string; message: string };
type Event = "placed" | "onTheWay" | "delivered" | "cancelled";

// Kept deliberately short: these render as a push banner first and a
// two-line row in the notification centre second. Neither has room for a
// sentence, and neither interpolates an amount — a currency figure in a
// translated string is its own trap.
const COPY: Record<string, Record<Event, Copy>> = {
  en: {
    placed: { title: "Order placed", message: "Thanks! Your order has been placed." },
    onTheWay: { title: "Order on the way", message: "Your order is out for delivery." },
    delivered: { title: "Order delivered", message: "Your order has been delivered. Enjoy!" },
    cancelled: { title: "Order cancelled", message: "Your order was cancelled. Any payment is being refunded." },
  },
  hi: {
    placed: { title: "ऑर्डर हो गया", message: "धन्यवाद! आपका ऑर्डर दर्ज हो गया है।" },
    onTheWay: { title: "ऑर्डर रास्ते में है", message: "आपका ऑर्डर डिलीवरी के लिए निकल चुका है।" },
    delivered: { title: "ऑर्डर पहुँच गया", message: "आपका ऑर्डर डिलीवर हो गया है।" },
    cancelled: { title: "ऑर्डर रद्द हुआ", message: "आपका ऑर्डर रद्द कर दिया गया है। भुगतान वापस किया जा रहा है।" },
  },
  de: {
    placed: { title: "Bestellung aufgegeben", message: "Danke! Ihre Bestellung ist eingegangen." },
    onTheWay: { title: "Bestellung unterwegs", message: "Ihre Bestellung ist in Zustellung." },
    delivered: { title: "Bestellung zugestellt", message: "Ihre Bestellung wurde zugestellt." },
    cancelled: { title: "Bestellung storniert", message: "Ihre Bestellung wurde storniert. Die Zahlung wird erstattet." },
  },
  fr: {
    placed: { title: "Commande passée", message: "Merci ! Votre commande a bien été enregistrée." },
    onTheWay: { title: "Commande en route", message: "Votre commande est en cours de livraison." },
    delivered: { title: "Commande livrée", message: "Votre commande a été livrée." },
    cancelled: { title: "Commande annulée", message: "Votre commande a été annulée. Le paiement est remboursé." },
  },
  es: {
    placed: { title: "Pedido realizado", message: "¡Gracias! Hemos recibido tu pedido." },
    onTheWay: { title: "Pedido en camino", message: "Tu pedido está en reparto." },
    delivered: { title: "Pedido entregado", message: "Tu pedido ha sido entregado." },
    cancelled: { title: "Pedido cancelado", message: "Tu pedido se ha cancelado. El pago se está reembolsando." },
  },
  it: {
    placed: { title: "Ordine effettuato", message: "Grazie! Il tuo ordine è stato registrato." },
    onTheWay: { title: "Ordine in arrivo", message: "Il tuo ordine è in consegna." },
    delivered: { title: "Ordine consegnato", message: "Il tuo ordine è stato consegnato." },
    cancelled: { title: "Ordine annullato", message: "Il tuo ordine è stato annullato. Il pagamento verrà rimborsato." },
  },
};

// The kind picks the glyph each storefront template draws. There is no
// "cancelled" kind and adding one would mean touching all three packs' glyph
// maps — `payment` is the honest stand-in, since a cancellation is a refund
// from the shopper's side.
const KINDS: Record<Event, NotificationKind> = {
  placed: "orderPlaced",
  onTheWay: "orderPlaced",
  delivered: "orderDelivered",
  cancelled: "payment",
};

// Read straight off the store doc rather than through lib/stores.ts, which
// uses the client SDK: these run inside API routes that already hold an
// Admin SDK connection, and the store doc is one field away.
async function storeLanguage(storeId: string): Promise<string> {
  try {
    const snap = await adminDb.collection("stores").doc(storeId).get();
    const language = snap.data()?.language as string | undefined;
    return language && language in COPY ? language : "en";
  } catch {
    return "en";
  }
}

/**
 * Sends an order event to the shopper who placed it.
 *
 * Never throws and never returns a failure: a notification is a side effect
 * of an order transition, and an order that was genuinely placed, delivered
 * or cancelled must not report failure because a push didn't go out.
 */
async function notify(order: Order, event: Event): Promise<void> {
  try {
    // Orders outlive the accounts that placed them — they are the store's
    // sales record, so closing an account deliberately keeps them (see
    // lib/account.ts). Advancing one of those orders must not write fresh
    // personal data back under a uid that no longer exists: Firestore will
    // happily create `users/{uid}/notifications` beneath a missing parent
    // doc, and nothing would ever delete it again.
    const account = await adminDb.collection("users").doc(order.uid).get();
    if (!account.exists) return;

    const language = await storeLanguage(order.storeId);
    const copy = (COPY[language] ?? COPY.en)[event];

    await sendNotification(
      { scope: "user", uid: order.uid, storeId: order.storeId },
      {
        kind: KINDS[event],
        title: copy.title,
        message: copy.message,
        // No artwork: an order update is functional, and any image would
        // have to be a product shot the whole basket doesn't have.
        imageUrl: "",
      },
      // Authored by the platform on the order's behalf — there is no admin
      // pressing a button for "placed", and attributing it to the store
      // owner would be untrue for a shopper's own cancellation.
      "system",
    );
  } catch (error) {
    console.error(`Order notification (${event}) failed`, error);
  }
}

export const notifyOrderPlaced = (order: Order) => notify(order, "placed");
export const notifyOrderCancelled = (order: Order) => notify(order, "cancelled");

/**
 * Only the two transitions a shopper cares about produce a notification.
 * `PENDING` is where an order starts (covered by "placed"), and `CANCELLED`
 * arrives through the cancel route, which sends its own.
 */
export async function notifyOrderStatusChanged(
  order: Order,
  status: OrderStatus,
): Promise<void> {
  if (status === "IN_PROCESS") return notify(order, "onTheWay");
  if (status === "DELIVERED") return notify(order, "delivered");
}
