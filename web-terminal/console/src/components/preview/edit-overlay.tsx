"use client";

import {
  useCallback,
  useEffect,
  useRef,
  useState,
  type RefObject,
} from "react";
import { Check, Code2, X } from "lucide-react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { RocketLoader } from "@/components/ui/rocket-loader";
import {
  getFile,
  getSelectedWidgetSource,
  reloadApp,
  saveFile,
  searchApp,
  setInspectorEnabled,
} from "@/lib/bridge";
import type { SourceTarget } from "@/lib/types";
import { useSelectionStore } from "@/stores/selection-store";
import { useUiStore } from "@/stores/ui-store";
import { cn } from "@/lib/utils";

// A widget picked out of the iframe: its bounds (iframe CSS pixels — the
// overlay shares that coordinate space) and what we could read off it.
interface Candidate {
  x: number;
  y: number;
  w: number;
  h: number;
  label: string;
  text: string | null;
}

const DIALOG_WIDTH = 260;

// Flutter web (CanvasKit) paints to a canvas, so per-widget DOM only exists in
// the accessibility tree. Clicking the hidden "enable accessibility"
// placeholder makes the engine build `flt-semantics` nodes — absolutely
// positioned boxes matching widget bounds, with aria-labels for text.
function enableFlutterSemantics(doc: Document) {
  const placeholder = doc.querySelector("flt-semantics-placeholder");
  placeholder?.dispatchEvent(
    new MouseEvent("click", { bubbles: true, cancelable: true }),
  );
}

// Non-informative containers we never want to select in plain-DOM fallback.
const BORING_TAGS = new Set([
  "html", "body", "canvas", "iframe",
  "flt-glass-pane", "flutter-view", "flt-scene-host", "flt-semantics-host",
]);

function readText(el: Element): string | null {
  const aria = el.getAttribute("aria-label")?.trim();
  if (aria) return aria;
  // Leaf semantics nodes carry their text as textContent; a container's
  // textContent would smash all descendants together, so skip those.
  if (!el.querySelector("flt-semantics")) {
    const text = el.textContent?.trim();
    if (text) return text;
  }
  return null;
}

function toCandidate(el: Element): Candidate {
  const r = el.getBoundingClientRect();
  const text = readText(el);
  const role = el.getAttribute("role");
  return {
    x: r.left,
    y: r.top,
    w: r.width,
    h: r.height,
    label: text ?? role ?? el.tagName.toLowerCase(),
    text,
  };
}

function pickCandidate(doc: Document, x: number, y: number): Candidate | null {
  // Flutter semantics nodes mostly have pointer-events:none, so
  // elementsFromPoint skips them — hit-test their rects geometrically instead
  // and take the smallest (deepest) widget under the pointer.
  let best: Element | null = null;
  let bestArea = Infinity;
  for (const el of doc.querySelectorAll("flt-semantics")) {
    const r = el.getBoundingClientRect();
    if (x < r.left || x > r.right || y < r.top || y > r.bottom) continue;
    const area = r.width * r.height;
    if (area > 0 && area < bestArea) {
      best = el;
      bestArea = area;
    }
  }
  if (best) return toCandidate(best);

  // Plain-DOM fallback for non-Flutter pages in the preview.
  const stack = doc
    .elementsFromPoint(x, y)
    .filter((el) => !BORING_TAGS.has(el.tagName.toLowerCase()))
    .filter((el) => {
      const r = el.getBoundingClientRect();
      return r.width * r.height > 0;
    })
    .sort((a, b) => {
      const ra = a.getBoundingClientRect();
      const rb = b.getBoundingClientRect();
      return ra.width * ra.height - rb.width * rb.height;
    });
  return stack[0] ? toCandidate(stack[0]) : null;
}

