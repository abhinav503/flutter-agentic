import type { GrocerySeed } from "@/lib/seed/seed-types";
import type { Category } from "@/lib/types";
import {
  toCsv,
  type ImportColumn,
} from "./csv-core";
import type { StoreCatalog } from "./store-catalog";

export type CategoryInput = Omit<Category, "id" | "createdAtMs">;

export const CATEGORY_COLUMNS: ImportColumn[] = [
  { key: "name", required: true, description: "Category name. Also the match key when `id` is blank." },
  { key: "image_url", required: false, description: "Public https URL of the category tile image." },
  { key: "group_name", required: false, description: "Section it appears under, e.g. \"Grocery & Kitchen\"." },
  { key: "parent", required: false, description: "Name of an existing category this one sits under. Blank = top level." },
  { key: "external_id", required: false, description: "The id your other system (Shopify, ERP) knows this category by." },
  { key: "id", required: false, description: "Existing category id. Present = update that exact category." },
];


/**
 * Categories have no cross-references, so the seed rows import as-is — this is
 * the one sample that is the same whatever the store already holds.
 *
 * Importing it into a store that was seeded from the same market updates those
 * categories rather than duplicating them, because the names match.
 */
export function sampleCategoryCsv(
  seed: GrocerySeed,
  _catalog: StoreCatalog,
  rowLimit = 8,
): string {
  const withImages = seed.categories.filter((c) => c.imageUrl);
  const pool = withImages.length >= rowLimit ? withImages : seed.categories;

  return toCsv(
    CATEGORY_COLUMNS,
    pool.slice(0, rowLimit).map((category) => [
      category.name,
      category.imageUrl,
      category.groupName,
      "", // parent
      "", // external_id
      "", // id
    ]),
  );
}
