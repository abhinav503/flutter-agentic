"use client";

import { useCallback, useEffect, useRef, useState, useSyncExternalStore } from "react";
import { PhoneFrame } from "./PhoneMockup";

const REDUCED_MOTION = "(prefers-reduced-motion: reduce)";

function subscribeToReducedMotion(onChange: () => void) {
  const query = window.matchMedia(REDUCED_MOTION);
  query.addEventListener("change", onChange);
  return () => query.removeEventListener("change", onChange);
}

/**
 * A storefront recording playing inside the same device frame the CSS
 * mockups use.
 *
 * The loading story, which is most of what this component is:
 *
 * 1. **Nothing is fetched until you scroll to it.** The `<video>` carries no
 *    `src` until the card nears the viewport, so a visitor who never reaches
 *    the templates section pays nothing for a multi-megabyte demo. The
 *    poster — tens of kilobytes — holds the frame until then.
 * 2. **Playback waits for a buffer.** Once the source is attached the video
 *    loads but stays on its poster; it only starts on `canplaythrough`, the
 *    point at which the browser expects to reach the end without stalling.
 *    Starting at the first decoded frame instead would open the demo with a
 *    stutter, which is a worse first impression than a moment's wait.
 * 3. **It plays only while on screen**, pausing the moment it scrolls away.
 *
 * Two more: `prefers-reduced-motion` gets the poster and controls rather
 * than playback starting on its own, and the frame's fixed aspect ratio
 * means poster, spinner and video all occupy the same box — no layout shift
 * at any stage.
 */
export function PhoneVideo({
  src,
  poster,
  label,
  loop = true,
  controls = false,
}: {
  src: string;
  poster: string;
  /** What the recording shows — this is content, not decoration. */
  label: string;
  /** Off for a long walkthrough; on for a short ambient clip. */
  loop?: boolean;
  /** On for anything long enough that a visitor may want to scrub or pause. */
  controls?: boolean;
}) {
  const videoRef = useRef<HTMLVideoElement>(null);
  // Whether the card is on screen *right now* — read inside the readiness
  // handler, which fires on its own schedule long after the observer did.
  const onScreenRef = useRef(false);

  // Once true it stays true: a video that has loaded shouldn't be torn down
  // and re-fetched every time it leaves the viewport.
  const [shouldLoad, setShouldLoad] = useState(false);
  const [buffered, setBuffered] = useState(false);

  const reducedMotion = useSyncExternalStore(
    subscribeToReducedMotion,
    () => window.matchMedia(REDUCED_MOTION).matches,
    // Server render: assume motion is fine, then correct on hydration.
    () => false,
  );

  // A rejected play() is normal (autoplay policy, a backgrounded tab) and
  // never worth surfacing — the poster simply stays put.
  const playIfWanted = useCallback(() => {
    if (reducedMotion || !onScreenRef.current) return;
    void videoRef.current?.play().catch(() => {});
  }, [reducedMotion]);

  useEffect(() => {
    const video = videoRef.current;
    if (!video) return;

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (!entry) return;
        onScreenRef.current = entry.isIntersecting;

        if (entry.isIntersecting) {
          // Attaching the source is what makes the fetch lazy — the browser
          // starts pulling bytes only from here.
          setShouldLoad(true);
          playIfWanted();
        } else {
          video.pause();
        }
      },
      // Fires just before the card arrives, so the buffer has a head start
      // on the scroll rather than beginning when it lands.
      { threshold: 0.1, rootMargin: "200px 0px" },
    );

    observer.observe(video);
    return () => observer.disconnect();
  }, [playIfWanted]);

  useEffect(() => {
    const video = videoRef.current;
    if (!video || !shouldLoad) return;

    const onReady = () => {
      setBuffered(true);
      playIfWanted();
    };

    // HAVE_ENOUGH_DATA already: a cached revisit can be ready before this
    // listener ever attaches, and the event won't fire again for it.
    if (video.readyState >= 4) {
      onReady();
      return;
    }

    video.addEventListener("canplaythrough", onReady);
    return () => video.removeEventListener("canplaythrough", onReady);
  }, [shouldLoad, playIfWanted]);

  return (
    <PhoneFrame decorative={false} flush>
      <div className="relative h-full w-full">
        <video
          ref={videoRef}
          className="h-full w-full object-cover"
          // No src until the observer fires — see the class doc.
          src={shouldLoad ? src : undefined}
          poster={poster}
          aria-label={label}
          muted
          loop={loop}
          playsInline
          // "none" until the card is near, then buffer properly — the whole
          // point is to arrive with enough data to play through.
          preload={shouldLoad ? "auto" : "none"}
          controls={controls || reducedMotion}
        />
        {/* Buffering: the poster alone would read as a frozen card on a slow
            connection. Gone the moment playback can run through. */}
        {shouldLoad && !buffered && !reducedMotion ? (
          <div
            aria-hidden="true"
            className="pointer-events-none absolute inset-0 flex items-center justify-center"
          >
            <span className="size-8 animate-spin rounded-full border-2 border-white/30 border-t-white/90" />
          </div>
        ) : null}
      </div>
    </PhoneFrame>
  );
}
