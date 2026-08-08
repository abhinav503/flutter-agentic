import { ref, uploadBytes, getDownloadURL } from "firebase/storage";
import { storage } from "./firebase";

// Path convention matches storage.rules: {storeId}/categories/**,
// {storeId}/products/**, {storeId}/banners/**, {storeId}/brands/**, and
// {storeId}/store/** (profile assets, e.g. the logo) are the only writable
// prefixes (owner-gated there).
export type CatalogImageKind =
  | "categories"
  | "products"
  | "banners"
  | "brands"
  | "store"
  | "notifications";

/**
 * First path segment for CordeliaApps-wide uploads, which belong to no store.
 * storage.rules gates this prefix on the superAdmin claim rather than store
 * ownership. Safe as a literal because store ids are Firestore-generated and
 * can never be the string "platform".
 */
export const PLATFORM_STORAGE_PREFIX = "platform";

export async function uploadCatalogImage(
  storeId: string,
  kind: CatalogImageKind,
  file: File,
): Promise<string> {
  const extension = file.name.split(".").pop() || "jpg";
  const path = `${storeId}/${kind}/${crypto.randomUUID()}.${extension}`;
  const imageRef = ref(storage, path);
  await uploadBytes(imageRef, file);
  return getDownloadURL(imageRef);
}
