Shopify `products_export.csv` samples from Shopify Partners
(github.com/shopifypartners/product-csvs and
shopify-product-csvs-and-images), legacy header dialect. Used to exercise
the `format=shopify` import:

- apparel.csv — 20 products, one with Size variants, no Type (tags only)
- home-and-garden.csv — 20 products, one with variants, "Cost per item" column
- snowdevil.csv — 278 products / 636 rows, two-axis (Size × Color) variants,
  gallery image rows, a draft, and two names the restricted-terms list catches