// Fullscreen-over-the-iframe inspection layer for edit mode. Hover draws a
// dotted bounding box around the widget under the cursor; click selects it and
// opens a small dialog with a jump-to-code action and — for text widgets — an
// inline text editor that patches the source and hot-restarts the app.
export function EditOverlay({
  iframeRef,
}: {
  iframeRef: RefObject<HTMLIFrameElement | null>;
}) {
  const overlayRef = useRef<HTMLDivElement>(null);
  const [hover, setHover] = useState<Candidate | null>(null);
  const [selected, setSelected] = useState<Candidate | null>(null);
  const [ready, setReady] = useState(false);
  const [draftText, setDraftText] = useState("");
  const [applying, setApplying] = useState(false);
  const [selectedSource, setSelectedSource] = useState<SourceTarget | null>(
    null,
  );
  const [overlaySize, setOverlaySize] = useState({ w: 0, h: 0 });
  // Where the user actually clicked (iframe-layout px). The dialog anchors here
  // rather than to the picked candidate's box — CanvasKit semantics often yield
  // a full-screen node, which would pin the dialog to the top-left corner.
  const [clickPoint, setClickPoint] = useState<{ x: number; y: number } | null>(
    null,
  );

  useEffect(() => {
    const el = overlayRef.current;
    if (!el) return;
    const observer = new ResizeObserver(([entry]) =>
      setOverlaySize({
        w: entry.contentRect.width,
        h: entry.contentRect.height,
      }),
    );
    observer.observe(el);
    return () => observer.disconnect();
  }, []);

  const selectedAppName = useSelectionStore((s) => s.selectedAppName);
  const reloadToken = useSelectionStore((s) => s.reloadToken);
  const openCode = useUiStore((s) => s.openCode);

  // Re-arm the loader the moment a reload is requested (adjust-during-render,
  // React's recommended alternative to resetting state inside an effect).
  const [lastToken, setLastToken] = useState(reloadToken);
  if (reloadToken !== lastToken) {
    setLastToken(reloadToken);
    setReady(false);
    setHover(null);
    setSelected(null);
    setSelectedSource(null);
  }

  const getDoc = useCallback((): Document | null => {
    try {
      return iframeRef.current?.contentDocument ?? null;
    } catch {
      return null; // cross-origin — inspection unavailable
    }
  }, [iframeRef]);

  // Hold the launch loader until the app is inspectable: keep poking the
  // semantics placeholder until the accessibility tree exists. Re-arms on a
  // preview reload (reloadToken). Falls back to "ready" for a non-Flutter page,
  // and after a hard timeout so a stuck boot never traps the user.
  useEffect(() => {
    const start = Date.now();
    const timer = setInterval(() => {
      const doc = getDoc();
      if (!doc || doc.readyState === "loading") return;

      if (doc.querySelector("flt-semantics")) {
        setReady(true);
        clearInterval(timer);
        return;
      }

      // A Flutter app is recognizable from its bootstrap even before it paints,
      // so we don't mistake a mid-boot app for a plain page.
      const looksFlutter = !!doc.querySelector(
        "flutter-view, flt-glass-pane, flt-semantics-placeholder, script[src*='flutter']",
      );
      if (looksFlutter) enableFlutterSemantics(doc);

      const elapsed = Date.now() - start;
      if ((!looksFlutter && elapsed > 3000) || elapsed > 40000) {
        setReady(true);
        clearInterval(timer);
      }
    }, 500);
    return () => clearInterval(timer);
  }, [getDoc, reloadToken]);

  useEffect(() => {
    if (!ready || !selectedAppName) return;
    let cancelled = false;

    setInspectorEnabled(selectedAppName, true).catch(() => {
      if (!cancelled) {
        toast.info("Flutter inspector is not available yet; text lookup still works.");
      }
    });

    return () => {
      cancelled = true;
      setInspectorEnabled(selectedAppName, false).catch(() => undefined);
    };
  }, [ready, selectedAppName]);

  // Overlay pointer position → iframe CSS pixels. The ratio absorbs the
  // device-frame scale() because the overlay's layout size matches the iframe.
  const toIframePoint = (e: React.MouseEvent) => {
    const overlay = overlayRef.current;
    const iframe = iframeRef.current;
    if (!overlay || !iframe) return null;
    const rect = overlay.getBoundingClientRect();
    if (rect.width === 0 || rect.height === 0) return null;
    return {
      x: ((e.clientX - rect.left) / rect.width) * iframe.clientWidth,
      y: ((e.clientY - rect.top) / rect.height) * iframe.clientHeight,
    };
  };

  const onMouseMove = (e: React.MouseEvent) => {
    if (!ready) return;
    const doc = getDoc();
    const point = doc && toIframePoint(e);
    setHover(point ? pickCandidate(doc, point.x, point.y) : null);
  };

  const dispatchInspectorTap = (doc: Document, x: number, y: number) => {
    const target = doc.elementFromPoint(x, y);
    if (!target) return;
    const win = doc.defaultView ?? window;
    const base = {
      bubbles: true,
      cancelable: true,
      clientX: x,
      clientY: y,
      screenX: x,
      screenY: y,
      view: win,
    };

    if ("PointerEvent" in win) {
      target.dispatchEvent(
        new win.PointerEvent("pointerdown", {
          ...base,
          pointerId: 1,
          pointerType: "mouse",
          isPrimary: true,
          buttons: 1,
        }),
      );
      target.dispatchEvent(
        new win.PointerEvent("pointerup", {
          ...base,
          pointerId: 1,
          pointerType: "mouse",
          isPrimary: true,
        }),
      );
    }
    target.dispatchEvent(new win.MouseEvent("mousedown", { ...base, buttons: 1 }));
    target.dispatchEvent(new win.MouseEvent("mouseup", base));
    target.dispatchEvent(new win.MouseEvent("click", base));
  };

  const readInspectorSelection = async () => {
    if (!selectedAppName) return null;
    try {
      for (let i = 0; i < 8; i += 1) {
        const source = await getSelectedWidgetSource(selectedAppName);
        if (source) return source;
        await new Promise((resolve) => setTimeout(resolve, 100));
      }
    } catch {
      return null;
    }
    return null;
  };

  const onClick = (e: React.MouseEvent) => {
    if (!ready) return;
    const doc = getDoc();
    const point = doc && toIframePoint(e);
    const candidate = point ? pickCandidate(doc, point.x, point.y) : null;
    setSelected(candidate);
    setClickPoint(point ?? null);
    setSelectedSource(null);
    setDraftText(candidate?.text ?? "");
    if (doc && point) {
      dispatchInspectorTap(doc, point.x, point.y);
      void readInspectorSelection()
        .then(setSelectedSource)
        .catch(() => undefined);
    }
  };

  const jumpToCode = async (candidate: Candidate) => {
    if (!selectedAppName) return;
    const inspectorSource = selectedSource ?? (await readInspectorSelection());
    if (inspectorSource) {
      openCode({
        path: inspectorSource.path,
        line: inspectorSource.line,
        column: inspectorSource.column,
      });
      return;
    }
    if (!candidate.text) {
      openCode();
      toast.info("Couldn't resolve this widget in the inspector — opened the code view.");
      return;
    }
    try {
      const hits = await searchApp(selectedAppName, candidate.text, "usage");
      if (hits.length > 0) {
        openCode({ path: hits[0].path, line: hits[0].line });
      } else {
        openCode();
        toast.info("Couldn't find this text in the source — opened the code view.");
      }
    } catch (err) {
      toast.error((err as Error).message);
    }
  };

  // Rocket-style text edit: find the literal in the source, replace it, save,
  // hot-restart, then reload the iframe onto the new build.
  const applyText = async (candidate: Candidate) => {
    if (!selectedAppName || !candidate.text) return;
    const oldText = candidate.text;
    const newText = draftText;
    if (newText === oldText || newText.trim() === "") return;

    setApplying(true);
    try {
      const hits = await searchApp(selectedAppName, oldText);
      if (hits.length === 0) {
        toast.error("Couldn't find this text in the source.");
        return;
      }
      const hit = hits[0];
      const { content } = await getFile(selectedAppName, hit.path);
      if (!content.includes(oldText)) {
        toast.error(`The text moved in ${hit.path} — try again.`);
        return;
      }
      await saveFile(selectedAppName, hit.path, content.replace(oldText, newText));
      toast.success(`Updated ${hit.path} — rebuilding…`);
      setSelected(null);

      // Hot restart pushes the new build into the running page in place — no
      // iframe reload needed (reloading would boot a fresh debug instance).
      const result = await reloadApp(selectedAppName);
      if (result.ok) {
        toast.success("Preview updated with your change.");
      } else {
        toast.info(
          `Saved — the rebuild is still in progress (${result.message ?? "unknown"}). The preview will catch up, or press reload.`,
        );
      }
    } catch (err) {
      toast.error((err as Error).message);
    } finally {
      setApplying(false);
    }
  };

  // Don't draw our own outline for a near-full-screen candidate — it's just a
  // coarse semantics container, and Flutter's inspector already draws a tight
  // box on the real widget. Suppress it above ~70% of the overlay area.
  const rawBox = selected ?? hover;
  const box =
    rawBox &&
    overlaySize.w > 0 &&
    rawBox.w * rawBox.h > overlaySize.w * overlaySize.h * 0.7
      ? null
      : rawBox;

  // Anchor the dialog to the click point, opening above it (flipping below when
  // there's no room) and clamped inside the overlay.
  const DIALOG_HEIGHT = 96;
  const dialogPos = () => {
    const p = clickPoint;
    if (!p) return { left: 8, top: 8 };
    const maxX = Math.max(8, overlaySize.w - DIALOG_WIDTH - 8);
    const left = Math.max(8, Math.min(p.x - DIALOG_WIDTH / 2, maxX));
    const aboveY = p.y - DIALOG_HEIGHT - 12;
    const top = aboveY > 8 ? aboveY : p.y + 16;
    return { left, top };
  };

  return (
    <div
      ref={overlayRef}
      className={cn(
        "absolute inset-0 z-10",
        ready ? "cursor-crosshair" : "cursor-wait",
      )}
      onMouseMove={onMouseMove}
      onMouseLeave={() => setHover(null)}
      onClick={onClick}
    >
      {!ready && (
        <RocketLoader
          variant="overlay"
          label="Preparing edit mode…"
          sublabel="Booting the live preview"
        />
      )}

      {ready && box && (
        <div
          className="pointer-events-none absolute border-2 border-dashed border-sky-500 bg-sky-500/10"
          style={{ left: box.x, top: box.y, width: box.w, height: box.h }}
        />
      )}

      {selected && (
        <div
          className="absolute rounded-lg border bg-popover p-2 text-popover-foreground shadow-lg"
          style={{ ...dialogPos(), width: DIALOG_WIDTH }}
          onClick={(e) => e.stopPropagation()}
          onMouseMove={(e) => e.stopPropagation()}
        >
          <div className="flex items-center gap-1.5">
            {selectedSource?.name ? (
              <>
                {/* Real widget type from the Flutter inspector (Column, Icon, …),
                    not just the semantics role — with where it'll jump. */}
                <span className="shrink-0 rounded bg-sky-100 px-1.5 py-0.5 font-mono text-[11px] font-medium text-sky-700 dark:bg-sky-950 dark:text-sky-300">
                  {selectedSource.name}
                </span>
                <span className="text-muted-foreground min-w-0 flex-1 truncate text-[11px]">
                  {selectedSource.path.split("/").pop()}:{selectedSource.line}
                </span>
              </>
            ) : (
              <span className="min-w-0 flex-1 truncate text-xs font-medium">
                {selected.label}
              </span>
            )}
            <Button
              size="icon-xs"
              variant="ghost"
              aria-label="Open in code"
              onClick={() => jumpToCode(selected)}
            >
              <Code2 className="size-3.5" />
            </Button>
            <Button
              size="icon-xs"
              variant="ghost"
              aria-label="Deselect"
              onClick={() => setSelected(null)}
            >
              <X className="size-3.5" />
            </Button>
          </div>

          {selected.text && (
            <form
              className="mt-2 flex items-center gap-1"
              onSubmit={(e) => {
                e.preventDefault();
                applyText(selected);
              }}
            >
              <Input
                value={draftText}
                onChange={(e) => setDraftText(e.target.value)}
                className="h-7 flex-1 text-xs"
                disabled={applying}
                autoFocus
              />
              <Button
                type="submit"
                size="icon-sm"
                aria-label="Apply text change"
                disabled={applying || draftText === selected.text}
              >
                <Check className="size-3.5" />
              </Button>
            </form>
          )}
        </div>
      )}
    </div>
  );
}
