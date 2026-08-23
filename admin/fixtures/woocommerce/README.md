WooCommerce core's own `sample_products.csv` (plugins/woocommerce/sample-data
in github.com/woocommerce/woocommerce) — the file WooCommerce's importer and
exporter are tested against, in the Products → Export column layout. Used to
exercise the `format=woocommerce` import: 25 rows → 14 products; two
`variable` parents with `variation` rows keyed by Parent SKU (one with an
attribute left "Any"), `Clothing > …` category paths, sale vs regular prices,
multi-image cells, attributes on simple products, and grouped / external /
virtual rows that must be skipped.
