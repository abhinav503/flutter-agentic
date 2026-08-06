"use client";

import {
  createContext,
  useContext,
  useEffect,
  useRef,
  useState,
  type ReactNode,
} from "react";
import { doc, onSnapshot, type DocumentSnapshot } from "firebase/firestore";
import { db } from "./firebase";
import { useAuth } from "./auth-context";
import type { User } from "firebase/auth";

export type StoreSummary = {
  id: string;
  name: string;
};

type StoreContextValue = {
  /** Every store this admin owns, in `admins/{uid}.storeIds` order. */
  stores: StoreSummary[];
  /** The store the dashboard is currently managing (null until one exists). */
  storeId: string | null;
  storeName: string | null;
  /**
   * What the active store charges in — every money figure in the dashboard
   * renders against this (see lib/money.ts). Defaults to INR while the store
   * doc is still loading and for stores predating the field, which is what
   * they were already charging.
   */
  storeCurrency: string;
  /**
   * The storefront's language. Rides the same store-doc snapshot as the
   * currency, so it costs no extra read — and it is the only thing that can
   * tell a French store from a German one, since both charge in euros.
   */
  storeLanguage: string;
  loading: boolean;
  selectStore: (storeId: string) => void;
  createStore: (
    name: string,
    templateId: string,
    language: string,
    currency: string,
  ) => Promise<string>;
};

const StoreContext = createContext<StoreContextValue | null>(null);

// Which store the dashboard was last managing, per admin — so a refresh (or
// a sign-out/in on the same machine) reopens the same store instead of
// snapping back to the first one.
function selectionKey(uid: string) {
  return `cordelia-admin-selected-store:${uid}`;
}

// A sign-up that created the Auth account but failed the admins-doc write
// leaves a record missing the fields nothing else can put back — see
// POST /api/admins/ensure, which is the only writer able to repair one.
// `createdAt` is deliberately not checked: the route won't backfill it onto
// an existing doc, so requiring it here would re-request a heal forever.
function isAdminRecordComplete(snap: DocumentSnapshot): boolean {
  if (!snap.exists()) return false;
  const data = snap.data() ?? {};
  return Boolean(data.email) && Boolean(data.role) && Array.isArray(data.storeIds);
}

async function healAdminRecord(user: User) {
  const token = await user.getIdToken();
  await fetch("/api/admins/ensure", {
    method: "POST",
    headers: { Authorization: `Bearer ${token}` },
  });
}

