"use client";

// Chrome DevTools' own device-emulation mode does this automatically — once
// you pick a device viewport, real mouse input gets synthesized as touch.
// Our phone frame (device-frame.tsx) is a hand-rolled CSS emulation, not real
// DevTools device mode, so it doesn't get that translation for free.
//
// Flutter's web engine keys scroll-drag eligibility off
// `PointerEvent.pointerType`: Material's default `ScrollBehavior` only lists
// touch/stylus in `dragDevices`, not mouse — intentional for a real desktop
// site (mouse users scroll by wheel, not click-drag). But the whole point of
// this preview is to emulate a *mobile* device, where click-drag standing in
// for a finger swipe is exactly what should happen. Without this, dragging
// with the mouse in the phone-frame preview does nothing, because the
// browser's real hardware is a mouse and Flutter sees `pointerType: "mouse"`.
//
// Attach this to the iframe's `onLoad` (re-fires each reload since the
// preview iframe is re-keyed, so there's no stale-document cleanup to chase).
// Only wire it up outside "fill" mode — a `previewMode === "fill"` view is
// meant to represent how the app looks on a real desktop browser, where
// native (non-drag) mouse-wheel scrolling is the *correct* behaviour to keep.
export function attachTouchEmulation(
  iframe: HTMLIFrameElement,
): (() => void) | undefined {
  let doc: Document;
  let win: (Window & typeof globalThis) | null;
  try {
    doc = iframe.contentDocument!;
    win = iframe.contentWindow as (Window & typeof globalThis) | null;
  } catch {
    return; // cross-origin — emulation unavailable
  }
  if (!doc || !win || !("PointerEvent" in win)) return;

  const redispatch = (type: string, e: PointerEvent, buttons: number) => {
    const target = doc.elementFromPoint(e.clientX, e.clientY);
    target?.dispatchEvent(
      new win!.PointerEvent(type, {
        bubbles: true,
        cancelable: true,
        clientX: e.clientX,
        clientY: e.clientY,
        screenX: e.screenX,
        screenY: e.screenY,
        pointerId: 1,
        pointerType: "touch",
        isPrimary: true,
        buttons,
        view: win!,
      }),
    );
  };

  // Only translate real mouse input — leave touch/pen (a real touchscreen
  // testing the console directly) completely alone, they already work.
  const onDown = (e: PointerEvent) => {
    if (e.pointerType !== "mouse") return;
    e.stopImmediatePropagation();
    e.preventDefault();
    redispatch("pointerdown", e, 1);
  };
  const onMove = (e: PointerEvent) => {
    if (e.pointerType !== "mouse" || e.buttons === 0) return;
    e.stopImmediatePropagation();
    e.preventDefault();
    redispatch("pointermove", e, 1);
  };
  const onUp = (e: PointerEvent) => {
    if (e.pointerType !== "mouse") return;
    e.stopImmediatePropagation();
    e.preventDefault();
    redispatch("pointerup", e, 0);
  };

  // Capture phase, directly on the iframe's own document — same-origin
  // access (via the preview-proxy) lets us reach in from the parent, same as
  // EditOverlay's getDoc(). Capturing ahead of Flutter's own listeners is
  // what lets stopImmediatePropagation actually suppress the mouse-typed
  // event before the engine ever sees it.
  doc.addEventListener("pointerdown", onDown, true);
  doc.addEventListener("pointermove", onMove, true);
  doc.addEventListener("pointerup", onUp, true);
  doc.addEventListener("pointercancel", onUp, true);

  return () => {
    doc.removeEventListener("pointerdown", onDown, true);
    doc.removeEventListener("pointermove", onMove, true);
    doc.removeEventListener("pointerup", onUp, true);
    doc.removeEventListener("pointercancel", onUp, true);
  };
}
