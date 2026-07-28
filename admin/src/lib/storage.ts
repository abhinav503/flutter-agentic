import { ref, uploadBytes, getDownloadURL } from "firebase/storage";
import { storage } from "./firebase";

// Path convention matches storage.rules: {storeId}/categories/**,
// {storeId}/products/**, {storeId}/banners/**, and {storeId}/store/**
// (profile assets, e.g. the logo) are the only writable prefixes
// (owner-gated there).
export type CatalogImageKind =
  | "categories"
  | "products"
  | "banners"
  | "store";

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
