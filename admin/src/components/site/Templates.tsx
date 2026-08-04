import { SectionShell, SectionHeading } from "./ui";
import { GraviaMockup, DailymartMockup, GrofastMockup } from "./PhoneMockup";
import { PhoneVideo } from "./PhoneVideo";

/**
 * A card shows a real storefront recording when `video` + `poster` are set,
 * and falls back to its drawn CSS mockup otherwise — so recording one
 * template at a time never leaves a hole in the row.
 *
 * Adding one (grofast is the worked example):
 *   public/videos/<name>.mp4          — H.264 MP4, NOT .mov: Chrome and
 *                                       Firefox won't play QuickTime
 *   public/images/<name>_poster.jpg   — the clip's own first frame
 *
 * Keep clips ~15-20s of one clean flow, silent (they autoplay muted), and
 * well under a megabyte or two — three of these load on the same page. The
 * grofast pair was cut from a 4-minute 194 MB screen recording down to
 * 510 KB with:
 *
 *   ffmpeg -ss 40 -i raw.mov -t 18 -vf "scale=608:-2,fps=30" \
 *     -c:v libx264 -profile:v main -pix_fmt yuv420p -crf 30 -preset slow \
 *     -an -movflags +faststart out.mp4
 */
const templates = [
  {
    name: "gravia",
    tagline: "Premium grocery. Sheet-and-header layout, soft depth.",
    Mockup: GraviaMockup,
    accent: "text-gravia",
    video:
      "https://firebasestorage.googleapis.com/v0/b/corderlia-ecom.appspot.com/o/videos%2Fgravia_demo_video.mp4?alt=media&token=21d83cab-be23-4ad2-a9bd-1c5e5ef4ff00#t=6" as
        | string
        | null,
    poster: "/images/gravia_poster.jpg" as string | null,
  },
  {
    name: "dailymart",
    tagline: "Clean daily-essentials mart. Stacked nav, carded rows.",
    Mockup: DailymartMockup,
    accent: "text-dailymart",
    video:
      "https://firebasestorage.googleapis.com/v0/b/corderlia-ecom.appspot.com/o/videos%2Fdailymart_demo_video.mp4?alt=media&token=4bbcc0d8-8cd1-4135-99e7-2bfae0bd71d2#t=6" as
        | string
        | null,
    poster: "/images/dailymart_poster.jpg" as string | null,
  },
  {
    name: "grofast",
    tagline: "Playful gradient grocery. Domed sheets, staggered grid.",
    Mockup: GrofastMockup,
    accent: "text-grofast",
    // A real recording: home → product details → rate this product. The
    // poster is the clip's own first frame, so nothing jumps when playback
    // starts.
    // The full walkthrough, hosted rather than bundled: megabytes have no
    // business in the deploy, and `PhoneVideo` doesn't fetch a byte until
    // the card scrolls into view.
    //
    // `#t=6` is a media fragment: both recordings open on the shared
    // store-picker screen, which would leave every card sitting at rest on
    // the same image and none of them showing the template they are named
    // after. Six seconds in, each is on its own storefront — and the poster
    // is cut from that exact frame, so nothing jumps when playback starts.
    video:
      "https://firebasestorage.googleapis.com/v0/b/corderlia-ecom.appspot.com/o/videos%2Fgrofast_demo_video.mp4?alt=media&token=4aca8b1c-5135-434d-9d6a-765d77fd5bfb#t=6" as
        | string
        | null,
    poster: "/images/grofast_poster.jpg" as string | null,
  },
];

export function Templates() {
  return (
    <SectionShell id="templates" labelledBy="templates-heading" className="bg-surface-2/60">
      <SectionHeading
        id="templates-heading"
        eyebrow="Templates"
        title="Three premium templates for your grocery app"
        lead="A template restyles the entire shopper experience at runtime — theme, layout, navigation, icons and motion — over the same store data. Switching is one dropdown."
      />

      <div className="mt-14 grid gap-6 md:grid-cols-3">
        {templates.map(({ name, tagline, Mockup, accent, video, poster }) => (
          <article key={name} className="surface-panel flex flex-col rounded-3xl p-6">
            <h3 className={`text-xl font-extrabold tracking-tight ${accent}`}>{name}</h3>
            <p className="mt-2 text-sm leading-6 text-muted-foreground">{tagline}</p>
            <div className="mt-7">
              {video && poster ? (
                <PhoneVideo
                  src={video}
                  poster={poster}
                  label={`A recording of the ${name} storefront running in the CordeliaApps shopper app`}
                  // A full walkthrough, not an ambient clip: give it controls
                  // and let it end rather than restart on a four-minute loop.
                  loop={false}
                  controls
                />
              ) : (
                <Mockup />
              )}
            </div>
            {!video && (
              <p className="mt-6 text-xs text-muted-foreground">
                Illustrative layout — a recording of the {name} storefront goes here.
              </p>
            )}
          </article>
        ))}
      </div>

      <p className="mt-10 max-w-3xl text-sm leading-6 text-muted-foreground">
        Every template implements every shopper screen — no store ever falls back to another
        template&rsquo;s design.
      </p>
    </SectionShell>
  );
}