export function StoreProvider({ children }: { children: ReactNode }) {
  const { user } = useAuth();
  const [storeIds, setStoreIds] = useState<string[]>([]);
  const [names, setNames] = useState<Record<string, string>>({});
  const [currencies, setCurrencies] = useState<Record<string, string>>({});
  const [languages, setLanguages] = useState<Record<string, string>>({});
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const healAttemptedFor = useRef<string | null>(null);

  // Reset derived state synchronously during render when the signed-in
  // user changes — React's documented alternative to an effect-based
  // reset (see "Adjusting state when a prop changes"). Keeps the effects
  // below to pure subscribe/setState-in-callback, nothing set synchronously
  // in the effect body itself.
  const uid = user?.uid ?? null;
  const [lastUid, setLastUid] = useState<string | null>(uid);
  if (uid !== lastUid) {
    setLastUid(uid);
    setStoreIds([]);
    setNames({});
    setCurrencies({});
    setLanguages({});
    setSelectedId(null);
    setLoading(uid !== null);
  }

  useEffect(() => {
    if (!user) return;
    return onSnapshot(doc(db, "admins", user.uid), (snap) => {
      // The snapshot already answers "is this record intact?", so the normal
      // case costs no extra read — and the repair is attempted once per
      // session, not per snapshot, since the write itself fires this callback
      // again and a failing route would otherwise retry in a loop.
      if (!isAdminRecordComplete(snap) && healAttemptedFor.current !== user.uid) {
        healAttemptedFor.current = user.uid;
        void healAdminRecord(user).catch(() => {
          // Nothing to show the user: they can still work, and the next load
          // gets another attempt. Left silent rather than surfacing a toast
          // about a record they don't know exists.
        });
      }

      const ids = (snap.data()?.storeIds as string[] | undefined) ?? [];
      setStoreIds(ids);
      // Keep the selection valid against the fresh list: restore the
      // persisted pick when it still exists, otherwise fall back to the
      // first store (covers first load, a deleted store, and an account
      // whose persisted pick belongs to a different machine's state).
      setSelectedId((current) => {
        if (current && ids.includes(current)) return current;
        const persisted = localStorage.getItem(selectionKey(user.uid));
        if (persisted && ids.includes(persisted)) return persisted;
        return ids[0] ?? null;
      });
      setLoading(false);
    });
  }, [user]);

  // One listener per owned store — N is small (an admin owns a handful of
  // stores at most) and the switcher should reflect a rename made in Settings
  // without a reload. The same snapshot carries the currency, so money
  // formatting costs no extra read and re-renders when Settings changes it.
  useEffect(() => {
    if (storeIds.length === 0) return;
    const unsubscribes = storeIds.map((id) =>
      onSnapshot(doc(db, "stores", id), (snap) => {
        const data = snap.data();
        const name = (data?.name as string | undefined) ?? "";
        const currency = (data?.currency as string | undefined) ?? "INR";
        const language = (data?.language as string | undefined) ?? "en";
        setNames((current) =>
          current[id] === name ? current : { ...current, [id]: name },
        );
        setCurrencies((current) =>
          current[id] === currency ? current : { ...current, [id]: currency },
        );
        setLanguages((current) =>
          current[id] === language ? current : { ...current, [id]: language },
        );
      }),
    );
    return () => unsubscribes.forEach((unsubscribe) => unsubscribe());
  }, [storeIds]);

  function selectStore(storeId: string) {
    if (!storeIds.includes(storeId)) return;
    setSelectedId(storeId);
    if (user) localStorage.setItem(selectionKey(user.uid), storeId);
  }

  // Goes through POST /api/stores (not direct Firestore writes) because
  // ownership lives in a `storeIds` custom claim only the server can stamp.
  // The onSnapshot watch above picks up the server's admins-doc write; the
  // force-refresh pulls the new claim into this session's ID token so API
  // calls guarded by requireStoreOwner work immediately, not after ≤1h.
  // Returns the new store's id and switches the dashboard to it.
  async function createStore(
    name: string,
    templateId: string,
    language: string,
    currency: string,
  ) {
    if (!user) throw new Error("Not signed in");
    const token = await user.getIdToken();
    const response = await fetch("/api/stores", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({ name, templateId, language, currency }),
    });
    if (!response.ok) {
      const body = await response.json().catch(() => ({}));
      throw new Error(body.error ?? "Failed to create store");
    }
    const { storeId } = (await response.json()) as { storeId: string };
    await user.getIdToken(true);
    // Not selectStore(): the admins-doc snapshot carrying the new id may
    // not have landed yet, and the guard there would drop the switch.
    setSelectedId(storeId);
    localStorage.setItem(selectionKey(user.uid), storeId);
    return storeId;
  }

  const stores: StoreSummary[] = storeIds.map((id) => ({
    id,
    name: names[id] ?? "",
  }));
  const storeId = selectedId;
  const storeName = storeId ? (names[storeId] ?? null) : null;
  const storeCurrency = (storeId ? currencies[storeId] : null) ?? "INR";
  const storeLanguage = (storeId ? languages[storeId] : null) ?? "en";

  return (
    <StoreContext.Provider
      value={{
        stores,
        storeId,
        storeName,
        storeCurrency,
        storeLanguage,
        loading,
        selectStore,
        createStore,
      }}
    >
      {children}
    </StoreContext.Provider>
  );
}

export function useStore() {
  const context = useContext(StoreContext);
  if (!context) {
    throw new Error("useStore must be used within a StoreProvider");
  }
  return context;
}
