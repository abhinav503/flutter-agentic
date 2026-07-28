import {
  collection,
  doc,
  addDoc,
  updateDoc,
  deleteDoc,
  onSnapshot,
  getDocs,
  serverTimestamp,
  type QueryDocumentSnapshot,
} from "firebase/firestore";
import { db } from "./firebase";
import type { Banner, BannerTargetType } from "./types";

function bannersRef(storeId: string) {
  return collection(db, "stores", storeId, "banners");
}

function mapBannerDoc(d: QueryDocumentSnapshot): Banner {
  const data = d.data();
  return {
    id: d.id,
    imageUrl: (data.imageUrl as string) ?? "",
    title: (data.title as string) ?? "",
    subtitle: (data.subtitle as string) ?? "",
    targetType: (data.targetType as BannerTargetType) ?? "none",
    targetId: (data.targetId as string) ?? "",
    sortOrder: (data.sortOrder as number) ?? 0,
    // Defaults true: a banner saved before this flag existed was, in effect,
    // live — treating a missing field as hidden would silently blank a
    // storefront's carousel.
    isActive: (data.isActive as boolean) ?? true,
  };
}

// Title breaks ties so the order can't shuffle between reads when an admin
// leaves several banners at the same position.
function bySortOrder(a: Banner, b: Banner) {
  return a.sortOrder - b.sortOrder || a.title.localeCompare(b.title);
}

export function watchBanners(
  storeId: string,
  onChange: (banners: Banner[]) => void,
) {
  return onSnapshot(bannersRef(storeId), (snap) => {
    onChange(snap.docs.map(mapBannerDoc).sort(bySortOrder));
  });
}

// One-shot fetch (vs. watchBanners' live listener) — for server contexts
// like API routes that don't hold a subscription open.
export async function getBanners(storeId: string): Promise<Banner[]> {
  const snap = await getDocs(bannersRef(storeId));
  return snap.docs.map(mapBannerDoc).sort(bySortOrder);
}

export async function addBanner(storeId: string, data: Omit<Banner, "id">) {
  await addDoc(bannersRef(storeId), { ...data, createdAt: serverTimestamp() });
}

export async function updateBanner(
  storeId: string,
  id: string,
  data: Omit<Banner, "id">,
) {
  await updateDoc(doc(db, "stores", storeId, "banners", id), {
    ...data,
    updatedAt: serverTimestamp(),
  });
}

export async function deleteBanner(storeId: string, id: string) {
  await deleteDoc(doc(db, "stores", storeId, "banners", id));
}
