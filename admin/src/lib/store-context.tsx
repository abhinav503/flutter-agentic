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

type StoreContextValue = {
  // First storeId this owner manages. MVP is single-store-per-owner; a
  // switcher for storeIds.length > 1 is a later milestone.
  storeId: string | null;
  storeName: string | null;
  loading: boolean;
  createStore: (name: string) => Promise<void>;
};

const StoreContext = createContext<StoreContextValue | null>(null);

export function StoreProvider({ children }: { children: ReactNode }) {
  const { user } = useAuth();
  const [storeId, setStoreId] = useState<string | null>(null);
  const [storeName, setStoreName] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  // Reset derived state synchronously during render when the signed-in
  // user changes — React's documented alternative to an effect-based
  // reset (see "Adjusting state when a prop changes"). Keeps both effects
  // below to pure subscribe/setState-in-callback, nothing set synchronously
  // in the effect body itself.
  const uid = user?.uid ?? null;
  const [lastUid, setLastUid] = useState<string | null>(uid);
  if (uid !== lastUid) {
    setLastUid(uid);
    setStoreId(null);
    setStoreName(null);
    setLoading(uid !== null);
  }

  useEffect(() => {
    if (!user) return;
    return onSnapshot(doc(db, "admins", user.uid), (snap) => {
      const storeIds = (snap.data()?.storeIds as string[] | undefined) ?? [];
      setStoreId(storeIds[0] ?? null);
      setLoading(false);
    });
  }, [user]);

  useEffect(() => {
    if (!storeId) return;
    return onSnapshot(doc(db, "stores", storeId), (snap) => {
      setStoreName((snap.data()?.name as string | undefined) ?? null);
    });
  }, [storeId]);

  // Goes through POST /api/stores (not direct Firestore writes) because
  // ownership lives in a `storeIds` custom claim only the server can stamp.
  // The onSnapshot watch above picks up the server's admins-doc write; the
  // force-refresh pulls the new claim into this session's ID token so API
  // calls guarded by requireStoreOwner work immediately, not after ≤1h.
  async function createStore(name: string) {
    if (!user) throw new Error("Not signed in");
    const token = await user.getIdToken();
    const response = await fetch("/api/stores", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({ name }),
    });
    if (!response.ok) {
      const body = await response.json().catch(() => ({}));
      throw new Error(body.error ?? "Failed to create store");
    }
    await user.getIdToken(true);
  }

  return (
    <StoreContext.Provider value={{ storeId, storeName, loading, createStore }}>
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
