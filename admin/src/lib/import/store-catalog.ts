import type { Brand, Category, Product } from "@/lib/types";
import { matchKey } from "./csv-core";

/**
 * The store's current contents, as every importer sees them — plus the two
 * rules that decide what a *sample* may put in its linking columns.
 *
 * A downloaded sample must import cleanly into the store that downloaded it.
 * The first version of this feature failed that: its category and brand
 * columns named a hardcoded Indian catalog, so on any store without those
 * exact names every row errored. Resolving the columns against the live
 * catalog is the fix, and it lives here because products, banners and coupons
 * all need the same three-case answer.
 */
export class StoreCatalog {
  readonly products: Product[];
  readonly categories: Category[];
  readonly brands: Brand[];

  private readonly categoryNames: Set<string>;
  private readonly brandNames: Set<string>;

  constructor(input: {
    products: Product[];
    categories: Category[];
    brands: Brand[];
  }) {
    this.products = input.products;
    this.categories = input.categories;
    this.brands = input.brands;
    this.categoryNames = new Set(input.categories.map((c) => matchKey(c.name)));
    this.brandNames = new Set(input.brands.map((b) => matchKey(b.name)));
  }

  hasCategory(name: string): boolean {
    return this.categoryNames.has(matchKey(name));
  }

  hasProduct(name: string): boolean {
    return this.products.some((p) => matchKey(p.name) === matchKey(name));
  }

  /**
   * Which category names a sample row may claim:
   * - a seed category the store actually has → used, demonstrating the column;
   * - none match but the store has categories → its first, so the row still
   *   shows what linking looks like;
   * - the store has none → empty, which imports fine (the column is optional).
   */
  linkableCategories(preferred: string[]): string[] {
    const usable = preferred.filter((name) => this.hasCategory(name));
    if (usable.length > 0) return usable;
    return this.categories.length > 0 ? [this.categories[0].name] : [];
  }

  /** `linkableCategories`' single-value twin, for the brand column. */
  linkableBrand(preferred: string | undefined): string {
    if (preferred && this.brandNames.has(matchKey(preferred))) return preferred;
    return this.brands[0]?.name ?? "";
  }
}
