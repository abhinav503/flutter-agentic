// The scope vocabulary, on its own so the console (a client bundle) can list
// it without pulling in the Admin SDK that api-tokens.ts needs.
export const API_TOKEN_SCOPES = [
  "catalog:write",
  "store:publish",
  "orders:read",
] as const;
export type ApiTokenScope = (typeof API_TOKEN_SCOPES)[number];

export const API_TOKEN_SCOPE_LABELS: Record<ApiTokenScope, string> = {
  "catalog:write":
    "Create and update products, categories, brands, coupons and banners",
  "store:publish": "Submit the store for review",
  "orders:read": "Read orders",
};
