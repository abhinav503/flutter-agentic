import { ref, uploadBytes, getDownloadURL } from "firebase/storage";
import { storage } from "./firebase";

// Path convention matches storage.rules: {storeId}/categories/** and
// {storeId}/products/** are the only writable prefixes (owner-gated there).
export async function uploadCatalogImage(
  storeId: string,
  kind: "categories" | "products",
  file: File,
): Promise<string> {
  const extension = file.name.split(".").pop() || "jpg";
  const path = `${storeId}/${kind}/${crypto.randomUUID()}.${extension}`;
  const imageRef = ref(storage, path);
  await uploadBytes(imageRef, file);
  return getDownloadURL(imageRef);
}
