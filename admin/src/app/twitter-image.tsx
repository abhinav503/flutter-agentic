/**
 * X/Twitter reads `twitter:image` and only falls back to `og:image` when the
 * former is absent — a fallback that holds today but is not guaranteed. One
 * re-export costs nothing and removes the dependency on it.
 */
export { default, size, contentType, alt } from "./opengraph-image";
