"use client";

import {
  createContext,
  useContext,
  useEffect,
  useState,
  type ReactNode,
} from "react";
import { doc, onSnapshot } from "firebase/firestore";
import { db } from "./firebase";
import { useAuth } from "./auth-context";

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
  loading: boolean;
  selectStore: (storeId: string) => void;
  createStore: (name: string, templateId: string) => Promise<string>;
};

const StoreContext = createContext<StoreContextValue | null>(null);

// Which store the dashboard was last managing, per admin — so a refresh (or
// a sign-out/in on the same machine) reopens the same store instead of
// snapping back to the first one.
function selectionKey(uid: string) {
  return `cordelia-admin-selected-store:${uid}`;
}

export function StoreProvider({ children }: { children: ReactNode }) {
  const { user } = useAuth();
  const [storeIds, setStoreIds] = useState<string[]>([]);
  const [names, setNames] = useState<Record<string, string>>({});
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

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
    setSelectedId(null);
    setLoading(uid !== null);
  }

  useEffect(() => {
    if (!user) return;
    return onSnapshot(doc(db, "admins", user.uid), (snap) => {
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

  // One name listener per owned store — N is small (an admin owns a
  // handful of stores at most) and the switcher should reflect a rename
  // made in Settings without a reload.
  useEffect(() => {
    if (storeIds.length === 0) return;
    const unsubscribes = storeIds.map((id) =>
      onSnapshot(doc(db, "stores", id), (snap) => {
        const name = (snap.data()?.name as string | undefined) ?? "";
        setNames((current) =>
          current[id] === name ? current : { ...current, [id]: name },
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
  async function createStore(name: string, templateId: string) {
    if (!user) throw new Error("Not signed in");
    const token = await user.getIdToken();
    const response = await fetch("/api/stores", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({ name, templateId }),
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

  return (
    <StoreContext.Provider
      value={{ stores, storeId, storeName, loading, selectStore, createStore }}
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
