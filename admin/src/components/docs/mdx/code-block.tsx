"use client";

import { useRef, useState, type ReactNode } from "react";
import { Check, Copy } from "lucide-react";

/**
 * The chrome around a fenced code block: a header carrying the language and a
 * copy button, over the highlighted body.
 *
 * The code itself is highlighted at build time (rehype-highlight in the MDX
 * pipeline), so the only reason this is a client component is the clipboard.
 * The text handed to it is read off the DOM through a ref rather than passed
 * as a prop — the child is already-rendered markup, and re-deriving the plain
 * source from it would mean walking the highlighter's span tree.
 */
export function CodeBlock({
  language,
  children,
}: {
  language?: string;
  children: ReactNode;
}) {
  const preRef = useRef<HTMLPreElement>(null);
  const [copied, setCopied] = useState(false);

  const copy = async () => {
    const text = preRef.current?.textContent ?? "";
    try {
      await navigator.clipboard.writeText(text);
      setCopied(true);
      setTimeout(() => setCopied(false), 1600);
    } catch {
      // Clipboard access is denied outside a secure context. The code is on
      // screen and selectable; a failed copy is not worth an error state.
    }
  };

  return (
    <div className="not-prose overflow-hidden rounded-2xl border border-border bg-muted/40">
      <div className="flex items-center justify-between border-b border-border bg-surface/60 py-1.5 pl-4 pr-1.5">
        <span className="font-mono text-[0.6875rem] uppercase tracking-wider text-muted-foreground">
          {language ?? "code"}
        </span>
        <button
          type="button"
          onClick={copy}
          className="flex items-center gap-1.5 rounded-lg px-2 py-1 font-mono text-[0.6875rem] text-muted-foreground transition-colors hover:bg-secondary hover:text-foreground"
        >
          {copied ? (
            <Check aria-hidden="true" className="size-3" />
          ) : (
            <Copy aria-hidden="true" className="size-3" />
          )}
          {copied ? "Copied" : "Copy"}
        </button>
      </div>
      <pre
        ref={preRef}
        className="overflow-x-auto p-4 font-mono text-[0.8125rem] leading-7 text-foreground"
      >
        {children}
      </pre>
    </div>
  );
}
