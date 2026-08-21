# Verify payments end to end

The release check for anything touching checkout, refunds or stock. Store
owners have their own, much shorter version in the merchant docs
(`payments/payment-flows`) — this is the engineering one, and several of its
steps deliberately break a working store, so run them against a **test-key**
store you own.

Nothing here needs a superadmin: a store owner account with test keys and a
phone is the whole rig.

## What can be checked without a device

```bash
cd admin
npm run verify:razorpay   # RAZORPAY_KEY_ID / RAZORPAY_KEY_SECRET (test keys)
npm run verify:stripe     # STRIPE_PK / STRIPE_SK (test keys)
npm run test:webhook      # WEBHOOK_SECRET, against a running dev server
```

- **verify:razorpay** — order creation, all four signature cases (correct,
  tampered, wrong order id, wrong secret), verification refusing a payment id
  that doesn't exist, and webhook signatures. It refuses to run against live
  keys.
- **verify:stripe** — the same shape plus a real confirm-with-test-card pass,
  since Stripe *can* be paid over the API. This is why Stripe's amount
  comparison is covered here and Razorpay's is not.
- **test:webhook** — the Razorpay refund webhook's signature handshake against
  a running server: valid accepted, tampered/missing/wrong-secret rejected.
  Non-destructive unless `PAYMENT_ID` is set.

Neither provider script can cover the two things that need a human paying: the
amount comparison against a genuinely paid Razorpay payment, and the capture of
an authorized one.

## The device passes

### 1. The ordinary order

Test keys, a real phone, the provider's test card. An order appears in the
console within a second of the sheet closing, stock comes down, the cart
empties, and the shopper gets a notification.

### 2. Wrong keys → refunded, not stranded

Change one character of the store's key **secret** in Settings, save, and pay
again.

- No order is written.
- The shopper is told, in their storefront's language.
- The payment is refunded automatically.
- **Orders → Payments without orders** grows a row reading *"Payment didn't
  verify — check your keys"*.

Put the real secret back afterwards.

### 3. Sold out mid-payment

The race the whole stock feature exists for, and the only way to reach it on
purpose:

1. On the phone, add a product to the cart and tap through to the payment
   sheet — but don't complete it.
2. In the console, set that product's stock to `0`.
3. Complete the payment.

Expected: no order, the payment refunded, and a message that **names the
product** in the storefront's language (not the server's English "Insufficient
stock for X"). The cart row corrects itself to *Out of Stock* on return.

### 4. Held card capture (Razorpay only)

The one branch nothing else reaches. In the store's Razorpay dashboard set
**Payment Capture** to manual, then place a normal test card order.

Expected: the order still lands. The server captures the authorized payment
after checking it is for this exact cart. Set the account back to automatic
afterwards.

If this regresses, the symptom is a checkout that fails only for card payments
and only on some stores — UPI, netbanking and wallets arrive captured and are
unaffected.

### 5. Cancel and refund

Cancel a paid test order from the console, and another from the app. Both
restock and start a refund. Razorpay sits at **Pending** until its webhook
lands (so this also proves the webhook is configured); Stripe usually completes
immediately.

## Stock display, without any payment

Faster than a checkout, and worth running after any pack change:

| Set stock to | Expect on card, product details, and cart |
|---|---|
| `0` | faded image, *Out of Stock*, add control disabled |
| `3` | *Only 3 left*, quantity picker stops at 3 |
| `10` | nothing — the ordinary state |
| unset (older API) | nothing, and the product stays buyable |

Change stock in the console while a cart sits open on the phone, then reopen
the Cart screen: the row corrects itself, because opening Cart and opening
Checkout both re-read the cart from the server.

Run this on **all three templates** — gravia, dailymart and grofast each render
the sold-out and low-stock states in their own recipe.

## What to check in Firestore afterwards

- `stores/{id}/orphanedPayments/{paymentId}` — one record per failed checkout,
  with `reason`, `refundStatus` and the refunded amount. A retried checkout
  updates the same record rather than adding a second.
- The record's `refundStatus` flips `PENDING → PROCESSED` when the provider's
  refund webhook lands, the same as an order's.
