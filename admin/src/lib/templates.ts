import { collection, getDocs } from "firebase/firestore";
import { db } from "./firebase";
import type { Template } from "./types";

// One-shot fetch for the create-store dialog's template dropdown —
// world-readable per firestore.rules, seeded via scripts/seed-templates.mjs.
export async function getTemplates(): Promise<Template[]> {
  const snap = await getDocs(collection(db, "templates"));
  return snap.docs.map((d) => ({
    id: d.id,
    name: (d.data().name as string | undefined) ?? d.id,
  }));
}
