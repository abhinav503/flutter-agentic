import type { ComponentPropsWithoutRef, ReactNode } from "react";
import Link from "next/link";

import { slugifyHeading } from "@/lib/docs";
import { Accordion } from "./accordion";
import { Callout } from "./callout";
import { Card, CardGroup } from "./cards";
import { CodeBlock } from "./code-block";
import { Step, Steps } from "./steps";
import { Tabs } from "./tabs";

/**
 * Flattens a heading's children back to plain text, so its anchor id can be
 * derived the same way the table of contents derives it — from the raw
 * markdown. Inline code and emphasis inside a heading arrive here as elements,
 * not strings.
 */
function toText(node: ReactNode): string {
  if (node == null || typeof node === "boolean") return "";
  if (typeof node === "string" || typeof node === "number") return String(node);
  if (Array.isArray(node)) return node.map(toText).join("");
  if (typeof node === "object" && "props" in node) {
    return toText((node as { props: { children?: ReactNode } }).props.children);
  }
  return "";
}

function Heading({
  level,
  children,
}: {
  level: 2 | 3;
  children: ReactNode;
}) {
  const id = slugifyHeading(toText(children));
  const Tag = level === 2 ? "h2" : "h3";

  return (
    <Tag
      id={id}
      className={
        level === 2
          ? "mt-10 mb-3 scroll-mt-24 text-2xl font-semibold tracking-tight text-foreground"
          : "mt-8 mb-2 scroll-mt-24 text-xl font-semibold tracking-tight text-foreground"
      }
    >
      {children}
    </Tag>
  );
}

/**
 * The one place a markdown element is bound to a React component.
 *
 * `h2`/`h3` are components rather than CSS because they carry the anchor the
 * table of contents links to. `pre` is a component because the copy button and
 * the language label live in its chrome. Everything else — paragraphs, lists,
 * tables, inline code — is styled by `.docs-prose` in globals.css, where it
 * takes a rule instead of a wrapper.
 */
export const mdxComponents = {
  h1: ({ children }: { children?: ReactNode }) => (
    // The page renders the article title itself, so an `#` inside the body is
    // a second first-level heading. Demoted rather than dropped.
    <Heading level={2}>{children}</Heading>
  ),
  h2: ({ children }: { children?: ReactNode }) => <Heading level={2}>{children}</Heading>,
  h3: ({ children }: { children?: ReactNode }) => <Heading level={3}>{children}</Heading>,

  a: ({ href = "", children, ...props }: ComponentPropsWithoutRef<"a">) => {
    const isExternal = /^https?:\/\//.test(href);
    return isExternal ? (
      <a href={href} target="_blank" rel="noopener noreferrer" {...props}>
        {children}
      </a>
    ) : (
      <Link href={href}>{children}</Link>
    );
  },

  pre: ({ children }: ComponentPropsWithoutRef<"pre">) => {
    // MDX nests the code element inside `pre`, and rehype-highlight leaves the
    // fence's language on it as `language-<id>`.
    const code = children as { props?: { className?: string } } | undefined;
    const language = /language-([\w-]+)/.exec(code?.props?.className ?? "")?.[1];
    return <CodeBlock language={language}>{children}</CodeBlock>;
  },

  // A table can exceed the article column; it scrolls inside its own box so
  // the page body never gains a horizontal scrollbar.
  table: (props: ComponentPropsWithoutRef<"table">) => (
    <div className="overflow-x-auto rounded-2xl border border-border">
      <table {...props} />
    </div>
  ),

  Accordion,
  Callout,
  Card,
  CardGroup,
  Step,
  Steps,
  Tabs,
};
