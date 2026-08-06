import type { GrocerySeed } from "@/lib/seed/seed-types";
import type { Category } from "@/lib/types";
import {
  eachRow,
  matchKey,
  readCsv,
  toCsv,
  type ImportColumn,
  type ImportPlan,
  type ImportRowError,
} from "./csv-core";
import type { StoreCatalog } from "./store-catalog";

export type CategoryInput = Omit<Category, "id" | "createdAtMs">;

export const CATEGORY_COLUMNS: ImportColumn[] = [
  { key: "name", required: true, description: "Category name. Also the match key when `id` is blank." },
  { key: "image_url", required: false, description: "Public https URL of the category tile image." },
  { key: "group_name", required: false, description: "Section it appears under, e.g. \"Grocery & Kitchen\"." },
  { key: "id", required: false, description: "Existing category id. Present = update that exact category." },
];

// What mapCategoryDoc falls back to, so an imported category with no group
// reads the same as one saved from the form with the field left empty.
const DEFAULT_GROUP = "Uncategorized";

export function buildCategoryPlan(
  csvText: string,
  catalog: StoreCatalog,
): ImportPlan<CategoryInput> {
  const { rows, headerError } = readCsv(csvText, CATEGORY_COLUMNS);
  if (headerError) return { writes: [], errors: [headerError], rowCount: rows.length };

  const errors: ImportRowError[] = [];
  const byId = new Map(catalog.categories.map((c) => [c.id, c]));
  const byName = new Map(catalog.categories.map((c) => [matchKey(c.name), c]));

  const writes = eachRow<CategoryInput>(rows, errors, ({ line, get, fail, identify }) => {
    const name = get("name");
    if (!name) {
      fail("name is required.");
      return;
    }
    if (!identify(name, get("id") || name)) return;

    const explicitId = get("id");
    let kind: "create" | "update" = "create";
    let id: string | undefined;
    if (explicitId) {
      if (!byId.has(explicitId)) {
        fail(`No category with id ${explicitId} in this store.`);
        return;
      }
      kind = "update";
      id = explicitId;
    } else {
      const existing = byName.get(matchKey(name));
      if (existing) {
        kind = "update";
        id = existing.id;
      }
    }

    return {
      line,
      kind,
      id,
      name,
      data: {
        name,
        imageUrl: get("image_url"),
        groupName: get("group_name") || DEFAULT_GROUP,
      },
    };
  });

  return { writes, errors, rowCount: rows.length };
}

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
      "",
    ]),
  );
}
