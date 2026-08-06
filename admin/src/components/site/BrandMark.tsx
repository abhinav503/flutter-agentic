/**
 * The CordeliaApps swift mark, wherever the brand appears — the marketing nav
 * and footer, and the dashboard sidebar.
 *
 * A plain `<img>` rather than `next/image`: the source is an SVG, so there is
 * no optimisation for next/image to perform, and the mark renders at 32px in
 * every current call site.
 *
 * Decorative in all three, because the word "CordeliaApps" sits beside it in
 * each — announcing it again would repeat the brand name to a screen reader.
 * Pass `aria-hidden={false}` with a label if it ever appears alone.
 */
export function BrandMark({ className = "h-8 w-auto" }: { className?: string }) {
  return (
    // eslint-disable-next-line @next/next/no-img-element -- SVG, nothing to optimise
    <img
      src="/brand/mark.svg"
      alt=""
      aria-hidden="true"
      className={className}
    />
  );
}
