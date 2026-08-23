Meta Commerce Manager / WhatsApp Business catalog feed, CSV. Meta ships no
downloadable sample file; `meta_catalog_feed.csv` is built from the example
rows in Meta's own catalog reference (developers.facebook.com → Marketing
API → Catalog → Reference: "Example CSV Feed" and "Example CSV Feed —
Commerce"), extended with the same columns to cover what a real WhatsApp
catalog export contains: `item_group_id` variants with `size`/`color`,
`price` as "9.99 INR", `sale_price`, `availability` values, an `out of
stock` item, a `product_type` path, multiple `additional_image_link`s, and
a `status: archived` row that must be skipped.
