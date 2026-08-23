import {
  collection,
  getDocs,
  type QueryDocumentSnapshot,
  type FirestoreError,
} from "firebase/firestore";

import { watchQuery } from "./watch";
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
    backgroundColor: (data.backgroundColor as string) ?? "",
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
  onError?: (error: FirestoreError) => void,
) {
  return watchQuery(bannersRef(storeId), (snap) => snap.docs.map(mapBannerDoc).sort(bySortOrder), onChange, onError);
}

// One-shot fetch (vs. watchBanners' live listener) — for server contexts
// like API routes that don't hold a subscription open.
export async function getBanners(storeId: string): Promise<Banner[]> {
  const snap = await getDocs(bannersRef(storeId));
  return snap.docs.map(mapBannerDoc).sort(bySortOrder);
}



