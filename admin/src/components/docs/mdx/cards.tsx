import type { ReactNode } from "react";
import Link from "next/link";
import { ArrowRight } from "lucide-react";
import { cn } from "@/lib/utils";
import { DocIcon, type DocIconName } from "../icon";

/**
 * The bordered tile used for "where to go next" links. Transparent fill over a
 * hairline, lifting only on hover — the template's treatment, so a grid of
 * these reads as structure rather than as six coloured boxes.
 */
export function Card({
  title,
  icon,
  href,
  children,
}: {
  title: string;
  icon?: DocIconName;
  href?: string;
  children?: ReactNode;
}) {
  const className = cn(
    "group flex h-full flex-col rounded-2xl border border-border bg-transparent p-5 backdrop-blur-sm transition-all",
    href && "hover:border-border-strong hover:shadow-soft",
  );

  const body = (
    <>
      {icon ? (
        <DocIcon name={icon} className="mb-3 size-6 text-primary" />
      ) : null}
      <h3 className="mb-1 flex items-center gap-1.5 text-[0.9375rem] font-semibold text-foreground">
        {title}
        {href ? (
          <ArrowRight
            aria-hidden="true"
            className="size-4 text-muted-foreground transition-transform group-hover:translate-x-0.5"
          />
        ) : null}
      </h3>
      {children ? (
        <div className="text-sm leading-6 text-muted-foreground">{children}</div>
      ) : null}
    </>
  );

  return href ? (
    <Link href={href} className={className}>
      {body}
    </Link>
  ) : (
    <div className={className}>{body}</div>
  );
}

export function CardGroup({
  cols = 2,
  children,
}: {
  cols?: 2 | 3;
  children: ReactNode;
}) {
  return (
    <div
      className={cn(
        "not-prose grid grid-cols-1 gap-4",
        cols === 3 ? "sm:grid-cols-3" : "sm:grid-cols-2",
      )}
    >
      {children}
    </div>
  );
}
