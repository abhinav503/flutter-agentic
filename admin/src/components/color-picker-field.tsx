"use client";

import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";

// The swatch the picker opens on when nothing is set yet. Only ever a
// starting point — an untouched field still saves as "".
const FALLBACK_SWATCH = "#C8DFC3";

const HEX = /^#[0-9a-fA-F]{6}$/;

export function isHexColor(value: string) {
  return HEX.test(value);
}

/**
 * A colour field: the OS colour picker, the hex beside it, and a way back to
 * "unset". Both halves write the same value, so a colour can be picked
 * visually or pasted from a design file.
 *
 * Empty is a real state, not a missing one — it means "let the storefront
 * decide", which is why this isn't just an <input type="color"> (that control
 * cannot express "no colour").
 */
export function ColorPickerField({
  id,
  label,
  value,
  onChange,
  description,
}: {
  id: string;
  label: string;
  value: string;
  onChange: (color: string) => void;
  description?: string;
}) {
  const swatch = isHexColor(value) ? value : FALLBACK_SWATCH;

  return (
    <div className="flex flex-col gap-1.5">
      <Label htmlFor={id}>{label}</Label>
      <div className="flex items-center gap-3">
        <input
          type="color"
          aria-label={`${label} picker`}
          value={swatch}
          onChange={(e) => onChange(e.target.value.toUpperCase())}
          className="size-10 shrink-0 cursor-pointer rounded-md border border-border bg-transparent p-1"
        />
        <Input
          id={id}
          value={value}
          onChange={(e) => onChange(e.target.value.trim().toUpperCase())}
          placeholder="#C8DFC3"
          className="font-mono"
        />
        <Button
          type="button"
          variant="ghost"
          size="sm"
          disabled={!value}
          onClick={() => onChange("")}
        >
          Clear
        </Button>
      </div>
      {description && (
        <p className="text-xs text-muted-foreground">{description}</p>
      )}
      {value && !isHexColor(value) && (
        <p className="text-xs text-destructive">
          Use a 6-digit hex colour, e.g. #C8DFC3
        </p>
      )}
    </div>
  );
}
