import { cn } from "@/lib/utils";

// An animated rocket-launch loader: bobbing + vibrating rocket with a
// flickering flame and streaming sparks. Shown while an app is starting and
// while edit mode boots the preview. `variant="overlay"` tints the backdrop for
// layering over an existing (dimmed) preview.
export function RocketLoader({
  label,
  sublabel,
  variant = "solid",
  className,
}: {
  label: string;
  sublabel?: string;
  variant?: "solid" | "overlay";
  className?: string;
}) {
  return (
    <div
      className={cn(
        "flex h-full w-full flex-col items-center justify-center gap-5",
        variant === "solid"
          ? "bg-gradient-to-b from-neutral-50 to-white"
          : "bg-white/70 backdrop-blur-sm",
        className,
      )}
    >
      <div className="relative flex flex-col items-center">
        <div className="rocket-bob">
          <div className="rocket-shake relative">
            <svg
              width="46"
              height="60"
              viewBox="0 0 46 60"
              fill="none"
              aria-hidden
            >
              {/* body */}
              <path
                d="M23 2c9 9 11 21 8 34H15C12 23 14 11 23 2Z"
                fill="#f1f5f9"
                stroke="#94a3b8"
                strokeWidth="1.5"
                strokeLinejoin="round"
              />
              {/* window */}
              <circle
                cx="23"
                cy="22"
                r="5"
                fill="#38bdf8"
                stroke="#0284c7"
                strokeWidth="1.5"
              />
              {/* fins */}
              <path d="M15 32 8 46l7-4Z" fill="#fb923c" />
              <path d="M31 32l7 14-7-4Z" fill="#fb923c" />
              {/* nozzle */}
              <rect x="18" y="42" width="10" height="5" rx="1.5" fill="#64748b" />
            </svg>

            {/* flame */}
            <div
              className="rocket-flame absolute left-1/2 top-[46px] h-6 w-3.5 -translate-x-1/2"
              style={{
                background:
                  "linear-gradient(to bottom, #fb923c 0%, #fbbf24 55%, transparent 100%)",
                clipPath: "polygon(50% 100%, 0 0, 100% 0)",
              }}
            />
          </div>
        </div>

        {/* sparks streaming from the nozzle */}
        <span
          className="rocket-spark absolute top-[52px] left-1/2 size-1 rounded-full bg-amber-400"
          style={{ animationDelay: "0s" }}
        />
        <span
          className="rocket-spark absolute top-[52px] left-[calc(50%-6px)] size-[3px] rounded-full bg-orange-400"
          style={{ animationDelay: "0.3s" }}
        />
        <span
          className="rocket-spark absolute top-[52px] left-[calc(50%+6px)] size-[3px] rounded-full bg-orange-500"
          style={{ animationDelay: "0.6s" }}
        />
      </div>

      <div className="text-center">
        <p className="rocket-pulse text-sm font-medium text-neutral-800">
          {label}
        </p>
        {sublabel && (
          <p className="mt-1 text-xs text-neutral-500">{sublabel}</p>
        )}
      </div>
    </div>
  );
}
